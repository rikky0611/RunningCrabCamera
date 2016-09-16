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
    var isFinished: Bool {
        return soFarDistance >= distance
    }
    
    init(distance: Double?, soFarDistance: Double?) {
        self.distance = distance
        self.soFarDistance = soFarDistance
    }
    
}
