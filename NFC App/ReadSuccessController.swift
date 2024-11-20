//
//  Read4Controller.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import CoreData

class ReadSuccessController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let instructionLabel = UILabel()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.text = "Read Successful!\nSee report for details"
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        instructionLabel.textColor = UIColor(named: "TextColor")
        instructionLabel.numberOfLines = 0

        let goToReportButton = UIButton()
        goToReportButton .translatesAutoresizingMaskIntoConstraints = false
        goToReportButton .setTitle("Go to Report", for: .normal)
        goToReportButton .backgroundColor = UIColor(named: "ButtonColor")
        goToReportButton .layer.cornerRadius = 10
        goToReportButton .setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        goToReportButton .addTarget(self, action: #selector(goToReportButtonTapped), for: .touchUpInside)
        
        view.addSubview(instructionLabel)
        view.addSubview(goToReportButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            goToReportButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30),
            goToReportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToReportButton.widthAnchor.constraint(equalToConstant: 300),
            goToReportButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func goToReportButtonTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SensorData> = SensorData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let sensorData = try context.fetch(fetchRequest).first
            if let reportController = tabBarController?.viewControllers?.first as? ReportController {
                reportController.selectedSensorData = sensorData
            }
        } catch {
            print("Failed to fetch latest sensor data: \(error)")
        }
        
        tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: false)
    }
}
