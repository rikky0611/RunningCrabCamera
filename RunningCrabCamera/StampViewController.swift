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
import GoogleMobileAds

class StampViewController: UIViewController {
    var takenImage: UIImage!
    var timeStamp: NSDate!
    let screenWidth = UIScreen.mainScreen().bounds.width
    var stampView: StampView!
    var object: PhotoObject!
    var bannerView: GADBannerView = GADBannerView()
    
    var cameraFrame: CGRect {
        return CGRectMake(0.0, ViewManager.navigationBarHeight(self), screenWidth, screenWidth*4/3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.boolForKey("firstLaunch") {
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("Congrats!", subTitle: "これでチュートリアルは終わりだよ！もっともっと一緒に走ってイイシャをたくさん撮るｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!, closeButtonTitle: "OK")
            ud.setBool(false, forKey: "firstLaunch")
        }
        
        stampView =  UINib(nibName: "StampView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! StampView
        stampView.frame = cameraFrame
        stampView.configure(takenImage, distance: Run.currentRun.distance!, date: Run.currentRun.startDate!)
        view.addSubview(stampView)
        
        setAdMob()
        savePhotoToAlbum()
    }
    
    private func savePhotoToAlbum() {
        guard let realm = try? Realm() else { return }
        
        UIGraphicsBeginImageContext(stampView.bounds.size)
        stampView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        object = PhotoObject(distance: Run.currentRun.distance!,
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
        self.presentViewController(ShareActivityController.create(object), animated: true, completion: nil)
    }
    
    @IBAction func didTapFinishButton() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK!") {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        alertView.iconTintColor = UIColor.whiteColor()
        alertView.showCustom("Congrats!", subTitle: "ナイスランだったｶﾆ！また一緒に走るｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!)
    }

}

extension StampViewController: GADBannerViewDelegate {
    
    private func setAdMob() {
        // AdMob広告設定
        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
        bannerView.frame.origin = CGPointMake(0, self.view.frame.height - bannerView.frame.height)
        bannerView.frame.size = CGSizeMake(self.view.frame.width, bannerView.frame.height)
        // AdMobで発行された広告ユニットIDを設定
        bannerView.adUnitID = "ca-app-pub-1375408112188399/4443197462"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        // テスト用の広告を表示する時のみ使用（申請時に削除）
        gadRequest.testDevices = ["1efa22abf589e3833e993b2e56010302"]
        bannerView.loadRequest(gadRequest)
        self.view.addSubview(bannerView)
    }
}
