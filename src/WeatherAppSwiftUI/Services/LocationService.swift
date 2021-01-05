//
//  LocationService.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 05/01/21.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func onLocationMeasured(lon: CLLocationDegrees, lat: CLLocationDegrees)
    func onLocationMeasureFailed(error:Error)
}

protocol LocationServiceProtocol {
    var locationServiceDelegate: LocationServiceDelegate? { get set }
    
    func requestForLocation()
}

//Mark: - LocationService

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    var locationServiceDelegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestForLocation() {
        locationManager.requestLocation()
    }
}

//Mark: - LocationManagerDelegate

extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationServiceDelegate?.onLocationMeasured(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
            locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationServiceDelegate?.onLocationMeasureFailed(error: error)
    }
}
