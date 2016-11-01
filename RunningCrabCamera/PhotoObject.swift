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
    dynamic fileprivate var id = 1
    dynamic var distance: Double = 0.0
    dynamic fileprivate var _image: UIImage? = nil
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
    dynamic var imageData: Data? = nil
    dynamic var timeStamp: Date = Date()
    
    
    override static func ignoredProperties() -> [String] {
        return ["_image","image"]
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }

    
    convenience init(distance: Double, image: UIImage, timeStamp: Date) {
        self.init()
        self.distance = distance
        self.image = image
        self.timeStamp = timeStamp
    }
    
}
