//
//  Run.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/16.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import Foundation

struct Run {
    var distance: Double?
    var soFarDistance: Double?
    var startDate: NSDate?
    var isFinished: Bool {
        return soFarDistance >= distance
    }
    
    init(distance: Double, soFarDistance: Double = 0.0, startDate: NSDate = NSDate()) {
        self.distance = distance
        self.soFarDistance = soFarDistance
        self.startDate = startDate
    }
    
    func update() {
        
    }
    
    static var currentRun: Run!
    
}
