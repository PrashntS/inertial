//
//  syncController.swift
//  inertial
//
//  Created by Prashant Sinha on 04/10/15.
//  Copyright © 2015 Prashant Sinha. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

class SyncController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doLinkDropbox(sender: AnyObject) {
        Dropbox.authorizeFromController(self)
    }
    
}