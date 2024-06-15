//
//  BikeRecord.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//


import Foundation
import Firebase
import FirebaseFirestore

struct BikeRecord {
    var usageTime: Int
    var distance: Double
    var calories: Double
    var carbonReduction: Double
    var startLocation: String
    var endLocation: String
    var startTime: Date
    var endTime: Date
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "usageTime": usageTime,
            "distance": distance,
            "calories": calories,
            "carbonReduction": carbonReduction,
            "startLocation": startLocation,
           "endLocation": endLocation,
           "startTime": startTime,
           "endTime": endTime
            
        ]
    }
}

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
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
