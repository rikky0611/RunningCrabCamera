//
//  PhotoObject.swift
//  RunningCrabCamera
//
//  Created by 荒川陸 on 2016/09/24.
//  Copyright © 2016年 Riku Arakawa. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoObject: Object {
    dynamic private var id = 1
    dynamic var distance: Double = 0.0
    dynamic private var _image: UIImage? = nil
    dynamic var image : UIImage? {
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        get{
            if let image = _image{
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    dynamic var imageData: NSData? = nil
    dynamic var timeStamp: NSDate = NSDate()
    
    
    override static func ignoredProperties() -> [String] {
        return ["_image","image"]
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }

    
    convenience init(distance: Double, image: UIImage, timeStamp: NSDate) {
        self.init()
        self.distance = distance
        self.image = image
        self.timeStamp = timeStamp
    }
    
}
