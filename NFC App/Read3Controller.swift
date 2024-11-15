//
//  Read3Controller.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class Read3Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor(named: "ButtonColor")
        nextButton.layer.cornerRadius = 10
        nextButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 300),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func nextButtonTapped() {
        navigationController?.pushViewController(Read4Controller(), animated: true)
    }
}
