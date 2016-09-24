//
//  PopUpPhotoView.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/24.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

class PopUpPhotoView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func configure(object: PhotoObject) {
        imageView.image = object.image
        let timeStamp = DateUtils.stringFromDate(object.timeStamp, format: "yyyy/MM/dd HH:mm")
        label.text = timeStamp
    }

}
