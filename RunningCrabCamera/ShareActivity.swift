//
//  ShareActivity.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

final class ShareActivityController {
    
    class func create(image: UIImage, text: String? = nil) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // 許可しない共有を設定
        // コメントにしているのは許可するもの
        activityController.excludedActivityTypes =  [
            // UIActivityTypePostToFacebook,
            // UIActivityTypePostToTwitter,
            // UIActivityTypePostToWeibo,
            // UIActivityTypeMessage,
            // UIActivityTypeMail,
            UIActivityTypePrint,
            // UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            //UIActivityTypeSaveToCameraRoll,
            // UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            // UIActivityTypePostToTencentWeibo,
            // UIActivityTypeAirDrop
        ]
        
        activityController.completionWithItemsHandler = {
            (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                guard activityType != nil else {
                    return
                }
            }
        }
        return activityController
    }
}
