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
            

            
        }
    }
    
}
