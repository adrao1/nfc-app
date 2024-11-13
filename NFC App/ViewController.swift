//
//  ViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/10/24.
//

import UIKit

class ViewController: UIViewController {
    let stackView = UIStackView()
    var writeData: Int = 0
    let writeDataLabel = UILabel()

    var block: [Int] = Array(repeating: 0, count: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Block Control"
        
        block[0] = 1
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        addSwitchWithLabel(text: "ADC0", tag: 2)
        addSwitchWithLabel(text: "ADC1", tag: 0)
        addSwitchWithLabel(text: "ADC2", tag: 1)
        addSwitchWithLabel(text: "Internal Sensor", tag: 3)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        writeDataLabel.text = "Write Data: \(hexString(from: block))"
        writeDataLabel.font = UIFont.systemFont(ofSize: 18)
        
        writeDataLabel.textColor = .label  // Automatically adapts to light and dark mode
        
        writeDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(writeDataLabel)
        
        NSLayoutConstraint.activate([
            writeDataLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            writeDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    func addSwitchWithLabel(text: String, tag: Int) {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 10
        
        let label = UILabel()
        label.text = text
        
        let labelWidth: CGFloat = 120
        label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        let switchControl = UISwitch()
        switchControl.tag = tag  // Use the tag to identify each switch
        switchControl.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        if let buttonBackgroundColor = UIColor(named: "ButtonBackgroundColor") {
            switchControl.tintColor = buttonBackgroundColor // Color for off state
            switchControl.onTintColor = buttonBackgroundColor // Color for on state
        }
        
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(switchControl)
        
        stackView.addArrangedSubview(horizontalStack)
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        let bitValue = sender.isOn ? 1 : 0
        updateBlock(for: sender.tag, with: bitValue)
        writeDataLabel.text = "Write Data: \(hexString(from: block))"
    }
    
    func updateBlock(for tag: Int, with bitValue: Int) {
        var byteValue = block[2]
        byteValue = (byteValue & ~(1 << tag)) | (bitValue << tag)
        block[2] = byteValue
    }
    
    func hexString(from block: [Int]) -> String {
        return "0x" + block.map { String(format: "%02X", $0) }.joined()
    }
}
