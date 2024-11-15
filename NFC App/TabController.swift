//
//  TabController.swift
//  NFC App
//
//  Created by Aditya Rao on 11/15/24.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let report = ReportController()
        let read = UINavigationController(rootViewController: Read1Controller())
        let log = LogController()

        report.tabBarItem = UITabBarItem(
            title: "Report",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        read.tabBarItem = UITabBarItem(
            title: "Read",
            image: UIImage(systemName: "antenna.radiowaves.left.and.right"), 
            selectedImage: UIImage(systemName: "antenna.radiowaves.left.and.right")
        )
        log.tabBarItem = UITabBarItem(
            title: "Log",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.fill")
        )

        self.viewControllers = [report, read, log]
    }
    
    private func setupTabs() {
        
    }
}
