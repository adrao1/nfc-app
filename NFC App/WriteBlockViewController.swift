//
//  WriteBlockViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/22/24.
//

import UIKit
import CoreNFC

class WriteBlockViewController: UIViewController, NFCTagReaderSessionDelegate  {
    @IBOutlet weak var blockNumberTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    var session: NFCTagReaderSession?
    var blockNumber: UInt8 = 0
    var data: Data = Data([0x12, 0x34, 0x56, 0x78])
    
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
            return
        }
        
        session.connect(to: tag) { (error) in
            if let error = error {
                print("Error connecting to tag: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            
            switch tag {
            case .iso15693(let iso15693Tag):
                self.writeTag(session: session, iso15693Tag: iso15693Tag)
            default:
                print("Unsupported tag type.")
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    func writeTag(session: NFCTagReaderSession, iso15693Tag: NFCISO15693Tag?) {
        guard let tag = iso15693Tag else {
            print("No tag available to write.")
            return
        }
        
        tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: self.blockNumber, dataBlock: self.data) { error in
            if let error = error {
                print("Error writing block: \(error.localizedDescription)")
                return
            }
            
            print("Successfully wrote to block \(self.blockNumber): \(self.data)")
            let hexString = self.data.map { String(format: "%02x", $0) }.joined()
            print("Data written in hex: \(hexString)")
            session.invalidate()
        }
    }
    
    func convertHexToByteArray(hexString: String) -> Data? {
        guard hexString.hasPrefix("0x"), hexString.count == 10 else {
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
        
        guard byteArray.count == 4 else { return nil }
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
            return
        }
        guard let blockText = blockNumberTextField.text, let blockNumber: UInt8 = UInt8(blockText) else {
            print("Invalid block number.")
            return
        }
        guard let dataText = dataTextField.text, let dataToWrite = convertHexToByteArray(hexString: dataText) else {
            print("Invalid data.")
            return
        }
        
        self.blockNumber = 10
        self.data = dataToWrite

        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
}
