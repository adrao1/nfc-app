//
//  Read2Controller.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class Read2Controller: UIViewController {
    let instructionLabel = UILabel()
    let samplingRateLabel = UILabel()
    let samplingRateValueLabel = UILabel()
    let samplingRateSlider = UISlider()
    let numberOfSamplesLabel = UILabel()
    let numberOfSamplesValueLabel = UILabel()
    let numberOfSamplesSlider = UISlider()
    let startSamplingButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        let writeData = UserDefaults.standard.data(forKey: "writeData")!
        let samplingRates = UserDefaults.standard.array(forKey: "samplingRates") as! [Double]
        let samplingRateIndex = Int(writeData[3])
        let samplingRate = samplingRates[samplingRateIndex]
        let numberOfSamples = Int(writeData[4])

        let samplingStackView = UIStackView(arrangedSubviews: [samplingRateLabel, samplingRateValueLabel])
        let numberOfSamplesStackView = UIStackView(arrangedSubviews: [numberOfSamplesLabel, numberOfSamplesValueLabel])

        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.text = "Set sampling rate, number of samples"
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        instructionLabel.textColor = UIColor(named: "TextColor")
        instructionLabel.numberOfLines = 0
        
        samplingRateLabel.translatesAutoresizingMaskIntoConstraints = false
        samplingRateLabel.text = "Sampling Rate (sec/sample)"
        samplingRateLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        samplingRateLabel.textColor = UIColor(named: "TextColor")
        
        samplingRateValueLabel.translatesAutoresizingMaskIntoConstraints = false
        samplingRateValueLabel.text = String(format: "%.2f", samplingRate)
        samplingRateValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        samplingRateValueLabel.textColor = UIColor(named: "TextColor")
        
        samplingRateSlider.translatesAutoresizingMaskIntoConstraints = false
        samplingRateSlider.minimumValue = 0
        samplingRateSlider.maximumValue = 2
        samplingRateSlider.value = Float(samplingRateIndex)
        samplingRateSlider.isContinuous = true
        samplingRateSlider.addTarget(self, action: #selector(samplingRateSliderChanged), for: .valueChanged)
        samplingRateSlider.tintColor = UIColor(named: "ButtonColor")

        numberOfSamplesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSamplesLabel.text = "Number of samples"
        numberOfSamplesLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        numberOfSamplesLabel.textColor = UIColor(named: "TextColor")
        
        numberOfSamplesValueLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSamplesValueLabel.text = "\(numberOfSamples)"
        numberOfSamplesValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        numberOfSamplesValueLabel.textColor = UIColor(named: "TextColor")
        
        numberOfSamplesSlider.translatesAutoresizingMaskIntoConstraints = false
        numberOfSamplesSlider.minimumValue = 1
        numberOfSamplesSlider.maximumValue = 20
        numberOfSamplesSlider.value = Float(numberOfSamples)
        numberOfSamplesSlider.isContinuous = true
        numberOfSamplesSlider.addTarget(self, action: #selector(numberOfSamplesSliderChanged), for: .valueChanged)
        numberOfSamplesSlider.tintColor = UIColor(named: "ButtonColor")

        samplingStackView.translatesAutoresizingMaskIntoConstraints = false
        samplingStackView.axis = .horizontal
        samplingStackView.alignment = .center
        samplingStackView.distribution = .fill
        
        numberOfSamplesStackView.translatesAutoresizingMaskIntoConstraints = false
        numberOfSamplesStackView.axis = .horizontal
        numberOfSamplesStackView.alignment = .center
        numberOfSamplesStackView.distribution = .fill
        
        startSamplingButton.translatesAutoresizingMaskIntoConstraints = false
        startSamplingButton.setTitle("Start Sampling", for: .normal)
        startSamplingButton.backgroundColor = UIColor(named: "ButtonColor")
        startSamplingButton.layer.cornerRadius = 10
        startSamplingButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        startSamplingButton.addTarget(self, action: #selector(startSamplingButtonTapped), for: .touchUpInside)

        view.addSubview(instructionLabel)
        view.addSubview(samplingStackView)
        view.addSubview(samplingRateSlider)
        view.addSubview(numberOfSamplesStackView)
        view.addSubview(numberOfSamplesSlider)
        view.addSubview(startSamplingButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
           
            samplingStackView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            samplingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            samplingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            samplingRateSlider.topAnchor.constraint(equalTo: samplingStackView.bottomAnchor, constant: 20),
            samplingRateSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            samplingRateSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            numberOfSamplesStackView.topAnchor.constraint(equalTo: samplingRateSlider.bottomAnchor, constant: 30),
            numberOfSamplesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfSamplesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            numberOfSamplesSlider.topAnchor.constraint(equalTo: numberOfSamplesStackView.bottomAnchor, constant: 20),
            numberOfSamplesSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfSamplesSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startSamplingButton.topAnchor.constraint(equalTo: numberOfSamplesSlider.bottomAnchor, constant: 30),
            startSamplingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSamplingButton.widthAnchor.constraint(equalToConstant: 300),
            startSamplingButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func samplingRateSliderChanged() {
        let samplingRates = UserDefaults.standard.array(forKey: "samplingRates") as! [Double]
        let index = Int(round(samplingRateSlider.value))
        samplingRateValueLabel.text = String(format: "%.2f", samplingRates[index])
    }
    
    @objc func numberOfSamplesSliderChanged() {
        let samples = Int(numberOfSamplesSlider.value)
        numberOfSamplesValueLabel.text = "\(samples)"
    }
    
    @objc func startSamplingButtonTapped() {
        let samplingRate = Double(samplingRateValueLabel.text!)!
        let numberOfSamples = UInt8(numberOfSamplesValueLabel.text!)!
        var writeData = UserDefaults.standard.data(forKey: "writeData")!
        let samplingRates = UserDefaults.standard.array(forKey: "samplingRates") as! [Double]
        
        writeData[3] = UInt8(samplingRates.firstIndex(of: samplingRate)!)
        writeData[4] = numberOfSamples
        UserDefaults.standard.set(writeData, forKey: "writeData")
    }
}
