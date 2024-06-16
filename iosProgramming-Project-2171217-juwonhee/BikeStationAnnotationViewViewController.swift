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

// 이용권 구매 -> 출발지와 도착지 설정 시 나오는 맵
class BikeStationAnnotationView: MKMarkerAnnotationView { // MKMarkerAnnotationView를 상속
    override var annotation: MKAnnotation? {
        willSet {
            guard let bikeStation = newValue as? BikeStationAnnotation else { return }
            canShowCallout = true // annotation 선택 시 나타나는 팝업
            
            let subtitleLabel = UILabel()
            subtitleLabel.numberOfLines = 0
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
            subtitleLabel.text = bikeStation.subtitle
            
            detailCalloutAccessoryView = subtitleLabel
            
            markerTintColor = bikeStation.markerTintColor 
            glyphText = "\(bikeStation.availableBikes)"

            // 팝업 오른쪽에 추가 뷰 설정
            let segmentedControl = UISegmentedControl(items: ["출발", "도착"])
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
        
        historyCollection.document("bikeList").getDocument { (document, error) in
            //var newIndex = 0 // 같은 db 공간에 저장하도록 설정
            let newRecordRef = historyCollection.document("bikeList").collection("1").document("record") // 항상 이 경로에 선택한 출발지와 도착지를 저장
            
            if type == "start" { // 출발로 선택 시
                newRecordRef.setData([
                    "startType": type,
                    "startLocation": location,
                    "startTimestamp": timestamp
                ], merge: true) { error in
                    if let error = error {
                        print("데이터 추가에 실패하였습니다.")
                    } else {
                        print("성공적으로 추가되었습니다.")
                    }
                }
            } else if type == "end" { // 도착으로 선택 시
                newRecordRef.setData([
                    "endType": type,
                    "endLocation": location,
                    "endTimestamp": timestamp
                ], merge: true) { error in
                    if let error = error {
                        print("데이터 추가에 실패하였습니다.")
                    } else {
                        print("성공적으로 추가되었습니다.")
                    }
                }
            }
        }
    }

}
   
