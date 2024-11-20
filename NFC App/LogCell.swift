//
//  LogCell.swift
//  NFC App
//
//  Created by Aditya Rao on 11/19/24.
//

import UIKit

class LogCell: UITableViewCell {
    
    let timestampLabel = UILabel()
    let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        timestampLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        timestampLabel.textColor = .label
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.numberOfLines = 0
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(timestampLabel)
        contentView.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            timestampLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(timestamp: String?, details: String) {
        timestampLabel.text = timestamp
        detailsLabel.text = details
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
