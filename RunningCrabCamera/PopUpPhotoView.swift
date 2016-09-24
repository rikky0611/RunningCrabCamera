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
    
    func configure(image: UIImage) {
        imageView.image = image
    }

}
