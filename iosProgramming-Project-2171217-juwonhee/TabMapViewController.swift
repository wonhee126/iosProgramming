//
//  TabMapViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/13/24.
//

import UIKit
import MapKit
import CoreLocation

class TabMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var initialLocationSet = false
    let initialCoordinates = CLLocationCoordinate2D(latitude: 37.499166, longitude: 127.159291)
    let regionRadius: CLLocationDistance = 500 
    
    let infoView = BikeStationInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar() // 상단바
        setupMapView() // 지도 뷰 설정 초기화
        setupInfoView() // 자전거 대여소 정보 뷰 설정 초기화
        checkLocationAuthorizationStatus() // 위치 권한 상태 확인
        loadBikeStations() // 자전거 대여소 데이터 로드

    }

    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        self.navigationItem.title = ""
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImage = UIImage(named: "NavigatorIcon")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "EcoBike"
        titleLabel.font = UIFont.systemFont(ofSize: 8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        self.navigationItem.titleView = titleView
    }


    func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupInfoView() {
        infoView.frame = CGRect(x: 0, y: 0, width: 405, height: 148)
        infoView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let parent = self.view!
        parent.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalToConstant: 405),
            infoView.heightAnchor.constraint(equalToConstant: 148),
            infoView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 13),
            infoView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 655)
        ])
        
        infoView.isHidden = true
    }

    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showSettingsAlert("Location Permission Denied", "Please enable location permissions in Settings.")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if !initialLocationSet {
            initialLocationSet = true
            let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude)
            mapView.setRegion(MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("사용자 위치를 가져오는데 실패하였습니다.")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
    
    func showSettingsAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadBikeStations() {
        BikeStationLoader.loadMultipleBikeStations { [weak self] bikeStations in
            guard let self = self, let bikeStations = bikeStations else {
                print("정보를 가져오는데 실패하였습니다.")
                return
            }

            DispatchQueue.main.async {
                for station in bikeStations {
                    let availableBikes = Int(station.parkingBikeTotCnt) ?? 0
                    let annotation = BikeStationAnnotation(
                        title: station.stationName,
                        subtitle: station.stationId,
                        coordinate: CLLocationCoordinate2D(latitude: station.stationLatitude,
                                                           longitude: station.stationLongitude),
                        availableBikes: availableBikes
                    )
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension TabMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? BikeStationAnnotation else { return }
        
        // 선택된 자전거 대여소의 세부 정보를 infoView 에 업데이트
        infoView.update(stationId: annotation.subtitle ?? "", stationName: annotation.title ?? "", availableBikes: annotation.availableBikes)
        infoView.isHidden = false // 화면에 표시
        
        if let tapView = view as? BikeStationAnnotationTapView { // MapViewController 와 다른 점
            // 자전거 대여소가 즐겨찾기인지 확인하고 UI를 업데이트
            tapView.checkFavoritedAndUpdateUI(bikeStation: annotation)
        }
        
    }
    
    // annotation 선택 해제 시 호출
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        infoView.isHidden = true // 숨기기
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BikeStationAnnotation else {
            return nil
        }
        
        let identifier = "bikeStation"
        var view: BikeStationAnnotationTapView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BikeStationAnnotationTapView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = BikeStationAnnotationTapView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        view.markerTintColor = annotation.markerTintColor
        view.glyphText = "\(annotation.availableBikes)"
        
        return view
    }
}



