//
//  ViewManager.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/19.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

struct ViewManager {
    
    static let rootViewController = UIApplication.shared.keyWindow?.rootViewController
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    static var currentWindow: UIWindow? {
        if let window = UIApplication.shared.keyWindow {
            return window
        } else {
            return UIApplication.shared.windows[0]
        }
    }
    
    static func navigationBarHeight(_ callFrom: UIViewController) -> CGFloat {
        return callFrom.navigationController?.navigationBar.frame.size.height ?? 44
    }
}
