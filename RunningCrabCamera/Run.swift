//
//  Run.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/16.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


struct Run {
    var distance: Double?
    var soFarDistance: Double? {
        didSet(value){
            print("現在のところ=\(value!)km")
        }
    }

    var startDate: Date?
    var isFinished: Bool {
        return soFarDistance >= distance
    }
    
    init(distance: Double, soFarDistance: Double = 0.0, startDate: Date = Date()) {
        self.distance = distance
        self.soFarDistance = soFarDistance
        self.startDate = startDate
    }
    
    func update(_ completion: @escaping (Void) -> Void) {
        Health.readHealthData(completion)
    }
    
    static var currentRun: Run!
    
}
