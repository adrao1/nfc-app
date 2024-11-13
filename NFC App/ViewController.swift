//
//  ViewController.swift
//  NFC App
//
//  Created by Aditya Rao on 10/10/24.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    let stackView = UIStackView()
    var writeData: Int = 0
    let writeDataLabel = UILabel()
    let sendCommandButton = UIButton()

    var block: Data = Data(repeating: 0, count: 8)
    
    let samplingFrequencies: [String] = [
        "0.25", "0.5", "1", "5", "15", "30", "60", "120", "300", "600", "1800", "3600", "7200", "18000", "36000", "86400"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Configure Sensors"
        
        block[0] = 1
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        addSwitchWithLabel(text: "ADC0", tag: 2)
        addSwitchWithLabel(text: "ADC1", tag: 0)
        addSwitchWithLabel(text: "ADC2", tag: 1)
        addSwitchWithLabel(text: "Internal Sensor", tag: 3)
        
        addSamplingFrequencyPicker()
        addNumberOfPassesInputField()
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        writeDataLabel.text = "Block 0: \(hexString(from: block))"
        writeDataLabel.font = UIFont.systemFont(ofSize: 18)
        writeDataLabel.textColor = .label
        writeDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(writeDataLabel)
        
        sendCommandButton.setTitle("Send Command", for: .normal)
        sendCommandButton.setTitleColor(.white, for: .normal)
        if let buttonBackgroundColor = UIColor(named: "ButtonBackgroundColor") {
            sendCommandButton.backgroundColor = buttonBackgroundColor
        }
        sendCommandButton.layer.cornerRadius = 10
        sendCommandButton.addTarget(self, action: #selector(sendCommandTapped), for: .touchUpInside)
        
        sendCommandButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendCommandButton)
        
        NSLayoutConstraint.activate([
            writeDataLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            writeDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            sendCommandButton.topAnchor.constraint(equalTo: writeDataLabel.bottomAnchor, constant: 30),
            sendCommandButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendCommandButton.heightAnchor.constraint(equalToConstant: 50),
            sendCommandButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sendCommandTapped() {
        let selectedRow = (stackView.arrangedSubviews[4] as! UIStackView).arrangedSubviews[1] as! UIPickerView
        let samplingFrequency = Double(samplingFrequencies[selectedRow.selectedRow(inComponent: 0)]) ?? 1.0
        let numberOfPasses = Int(block[4])
        let samplingTime = samplingFrequency * Double(numberOfPasses)
        
        let sensorNames = [
            "ADC1", "ADC2", "ADC0", "Internal Sensor"
        ]
        var enabledSensors: [String] = []
        for subview in stackView.arrangedSubviews {
            if let horizontalStack = subview as? UIStackView {
                if let switchControl = horizontalStack.arrangedSubviews[1] as? UISwitch {
                    if switchControl.isOn {
                        enabledSensors.append(sensorNames[switchControl.tag])
                    }
                }
            }
        }
        enabledSensors.sort { sensorNames.firstIndex(of: $0)! < sensorNames.firstIndex(of: $1)! }
        
        let sensorDataVC = SensorDataViewController()
        sensorDataVC.block = self.block
        sensorDataVC.samplingFrequency = samplingFrequency
        sensorDataVC.samplingTime = samplingTime
        sensorDataVC.enabledSensors = enabledSensors
        navigationController?.pushViewController(sensorDataVC, animated: true)
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
        switchControl.tag = tag
        switchControl.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        if let buttonBackgroundColor = UIColor(named: "ButtonBackgroundColor") {
            switchControl.tintColor = buttonBackgroundColor
            switchControl.onTintColor = buttonBackgroundColor
        }
        
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(switchControl)
        
        stackView.addArrangedSubview(horizontalStack)
    }
    
    func addSamplingFrequencyPicker() {
        let label = UILabel()
        label.text = "Sampling Frequency"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let defaultRow = block[3]
        pickerView.selectRow(Int(defaultRow), inComponent: 0, animated: false)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 10
        
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(pickerView)
        
        stackView.addArrangedSubview(horizontalStack)
    }

    func addNumberOfPassesInputField() {
        let label = UILabel()
        label.text = "Number of Passes"
        
        let textField = UITextField()
        textField.placeholder = "Enter a value (0-200)"
        textField.keyboardType = .numberPad
        textField.delegate = self
        
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 10
        
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(textField)
        
        stackView.addArrangedSubview(horizontalStack)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            block[4] = 0
            writeDataLabel.text = "Block 0: \(hexString(from: block))"
            return true
        }
        
        if string.isEmpty, let text = textField.text, text.count > 0 {
            let newTextAfterBackspace = String(text.dropLast())
            if let number = Int(newTextAfterBackspace), (0...200).contains(number) {
                block[4] = UInt8(number)
                writeDataLabel.text = "Block 0: \(hexString(from: block))"
            }
            return true
        }
        
        if let number = Int(newText), (0...200).contains(number) {
            block[4] = UInt8(number)
            writeDataLabel.text = "Block 0: \(hexString(from: block))"
            return true
        }
        
        return false
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        let bitValue = sender.isOn ? 1 : 0
        updateBlock(for: sender.tag, with: bitValue)
        writeDataLabel.text = "Block 0: \(hexString(from: block))"
    }
    
    func updateBlock(for tag: Int, with bitValue: Int) {
        var byteValue = block[2]
        byteValue = (byteValue & ~(UInt8(1) << tag)) | (UInt8(bitValue) << tag)
        block[2] = byteValue
    }
    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return samplingFrequencies.count
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return samplingFrequencies[row]
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        block[3] = UInt8(row)
        writeDataLabel.text = "Block 0: \(hexString(from: block))"
    }
    
    func hexString(from block: Data) -> String {
        return "0x" + block.map { String(format: "%02X", $0) }.joined()
    }
}
