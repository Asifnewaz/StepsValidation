//
//  ViewController.swift
//  Step Validation
//
//  Created by Asif Newaz on 11/4/20.
//  Copyright © 2020 Asif Newaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var validStepsLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    
    lazy var viewModel : ViewControllerViewModel = {
        let viewModel = ViewControllerViewModel()
        return viewModel
    }()
    
    deinit {
        print("Destroyed VC")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseBinding()
    }
    
    
    @IBAction func startStopAction(_ sender: UIButton) {
        self.viewModel.startStopTimer()
    }
    
    func initialiseBinding(){
        self.viewModel.isTimerStarted.valueChanged = { [weak self] isStarted in
            if isStarted {
                self?.changeButtonInfo(name: "Stop")
            } else {
                self?.changeButtonInfo(name: "Start")
            }
        }
        
        self.viewModel.errorMessage.valueChanged = { [weak self] error in
            print(error)
        }
        
        self.viewModel.locationInfoChanged.valueChanged = { [weak self] location in
            self?.updateLocationUI(location: location)
        }
        
        self.viewModel.distanceChanged.valueChanged = { [weak self] distance in
            self?.updateDistance(distance: distance)
        }
        
        self.viewModel.isvalidStep.valueChanged = { [weak self] isValid in
            if isValid {
                self?.validStepsLabel.text = "Valid Steps: Yes"
            } else {
                self?.validStepsLabel.text = "Valid Steps: No"
            }
        }
        self.viewModel.timeInfo.valueChanged = { [weak self] time in
            self?.updateTime(time: time)
        }
    }
    
    
    
    private func changeButtonInfo(name: String){
        self.startStopButton.setTitle(name, for: .normal)
    }
    
    private func updateLocationUI(location: LocationData?){
        if let lat = location?.latitude {
            self.latitudeLabel.text = "Latitude: \(lat)"
        }
        
        if let lon = location?.longitude {
            self.longitudeLabel.text = "Longitude: \(lon)"
        }
    }
    
    private func updateTime(time: String){
        self.timeLabel.text = time
    }
    
    private func updateDistance(distance: String){
        self.distanceLabel.text = distance
    }
}

