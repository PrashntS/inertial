//
//  StreamerController.swift
//  inertial
//
//  Created by Prashant Sinha on 03/10/15.
//  Copyright © 2015 Prashant Sinha. All rights reserved.
//

import UIKit

class StreamerController: UIViewController {
    
    @IBOutlet weak var triggerSwitch: UISwitch!
    @IBOutlet weak var portNumber: UITextField!
    @IBOutlet weak var sampleRateSlider: UISlider!
    @IBOutlet weak var sampleRateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shouldTrigger(sender: UISwitch) {
    }
    @IBAction func didChangeSampleRate(sender: UISlider) {
    }
    @IBAction func shouldUpdateSampleLabel(sender: UISlider) {
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        // Dismiss Keyboards
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}