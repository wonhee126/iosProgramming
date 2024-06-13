//
//  PrintRecordViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PrintRecordViewController: UIViewController {

    @IBOutlet weak var bikeRecordTableView: UITableView!
    
        
        private var bikeRecords: [BikeRecord] = []
        private let db = Firestore.firestore()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            configureTableView()
            fetchBikeRecords()
        }
        
        func configureTableView() {
            bikeRecordTableView.delegate = self
            bikeRecordTableView.dataSource = self
            bikeRecordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
        
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
                self.bikeRecordTableView.reloadData()
            }
        }
    }

    extension PrintRecordViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bikeRecords.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let record = bikeRecords[indexPath.row]
            cell.textLabel?.text = "이용 시간: \(record.usageTime) 분, 거리: \(record.distance) km"
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRecord = bikeRecords[indexPath.row]
            showDetailViewController(for: selectedRecord)
        }
        
        func showDetailViewController(for record: BikeRecord) {
//            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//            detailVC.bikeRecord = record
//            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

