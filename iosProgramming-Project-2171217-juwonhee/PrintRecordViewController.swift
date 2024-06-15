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
    
    let headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 356.75, height: 66)
        view.backgroundColor = UIColor(red: 174/255, green: 225/255, blue: 223/255, alpha: 1)
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 162, height: 38)
        label.textColor = .black
        label.font = UIFont(name: "Jua-Regular", size: 30)
        label.textAlignment = .center
        label.text = "대여 반납 목록"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var bikeRecords: [BikeRecord] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureTableView()
        fetchBikeRecords()
        setupHeaderView()
    }
    
    deinit {
        listener?.remove()
    }
    
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            // Header View Constraints
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.heightAnchor.constraint(equalToConstant: 66),
            
            
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.widthAnchor.constraint(equalToConstant: 162),
            headerLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
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
            .order(by: "startTime", descending: true) // startTime 기준으로 내림차순 정렬
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
