//
//  FavoritesViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/16/24.
//


import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation
import FirebaseAuth

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 356.75, height: 66)
        view.backgroundColor = UIColor(red: 1.0, green: 0.94, blue: 0.42, alpha: 1.0) // #FFF06D
        return view
    }()

    let headerLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 162, height: 38)
        label.textColor = .black
        label.font = UIFont(name: "Jua-Regular", size: 30)
        label.textAlignment = .center
        label.text = "즐겨찾기 목록"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

        private var favoriteBikeStations: [BikeStationAnnotation] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavigationBar() // 상단바

            // tableview 에서 사용할 cell, datasource, delegate 설정
            favoriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
            favoriteTableView.dataSource = self
            favoriteTableView.delegate = self

            // 즐겨찾기 목록 UI
            setupHeaderView()
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
    
        override func viewDidAppear(_ animated: Bool) { // 뷰가 화면에 나타난 후에 호출
            super.viewDidAppear(animated)

            // 즐겨찾기 항목을 최신 상태로 유지하기 위함
            loadFavorites() // loadFavorites() 메서드를 이 메서드 안에서 호출하여 뷰가 화면에 나타날 때마다 즐겨찾기 항목을 다시 로드
        }

        private func setupHeaderView() {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(headerView)
            headerView.addSubview(headerLabel)
            
            NSLayoutConstraint.activate([
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

//        @objc private func handleFavoritesUpdated(_ notification: Notification) {
//            loadFavorites()
//        }

        private func loadFavorites() {
            guard let user = Auth.auth().currentUser, let email = user.email else { return }

            let db = Firestore.firestore()
            db.collection("favorites").document(email).collection("bikeStation").getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self?.favoriteBikeStations = querySnapshot?.documents.compactMap { document in
                        let data = document.data()
                        let title = data["title"] as? String ?? ""
                        let subtitle = data["subtitle"] as? String ?? ""
                        let latitude = data["latitude"] as? Double ?? 0.0
                        let longitude = data["longitude"] as? Double ?? 0.0
                        let availableBikes = data["availableBikes"] as? Int ?? 0
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let bikeStation = BikeStationAnnotation(
                            title: title,
                            subtitle: subtitle,
                            coordinate: coordinate,
                            availableBikes: availableBikes
                        )
                        return bikeStation
                    } ?? []

                    self?.favoriteTableView.reloadData() // db에서 즐겨찾기 항목을 가져와 최신 상태로 reload
                }
            }
        }

        // 편집->완료, 완료->편집 으로 title 변경
        @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
            favoriteTableView.setEditing(!favoriteTableView.isEditing, animated: true)
            editButton.title = favoriteTableView.isEditing ? "완료" : "편집"
        }
    }

    extension FavoritesViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteBikeStations.count
        }

        // 셀을 구성
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
            let bikeStation = favoriteBikeStations[indexPath.row]
            cell.textLabel?.text = bikeStation.title
            cell.detailTextLabel?.text = bikeStation.subtitle
            cell.imageView?.image = UIImage(systemName: "bicycle")
            return cell
        }

        // swipe 하여 삭제
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                guard let user = Auth.auth().currentUser, let email = user.email else { return }
                let db = Firestore.firestore()
                let bikeStation = favoriteBikeStations[indexPath.row]
                db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").delete { [weak self] error in
                    if let error = error {
                        print("즐겨찾기 삭제에 실패하였습니다.")
                    } else {
                        self?.favoriteBikeStations.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }

        // 삭제
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            favoriteBikeStations.remove(at: sourceIndexPath.row)
        }

        // 이동
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }

    extension FavoritesViewController: UITableViewDelegate {

        // 특정 행을 선택
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            _ = favoriteBikeStations[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
