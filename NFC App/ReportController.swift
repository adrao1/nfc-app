//
//  ReportController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class ReportController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let greetingLabel = UILabel()
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 30)
        greetingLabel.textColor = UIColor(named: "TextColor")
        greetingLabel.text = "Good Morning"
        view.addSubview(greetingLabel)

        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }


}

