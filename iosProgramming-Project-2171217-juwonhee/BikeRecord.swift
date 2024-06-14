//
//  BikeRecord.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//


import Foundation
import Firebase
import FirebaseFirestore

// 저장할 데이터 모델 정의
struct BikeRecord {
    var usageTime: Int
    var distance: Double
    var calories: Double
    var carbonReduction: Double
    
    // 모델을 Dictionary로 변환하는 메서드
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "usageTime": usageTime,
            "distance": distance,
            "calories": calories,
            "carbonReduction": carbonReduction
        ]
    }
}

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Firestore에 데이터 저장하는 함수
    func saveBikeRecord(_ record: BikeRecord, forUser userId: String, completion: @escaping (Error?) -> Void) {
        let userHistoryRef = db.collection("history").document("bikelist").collection(userId).document()
        
        userHistoryRef.setData(record.dictionaryRepresentation()) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
