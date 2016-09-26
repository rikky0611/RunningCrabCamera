//
//  PopUpPhotoView.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/24.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

protocol PopUpPhotoViewDelegate: class {
    func didTapActionButton(object: PhotoObject)
}

class PopUpPhotoView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var currentObject: PhotoObject?
    var delegate: PopUpPhotoViewDelegate?
    
    func configure(object: PhotoObject) {
        currentObject = object
        imageView.image = object.image
        let timeStamp = DateUtils.stringFromDate(object.timeStamp, format: "yyyy/MM/dd HH:mm")
        label.text = timeStamp
    }
    
    @IBAction func didTapActionButton() {
        guard currentObject != nil  else { return }
        delegate?.didTapActionButton(currentObject!)
    }

}
