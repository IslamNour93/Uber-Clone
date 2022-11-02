//
//  LocationHandler.swift
//  Uber
//
//  Created by Islam NourEldin on 25/10/2022.
//

import CoreLocation

class LocationHandler:NSObject,CLLocationManagerDelegate{
    static let shared = LocationHandler()
    var location:CLLocation?
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
}
