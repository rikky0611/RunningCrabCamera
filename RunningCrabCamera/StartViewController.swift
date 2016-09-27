//
//  ViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/16.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import SCLAlertView

class StartViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    var distance: Double! = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setBool(true, forKey: "firstLaunch")
        if ud.boolForKey("firstLaunch") {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK!") {
                self.performSegueWithIdentifier("toCamera", sender: self)
            }
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("ようこそ", subTitle: "\nRunningCameraにようこそｶﾆ！\nぼくはマスコットのクラブ！みんなのランをサポートするｶﾆ！\n\nこのアプリは最初に決めた目標距離ランニングをして、想い出に残る写真を撮るアプリだｶﾆ！走りきったあとの達成感溢れる一瞬をぜひこのアプリで写真におさめるｶﾆ。ぼくもみんなの写真の中にお邪魔するｶﾆ！\n\nそれでは張り切ってランをするｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
            ud.setBool(false, forKey: "firstLaunch")
            Run.currentRun = Run(distance: 0.0)
            performSegueWithIdentifier("toCamera", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func didTapStartButton() {
        if distance < 1.0 {
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("Ooops", subTitle: "短すぎるｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
        }
        else if distance > 42.195 {
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("Ooops", subTitle: "フルマラソンより長いｶﾆ！危険だｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!, closeButtonTitle: "OK")
        } else {
            Run.currentRun = Run(distance: distance)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK!") {
                self.performSegueWithIdentifier("toCamera", sender: self)
            }
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("Start!", subTitle: "がんばって走るｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!)
            print("目標distance=\(distance)kmに設定")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension StartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 42
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame:  CGRectMake(0,0,100,20))
        label.text = "\(row+1)"
        label.textColor = UIColor.whiteColor()
        label.font = label.font.fontWithSize(24)
        label.textAlignment = .Center
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distance = Double(row+1)
    }
}

