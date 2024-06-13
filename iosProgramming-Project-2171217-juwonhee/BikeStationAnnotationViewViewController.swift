//
//  BikeStationAnnotationViewViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/4/24.
//



import MapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class BikeStationAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let bikeStation = newValue as? BikeStationAnnotation else { return }
            canShowCallout = true
            
            let subtitleLabel = UILabel()
            subtitleLabel.numberOfLines = 0
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            subtitleLabel.text = bikeStation.subtitle
            
            detailCalloutAccessoryView = subtitleLabel
            
            markerTintColor = bikeStation.markerTintColor
            glyphText = "\(bikeStation.availableBikes)"
            
            // Segmented Control 설정
            let segmentedControl = UISegmentedControl(items: ["출발", "도착"])
            //            segmentedControl.selectedSegmentIndex = 0 // 기본값을 출발로 설정
            segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
            
            rightCalloutAccessoryView = segmentedControl
            
        }
    }
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        guard let bikeStation = annotation as? BikeStationAnnotation else {
            print("마커에서 BikeStationAnnotation을 가져올 수 없습니다.")
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            print("사용자가 로그인되어 있지 않습니다.")
            return
        }
        
        let db = Firestore.firestore()
        let userDoc = db.collection("Users").document(user.uid)
        let historyCollection = userDoc.collection("history")
        let location = bikeStation.title ?? ""
        let timestamp = Timestamp(date: Date())
        let type = sender.selectedSegmentIndex == 0 ? "start" : "end"
        
        // Get the current count of documents in bikeList
        historyCollection.document("bikeList").getDocument { (document, error) in
            var newIndex = 0
            
            if let document = document, document.exists {
                // If document exists, get the current count and increment it
                newIndex = (document.data()?["count"] as? Int ?? 0) + 1
            } else {
                // If document doesn't exist, create it with count 1
                historyCollection.document("bikeList").setData(["count": 1])
            }
            
            // Add new document with the incremented index
            let bikeListDoc = historyCollection.document("bikeList").collection("\(newIndex)").document("record")
            
            // Set data in Firestore based on type
            if type == "start" {
                bikeListDoc.setData([
                    "startType": type,
                    "startLocation": location,
                    "startTimestamp": timestamp
                ], merge: true) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Start document added successfully")
                    }
                }
            } else if type == "end" {
                bikeListDoc.setData([
                    "endType": type,
                    "endLocation": location,
                    "endTimestamp": timestamp
                ], merge: true) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("End document added successfully")
                    }
                }
            }
        }
    }





}
   
