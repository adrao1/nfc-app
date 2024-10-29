//
//  WriteBlockViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/22/24.
//

import UIKit
import CoreNFC

class WriteBlockViewController: UIViewController, NFCTagReaderSessionDelegate, UITextFieldDelegate {
    @IBOutlet weak var blockNumberTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var writeResultOutputLabel: UILabel!
    var session: NFCTagReaderSession?
    var blockNumber: UInt8 = 0
    var data: Data = Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session became active. Ready to scan for tags.")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        print("Session invalidated: \(error.localizedDescription)")
        self.session = nil
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            print("No tags detected.")
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Error: No tags detected."
            }
            return
        }
        
        session.connect(to: tag) { (error) in
            if let error = error {
                print("Error connecting to tag: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.writeResultOutputLabel.text = "Error: Connection error. Please try again."
                }
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            
            switch tag {
            case .iso15693(let iso15693Tag):
                self.writeTag(session: session, iso15693Tag: iso15693Tag)
            default:
                print("Unsupported tag type.")
                DispatchQueue.main.async {
                    self.writeResultOutputLabel.text = "Error: Unsupported tag."
                }
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    func writeTag(session: NFCTagReaderSession, iso15693Tag: NFCISO15693Tag?) {
        guard let tag = iso15693Tag else {
            print("No tag available to write.")
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Error: No tag available to write."
            }
            return
        }
        
        tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: self.blockNumber, dataBlock: self.data) { error in
            if let error = error {
                print("Error writing block: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.writeResultOutputLabel.text = "Error writing to block: \(error.localizedDescription)"
                }
                return
            }
            
            print("Successfully wrote to block \(self.blockNumber): \(self.data)")
            let hexString = self.data.map { String(format: "%02x", $0) }.joined()
            print("Data written in hex: \(hexString.uppercased())")
            
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Success: Data written to block \(self.blockNumber) - \(hexString.uppercased())"
            }
            session.invalidate()
        }
    }
    
    func convertHexToByteArray(hexString: String) -> Data? {
        guard hexString.hasPrefix("0x"), hexString.count == 18 else {
            return nil
        }
        
        let hexWithoutPrefix = String(hexString.dropFirst(2))
        var byteArray = [UInt8]()
        
        for i in stride(from: 0, to: hexWithoutPrefix.count, by: 2) {
            let startIndex = hexWithoutPrefix.index(hexWithoutPrefix.startIndex, offsetBy: i)
            let endIndex = hexWithoutPrefix.index(startIndex, offsetBy: 2)
            let byteString = hexWithoutPrefix[startIndex..<endIndex]
            
            if let byte = UInt8(byteString, radix: 16) {
                byteArray.append(byte)
            } else {
                return nil
            }
        }
        
        guard byteArray.count == 8 else { return nil }
        return Data(byteArray)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Write Block"
    }
    
    @IBAction func sendCommand(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Error: Scanning not supported on this device."
            }
            return
        }
        guard let blockText = blockNumberTextField.text, let blockNumber: UInt8 = UInt8(blockText) else {
            print("Invalid block number.")
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Error: Invalid block number."
            }
            return
        }
        guard let dataText = dataTextField.text, let dataToWrite = convertHexToByteArray(hexString: dataText) else {
            print("Invalid data.")
            DispatchQueue.main.async {
                self.writeResultOutputLabel.text = "Error: Invalid data format."
            }
            return
        }
        
        self.blockNumber = blockNumber
        self.data = dataToWrite

        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
}
