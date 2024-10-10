//
//  ViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/10/24.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCTagReaderSessionDelegate {
    var session: NFCTagReaderSession?
    var detectedTag: NFCISO15693Tag?
    
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
                self.detectedTag = iso15693Tag
                print("ISO15693 tag detected.")
            default:
                print("Unsupported tag type.")
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scanTag(_ sender: Any) {
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
        
        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
    
    @IBAction func readTag(_ sender: Any) {
        guard let tag = self.detectedTag else {
            print("No tag available to read.")
            return
        }
        let blockNumber: UInt8 = 0
        tag.readSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: blockNumber) { (data, error) in
            if let error = error {
                print("Error reading block: \(error.localizedDescription)")
                return
            }
            
            print("Data read from block \(blockNumber): \(data)")
            let hexString = data.map { String(format: "%02x", $0) }.joined()
            print("Data in hex: \(hexString)")
        }
    }
    
    @IBAction func writeTag(_ sender: Any) {
        guard let tag = self.detectedTag else {
            print("No tag available to write.")
            return
        }
        
        let blockNumber: UInt8 = 0
        let dataToWrite = Data([0x01, 0x02, 0x03, 0x04])
        
        tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: blockNumber, dataBlock: dataToWrite) { error in
            if let error = error {
                print("Error writing block: \(error.localizedDescription)")
                return
            }
            
            print("Successfully wrote to block \(blockNumber): \(dataToWrite)")
            let hexString = dataToWrite.map { String(format: "%02x", $0) }.joined()
            print("Data written in hex: \(hexString)")
        }
    }
}

