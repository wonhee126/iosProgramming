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
    
    // MARK: - Outlets
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet weak var carbonReductionLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var startBikeStationLabel: UILabel!
    @IBOutlet weak var endBikeStationLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    

        
        // MARK: - Properties
        private let db = Firestore.firestore()
        private var bikeRecords: [BikeRecord] = []
            
        // MARK: - Lifecycle Methods
        override func viewDidLoad() {
            super.viewDidLoad()
            fetchBikeRecords()
        }
            
        // MARK: - Firestore Interaction
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
//                       let startTimeStamp = recordData["startTime"] as? String,
//                       let endTimeStamp = recordData["endTime"] as? String{
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
            
        // MARK: - UI Update
        func updateUI() {
            guard let latestRecord = bikeRecords.last else {
                print("자전거 기록이 없습니다.")
                return
            }
                
            DispatchQueue.main.async {
                self.usageTimeLabel.text = "이용 시간: \(latestRecord.usageTime) 분"
                self.distanceLabel.text = String(format: "거리: %.2f km", latestRecord.distance)
                self.caloriesLabel.text = String(format: "칼로리 소모: %.1f kcal", latestRecord.calories)
                self.carbonReductionLabel.text = String(format: "탄소 절감: %.3f kg", latestRecord.carbonReduction)
                self.startBikeStationLabel.text = latestRecord.startLocation
                self.endBikeStationLabel.text = latestRecord.endLocation
                
//                self.startTimeLabel.text = latestRecord.startTime
//                self.endTimeLabel.text =  latestRecord.endTime
//
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 M월 d일 a h시 m분 s초"
                dateFormatter.timeZone = TimeZone.current
                
                self.startTimeLabel.text = dateFormatter.string(from: latestRecord.startTime)
                self.endTimeLabel.text = dateFormatter.string(from: latestRecord.endTime)
            }
        }
    }
