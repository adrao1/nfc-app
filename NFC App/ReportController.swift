//
//  ReportController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import Charts
import CoreData

class ReportController: UIViewController {
    let greetingLabel = UILabel()
    let scatterChartView = ScatterChartView()
    let sensorTypeLabel = UILabel()
    let samplingRateLabel = UILabel()
    let numberOfSamplesLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 30)
        greetingLabel.textColor = UIColor(named: "TextColor")
        greetingLabel.numberOfLines = 0
        greetingLabel.text = "Good \(getTime()) \(UserDefaults.standard.string(forKey: "userName")!)"

        scatterChartView.translatesAutoresizingMaskIntoConstraints = false
        scatterChartView.legend.enabled = false
        scatterChartView.xAxis.labelPosition = .bottom
        scatterChartView.rightAxis.enabled = false
        
        sensorTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        sensorTypeLabel.text = "Sensor Type:"
        sensorTypeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        sensorTypeLabel.textColor = UIColor(named: "TextColor")

        samplingRateLabel.translatesAutoresizingMaskIntoConstraints = false
        samplingRateLabel.text = "Sampling Rate (sec/sample):"
        samplingRateLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        samplingRateLabel.textColor = UIColor(named: "TextColor")
        
        numberOfSamplesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSamplesLabel.text = "Number of samples:"
        numberOfSamplesLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        numberOfSamplesLabel.textColor = UIColor(named: "TextColor")

        view.addSubview(greetingLabel)
        view.addSubview(scatterChartView)
        view.addSubview(sensorTypeLabel)
        view.addSubview(samplingRateLabel)
        view.addSubview(numberOfSamplesLabel)

        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            scatterChartView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 50),
            scatterChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scatterChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scatterChartView.heightAnchor.constraint(equalToConstant: 300),
            
            sensorTypeLabel.topAnchor.constraint(equalTo: scatterChartView.bottomAnchor, constant: 50),
            sensorTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sensorTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            samplingRateLabel.topAnchor.constraint(equalTo: sensorTypeLabel.bottomAnchor, constant: 20),
            samplingRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            samplingRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            numberOfSamplesLabel.topAnchor.constraint(equalTo: samplingRateLabel.bottomAnchor, constant: 20),
            numberOfSamplesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfSamplesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        if let latestSensorData = fetchLatestSensorData() {
            populateChart(with: latestSensorData)
        } else {
            displayEmptyChart()
        }
    }
    
    func getTime() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let time: String
        if currentHour >= 5 && currentHour < 12 {
            time = "Morning"
        } else if currentHour >= 12 && currentHour < 17 {
            time = "Afternoon"
        } else {
            time = "Evening"
        }
        return time
    }
    
    func fetchLatestSensorData() -> SensorData? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SensorData> = SensorData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch latest sensor data: \(error)")
            return nil
        }
    }
    
    func populateChart(with sensorData: SensorData) {
        guard let data = sensorData.sensorData else { return }
        
        let values = Array(data)
        let entries = values.enumerated().map { index, value in
            ChartDataEntry(x: Double(index), y: Double(value))
        }
        
        let dataSet = ScatterChartDataSet(entries: entries, label: "Sensor Data")
        dataSet.colors = [NSUIColor.init(red: 58/255.0, green: 199/255.0, blue: 235/255.0, alpha: 1)]
        dataSet.setScatterShape(.circle)
        dataSet.scatterShapeSize = 10
        dataSet.drawValuesEnabled = false
        
        scatterChartView.data = ScatterChartData(dataSet: dataSet)
        sensorTypeLabel.text =  "Sensor Type: \(sensorData.sensorType ?? "Unknown")"
        samplingRateLabel.text = "Sampling Rate (sec/sample): \(sensorData.samplingRate)"
        numberOfSamplesLabel.text = "Number of samples: \(sensorData.sampleCount)"
    }
    
    func displayEmptyChart() {
        let emptyDataSet = ScatterChartDataSet(entries: [], label: "No Data")
        scatterChartView.data = ScatterChartData(dataSet: emptyDataSet)
        sensorTypeLabel.text = "Sensor Type:"
        samplingRateLabel.text = "Sampling Rate (sec/sample):"
        numberOfSamplesLabel.text = "Number of samples:"
    }
}

