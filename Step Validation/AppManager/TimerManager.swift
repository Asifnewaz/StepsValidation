//
//  TimerManager.swift
//  Step Validation
//
//  Created by Asif Newaz on 11/4/20.
//  Copyright © 2020 Asif Newaz. All rights reserved.
//

import Foundation

protocol UpdateTimeProtocol: class {
    func updateTime(time: String)
    func updateTotalTime(time: Double)
}

class TimerManager: NSObject {
    
    static var shared = TimerManager()
    
    weak var delegate: UpdateTimeProtocol?
    var timer: Timer?
    var timeSec: Int = 0
    
    override init() {
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        self.timeSec += 1
        let seconds = self.timeSec % 60
        let minutes = (self.timeSec / 60) % 60
        
        self.delegate?.updateTotalTime(time: Double(self.timeSec))
        self.delegate?.updateTime(time: String(format: "Time: %0.2d min %0.2d sec",minutes,seconds))
    }
    
    func resetTimer(){
        if let timer = self.timer {
            timer.invalidate()
            self.timeSec = 0
        }
    }
    
}
