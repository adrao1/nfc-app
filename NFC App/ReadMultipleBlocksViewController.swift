//
//  ReadBlockViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/22/24.
//

import UIKit
import CoreNFC

class ReadMultipleBlocksViewController: UIViewController, NFCTagReaderSessionDelegate, UITextFieldDelegate {
    @IBOutlet weak var startBlockNumberTextField: UITextField!
    @IBOutlet weak var endBlockNumberTextField: UITextField!
    @IBOutlet weak var readResultOutputLabel: UILabel!
    var session: NFCTagReaderSession?
    var startBlock: UInt8 = 0
    var endBlock: UInt8 = 0
    var combinedData = ""
    
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
                self.readTagInBatches(session: session, iso15693Tag: iso15693Tag)
            default:
                print("Unsupported tag type.")
                DispatchQueue.main.async {
                    self.readResultOutputLabel.text = "Error: Unsupported tag."
                }
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    func readTagInBatches(session: NFCTagReaderSession, iso15693Tag: NFCISO15693Tag?) {
        guard let tag = iso15693Tag else {
            print("No tag available to read.")
            DispatchQueue.main.async {
                self.readResultOutputLabel.text = "Error: No tag available to read."
            }
            return
        }
        
        let startBlock = Int(self.startBlock)
        let endBlock = Int(self.endBlock)
        let maxBlocksPerRead = 3

        func readNextBatch(currentBlock: Int) {
            guard currentBlock <= endBlock else {
                DispatchQueue.main.async {
                    self.readResultOutputLabel.text = self.combinedData
                }
                session.invalidate()
                return
            }

            let blocksRemaining = endBlock - currentBlock + 1
            let blocksToRead = min(maxBlocksPerRead, blocksRemaining)
            let blockRange = NSRange(location: currentBlock, length: blocksToRead)
            
            tag.readMultipleBlocks(requestFlags: [.highDataRate, .address], blockRange: blockRange) { (dataBlocks, error) in
                if let error = error {
                    print("Error reading blocks: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.readResultOutputLabel.text = "Error: \(error.localizedDescription)"
                    }
                    session.invalidate()
                    return
                }
                
                for (index, data) in dataBlocks.enumerated() {
                    let hexString = data.map { String(format: "%02x", $0) }.joined()
                    let blockNumber = currentBlock + index
                    self.combinedData += "Block \(blockNumber): \(hexString.uppercased())\n"
                }
                
                print("Data read from blocks \(currentBlock) to \(currentBlock + blocksToRead - 1):\n\(self.combinedData)")
                
                readNextBatch(currentBlock: currentBlock + blocksToRead)
            }
        }
        
        readNextBatch(currentBlock: startBlock)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Read Multiple Blocks"
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
        
        guard let startText = startBlockNumberTextField.text, let startBlock: UInt8 = UInt8(startText),
              let endText = endBlockNumberTextField.text, let endBlock: UInt8 = UInt8(endText),
              endBlock >= startBlock else {
            print("Invalid block range.")
            DispatchQueue.main.async {
                self.readResultOutputLabel.text = "Error: Invalid block range."
            }
            return
        }
        
        self.startBlock = startBlock
        self.endBlock = endBlock
        self.combinedData = ""

        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
}
