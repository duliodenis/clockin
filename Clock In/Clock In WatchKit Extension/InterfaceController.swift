//
//  InterfaceController.swift
//  Clock In WatchKit Extension
//
//  Created by ddenis on 10/1/16.
//  Copyright © 2016 ddApps. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var button: WKInterfaceButton!
    var isClockedIn = false

    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var middleLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateUI(clockedIn: isClockedIn)
    }
    
    
    func updateUI(clockedIn:Bool) {
        if clockedIn {
            // THE CLOCKED IN UI
            topLabel.setHidden(false)
            middleLabel.setText("5m 22s")
            button.setTitle("Clock Out")
            button.setBackgroundColor(UIColor.init(red: 234/255, green: 76/255, blue: 136/255, alpha: 1))
        } else {
            // THE CLOCKED OUT UI
            topLabel.setHidden(true)
            middleLabel.setText("Today\n3h 22m")
            button.setTitle("Clock In")
            button.setBackgroundColor(UIColor.init(red: 22/255, green: 160/255, blue: 133/255, alpha: 1))
        }
    }
    

    // MARK: - Button Tapped
    
    @IBAction func clockInOutTapped() {
        if isClockedIn {
            clockOut()
        } else {
            clockIn()
        }
        updateUI(clockedIn: isClockedIn)
    }
    
    
    // MARK: - Clock In and Out Functions
    
    func clockIn() {
        isClockedIn = true
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        
        // Start a timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                self.middleLabel.setText("\(hours)h \(minutes)m \(seconds)s")
                
                let totalTimeInterval = timeInterval + self.totalClockedTime()
                
                let totalHours = totalTimeInterval / 3600
                let totalMinutes = (totalTimeInterval % 3600) / 60
                let totalSeconds = totalTimeInterval % 60
                
                self.topLabel.setText("Today: \(totalHours)h \(totalMinutes)m \(totalSeconds)s")
            }
        }
    }
    
    
    func clockOut() {
        isClockedIn = false
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            
            // Add the clock in time to the clockIns Array
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
            } else {
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            // Add the clock out time to the clockOuts Array
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                clockOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
            } else {
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
            }
            
            // set the clockedIn time to nil
            UserDefaults.standard.set(nil, forKey: "clockedIn")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func totalClockedTime() -> Int {
        if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                // having both clock in and clock outs arrays
                // iterate through to calculate the time of each row
                // and put into a total seconds variable
                var totalSeconds = 0
                
                for index in 0..<clockIns.count {
                    // figure out the seconds between clockin and clockout
                    let currentSeconds = Int(clockOuts[index].timeIntervalSince(clockIns[index]))
                    // add time to totalSeconds
                    totalSeconds += currentSeconds
                }
                return totalSeconds
            }
        }
        return 0
    }
    
}
