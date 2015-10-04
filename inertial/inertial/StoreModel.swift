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
    let safeTag: String
    let created: String?
    let sampleRate: Int
    var store: [[String: Double]] = []
    
    init (tag: String, created: NSDate, rate: Int) {
        self.tag = tag
        self.safeTag = tag.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("")
        self.sampleRate = rate
        self.created = Probe.getFormattedDate(created)
    }
    
    static func getFormattedDate (date: NSDate, kind: Int = 0, utc: Bool = true) -> String {
        let formatter = NSDateFormatter()
        switch kind {
        case 1:
            formatter.dateFormat = "yyyyMMddHHmmss.SSS"
        default:
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS ZZZ"
        }

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
    
    func saveAsFile() -> String? {
        do {
            let fileName = Probe.getFormattedDate(NSDate(), kind: 1) + self.safeTag + ".json"
            let fileLoc = FKPath.UserHome.rawValue + "/Documents/" + fileName
            let filePath = FKPath(fileLoc)
//            try filePath.createFile()
            try self.description! |> FKTextFile(path: filePath)
            NSLog("Saved file as" + filePath.description)
            return filePath.description
        } catch {
            NSLog("Could not save the file")
            return nil
        }
    }
    
    deinit {
        self.saveAsFile()
    }
    
}
