//
//  BikeStationInfoViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/4/24.
//

import UIKit

class BikeStationInfoView: UIView {
    
    private let stationIdLabel = UILabel()
    private let stationNameLabel = UILabel()
    private let availableBikesLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Setup the view's appearance
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        // Setup the stationId label
        stationIdLabel.font = UIFont.systemFont(ofSize: 14)
        stationIdLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stationIdLabel)
        
        // Setup the stationName label
        stationNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stationNameLabel)
        
        // Setup the availableBikes label
        availableBikesLabel.font = UIFont.systemFont(ofSize: 14)
        availableBikesLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(availableBikesLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            stationIdLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stationIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stationIdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            stationNameLabel.topAnchor.constraint(equalTo: stationIdLabel.bottomAnchor, constant: 10),
            stationNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stationNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            availableBikesLabel.topAnchor.constraint(equalTo: stationNameLabel.bottomAnchor, constant: 10),
            availableBikesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            availableBikesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            availableBikesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func update(stationId: String, stationName: String, availableBikes: Int) {
        stationIdLabel.text = stationId
        stationNameLabel.text = stationName
        availableBikesLabel.text = "\(availableBikes)"
    }
}
