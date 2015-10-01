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
    
    @IBOutlet weak var chV: BarChartView!
    var days:[String] = []
    var stepsTaken:[Int] = []
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    var cnt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        chV.delegate = self;
        
        chV.descriptionText = "";
        chV.noDataTextDescription = "Data will be loaded soon."
        
        chV.drawBarShadowEnabled = false
        chV.drawValueAboveBarEnabled = true
        
        chV.maxVisibleValueCount = 60
        chV.pinchZoomEnabled = false
        chV.drawGridBackgroundEnabled = true
        chV.drawBordersEnabled = false
        
        getDataForLastWeek()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDataForLastWeek() {
        if(CMPedometer.isStepCountingAvailable()){
            var serialQueue : dispatch_queue_t  = dispatch_queue_create("com.example.MyQueue", nil)
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "d MMM"
            dispatch_sync(serialQueue, { () -> Void in
                let today = NSDate()
                for day in 0...6{
                    let fromDate = NSDate(timeIntervalSinceNow: Double(-7+day) * 86400)
                    let toDate = NSDate(timeIntervalSinceNow: Double(-7+day+1) * 86400)
                    let dtStr = formatter.stringFromDate(toDate)
                    self.pedoMeter.queryPedometerDataFromDate(fromDate, toDate: toDate) { (data : CMPedometerData?, error) -> Void in
                        if(error == nil){
                            print("\(dtStr) : \(data!.numberOfSteps)")
                            self.days.append(dtStr)
                            self.stepsTaken.append(Int(data!.numberOfSteps))
                            print("Days :\(self.days)")
                            print("Steps :\(self.stepsTaken)")
                            if(self.days.count == 7){
                                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                    let xVals = self.days
                                    var yVals: [BarChartDataEntry] = []
                                    for idx in 0...6 {
                                        yVals.append(BarChartDataEntry(value: Double(self.stepsTaken[idx]), xIndex: idx))
                                    }
                                    print("Days :\(self.days)")
                                    print("Steps :\(self.stepsTaken)")
                                    
                                    let set1 = BarChartDataSet(yVals: yVals, label: "Steps Taken")
                                    set1.barSpace = 0.25
                                    
                                    let data = BarChartData(xVals: xVals, dataSet: set1)
                                    data.setValueFont(UIFont(name: "Avenir", size: 12))
                                    self.chV.data = data
                                    self.view.reloadInputViews()
                                })
                                
                            }
                        }
                    }
                    
                }
                
            })
        }
    }
    
}