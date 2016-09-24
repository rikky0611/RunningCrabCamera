//
//  StampViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import RealmSwift

class StampViewController: UIViewController {
    var takenImage: UIImage!
    var timeStamp: NSDate!
    let screenWidth = UIScreen.mainScreen().bounds.width
    var stampView: StampView!
    
    var cameraFrame: CGRect {
        return CGRectMake(0.0, ViewManager.navigationBarHeight(self), screenWidth, screenWidth*1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stampView =  UINib(nibName: "StampView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! StampView
        stampView.frame = cameraFrame
        stampView.configure(takenImage)
        view.addSubview(stampView)
    }
    
    @IBAction func didTapActionButton() {
        UIGraphicsBeginImageContext(stampView.bounds.size)
        stampView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.presentViewController(ShareActivityController.create(image), animated: true, completion: nil)
    }
    
    @IBAction func savePhotoToAlbum() {
        guard let realm = try? Realm() else { return }
        
        UIGraphicsBeginImageContext(stampView.bounds.size)
        stampView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let object = PhotoObject(distance: Run.currentRun.distance!,
                                 image: image,
                                 timeStamp: timeStamp)
        do {
            try realm.write {
                realm.add(object, update: false)
                print("データベースに保存")
            }
        } catch {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
