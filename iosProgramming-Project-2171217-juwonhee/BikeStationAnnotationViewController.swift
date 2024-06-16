//
//  BikeStationAnnotationViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/4/24.
//

import MapKit

// 지도 위에 자전거 대여소를 표시
class BikeStationAnnotation: NSObject, MKAnnotation { // MapKit의 MKAnnotation 프로토콜
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let availableBikes: Int

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, availableBikes: Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.availableBikes = availableBikes
        super.init()
    }

    var markerTintColor: UIColor { // annotation 색상 
        return .green
    } 
}

