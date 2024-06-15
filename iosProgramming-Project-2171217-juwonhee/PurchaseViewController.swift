//
//  PurchaseViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//

import UIKit

class PurchaseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var rentalTime: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    let dailyLabel: UILabel = {
        let label = UILabel()
        label.text = "일일권"
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
        let rentalLabel: UILabel = {
            let label = UILabel()
            label.text = "기본 대여 시간"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let rentalTimePicker: UIPickerView = {
            let picker = UIPickerView()
            picker.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0) // very light gray
            picker.translatesAutoresizingMaskIntoConstraints = false
            return picker
        }()
        
        let paymentLabel: UILabel = {
            let label = UILabel()
            label.text = "결제금액"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text = "1000원"
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let amountDescLabel: UILabel = {
            let label = UILabel()
            label.text = "일일권(1시간)"
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let rentalOptions = ["1시간", "2시간", "3시간", "4시간", "5시간", "6시간"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavigationBar() // 상단바
            
            rentalTimePicker.dataSource = self
            rentalTimePicker.delegate = self
            
            setupLayout()
        }
        
        func setupNavigationBar() {
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
            self.navigationItem.title = ""
            
            let titleView = UIView()
            titleView.translatesAutoresizingMaskIntoConstraints = false
            
            let logoImage = UIImage(named: "NavigatorIcon")
            let imageView = UIImageView(image: logoImage)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLabel = UILabel()
            titleLabel.text = "EcoBike"
            titleLabel.font = UIFont.systemFont(ofSize: 8)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 2
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            titleView.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
                
                imageView.widthAnchor.constraint(equalToConstant: 36),
                imageView.heightAnchor.constraint(equalToConstant: 36)
            ])
            
            self.navigationItem.titleView = titleView
        }
        
        func setupLayout() {
                nextButton.setTitle("다음으로", for: .normal)
                nextButton.setTitleColor(.black, for: .normal)
                nextButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
                nextButton.translatesAutoresizingMaskIntoConstraints = false
                
            
            view.addSubview(rentalLabel)
            view.addSubview(rentalTimePicker)
            view.addSubview(paymentLabel)
            view.addSubview(amountLabel)
            view.addSubview(amountDescLabel)
            view.addSubview(nextButton)
            view.addSubview(dailyLabel)
  

                NSLayoutConstraint.activate([
                    dailyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    dailyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    dailyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    dailyLabel.heightAnchor.constraint(equalToConstant: 40),
                ])

            
            let paymentSectionBackground = UIView()
            paymentSectionBackground.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 0.5)
            paymentSectionBackground.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(paymentSectionBackground, belowSubview: paymentLabel)
            
            NSLayoutConstraint.activate([
                rentalLabel.topAnchor.constraint(equalTo: dailyLabel.bottomAnchor, constant: 40),
                rentalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                rentalTimePicker.topAnchor.constraint(equalTo: rentalLabel.bottomAnchor, constant: 20),
                rentalTimePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                rentalTimePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                rentalTimePicker.heightAnchor.constraint(equalToConstant: 150),
                
                nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                nextButton.heightAnchor.constraint(equalToConstant: 50),
                
                paymentLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -80),
                paymentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

                amountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                amountLabel.topAnchor.constraint(equalTo: paymentLabel.topAnchor),

                amountDescLabel.leadingAnchor.constraint(equalTo: paymentLabel.leadingAnchor),
                amountDescLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10),
                

                paymentSectionBackground.topAnchor.constraint(equalTo: paymentLabel.topAnchor, constant: -10),
                paymentSectionBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                paymentSectionBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                paymentSectionBackground.bottomAnchor.constraint(equalTo: amountDescLabel.bottomAnchor, constant: 42)
            ])
        }
    
        @objc func nextButtonTapped() {
            performSegue(withIdentifier: "SelectedStationViewController", sender: self)
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return rentalOptions.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return rentalOptions[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedRentalTime = rentalOptions[row]
            let price = (row + 1) * 1000 // 1시간에 1000원
            amountLabel.text = "\(price)원"
            amountDescLabel.text = "일일권(\(selectedRentalTime))"
            print("Selected rental time: \(selectedRentalTime)")
        }
    }
