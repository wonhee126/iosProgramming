//
//  BikeStationInfoViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/4/24.
//



import UIKit

// annotation 선택 시 하단에 뜨는 정보
class BikeStationInfoView: UIView {
    
    private let stackView = UIStackView()
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
        
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 5
        stackView.layer.borderColor = UIColor(red: 174/255, green: 225/255, blue: 223/255, alpha: 1).cgColor
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stationNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        stationNameLabel.textColor = .black
        stationNameLabel.textAlignment = .left
        stationNameLabel.numberOfLines = 0
        stationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(stationNameLabel)
        
        availableBikesLabel.font = UIFont.boldSystemFont(ofSize: 24)
        availableBikesLabel.textColor = .black
        availableBikesLabel.textAlignment = .right
        availableBikesLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(availableBikesLabel)
        
        NSLayoutConstraint.activate([
            availableBikesLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30),
            availableBikesLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            stackView.widthAnchor.constraint(equalToConstant: 350),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        NSLayoutConstraint.activate([
            stationNameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            stationNameLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
            
        ])
    }
    
    func update(stationId: String, stationName: String, availableBikes: Int) {
        stationIdLabel.text = stationId
        stationNameLabel.text = stationName
        availableBikesLabel.text = "\(availableBikes)"
    }
}
