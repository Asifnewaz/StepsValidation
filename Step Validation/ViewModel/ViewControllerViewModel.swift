//
//  ViewControllerViewModel.swift
//  Step Validation
//
//  Created by Asif Newaz on 11/4/20.
//  Copyright © 2020 Asif Newaz. All rights reserved.
//

import Foundation
import CoreLocation

class ViewControllerViewModel: NSObject {
    
    var isTimerStarted = Observable(false)
    var errorMessage = Observable("")
    var locationInfoChanged = Observable(LocationData())
    var distanceChanged = Observable("")
    var timeInfo = Observable("")
    var isvalidStep = Observable(false)
    
    var totalDistance: Double?
    var totalTime: Double?
    
    override init() {
    }
    
    func startStopTimer(){
        if self.isTimerStarted.value {
            self.isTimerStarted.value = false
            self.stopTime()
            self.stopUpdatingLocation()
            self.calculateValidity()
        } else {
            self.isTimerStarted.value = true
            self.getTime()
            self.fetchLocation()
        }
    }
    
    
    func getTime(){
        TimerManager.shared.delegate = self
        TimerManager.shared.startTimer()
    }
    
    func stopTime(){
        TimerManager.shared.resetTimer()
    }
    
    func fetchLocation(){
        LocationManager.shared.delegate = self
        LocationManager.shared.getLocationData()
    }
    
    func stopUpdatingLocation(){
        LocationManager.shared.stopUpdatinngLocation()
    }
    
    
    func calculateValidity(){
        if let time = self.totalTime, let distance = self.totalDistance {
            let meters = distance
            let distanceMeters = Measurement(value: meters, unit: UnitLength.meters)
            let distanceMiles = distanceMeters.converted(to: UnitLength.miles)
            let miles = distanceMeters.converted(to: UnitLength.miles).value
            
            let hour = time.truncatingRemainder(dividingBy: 3600.00)
            let milesPerHour = miles/hour
            
            if milesPerHour >= 3.0 {
                self.isvalidStep.value = true
            } else {
                self.isvalidStep.value = false
            }
        }
    }
}

extension ViewControllerViewModel: UpdateTimeProtocol {
    
    func updateTime(time: String) {
        self.timeInfo.value = time
    }
    
    func updateTotalTime(time: Double) {
        self.totalTime = time
    }
    
}


extension ViewControllerViewModel: UpdateLocationProtocol {
    
    func updateLocation(location: LocationData) {
        self.locationInfoChanged.value = location
    }
    
    func updateDistance(distance: Double) {
        self.totalDistance = distance
        self.distanceChanged.value = String(format: "Distance: %.02f meter", distance) //
    }
    
    func errorFetchingLocation(error: String) {
        self.errorMessage.value = error
    }
}
