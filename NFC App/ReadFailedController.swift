//
//  ReadFailedController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class ReadFailedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let warningImageView = UIImageView()
        let instructionLabel = UILabel()
        let retryButton = UIButton()
        let stackView = UIStackView(arrangedSubviews: [warningImageView, instructionLabel, retryButton])
        
        warningImageView.translatesAutoresizingMaskIntoConstraints = false
        warningImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        warningImageView.tintColor = .systemYellow
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.text = "Read Failed\nPlease try again"
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        instructionLabel.textColor = UIColor(named: "TextColor")
        instructionLabel.numberOfLines = 0

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Retry", for: .normal)
        retryButton.backgroundColor = UIColor(named: "ButtonColor")
        retryButton.layer.cornerRadius = 10
        retryButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            warningImageView.widthAnchor.constraint(equalToConstant: 50),
            warningImageView.heightAnchor.constraint(equalToConstant: 50),
            
            retryButton.widthAnchor.constraint(equalToConstant: 300),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func retryButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
