//
//  DetailViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//

import UIKit

class DetailViewController: UIViewController {

    var bikeRecord: BikeRecord?
    
    @IBOutlet weak var carbonReductionLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    


        
        override func viewDidLoad() {
            super.viewDidLoad()

            updateUI()
        }
        
        func updateUI() {
            guard let record = bikeRecord else {
                print("자전거 기록이 없습니다.")
                return
            }
            
            startLocationLabel.text = "출발지: \(record.startLocation)"
            endLocationLabel.text = "도착지: \(record.endLocation)"
            usageTimeLabel.text = "이용 시간: \(record.usageTime) 분"
            distanceLabel.text = String(format: "거리: %.2f km", record.distance)
            caloriesLabel.text = String(format: "칼로리 소모: %.1f kcal", record.calories)
            carbonReductionLabel.text = String(format: "탄소 절감: %.3f kg", record.carbonReduction)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatter.timeZone = TimeZone.current
            
            
//            startTimeLabel.text = "출발 시각: \(record.startTime)"
//            endTimeLabel.text = "도착 시각: \(record.endTime)"
            
            startTimeLabel.text = "출발 시각: \(dateFormatter.string(from: record.startTime))"
            endTimeLabel.text = "도착 시각: \(dateFormatter.string(from: record.endTime))"
        }
    }
