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

   
            checkFavoritedAndUpdateUI(bikeStation: bikeStation) // 즐겨찾기 상태를 확인하여 UI 업데이트

            rightCalloutAccessoryView = starButton // 즐겨찾기

            markerTintColor = bikeStation.markerTintColor
            glyphText = "\(bikeStation.availableBikes)"
        }
    }

    @objc private func toggleStar(sender: UIButton) { // 맵에서 즐겨찾기 버튼 클릭에 대한 처리
        guard let bikeStation = annotation as? BikeStationAnnotation else { return }

        if let user = Auth.auth().currentUser, let email = user.email {
            let db = Firestore.firestore()

            if isStarred {
                db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").delete { [weak self] error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    } else {
                        print("즐겨찾기 삭제 대여소: \(bikeStation.title ?? "")")

                        self?.setStarState(isStarred: false)
                        self?.updateTableView()
                    }
                }
            } else {
                let favoriteData: [String: Any] = [
                    "title": bikeStation.title ?? "",
                    "subtitle": bikeStation.subtitle ?? "",
                    "latitude": bikeStation.coordinate.latitude,
                    "longitude": bikeStation.coordinate.longitude,
                    "availableBikes": bikeStation.availableBikes
                ]

                db.collection("favorites").document(email).collection("bikeStation").document(bikeStation.title ?? "").setData(favoriteData) { [weak self] error in
                    if error != nil {
                        print("즐겨찾기 추가에 실패하였습니다.")
                    } else {
                        print("즐겨찾기에 추가되었습니다.")
                        self?.setStarState(isStarred: true)
                        self?.updateTableView()
                    }
                }
            }
        }
    }

    private func isStarred(bikeStation: BikeStationAnnotation, completion: @escaping (Bool) -> Void) { // db 에서 해당 대여소가 즐겨찾기에 해당되는지를 확인
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

    public func checkFavoritedAndUpdateUI(bikeStation: BikeStationAnnotation) {
        isStarred(bikeStation: bikeStation) { [weak self] (isStarred) in
            self?.setStarState(isStarred: isStarred)
        }
    }

    private func updateTableView() { // 즐겨찾기에 대한 알림을 전송
        NotificationCenter.default.post(name: Notification.Name("FavoritesUpdated"), object: nil)
    }
}

