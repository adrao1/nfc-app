//
//  SensorDataViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/12/24.
//

import UIKit

class SensorDataViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Sensor Data"
        
        let sensorDataLabel = UILabel()
        sensorDataLabel.text = "ADC0: 0V"
        sensorDataLabel.textAlignment = .left
        sensorDataLabel.numberOfLines = 0
        sensorDataLabel.font = UIFont.systemFont(ofSize: 18)
        sensorDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sensorDataLabel)
        
        NSLayoutConstraint.activate([
            sensorDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sensorDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sensorDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
