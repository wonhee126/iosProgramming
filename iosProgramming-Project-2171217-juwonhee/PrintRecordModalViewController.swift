//
//  PringRecordViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PrintRecordModalViewController: UIViewController {
    
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet weak var carbonReductionLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startBikeStationLabel: UILabel!
    @IBOutlet weak var endBikeStationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
        private let db = Firestore.firestore()
        private var bikeRecords: [BikeRecord] = []
            
        override func viewDidLoad() {
            super.viewDidLoad()
            fetchBikeRecords()
        }

        func fetchBikeRecords() {
            guard let user = Auth.auth().currentUser else {
                print("사용자가 로그인되어 있지 않습니다.")
                return
            }
                
            let userEmail = user.email ?? "unknown@example.com"
                        
            db.collection("history").document("bikelist").collection(userEmail)
                        .order(by: "endTime", descending: true)
                        .limit(to: 1)
                        .getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("자전거 기록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
                                return
                            }
                                
                            guard let document = querySnapshot?.documents.first else {
                                print("자전거 기록이 없습니다.")
                                return
                            }
                    
                var fetchedRecords: [BikeRecord] = []
                for document in querySnapshot!.documents {
                    if let recordData = document.data() as? [String: Any],
                       let usageTime = recordData["usageTime"] as? Int,
                       let distance = recordData["distance"] as? Double,
                       let calories = recordData["calories"] as? Double,
                       let carbonReduction = recordData["carbonReduction"] as? Double,
                       let startLocation = recordData["startLocation"] as? String,
                       let endLocation = recordData["endLocation"] as? String,
                       let startTimeStamp = recordData["startTime"] as? Timestamp,
                       let endTimeStamp = recordData["endTime"] as? Timestamp {
                       let startTime = startTimeStamp.dateValue()
                       let endTime = endTimeStamp.dateValue()
                        
                        let record = BikeRecord(
                            usageTime: usageTime,
                            distance: distance,
                            calories: calories,
                            carbonReduction: carbonReduction,
                            startLocation: startLocation,
                            endLocation: endLocation,
                            startTime: startTime,
                            endTime: endTime
                        )
                        fetchedRecords.append(record)
                    }
                }
                    
                self.bikeRecords = fetchedRecords
                self.updateUI()
            }
        }
            
        func updateUI() {
            guard let latestRecord = bikeRecords.last else {
                print("자전거 기록이 없습니다.")
                return
            }
                
            startBikeStationLabel.isHidden = true
            endBikeStationLabel.isHidden = true
            startTimeLabel.isHidden = true
            endTimeLabel.isHidden = true
            
            DispatchQueue.main.async {
                self.usageTimeLabel.text = "\(latestRecord.usageTime) 분 동안"
                self.distanceLabel.text = String(format: "%.2f km를 이동하여", latestRecord.distance)
                self.caloriesLabel.text = String(format: "%.1f kcal를 소모하였습니다.", latestRecord.calories)
                self.carbonReductionLabel.text = String(format: "%.3f kg이 탄소절감 되었습니다.", latestRecord.carbonReduction)
                self.startBikeStationLabel.text = latestRecord.startLocation
                self.endBikeStationLabel.text = latestRecord.endLocation
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 M월 d일 a h시 m분 s초"
                dateFormatter.timeZone = TimeZone.current
                
                self.startTimeLabel.text = dateFormatter.string(from: latestRecord.startTime)
                self.endTimeLabel.text = dateFormatter.string(from: latestRecord.endTime)
                
                
            }
        }
    }
