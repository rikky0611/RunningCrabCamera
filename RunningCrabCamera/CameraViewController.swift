//
//  ViewController.swift
//  test_AVFoundationCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var input: AVCaptureDeviceInput!
    var output: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    var camera: AVCaptureDevice!
    var image: UIImage!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    var cameraFrame: CGRect {
        return CGRectMake(0.0, ViewManager.navigationBarHeight(self), screenWidth, screenWidth*1.0)
    }
    
    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Run.currentRun = Run(distance: 10.0)
        Health.readHealthData()
    }
    
    // メモリ管理のため
    override func viewWillAppear(animated: Bool) {
        setupCameraWithPosition(.Back)
        setupLockView()
    }
    // メモリ管理のため
    override func viewDidDisappear(animated: Bool) {
        initializeForMemory()
    }
    
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
    
    private func setupLockView() {
        let lockView =  UINib(nibName: "LockView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! LockView
        lockView.frame = cameraFrame
        view.addSubview(lockView)
    }
    
    @IBAction func takeStillPicture() {
        if let connection:AVCaptureConnection? = output.connectionWithMediaType(AVMediaTypeVideo) {
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in
                let imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                self.image = UIImage(data: imageData)!
                self.performSegueWithIdentifier("toNext", sender: nil)
            })
        }
    }
    
    @IBAction func changeCameraPosition() {
        if camera.position == .Back {
            setupCameraWithPosition(.Front)
        }
        else if camera.position == .Front {
            setupCameraWithPosition(.Back)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let stampViewController = segue.destinationViewController as! StampViewController
        stampViewController.takenImage = image
        print("success")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
