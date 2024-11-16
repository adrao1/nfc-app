//
//  LoginController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import CoreData

class LoginController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let nameField = UITextField()
        nameField.placeholder = "Enter your name"
        nameField.returnKeyType = .done
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.textAlignment = .center
        nameField.font = UIFont.systemFont(ofSize: 30)
        nameField.delegate = self
        
        view.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameField.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        nameField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            var writeData = Data(repeating: 0, count: 8)
            let samplingRates: [Double] = [0.25, 0.5, 1.0]
            writeData[0] = 1
            writeData[3] = 1
            writeData[4] = 10
            UserDefaults.standard.set(name, forKey: "userName")
            UserDefaults.standard.set(writeData, forKey: "writeData")
            UserDefaults.standard.set(samplingRates, forKey: "samplingRates")
            textField.resignFirstResponder()
            view.window?.rootViewController = TabController()
        }
        return true
    }

}
