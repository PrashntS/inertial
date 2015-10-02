//
//  ChartViewController.swift
//  Steps
//
//  Created by Shrikar Archak on 4/11/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit
import Charts
import CoreMotion

class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var testLabel: UILabel!

    let motionKit = MotionKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        
        let dataPoints = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        getSensorData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func getSensorData() {
        self.motionKit.getDeviceMotionObject(0.01) {
            (deviceMotion) -> () in
            let motionData: [String: Double] = [
                "Accel_X": deviceMotion.gravity.x,
                "Accel_Y": deviceMotion.gravity.y,
                "Accel_Z": deviceMotion.gravity.z,
                "RotRate_X": deviceMotion.rotationRate.x,
                "RotRate_Y": deviceMotion.rotationRate.y,
                "RotRate_Z": deviceMotion.rotationRate.z,
                "MagX": deviceMotion.magneticField.field.x,
                "MagY": deviceMotion.magneticField.field.y,
                "MagZ": deviceMotion.magneticField.field.z,
                "Yaw": deviceMotion.attitude.yaw,
                "Pitch": deviceMotion.attitude.pitch,
                "Roll": deviceMotion.attitude.roll
            ]
            dispatch_sync(dispatch_get_main_queue(), { () ->
                Void in
                self.testLabel.text = motionData["Accel_X"]?.description
            })
        }
    }
    
}