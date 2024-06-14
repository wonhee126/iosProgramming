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
        private var listener: ListenerRegistration?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureTableView()
            fetchBikeRecords()
        }
        
        deinit {
            listener?.remove()
        }
        
        func configureTableView() {
            bikeRecordTableView.delegate = self
            bikeRecordTableView.dataSource = self
            bikeRecordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
        
        func fetchBikeRecords() {
            guard let user = Auth.auth().currentUser else {
                print("사용자가 로그인되어 있지 않습니다.")
                return
            }
            
            let userEmail = user.email ?? "unknown@example.com"
            
    
            listener = db.collection("history")
                .document("bikelist")
                .collection(userEmail)
                .addSnapshotListener { [weak self] (querySnapshot, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching bike records: \(error.localizedDescription)")
                        return
                    }
                    
                    var fetchedRecords: [BikeRecord] = []
                    
                    for document in querySnapshot!.documents {
                        let recordData = document.data()
                        
                        guard let usageTime = recordData["usageTime"] as? Int,
                              let distance = recordData["distance"] as? Double,
                              let calories = recordData["calories"] as? Double,
                              let carbonReduction = recordData["carbonReduction"] as? Double,
                              let startLocation = recordData["startLocation"] as? String,
                              let endLocation = recordData["endLocation"] as? String,
                              let startTimeStamp = recordData["startTime"] as? Timestamp,
                              let endTimeStamp = recordData["endTime"] as? Timestamp else {
                            print("Invalid data format for document \(document.documentID)")
                            continue
                        }
                        
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
                    
           
                    self.bikeRecords = fetchedRecords
                    DispatchQueue.main.async {
                        self.bikeRecordTableView.reloadData()
                    }
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
            let formattedDistance = String(format: "거리: %.3f km", record.distance)
            cell.textLabel?.text = "이용 시간: \(record.usageTime) 분, \(formattedDistance)"
            
            let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrowImageView.tintColor = .systemBlue
            arrowImageView.contentMode = .scaleAspectFit
            
            cell.accessoryView = arrowImageView
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRecord = bikeRecords[indexPath.row]
            showDetailViewController(for: selectedRecord)
        }
        
        func showDetailViewController(for record: BikeRecord) {
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.bikeRecord = record
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
