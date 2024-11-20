//
//  LogController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import CoreData

class LogController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var sensorDataArray: [SensorData] = []
    var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        
        let sensorData = sensorDataArray[indexPath.row]
        
        let formattedDate = DateFormatter.localizedString(from: sensorData.timestamp!, dateStyle: .medium, timeStyle: .short)
        let sensorType = sensorData.sensorType!
        let samplingRate = sensorData.samplingRate
        let numberOfSamples = sensorData.sampleCount
        let details = "Type: \(sensorType), Rate: \(samplingRate) Hz, Samples: \(numberOfSamples)"
        
        cell.configure(timestamp: formattedDate, details: details)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSensorData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LogCell.self, forCellReuseIdentifier: "LogCell")
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        fetchSensorData()
    }
    
    func fetchSensorData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SensorData> = SensorData.fetchRequest()

        do {
            sensorDataArray = try context.fetch(fetchRequest)
            sensorDataArray.sort { ($0.timestamp ?? Date.distantPast) > ($1.timestamp ?? Date.distantPast) }
            tableView.reloadData()
        } catch {
            print("Failed to fetch sensor data: \(error)")
        }
    }
}
