//
//  StampView.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/19.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

class StampView: UIView {
    @IBOutlet weak var imageViewForTakenImage: UIImageView!
    @IBOutlet weak var labelForComment: UILabel!
    @IBOutlet weak var labelForDate: UILabel!
    
    func configure(image: UIImage, distance: Double, date: NSDate) {
        imageViewForTakenImage.image = image
        if distance == 0.0 {
            //すなわちチュートリアル
            labelForComment.text = "チュートリアル終了だｶﾆ！"
            labelForComment.font = UIFont(name: "03SmartFontUI", size: 17)
        } else {
            labelForComment.text = "\(distance)km完走だｶﾆ！"
            labelForComment.font = UIFont(name: "03SmartFontUI", size: 17)
        }
        let timeStamp = DateUtils.stringFromDate(date, format: "yyyy/MM/dd HH:mm")
        labelForDate.text = timeStamp
        labelForDate.font = UIFont(name: "Code-Bold", size: 14)
        
        //labelForComment.transform = CGAffineTransformRotate(labelForComment.transform, CGFloat(-M_PI/12))
        //labelForDate.transform = CGAffineTransformRotate(labelForDate.transform, CGFloat(-M_PI/12))
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
