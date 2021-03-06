//
//  FirstViewController.swift
//  inertial
//
//  Created by Prashant Sinha on 01/10/15.
//  Copyright © 2015 Prashant Sinha. All rights reserved.
//

import UIKit
import Charts

class LoggerController: UIViewController {

    @IBOutlet weak var triggerSwitch: UISwitch!
    @IBOutlet weak var motionTag: UITextField!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var longPressGesture: UILongPressGestureRecognizer!
    
    let mk: MotionKit = MotionKit()
    var prober: Probe!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shouldTrigger(sender: UISwitch) {
        if self.triggerSwitch.on {
            // Gather Values from Global Tag and Sample Rate.
            let tag  = self.motionTag.text,
                rate = Int(self.rateSlider.value)
            
            if tag?.characters.count < 5 {
                self.triggerSwitch.on = false
                SweetAlert().showAlert("Invalid Tag", subTitle: "Please enter a descriptive Motion Tag Value.", style: AlertStyle.Error)
                return
            }
            
            // Disable These
            self.motionTag.enabled = false
            self.rateSlider.enabled = false
            self.rateLabel.enabled = false
            
            // Create Probe Object
            self.prober = Probe(tag: tag!, created: NSDate(), rate: rate)
            
            // Call Data Gather
            self.getSensorData(rate)
        }
        else {
            // Enable Tag entry, and switches.
            self.motionTag.enabled = true
            self.rateSlider.enabled = true
            self.rateLabel.enabled = true
            self.mk.stopDeviceMotionUpdates()
            self.prober.saveAsFile()
        }
    }

    @IBAction func shouldUpdateRateLabel(sender: UISlider) {
        let rate: Int = Int(self.rateSlider.value)
        self.rateLabel.text = "\(rate) Hz"
    }

    @IBAction func didMotionTagEditingEnd(sender: UITextField) {
        view.endEditing(true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        // Dismiss Keyboards
        
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    @IBAction func didDoLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Ended {
            SweetAlert().showAlert("Something!", subTitle: "You clicked the button!", style: AlertStyle.Success)
        }
    }
    
    func getSensorData(rate: Int) {
        self.mk.getDeviceMotionObject(1.0 / Double(rate)) {
            (deviceMotion) -> () in
            let motionData: [String: Double] = [
                "Accel_X": deviceMotion.gravity.x,
                "Accel_Y": deviceMotion.gravity.y,
                "Accel_Z": deviceMotion.gravity.z,
                "RotRate_X": deviceMotion.rotationRate.x,
                "RotRate_Y": deviceMotion.rotationRate.y,
                "RotRate_Z": deviceMotion.rotationRate.z,
                "MagX": Double(deviceMotion.magneticField.accuracy.rawValue),
                "MagY": deviceMotion.magneticField.field.y,
                "MagZ": deviceMotion.magneticField.field.z,
                "Yaw": deviceMotion.attitude.yaw,
                "Pitch": deviceMotion.attitude.pitch,
                "Roll": deviceMotion.attitude.roll
            ]
            self.prober.push(motionData)
            print("Background")
            dispatch_sync(dispatch_get_main_queue(), { () ->
                Void in
                print(":)")
            })
        }
    }
    
}
