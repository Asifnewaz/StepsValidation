//
//  LocationManager.swift
//  Step Validation
//
//  Created by Asif Newaz on 11/4/20.
//  Copyright © 2020 Asif Newaz. All rights reserved.
//

import Foundation
import CoreLocation

protocol UpdateLocationProtocol: class {
    func updateLocation(location: LocationData)
    func updateDistance(distance: Double)
    func errorFetchingLocation(error: String)
}

class LocationManager: NSObject {
    
    static var shared = LocationManager()
    var locationManager = CLLocationManager()
    
    var startLocation: CLLocation?
    var lastLocation: CLLocation?
    var traveledDistance: Double = 0
    
    weak var delegate: UpdateLocationProtocol?
    
    override init() {
    }
    
    func getLocationData(){
        // Location manager for getting user current location
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func stopUpdatinngLocation() {
        self.startLocation = nil
        self.lastLocation = nil
        self.traveledDistance = 0
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print(location)
        
        if startLocation == nil {
            startLocation = locations.first
        } else if let lastL = locations.last {
            traveledDistance += lastLocation?.distance(from: lastL) ?? 0.0
            print("Traveled Distance:",  traveledDistance)
            print("Straight Distance:", startLocation?.distance(from: locations.last!))
        }
        lastLocation = locations.last
        
        
        var locationData = LocationData()
        locationData.latitude = location.coordinate.latitude
        locationData.longitude =  location.coordinate.longitude
        self.delegate?.updateDistance(distance: traveledDistance)
        self.delegate?.updateLocation(location: locationData)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            self.delegate?.errorFetchingLocation(error: "Location access was restricted.")
        case .denied:
            self.delegate?.errorFetchingLocation(error: "User denied access to location.")
        case .notDetermined:
            self.delegate?.errorFetchingLocation(error: "Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            self.delegate?.errorFetchingLocation(error: "Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        self.delegate?.errorFetchingLocation(error: "Error: \(error)")
    }
}
