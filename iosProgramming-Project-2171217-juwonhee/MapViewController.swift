import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var initialLocationSet = false
    let initialCoordinates = CLLocationCoordinate2D(latitude: 37.499166, longitude: 127.159291)
    let regionRadius: CLLocationDistance = 500 // 원하는 반경 크기 설정
    
    let infoView = BikeStationInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Setup map view
        mapView.mapType = .standard // 표준 지도 설정
        mapView.showsUserLocation = true
        
        // Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // Check location authorization status
        checkLocationAuthorizationStatus()
        
        // Load data from BikeStationLoader
        BikeStationLoader.loadMultipleBikeStations { [weak self] bikeStations in
            guard let self = self, let bikeStations = bikeStations else {
                print("Failed to load bike data.")
                return
            }

            DispatchQueue.main.async {
                for station in bikeStations {
                    let availableBikes = Int(station.parkingBikeTotCnt) ?? 0
                    let annotation = BikeStationAnnotation(
                        title: station.stationName,
                        subtitle: station.stationId, // stationId를 subtitle로 사용
                        coordinate: CLLocationCoordinate2D(latitude: station.stationLatitude,
                                                           longitude: station.stationLongitude),
                        availableBikes: availableBikes
                    )
                    self.mapView.addAnnotation(annotation)
                }
            }
        }

        centerMapOnLocation(location: initialCoordinates)
        
        // Setup and add info view
        setupInfoView()
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

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 최초 위치 설정을 덮어쓰지 않도록 함
        if !initialLocationSet {
            initialLocationSet = true
            let userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude)
            mapView.setRegion(MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
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

    // Center map on given location
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? BikeStationAnnotation else { return }
        
        // Update and show the info view with annotation details
        infoView.update(stationId: annotation.subtitle ?? "", stationName: annotation.title ?? "", availableBikes: annotation.availableBikes)
        infoView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        infoView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BikeStationAnnotation else {
            return nil
        }
        
        let identifier = "bikeStation"
        var view: BikeStationAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? BikeStationAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = BikeStationAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        view.markerTintColor = annotation.markerTintColor
        view.glyphText = "\(annotation.availableBikes)"
        
        return view
    }
}
