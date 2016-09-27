//
//  ViewController.swift
//  test_AVFoundationCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView

class CameraViewController: UIViewController {
    
    var input: AVCaptureDeviceInput!
    var output: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    var camera: AVCaptureDevice!
    var image: UIImage!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    var cameraFrame: CGRect {
        return CGRectMake(0.0, ViewManager.navigationBarHeight(self), screenWidth, screenWidth*4/3)
    }
    
    var lockView: LockView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var changeCameraPositionButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    var timer: NSTimer?
    var didSendNotification: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = false
        
        cameraButton.addTarget(self,action: #selector(didTapCameraButton(_:)), forControlEvents: .TouchUpInside)
        changeCameraPositionButton.addTarget(self, action: #selector(didTapChangeCameraPositionButton(_:)), forControlEvents: .TouchUpInside)
        
        cameraButton.enabled = false
        changeCameraPositionButton.hidden = true
        resetButton.enabled = true
        albumButton.enabled = true
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.boolForKey("firstLaunch") {
            resetButton.enabled = false
            albumButton.enabled = false
            
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.whiteColor()
            alertView.showCustom("カメラ", subTitle: "目標距離走ったらここで写真を撮るｶﾆ！\n今回は最初だから実際に走らなくて大丈夫だｶﾆ", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
        }
    }
    
    func updateHealthData(timer : NSTimer) {
        updateRunAndLockView()
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(updateHealthData(_:)), userInfo: nil, repeats: true)
        setupCameraWithPosition(.Back)
        setupLockView()
        updateRunAndLockView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
        timer = nil
        initializeForMemory()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toNext" {
            let stampViewController = segue.destinationViewController as! StampViewController
            stampViewController.takenImage = image
            stampViewController.timeStamp = NSDate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: LockView系メソッド


extension CameraViewController {
    private func setupLockView() {
        lockView =  UINib(nibName: "LockView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! LockView
        lockView.frame = cameraFrame
        view.addSubview(lockView)
    }
    
    private func updateRunAndLockView() {
        guard Run.currentRun != nil else { return }
        Run.currentRun.update() {
            self.lockView.update()
            if Run.currentRun.isFinished {
                self.removeLockViewAndEnableCameraButton()
                if !self.didSendNotification {
                    self.sendNotification()
                    self.didSendNotification = true
                }
            }
        }
    }
    
    private func removeLockViewAndEnableCameraButton() {
        lockView.removeFromSuperview()
        cameraButton.enabled = true
        changeCameraPositionButton.hidden = false
    }
    
    private func sendNotification() {
        let notif = UILocalNotification()
        notif.fireDate = NSDate()
        notif.timeZone = NSTimeZone.defaultTimeZone()
        notif.alertBody = "目標距離達成ｶﾆ~\n写真を撮るｶﾆ！"
        notif.alertAction = "OK"
        notif.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notif)
    }

}


//MARK: Camera系メソッド


extension CameraViewController {
    private func initializeForMemory() {
        session.stopRunning()
        for output in session.outputs {
            session.removeOutput(output as? AVCaptureOutput)
        }
        for input in session.inputs {
            session.removeInput(input as? AVCaptureInput)
        }
        session = nil
        camera = nil
        //previewレイヤーを削除
        view.layer.sublayers!.removeLast()
    }
    
    private func setupCameraWithPosition(position: AVCaptureDevicePosition) {
        session = AVCaptureSession()
        for caputureDevice: AnyObject in AVCaptureDevice.devices() {
            // 背面or前面カメラを取得
            if caputureDevice.position == position {
                camera = caputureDevice as? AVCaptureDevice
            }
        }
        
        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        
        // 入力をセッションに追加
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCaptureStillImageOutput()
        // 出力をセッションに追加
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示を設定
        // previewLayerのframeはコードで指定しないと一回目のイニシャライザで正しく表示されなかった。
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = cameraFrame
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    func didTapCameraButton(sender: UIButton) {
        if let connection:AVCaptureConnection? = output.connectionWithMediaType(AVMediaTypeVideo) {
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in
                let imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                self.image = UIImage(data: imageData)!
                self.performSegueWithIdentifier("toNext", sender: nil)
            })
        }
    }
    
    func didTapChangeCameraPositionButton(sender: UIButton) {
        if camera.position == .Back {
            setupCameraWithPosition(.Front)
        }
        else if camera.position == .Front {
            setupCameraWithPosition(.Back)
        }
    }

}


//MARK: リセット系メソッド


extension CameraViewController {
    @IBAction func didTapResetButton() {
        let alertView = SCLAlertView()
        alertView.addButton("ランを終了する") {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        alertView.iconTintColor = UIColor.whiteColor()
        alertView.showCustom("注意", subTitle: "ランを終了すると今回のランは記録されないｶﾆ。\n ランを終了するｶﾆ？", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!, closeButtonTitle: "キャンセル")

    }
}