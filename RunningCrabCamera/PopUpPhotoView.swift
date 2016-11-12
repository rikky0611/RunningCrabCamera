//
//  PopUpPhotoView.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/24.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

protocol PopUpPhotoViewDelegate: class {
    func didTapActionButton(_ object: PhotoObject)
}

class PopUpPhotoView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var currentObject: PhotoObject?
    var delegate: PopUpPhotoViewDelegate?
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func configure(_ object: PhotoObject) {
        currentObject = object
        imageView.image = object.image
        let timeStamp = DateUtils.stringFromDate(object.timeStamp, format: "yyyy/MM/dd HH:mm")
        label.text = timeStamp
        label.font = UIFont(name: "Code-Bold", size: 16)
        
        let shareImage = UIImage(named: "share2.png")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        actionButton.setImage(shareImage, for: UIControlState())
        actionButton.tintColor = UIColor.crabBlue()
    }
    
    @IBAction func didTapActionButton() {
        guard currentObject != nil  else { return }
        delegate?.didTapActionButton(currentObject!)
    }

}
