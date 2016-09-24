//
//  DateUtils.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/24.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

final class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}