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
    
    func configure(image: UIImage) {
        imageViewForTakenImage.image = image
    }    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
