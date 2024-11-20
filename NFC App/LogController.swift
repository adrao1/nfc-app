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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimestampCell", for: indexPath)
        
        let sensorData = sensorDataArray[indexPath.row]
        if let timestamp = sensorData.timestamp {
            let formattedDate = DateFormatter.localizedString(from: timestamp, dateStyle: .medium, timeStyle: .short)
            cell.textLabel?.text = formattedDate
        } else {
            cell.textLabel?.text = "No Timestamp Available"
        }
        
        return cell
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimestampCell")
        
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
