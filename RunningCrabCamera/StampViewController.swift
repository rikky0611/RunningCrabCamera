//
//  StampViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

class StampViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var takenImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = takenImage
        imageView.addSubview(UIImageView(image: UIImage(named: "logo")))
    }
    
    @IBAction func didTapActionButton() {
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.presentViewController(ShareActivityController.create(image), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
