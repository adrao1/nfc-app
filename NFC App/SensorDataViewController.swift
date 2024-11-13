//
//  SensorDataViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/12/24.
//

import UIKit

class SensorDataViewController: UIViewController {
    
    var block: Data?
    
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
            let hexString = convertToHexString(block)
            sensorDataLabel.text = hexString
        }
        
        NSLayoutConstraint.activate([
            sensorDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sensorDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sensorDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func convertToHexString(_ data: Data) -> String {
        return data.map { String(format: "%02x", $0) }.joined()
    }
}
