//
//  ReportController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit
import Charts

class ReportController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let greetingLabel = UILabel()
        let scatterChartView = ScatterChartView()
        let samplingRateLabel = UILabel()
        let numberOfSamplesLabel = UILabel()

        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 30)
        greetingLabel.textColor = UIColor(named: "TextColor")
        greetingLabel.text = "Good Morning"
        
        scatterChartView.translatesAutoresizingMaskIntoConstraints = false
        scatterChartView.legend.enabled = false
        scatterChartView.xAxis.labelPosition = .bottom
        scatterChartView.rightAxis.enabled = false
        
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
        view.addSubview(samplingRateLabel)
        view.addSubview(numberOfSamplesLabel)

        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            scatterChartView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 50),
            scatterChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scatterChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scatterChartView.heightAnchor.constraint(equalToConstant: 300),
            
            samplingRateLabel.topAnchor.constraint(equalTo: scatterChartView.bottomAnchor, constant: 50),
            samplingRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            samplingRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            numberOfSamplesLabel.topAnchor.constraint(equalTo: samplingRateLabel.bottomAnchor, constant: 20),
            numberOfSamplesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfSamplesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let entries: [ChartDataEntry] = [
            ChartDataEntry(x: 2.02, y: 3.5),
            ChartDataEntry(x: 3.98, y: 3.5),

            ChartDataEntry(x: 1.94, y: 3.05),
            ChartDataEntry(x: 2.1, y: 2.99),
            ChartDataEntry(x: 2.3, y: 2.94),
            ChartDataEntry(x: 2.5, y: 2.89),
            ChartDataEntry(x: 2.75, y: 2.85),
            ChartDataEntry(x: 3.0, y: 2.84),
            ChartDataEntry(x: 3.25, y: 2.85),
            ChartDataEntry(x: 3.5, y: 2.89),
            ChartDataEntry(x: 3.7, y: 2.94),
            ChartDataEntry(x: 3.9, y: 2.99),
            ChartDataEntry(x: 4.06, y: 3.05),
        ]
        
        let dataSet = ScatterChartDataSet(entries: entries, label: "Example Scatter Plot")
        dataSet.colors = [NSUIColor.init(red: 58/255.0, green: 199/255.0, blue: 235/255.0, alpha: 1)]
        dataSet.setScatterShape(.circle)
        dataSet.scatterShapeSize = 25
        dataSet.drawValuesEnabled = false

        let data = ScatterChartData(dataSet: dataSet)
        scatterChartView.data = data
    }


}

