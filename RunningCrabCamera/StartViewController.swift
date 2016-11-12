//
//  ViewController.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/16.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import SCLAlertView
import SABlurImageView

class StartViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    var distance: Double! = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let bgImageView = SABlurImageView(image: UIImage(named: "bg.jpg"))
        bgImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        bgImageView.addBlurEffect(10)
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.alpha = 0.6
        view.addSubview(bgImageView)
        view.sendSubview(toBack: bgImageView)
        
        let ud = UserDefaults.standard
        if ud.bool(forKey: "firstLaunch") {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK!") {
                self.performSegue(withIdentifier: "toCamera", sender: self)
            }
            alertView.iconTintColor = UIColor.white
            alertView.showCustom("ようこそ", subTitle: "\nCrabCameraにようこそｶﾆ！\nぼくはマスコットのクラブ！みんなのランをサポートするｶﾆ！\n\nこのアプリは最初に決めた目標距離ランニングをして、想い出に残る写真を撮るアプリだｶﾆ！走りきったあとの達成感溢れる一瞬をぜひこのアプリで写真におさめるｶﾆ。ぼくもみんなの写真の中にお邪魔するｶﾆ！\n\nそれでは次に進むｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
            Run.currentRun = Run(distance: 0.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapStartButton() {
        if distance < 1.0 {
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.white
            alertView.showCustom("Ooops", subTitle: "短すぎるｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
        }
        else if distance > 42.195 {
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.white
            alertView.showCustom("Ooops", subTitle: "フルマラソンより長いｶﾆ！危険だｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!, closeButtonTitle: "OK")
        } else {
            Run.currentRun = Run(distance: 0.0)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK!") {
                self.performSegue(withIdentifier: "toCamera", sender: self)
            }
            alertView.iconTintColor = UIColor.white
            alertView.showCustom("START!", subTitle: "がんばって走るｶﾆ！", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!)
            print("目標distance=\(distance)kmに設定")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension StartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 42
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame:  CGRect(x: 0,y: 0,width: 100,height: 20))
        label.text = "\(row+1)"
        label.textColor = UIColor.white
        label.font = label.font.withSize(24)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distance = Double(row+1)
    }
}

