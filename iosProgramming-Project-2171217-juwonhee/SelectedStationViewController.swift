//
//  SelectedStationViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//

import UIKit

class SelectedStationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        // Create and configure the departure and arrival labels and buttons
        let departureLabel: UILabel = {
            let label = UILabel()
            label.text = "출발지"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let departureStationLabel: UILabel = {
            let label = UILabel()
            label.text = "정류장이름1"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let departureMapButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("지도 보러가기", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let arrivalLabel: UILabel = {
            let label = UILabel()
            label.text = "도착지"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let arrivalStationLabel: UILabel = {
            let label = UILabel()
            label.text = "정류장이름2"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let arrivalMapButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("지도 보러가기", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("다음으로", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        // Add the subviews
        view.addSubview(departureLabel)
        view.addSubview(departureStationLabel)
        view.addSubview(departureMapButton)
        view.addSubview(arrivalLabel)
        view.addSubview(arrivalStationLabel)
        view.addSubview(arrivalMapButton)
        view.addSubview(nextButton)
        
        // Create a background view for the labels and buttons
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 0.3)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, belowSubview: departureLabel)
        
        // Define the layout constraints
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalToConstant: 100),
            
            departureLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            departureLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            
            departureStationLabel.centerYAnchor.constraint(equalTo: departureLabel.centerYAnchor),
            departureStationLabel.leadingAnchor.constraint(equalTo: departureLabel.trailingAnchor, constant: 20),
            
            departureMapButton.centerYAnchor.constraint(equalTo: departureLabel.centerYAnchor),
            departureMapButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            
            arrivalLabel.topAnchor.constraint(equalTo: departureLabel.bottomAnchor, constant: 20),
            arrivalLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            
            arrivalStationLabel.centerYAnchor.constraint(equalTo: arrivalLabel.centerYAnchor),
            arrivalStationLabel.leadingAnchor.constraint(equalTo: arrivalLabel.trailingAnchor, constant: 20),
            
            arrivalMapButton.centerYAnchor.constraint(equalTo: arrivalLabel.centerYAnchor),
            arrivalMapButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

