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
        guard let userId = Auth.auth().currentUser?.uid else {
            print("사용자가 로그인되어 있지 않습니다.")
            return
        }
        
        db.collection("history").document("bikelist").collection(userId).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("자전거 기록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
                return
            }
            
            var fetchedRecords: [BikeRecord] = []
            for document in querySnapshot!.documents {
                if let recordData = document.data() as? [String: Any],
                   let usageTime = recordData["usageTime"] as? Int,
                   let distance = recordData["distance"] as? Double,
                   let calories = recordData["calories"] as? Double,
                   let carbonReduction = recordData["carbonReduction"] as? Double {
                    
                    let record = BikeRecord(usageTime: usageTime, distance: distance, calories: calories, carbonReduction: carbonReduction)
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
        }
    }
}
