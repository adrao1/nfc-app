//
//  Read2Controller.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import CoreNFC

class Read2Controller: UIViewController {
    var session: NFCTagReaderSession?
    var timeLeft: Int = 0
    var timer: Timer?
    
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
        self.timeLeft = Int(ceil(samplingRate * Double(numberOfSamples)))

        writeData[3] = UInt8(samplingRates.firstIndex(of: samplingRate)!)
        writeData[4] = numberOfSamples
        UserDefaults.standard.set(writeData, forKey: "writeData")
        
        self.session = NFCTagReaderSession(pollingOption: [.iso15693], delegate: self, queue: nil)
        self.session?.alertMessage = "Hold phone close to sensor for \(self.timeLeft) seconds."
        self.session?.begin()
        
    }
}

extension Read2Controller: NFCTagReaderSessionDelegate {
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
                self.writeTag(iso15693Tag: iso15693Tag)
            default:
                print("Unsupported tag type.")
                session.invalidate(errorMessage: "Unsupported tag.")
            }
        }
    }
    
    func writeTag(iso15693Tag: NFCISO15693Tag?) {
        let writeData = UserDefaults.standard.data(forKey: "writeData")!
        
        guard let tag = iso15693Tag else {
            print("No tag available to write.")
            return
        }
        
        tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: 0, dataBlock: writeData) { error in
            if let error = error {
                print("Error writing block: \(error.localizedDescription)")
                return
            }
            
            print("Successfully wrote to block \(0): \(writeData)")
            let hexString = writeData.map { String(format: "%02x", $0) }.joined()
            print("Data written in hex: \(hexString.uppercased())")
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    if self.timeLeft >= 0 {
                        self.session?.alertMessage = "Hold phone close to sensor for \(self.timeLeft) seconds."
                        self.timeLeft -= 1
                    } else {
                        timer.invalidate()
                        self.readData(iso15693Tag: iso15693Tag)
                    }
                }
            }
        }
    }
    
    func readData(iso15693Tag: NFCISO15693Tag?) {
        guard let tag = iso15693Tag else {
            print("No tag available to write.")
            return
        }
        
        let writeData = UserDefaults.standard.data(forKey: "writeData")!
        let numberOfSamples = Int(writeData[4])
        
        let startBlock = 9
        let dataSize = 2
        let blockSize = 8
        let totalBytes = numberOfSamples * dataSize
        let blocksToRead = Int(ceil(Double(totalBytes) / Double(blockSize)))

        var currentBlock = startBlock
        var allData = Data()
        
        func readNextBlock() {
            if currentBlock < startBlock + blocksToRead {
                tag.readSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: UInt8(currentBlock)) { (data, error) in
                    if let error = error {
                        print("Error reading block \(currentBlock): \(error.localizedDescription)")
                        self.session?.invalidate()
                        return
                    }
                    
                    print("Data read from block \(currentBlock): \(data)")
                    allData.append(data)
                    
                    currentBlock += 1
                    readNextBlock()
                }
            } else {
                let hexString = allData.map { String(format: "%02X", $0) }.joined()
                print("Complete data read in hex: \(hexString.uppercased())")
                let expectedDataLength = numberOfSamples * dataSize
                let trimmedData = allData.prefix(expectedDataLength)
                print("Trimmed data: \(trimmedData.map { String(format: "%02X", $0) }.joined().uppercased())")
                self.session?.invalidate()
                DispatchQueue.main.async {
                    self.saveSensorData(data: trimmedData)
                    self.navigationController?.pushViewController(ReadSuccessController(), animated: true)
                }
            }
        }
        tag.readSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: 0) { (data, error) in
            if let error = error {
                print("Error reading block \(currentBlock): \(error.localizedDescription)")
                self.session?.invalidate()
                return
            }
            
            let hexString = data.map { String(format: "%02X", $0) }.joined()
            print("Data read from block 0 in hex: \(hexString)")
        }
        readNextBlock()
    }
    
    func saveSensorData(data: Data) {
        DispatchQueue.main.async {
            let writeData = UserDefaults.standard.data(forKey: "writeData")!
            let samplingRates = UserDefaults.standard.array(forKey: "samplingRates")!
            let numberOfSamples = Int(writeData[4])
            let sensorType = (writeData[2] == 4) ? "Light" : "Temperature"
            let samplingRateIndex = Int(writeData[3])
            let samplingRate = samplingRates[samplingRateIndex] as! Double
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let sensorDataEntity = SensorData(context: context)
            sensorDataEntity.timestamp = Date()
            sensorDataEntity.sensorType = sensorType
            sensorDataEntity.sampleCount = Int16(numberOfSamples)
            sensorDataEntity.samplingRate = samplingRate
            sensorDataEntity.sensorData = data
            
            do {
                try context.save()
                print("Sensor data saved successfully.")
            } catch {
                print("Failed to save sensor data: \(error.localizedDescription)")
            }
        }
    }
}
