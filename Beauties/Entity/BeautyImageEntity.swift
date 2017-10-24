//
//  BeautyImageEntity.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/12.
//  Copyright © 2017年 高临原. All rights reserved.
//

import Foundation

class BeautyImageEntity: NSObject,NSCoding {
    var imageUrl : String?
    var imageHeight : Int?
    var imageWidth : Int?
    
    override var description: String{
        return "imageUrl:\(self.imageUrl ?? ""),imageHeight:\(imageHeight ?? 0),imageWidth:\(imageWidth ?? 0)"
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageUrl    = aDecoder.decodeObject(forKey: "imageUrl") as? String
        imageHeight = aDecoder.decodeObject(forKey: "imageHeight") as? Int
        imageWidth  = aDecoder.decodeObject(forKey: "imageWidth") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        if imageUrl != nil {
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if imageHeight != nil {
            aCoder.encode(imageHeight, forKey: "imageHeight")
        }
        if imageWidth != nil {
            aCoder.encode(imageWidth, forKey: "imageWidth")
        }
    }
}
