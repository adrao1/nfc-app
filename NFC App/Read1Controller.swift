//
//  Read1Controller.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class Read1Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let sensorLabel = UILabel()
        let lightButton = UIButton()
        let tempButton = UIButton()
        
        sensorLabel.translatesAutoresizingMaskIntoConstraints = false
        sensorLabel.text = "Choose sensor to read"
        sensorLabel.textAlignment = .center
        sensorLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        sensorLabel.textColor = UIColor(named: "TextColor")
        
        lightButton.translatesAutoresizingMaskIntoConstraints = false
        lightButton.setTitle("Light Intensity", for: .normal)
        lightButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        lightButton.backgroundColor = UIColor(named: "ButtonColor")
        lightButton.layer.cornerRadius = 10
        lightButton.addTarget(self, action: #selector(lightButtonTapped), for: .touchUpInside)
        
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.setTitle("Temperature", for: .normal)
        tempButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        tempButton.backgroundColor = UIColor(named: "ButtonColor")
        tempButton.layer.cornerRadius = 10
        tempButton.addTarget(self, action: #selector(tempButtonTapped), for: .touchUpInside)
        
        view.addSubview(sensorLabel)
        view.addSubview(lightButton)
        view.addSubview(tempButton)

        NSLayoutConstraint.activate([
            sensorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            sensorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lightButton.topAnchor.constraint(equalTo: sensorLabel.bottomAnchor, constant: 30),
            lightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lightButton.widthAnchor.constraint(equalToConstant: 300),
            lightButton.heightAnchor.constraint(equalToConstant: 50),
            
            tempButton.topAnchor.constraint(equalTo: lightButton.bottomAnchor, constant: 20),
            tempButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempButton.widthAnchor.constraint(equalToConstant: 300),
            tempButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func lightButtonTapped() {
        navigationController?.pushViewController(Read2Controller(), animated: true)
    }
    
    @objc private func tempButtonTapped() {
        navigationController?.pushViewController(Read2Controller(), animated: true)
    }
}
