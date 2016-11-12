//
//  LockView.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/19.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

class LockView: UIView {
    @IBOutlet weak var lockLabel: UILabel!
    @IBOutlet weak var distanceBaseGage: UILabel!
    @IBOutlet weak var distanceGage: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func update() {
        layoutIfNeeded()
        var run = Run.currentRun
        if run?.distance == 0.0 {
            run?.distance = 1.0
        }
        distanceGage.frame.size.width = distanceBaseGage.bounds.width * CGFloat((run?.soFarDistance!)! / (run?.distance!)!)
        let decimal = (run?.soFarDistance!)! * 10
        distanceLabel.text = "\(floor(decimal) / 10) / \(run!.distance!) [km]"
    }

}
