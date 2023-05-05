//
//  HelpViewModel.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import SwiftUI
import MapKit
import CoreLocation

class HelpViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    @Published var searchResults: [MKPointAnnotation] = []

    private let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 5000

    override init() {
        super.init()
        checkLocationServices()
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func searchNearbyPlaces(in city: String) {
        let categories = ["Mental Health Specialists", "Yoga Studios", "Gyms"]
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(city) { (placemarks, error) in
            if let error = error {
                print("Error geocoding city: \(error.localizedDescription)")
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: self.regionRadius)
                self.mapView.setRegion(region, animated: true)

                self.searchResults.removeAll()

                for category in categories {
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = category
                    request.region = self.mapView.region

                    let search = MKLocalSearch(request: request)
                    search.start { (response, error) in
                        guard let response = response else { return }
                        let newResults = response.mapItems.map { item -> MKPointAnnotation in
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = item.placemark.coordinate
                            annotation.title = item.name
                            return annotation
                        }
                        self.searchResults.append(contentsOf: newResults)
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.searchResults)
                }
            }
        }
    }
}
