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
        // Create and configure the departure and arrival labels
        let departureLabel: UILabel = {
            let label = UILabel()
            label.text = "출발지"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let departureStationLabel: UILabel = {
            let label = UILabel()
            label.text = "정류장이름1"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let arrivalLabel: UILabel = {
            let label = UILabel()
            label.text = "도착지"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let arrivalStationLabel: UILabel = {
            let label = UILabel()
            label.text = "정류장이름2"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // Create a background view for the labels
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.borderWidth = 10
            view.layer.borderColor = UIColor(red: 0.788, green: 0.906, blue: 0.898, alpha: 1).cgColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Add subviews to the main view
        view.addSubview(backgroundView)
        backgroundView.addSubview(departureLabel)
        backgroundView.addSubview(departureStationLabel)
        backgroundView.addSubview(arrivalLabel)
        backgroundView.addSubview(arrivalStationLabel)
        
        // Define layout constraints
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 188),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            backgroundView.heightAnchor.constraint(equalToConstant: 170),
            
            departureLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            departureLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 39),
            departureLabel.widthAnchor.constraint(equalToConstant: 56),
            departureLabel.heightAnchor.constraint(equalToConstant: 24),
            
            departureStationLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
            departureStationLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 215),
            departureStationLabel.widthAnchor.constraint(equalToConstant: 102),
            departureStationLabel.heightAnchor.constraint(equalToConstant: 24),
            
            arrivalLabel.topAnchor.constraint(equalTo: departureLabel.bottomAnchor, constant: 61),
            arrivalLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 39),
            arrivalLabel.widthAnchor.constraint(equalToConstant: 56),
            arrivalLabel.heightAnchor.constraint(equalToConstant: 24),
            
            arrivalStationLabel.topAnchor.constraint(equalTo: departureStationLabel.bottomAnchor, constant: 61),
            arrivalStationLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 215),
            arrivalStationLabel.widthAnchor.constraint(equalToConstant: 105),
            arrivalStationLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
