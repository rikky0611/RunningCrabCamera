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
    
    func configure(image: UIImage, distance: Double) {
        imageViewForTakenImage.image = image
        if distance == 0.0 {
            //すなわちチュートリアル
            labelForComment.text = "チュートリアル終了だｶﾆ！"
            labelForComment.font = UIFont(name: "03スマートフォントUI", size: 20)
        } else {
            labelForComment.text = "\(distance)km完走だｶﾆ！"
            labelForComment.font = UIFont(name: "03スマートフォントUI", size: 20)
        }
    }    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
