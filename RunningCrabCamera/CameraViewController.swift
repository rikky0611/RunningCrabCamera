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
import RealmSwift

class CameraViewController: UIViewController {
    
    var input: AVCaptureDeviceInput!
    var output: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    var camera: AVCaptureDevice!
    var image: UIImage!
    var albumThumbnailImage: UIImage?
    
    let screenWidth = UIScreen.main.bounds.width
    var cameraFrame: CGRect {
        return CGRect(x: 0.0, y: ViewManager.navigationBarHeight(self), width: screenWidth, height: screenWidth*4/3)
    }
    
    var lockView: LockView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var changeCameraPositionButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    var timer: Timer?
    var didSendNotification: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        cameraButton.addTarget(self,action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
        changeCameraPositionButton.addTarget(self, action: #selector(didTapChangeCameraPositionButton(_:)), for: .touchUpInside)
        
        cameraButton.isEnabled = false
        changeCameraPositionButton.isHidden = true
        resetButton.isEnabled = true
        albumButton.isEnabled = true
        
        setAlbumThumbnailImage()
        
        let ud = UserDefaults.standard
        if ud.bool(forKey: "firstLaunch") {
            resetButton.isEnabled = false
            albumButton.isEnabled = false
            
            let alertView = SCLAlertView()
            alertView.iconTintColor = UIColor.white
            alertView.showCustom("カメラ", subTitle: "目標距離走ったらここで写真を撮るｶﾆ！\n今回は最初だから実際に走らなくて大丈夫だｶﾆ", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!,closeButtonTitle: "OK")
        }
    }
    
    func updateHealthData(_ timer : Timer) {
        updateRunAndLockView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateHealthData(_:)), userInfo: nil, repeats: true)
        setupCameraWithPosition(.back)
        setupLockView()
        updateRunAndLockView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
        initializeForMemory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNext" {
            let stampViewController = segue.destination as! StampViewController
            stampViewController.takenImage = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: LockView系メソッド


extension CameraViewController {
    fileprivate func setupLockView() {
        lockView =  UINib(nibName: "LockView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! LockView
        lockView.frame = cameraFrame
        view.addSubview(lockView)
    }
    
    fileprivate func updateRunAndLockView() {
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
    
    fileprivate func removeLockViewAndEnableCameraButton() {
        lockView.removeFromSuperview()
        cameraButton.isEnabled = true
        changeCameraPositionButton.isHidden = false
    }
    
    fileprivate func sendNotification() {
        let notif = UILocalNotification()
        notif.fireDate = Date()
        notif.timeZone = TimeZone.current
        notif.alertBody = "目標距離達成ｶﾆ~\n写真を撮るｶﾆ！"
        notif.alertAction = "OK"
        notif.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notif)
    }

}


//MARK: Camera系メソッド


extension CameraViewController {
    fileprivate func initializeForMemory() {
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
    
    fileprivate func setupCameraWithPosition(_ position: AVCaptureDevicePosition) {
        session = AVCaptureSession()
        for caputureDevice: AnyObject in AVCaptureDevice.devices() as [AnyObject] {
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
        previewLayer?.frame = cameraFrame
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(previewLayer!)
        session.startRunning()
    }
    
    func didTapCameraButton(_ sender: UIButton) {
        if let connection:AVCaptureConnection? = output.connection(withMediaType: AVMediaTypeVideo) {
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronously(from: connection, completionHandler: { (imageDataBuffer, error) -> Void in
                let imageData: Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                self.image = UIImage(data: imageData)!
                self.performSegue(withIdentifier: "toNext", sender: nil)
            })
        }
    }
    
    func didTapChangeCameraPositionButton(_ sender: UIButton) {
        if camera.position == .back {
            setupCameraWithPosition(.front)
        }
        else if camera.position == .front {
            setupCameraWithPosition(.back)
        }
    }

}


//MARK: リセット系メソッド


extension CameraViewController {
    @IBAction func didTapResetButton() {
        let alertView = SCLAlertView()
        alertView.addButton("ランを終了する") {
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertView.iconTintColor = UIColor.white
        alertView.showCustom("注意", subTitle: "ランを終了すると今回のランは記録されないｶﾆ。\n ランを終了するｶﾆ？", color: UIColor.crabRed(), icon: UIImage(named: "crab2.png")!, closeButtonTitle: "キャンセル")

    }
}


//MARK: Album系メソッド


extension CameraViewController {
    
    fileprivate func setAlbumThumbnailImage() {
        loadPhotoFromRealm()
        if let albumThumbnailImage = albumThumbnailImage {
            albumButton.setBackgroundImage(albumThumbnailImage, for: UIControlState())
        } else {
            albumButton.setBackgroundImage(UIImage(named: "hand2.png"), for: UIControlState())
        }
    }
    
    fileprivate func loadPhotoFromRealm() {
        guard let realm = try? Realm() else { return }
        albumThumbnailImage = realm.objects(PhotoObject.self).sorted(byProperty: "timeStamp").last?.image
    }

}
