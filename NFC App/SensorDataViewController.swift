//
//  SensorDataViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/12/24.
//

import UIKit
import CoreNFC

class SensorDataViewController: UIViewController, NFCTagReaderSessionDelegate {
    
    var block: Data!
    var samplingFrequency: Double!
    var samplingTime: Double!
    var enabledSensors: [String]!
    var session: NFCTagReaderSession?
    
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
        
        tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: 0, dataBlock: self.block) { error in
            if let error = error {
                print("Error writing block: \(error.localizedDescription)")
                return
            }
            
            print("Successfully wrote to block \(0): \(String(describing: self.block))")
            print("Data written in hex: \(self.hexString(from: self.block))")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.samplingTime) {
                print("Sampling time completed. Invalidating session.")
                session.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Sensor Data"
        
        let sensorDataLabel = UILabel()
        sensorDataLabel.textAlignment = .left
        sensorDataLabel.numberOfLines = 0
        sensorDataLabel.font = UIFont.systemFont(ofSize: 18)
        sensorDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sensorDataLabel)
        
        if let block = block {
            sensorDataLabel.text = "Data Written: " + hexString(from: block)
        }
        
        NSLayoutConstraint.activate([
            sensorDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sensorDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sensorDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold your iPhone near the tag."
        self.session?.begin()
    }
    
    func hexString(from block: Data) -> String {
        return "0x" + block.map { String(format: "%02X", $0) }.joined()
    }
}
