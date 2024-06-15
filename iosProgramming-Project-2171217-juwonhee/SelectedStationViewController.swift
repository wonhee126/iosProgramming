//
//  SelectedStationViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//


//
//  SelectedStationViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SelectedStationViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!

        let db = Firestore.firestore()

        var startLocation: String = ""
        var endLocation: String = ""

        let departureLabel: UILabel = {
            let label = UILabel()
            label.text = "출발지"
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

        let departureStationLabel: UILabel = {
            let label = UILabel()
            label.text = "출발지를 설정해주세요"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let arrivalStationLabel: UILabel = {
            let label = UILabel()
            label.text = "도착지를 설정해주세요"
            label.textColor = .black
            label.font = UIFont(name: "Inter-Regular", size: 20)
            label.textAlignment = .center
            label.lineBreakMode = .byTruncatingTail
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavigationBar() // 상단바
            setupLayout()
            fetchLocations()
            updateNextButtonState()
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
            let backgroundView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.layer.borderWidth = 10
                view.layer.borderColor = UIColor(red: 0.788, green: 0.906, blue: 0.898, alpha: 1).cgColor
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()

            nextButton.setTitle("다음으로", for: .normal)
            nextButton.setTitleColor(.black, for: .normal)
            nextButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            
      
            view.addSubview(backgroundView)
            backgroundView.addSubview(departureLabel)
            backgroundView.addSubview(arrivalLabel)
            backgroundView.addSubview(departureStationLabel)
            backgroundView.addSubview(arrivalStationLabel)
            view.addSubview(nextButton)

            NSLayoutConstraint.activate([
                nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                nextButton.heightAnchor.constraint(equalToConstant: 50),
                
                backgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 188),
                backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
                backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
                backgroundView.heightAnchor.constraint(equalToConstant: 170),

                departureLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
                departureLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
                departureLabel.widthAnchor.constraint(equalToConstant: 56),
                departureLabel.heightAnchor.constraint(equalToConstant: 24),

                arrivalLabel.topAnchor.constraint(equalTo: departureLabel.bottomAnchor, constant: 61),
                arrivalLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
                arrivalLabel.widthAnchor.constraint(equalToConstant: 56),
                arrivalLabel.heightAnchor.constraint(equalToConstant: 24),

                departureStationLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30),
                departureStationLabel.leadingAnchor.constraint(equalTo: departureLabel.trailingAnchor, constant: 10),
                //departureStationLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
                departureStationLabel.heightAnchor.constraint(equalToConstant: 24),

                arrivalStationLabel.topAnchor.constraint(equalTo: departureStationLabel.bottomAnchor, constant: 61),
                arrivalStationLabel.leadingAnchor.constraint(equalTo: arrivalLabel.trailingAnchor, constant: 10),
                //arrivalStationLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
                arrivalStationLabel.heightAnchor.constraint(equalToConstant: 24),
            ])
        }

        func fetchLocations() {
            guard let user = Auth.auth().currentUser else {
                print("사용자가 로그인되어 있지 않습니다.")
                return
            }

            let docRef = db.collection("Users").document(user.uid).collection("history").document("bikeList").collection("1").document("record")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.startLocation = document.data()?["startLocation"] as? String ?? ""
                    self.endLocation = document.data()?["endLocation"] as? String ?? ""
                    self.updateUI()
                } else {
                    print("Document does not exist")
                    self.startLocation = ""
                    self.endLocation = ""
                    self.updateUI()
                    self.initializeUserData(for: user.uid)
                }
            }
        }

        func initializeUserData(for userId: String) {
            let docRef = db.collection("Users").document(userId).collection("history").document("bikeList").collection("1").document("record")

            let initialData: [String: Any] = [
                "startLocation": "",
                "endLocation": ""
            ]
            
            docRef.setData(initialData) { error in
                if let error = error {
                    print("Error initializing user data: \(error.localizedDescription)")
                } else {
                    print("User data initialized successfully")
                    self.startLocation = ""
                    self.endLocation = ""
                    self.updateUI()
                }
            }
        }

        func updateUI() {
            let cleanStartLocation = startLocation.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))).joined()
            let cleanEndLocation = endLocation.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))).joined()

            departureStationLabel.text = cleanStartLocation.isEmpty ? "출발지를 설정해주세요" : cleanStartLocation
            arrivalStationLabel.text = cleanEndLocation.isEmpty ? "도착지를 설정해주세요" : cleanEndLocation
            
            updateNextButtonState()
        }
    
    func updateNextButtonState() {
           if departureStationLabel.text != "출발지를 설정해주세요" && arrivalStationLabel.text != "도착지를 설정해주세요" {
               nextButton.isEnabled = true
           } else {
               nextButton.isEnabled = false
           }
       }

    
    }
