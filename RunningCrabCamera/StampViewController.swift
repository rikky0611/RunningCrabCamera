//
//  StampViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView

class StampViewController: UIViewController {
    var takenImage: UIImage!
    var timeStamp: NSDate!
    let screenWidth = UIScreen.mainScreen().bounds.width
    var stampView: StampView!
    
    var cameraFrame: CGRect {
        return CGRectMake(0.0, ViewManager.navigationBarHeight(self), screenWidth, screenWidth*4/3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stampView =  UINib(nibName: "StampView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! StampView
        stampView.frame = cameraFrame
        stampView.configure(takenImage, distance: Run.currentRun.distance!)
        view.addSubview(stampView)
        
        savePhotoToAlbum()
    }
    
    private func savePhotoToAlbum() {
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


extension StampViewController {
    @IBAction func didTapActionButton() {
        UIGraphicsBeginImageContext(stampView.bounds.size)
        stampView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.presentViewController(ShareActivityController.create(image), animated: true, completion: nil)
    }
    
    @IBAction func didTapFinishButton() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Done") {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        alertView.showSuccess("Congrats!", subTitle: "ナイスランだったｶﾆ！また一緒に走るｶﾆ！")
    }

}
