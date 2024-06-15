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

    private var favoriteBikeStations: [BikeStationAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFavorites()
    }

    @objc private func handleFavoritesUpdated(_ notification: Notification) {
        loadFavorites()
    }

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

                self?.favoriteTableView.reloadData()
                
            }
        }
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        favoriteTableView.setEditing(!favoriteTableView.isEditing, animated: true)
        editButton.title = favoriteTableView.isEditing ? "Done" : "Edit"
    }
}

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBikeStations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let bikeStation = favoriteBikeStations[indexPath.row]
        cell.textLabel?.text = bikeStation.title
        cell.detailTextLabel?.text = bikeStation.subtitle
        cell.imageView?.image = UIImage(systemName: "bicycle") // 기본 이미지 설정
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = Auth.auth().currentUser, let email = user.email else { return }
            let db = Firestore.firestore()
            let bikeStation = favoriteBikeStations[indexPath.row]
            db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").delete { [weak self] error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    
                    self?.favoriteBikeStations.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                   
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = favoriteBikeStations[sourceIndexPath.row]
        favoriteBikeStations.remove(at: sourceIndexPath.row)
        favoriteBikeStations.insert(movedObject, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = favoriteBikeStations[indexPath.row]
        // Optional: Handle selection action if needed
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
