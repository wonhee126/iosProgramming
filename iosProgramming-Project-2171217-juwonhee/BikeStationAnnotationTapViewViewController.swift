//
//  BikeStationAnnotationTapViewViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//


import MapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class BikeStationAnnotationTapView: MKMarkerAnnotationView {

    private var starButton: UIButton?
    private var isStarred = false

    override var annotation: MKAnnotation? {
        willSet {
            guard let bikeStation = newValue as? BikeStationAnnotation else { return }
            canShowCallout = true


            starButton = UIButton(type: .custom)
            starButton?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            starButton?.addTarget(self, action: #selector(toggleStar), for: .touchUpInside)

   
            checkIfFavoritedAndUpdateUI(bikeStation: bikeStation)

            rightCalloutAccessoryView = starButton

            markerTintColor = bikeStation.markerTintColor
            glyphText = "\(bikeStation.availableBikes)"
        }
    }

    @objc private func toggleStar(sender: UIButton) {
        guard let bikeStation = annotation as? BikeStationAnnotation else { return }

        if let user = Auth.auth().currentUser, let email = user.email {
            let db = Firestore.firestore()

            if isStarred {
                // Remove from favorites
                db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").delete { [weak self] error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        // 로그 출력
                        print("BikeStationAnnotationTapViewController Deleted favorite bike station: \(bikeStation.title ?? "")")

                        self?.setStarState(isStarred: false)
                        self?.updateTableView()
                    }
                }
            } else {
                // Add to favorites
                let favoriteData: [String: Any] = [
                    "title": bikeStation.title ?? "",
                    "subtitle": bikeStation.subtitle ?? "",
                    "latitude": bikeStation.coordinate.latitude,
                    "longitude": bikeStation.coordinate.longitude,
                    "availableBikes": bikeStation.availableBikes
                ]

                db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").setData(favoriteData) { [weak self] error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Added to favorites")
                        self?.setStarState(isStarred: true)
                        self?.updateTableView()
                    }
                }
            }
        }
    }

    private func isStarred(bikeStation: BikeStationAnnotation, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    private func setStarState(isStarred: Bool) {
        self.isStarred = isStarred
        if isStarred {
            starButton?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton?.tintColor = .yellow
        } else {
            starButton?.setImage(UIImage(systemName: "star"), for: .normal)
            starButton?.tintColor = .gray
        }
    }

    public func checkIfFavoritedAndUpdateUI(bikeStation: BikeStationAnnotation) {
        isStarred(bikeStation: bikeStation) { [weak self] (isStarred) in
            self?.setStarState(isStarred: isStarred)
        }
    }

    private func updateTableView() {
        NotificationCenter.default.post(name: Notification.Name("FavoritesUpdated"), object: nil)
    }
}

