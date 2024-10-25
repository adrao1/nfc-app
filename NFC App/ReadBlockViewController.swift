//
//  ReadBlockViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/22/24.
//

import UIKit
import CoreNFC

class ReadBlockViewController: UIViewController, NFCTagReaderSessionDelegate {
    @IBOutlet weak var blockNumberTextField: UITextField!
    @IBOutlet weak var readResultOutputLabel: UILabel!
    var session: NFCTagReaderSession?
    var blockNumber: UInt8 = 0
    
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
                self.readResultOutputLabel.text = "Error: No tags detected."
            }
            return
        }
        
        session.connect(to: tag) { (error) in
            if let error = error {
                print("Error connecting to tag: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.readResultOutputLabel.text = "Error: Connection error. Please try again."
                }
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            
            switch tag {
            case .iso15693(let iso15693Tag):
                self.readTag(session: session, iso15693Tag: iso15693Tag)
            default:
                print("Unsupported tag type.")
                DispatchQueue.main.async {
                    self.readResultOutputLabel.text = "Error: Unsupported tag."
                }
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    func readTag(session: NFCTagReaderSession, iso15693Tag: NFCISO15693Tag?) {
        guard let tag = iso15693Tag else {
            print("No tag available to write.")
            DispatchQueue.main.async {
                self.readResultOutputLabel.text = "Error: No tag available to read."
            }
            return
        }
        
        tag.readSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: self.blockNumber) { (data, error) in
            if let error = error {
                print("Error reading block: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.readResultOutputLabel.text = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            print("Data read from block \(self.blockNumber): \(data)")
            let hexString = data.map { String(format: "%02x", $0) }.joined()
            print("Data in hex: \(hexString.uppercased())")
            
            DispatchQueue.main.async {
                self.readResultOutputLabel.text = hexString.uppercased()
            }
            session.invalidate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Read Block"
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
                self.readResultOutputLabel.text = "Error: Scanning not supported on this device."
            }
            return
        }
        
        guard let text = blockNumberTextField.text, let blockNumber: UInt8 = UInt8(text) else {
            print("Invalid block number.")
            DispatchQueue.main.async {
                self.readResultOutputLabel.text = "Error: Invalid block number."
            }
            return
        }
        self.blockNumber = blockNumber;

        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
}
