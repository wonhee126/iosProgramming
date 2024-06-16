//
//  BikeMeasurementViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//



//이용 시간: 분 단위로 표시.
//거리: 1초당 4.17미터 (0.00417km)로 계산.
//칼로리: 1분당 5.8 칼로리로 계산.
//탄소절감: 1km당 0.21kg CO2로 계산.


import UIKit
import Firebase
import FirebaseAuth

class BikeMeasurementViewController: UIViewController {


    @IBOutlet weak var arrivedButton: UIButton!
    @IBOutlet weak var departButton: UIButton!
    @IBOutlet weak var startBikeStation: UILabel!
    @IBOutlet weak var endBikeStation: UILabel!

        var timer: Timer?
        var startTime: Date?
        var endTime: Date?
        var elapsedTime: TimeInterval = 0.0
    
        let stopwatchLabel = UILabel()
        let usageTimeLabel = UILabel()
        let distanceLabel = UILabel()
        let calorieLabel = UILabel()
        let carbonReductionLabel = UILabel()
        let arrowLabel = UILabel()

        let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
            arrivedButton.isEnabled = false
            setupNavigationBar()
            setupStopwatchLabel()
            setupMetricsLabels()
            setupStartButton()
            setupStopButton()
            fetchBikeStations()
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

        func setupStopwatchLabel() {
            stopwatchLabel.textColor = .black
            stopwatchLabel.font = UIFont(name: "Jua-Regular", size: 40)
            stopwatchLabel.font = UIFont.boldSystemFont(ofSize: 48)
            stopwatchLabel.text = "00:00:00초"
            
            let parent = self.view!
            parent.addSubview(stopwatchLabel)
            stopwatchLabel.translatesAutoresizingMaskIntoConstraints = false

            
            NSLayoutConstraint.activate([
                stopwatchLabel.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                stopwatchLabel.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: -50),
                 stopwatchLabel.heightAnchor.constraint(equalToConstant: 50),
               
             ])
        }
        
    func setupMetricsLabels() {
        setupMetricLabel(label: usageTimeLabel, text: "이용시간: 0분", yPosition: 480, isLeftAligned: true)
        setupMetricLabel(label: distanceLabel, text: "거리: 0.00km", yPosition: 530, isLeftAligned: true)
        setupMetricLabel(label: calorieLabel, text: "칼로리: 0.0kcal", yPosition: 480, isLeftAligned: false)
        setupMetricLabel(label: carbonReductionLabel, text: "탄소절감: 0.0kg", yPosition: 530, isLeftAligned: false)
    }

    func setupMetricLabel(label: UILabel, text: String, yPosition: CGFloat, isLeftAligned: Bool) {
        label.textColor = .black
        label.font = UIFont(name: "Jua-Regular", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = text
        
        let parent = self.view!
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        if isLeftAligned {
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 20),
                label.topAnchor.constraint(equalTo: parent.topAnchor, constant: yPosition)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -20),
                label.topAnchor.constraint(equalTo: parent.topAnchor, constant: yPosition)
            ])
        }
    }


    func setupStartButton() {
        departButton.setTitle("출발하기", for: .normal)
        departButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 30)
        departButton.setTitleColor(.black, for: .normal)
        departButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        departButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        

        
        let parent = self.view!
        parent.addSubview(departButton)
        
        departButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            departButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            departButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            departButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 120),
            departButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }


        func setupStopButton() {
            arrivedButton.setTitle("목적지 도착", for: .normal)
            arrivedButton.setTitleColor(.black, for: .normal)
            arrivedButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
            arrivedButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
            arrivedButton.translatesAutoresizingMaskIntoConstraints = false
            
            let parent = self.view!
            parent.addSubview(arrivedButton)
            arrivedButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                arrivedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                arrivedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                arrivedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                arrivedButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        }

        func fetchBikeStations() {
            guard let user = Auth.auth().currentUser else {
                print("사용자가 로그인되어 있지 않습니다.")
                return
            }

            let docRef = db.collection("Users").document(user.uid).collection("history").document("bikeList").collection("1").document("record")

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let startLocation = document.data()?["startLocation"] as? String ?? "출발지를 설정해주세요"
                    let endLocation = document.data()?["endLocation"] as? String ?? "도착지를 설정해주세요"
                    
                    let cleanStartLocation = startLocation.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))).joined()
                    let cleanEndLocation = endLocation.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))).joined()

                    self.startBikeStation.text = cleanStartLocation
                    self.endBikeStation.text = cleanEndLocation
                } else {
                    print("목적지를 설정해주세요.")
                    self.startBikeStation.text = "출발지를 설정해주세요"
                    self.endBikeStation.text = "도착지를 설정해주세요"
                }
            }
        }

        @objc func startButtonTapped() {
            startStopwatch()
            arrivedButton.isEnabled = true
            departButton.isHidden = true
            navigationItem.hidesBackButton = true
            
            startTime = Date() // 출발한 시각
        }
        
    @objc func stopButtonTapped() {
        stopStopwatch()
        arrivedButton.isEnabled = false
        endTime = Date()
        
        saveBikeRecordToFirebase(startTime: startTime, endTime: endTime)
        departButton.isHidden = true
        
        resetBikeRecordInFirestore()
        
    }

    // 목적지 도착 버튼 클릭 후 호출
    // 설정한 경로 초기화하여 새롭게 경로 선택할 수 있게 함
    func resetBikeRecordInFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let docRef = db.collection("Users").document(user.uid)
                         .collection("history").document("bikeList")
                         .collection("1").document("record")
        
        let defaultStartLocation = "출발지를 설정해주세요"
        let defaultEndLocation = "도착지를 설정해주세요"
        let startTimestamp = Timestamp(date: Date())
        let endTimestamp = Timestamp(date: Date())
        
        docRef.updateData([
                "startLocation": defaultStartLocation,
                "startTimestamp": startTimestamp,
                "startType": "",
                "endLocation": defaultEndLocation,
                "endTimestamp": endTimestamp,
                "endType": ""
      
            ]) { error in
                if let error = error {
                    print("초기화 실패")
                } else {
                    print("성공적으로 데이터가 초기화되었습니다.")
                }
            }
        }
    
    
        func startStopwatch() {
            timer?.invalidate()
            elapsedTime = 0.0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
        }
        
        @objc func updateStopwatch() {
            elapsedTime += 1.0
            let hours = Int(elapsedTime) / 3600
            let minutes = (Int(elapsedTime) / 60) % 60
            let seconds = Int(elapsedTime) % 60
            stopwatchLabel.text = String(format: "%02d:%02d:%02d초", hours, minutes, seconds)
            
            let totalSeconds = Int(elapsedTime)
            let totalMinutes = totalSeconds / 60
            
            let distance = (elapsedTime * 4.17) / 1000.0
            let calories = Double(totalMinutes) * 5.8
            let carbonReduction = distance * 0.21
            
            usageTimeLabel.text = String(format: "이용시간: %d분", totalMinutes)
            distanceLabel.text = String(format: "거리: %.2fkm", distance)
            calorieLabel.text = String(format: "칼로리: %.1fkcal", calories)
            carbonReductionLabel.text = String(format: "탄소절감: %.2fkg", carbonReduction)
        }
        
        func stopStopwatch() {
            timer?.invalidate()
            timer = nil
        }
        
        func saveBikeRecordToFirebase(startTime: Date?, endTime: Date?) {
            guard let user = Auth.auth().currentUser else {
                        print("사용자가 로그인이 되어있지 않습니다.")
                        return
                    }

            guard let startTime = startTime, let endTime = endTime else {
                    print("변수에 nil 이 있습니다.")
                    return
                }
            
            let startLocation = startBikeStation.text ?? "출발지를 설정해주세요"
            let endLocation = endBikeStation.text ?? "도착지를 설정해주세요"
            

            
            let record = BikeRecord(usageTime: Int(elapsedTime / 60), distance: (elapsedTime * 4.17) / 1000.0, calories: Double(Int(elapsedTime / 60)) * 5.8, carbonReduction: (elapsedTime * 4.17) / 1000.0 * 0.21, startLocation: startLocation, endLocation: endLocation, startTime: startTime, endTime: endTime)
            
            FirestoreManager.shared.saveBikeRecord(record, forUser: user.email ?? "unknown") { error in
                        if let error = error {
                            print("자전거 기록에 실패하였습니다.")
                            return
                        }
                        print("성공정으로 기록되었습니다.")
                    //print("record: \(record)")
                    }
            }
        }
    

                                       
