//
//  StoreModel.swift
//  inertial
//
//  Created by Prashant Sinha on 03/10/15.
//  Copyright © 2015 Prashant Sinha. All rights reserved.
//

import Foundation
import SwiftyJSON
import FileKit

class Probe {
    let tag: String
    let created: String?
    let sampleRate: Int
    var store: [[String: Double]] = []
    
    init (tag: String, created: NSDate, rate: Int) {
        self.tag = tag
        self.sampleRate = rate
        self.created = Probe.getFormattedDate(created)
    }
    
    static func getFormattedDate (date: NSDate, utc: Bool = true) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        if utc {
            formatter.timeZone = NSTimeZone(abbreviation: "UTC")
        }
        return formatter.stringFromDate(date)
    }
    
    func push (dat: [String: Double]) {
        self.store.append(dat)
    }
    
    func _repr_ () -> [String: AnyObject] {
        return [
            "created": self.created!,
            "rate": self.sampleRate,
            "updated": Probe.getFormattedDate(NSDate()),
            "data": self.store
        ]
    }
    
    var description: String? {
        let paramsJSON = JSON(self._repr_())
        return paramsJSON.rawString(NSUTF8StringEncoding)
    }
    
    func saveAsFile() {
        
    }
}
