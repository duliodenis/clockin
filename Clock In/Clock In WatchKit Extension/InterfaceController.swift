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
    

    @IBAction func clockInOutTapped() {
        if isClockedIn {
            isClockedIn = false
        } else {
            isClockedIn = true
        }
        updateUI(clockedIn: isClockedIn)
    }
}
