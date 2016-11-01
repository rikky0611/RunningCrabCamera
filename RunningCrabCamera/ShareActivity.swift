//
//  ShareActivity.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/17.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit

final class ShareActivityController {
    
    class func create(_ object: PhotoObject) -> UIActivityViewController {
        let image = object.image!
        let timeStamp = DateUtils.stringFromDate(object.timeStamp, format: "yyyy/MM/dd HH:mm")
        let text = "\(timeStamp)に\(object.distance)km走りました！\n#RunningCamera"
        let activityController = UIActivityViewController(activityItems: [image,text], applicationActivities: nil)
        
        // 許可しない共有を設定
        // コメントにしているのは許可するもの
        activityController.excludedActivityTypes =  [
            // UIActivityTypePostToFacebook,
            // UIActivityTypePostToTwitter,
            // UIActivityTypePostToWeibo,
            // UIActivityTypeMessage,
            // UIActivityTypeMail,
            UIActivityType.print,
            // UIActivityTypeCopyToPasteboard,
            UIActivityType.assignToContact,
            //UIActivityTypeSaveToCameraRoll,
            // UIActivityTypeAddToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            // UIActivityTypePostToTencentWeibo,
            // UIActivityTypeAirDrop
        ]
        
        activityController.completionWithItemsHandler = nil
        return activityController
    }
}
