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
    
    var input:AVCaptureDeviceInput!
    var output:AVCaptureStillImageOutput!
    var session:AVCaptureSession!
    var camera:AVCaptureDevice!
    
    @IBOutlet var preView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // メモリ管理のため
    override func viewWillAppear(animated: Bool) {
        setupCamera()
    }
    
    // メモリ管理のため
    override func viewDidDisappear(animated: Bool) {
        session.stopRunning()
        for output in session.outputs {
            session.removeOutput(output as? AVCaptureOutput)
        }
        for input in session.inputs {
            session.removeInput(input as? AVCaptureInput)
        }
        session = nil
        camera = nil
    }
    
    func setupCamera(){
        session = AVCaptureSession()
        
        for caputureDevice: AnyObject in AVCaptureDevice.devices() {
            // 背面カメラを取得
            if caputureDevice.position == AVCaptureDevicePosition.Back {
                camera = caputureDevice as? AVCaptureDevice
            }
            // 前面カメラを取得
            //if caputureDevice.position == AVCaptureDevicePosition.Front {
            //    camera = caputureDevice as? AVCaptureDevice
            //}
        }
        
        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        
        // 入力をセッションに追加
        if (session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCaptureStillImageOutput()
        // 出力をセッションに追加
        if (session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示を
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.frame = preView.frame
        
        //        previewLayer.videoGravity = AVLayerVideoGravityResize
        //        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // レイヤーをViewに設定
        // これを外すとプレビューが無くなる、けれど撮影はできる
        self.view.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    @IBAction func takeStillPicture() {
        if let connection:AVCaptureConnection? = output.connectionWithMediaType(AVMediaTypeVideo) {
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in
                let imageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                let image:UIImage = UIImage(data: imageData)!
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
