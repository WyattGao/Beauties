//
//  BeautyCollectionCell.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/13.
//  Copyright © 2017年 高临原. All rights reserved.
//

import Foundation
import UIKit

class BeautyCollectionCell: UICollectionViewCell {
    var imageView : UIImageView
//    var entity    : BeautyImageEntity
    
    required init?(coder aDecoder: NSCoder) {
        imageView = UIImageView()
        entity    = BeautyImageEntity()
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        entity    = BeautyImageEntity()
        super.init(frame: frame)
        commoInit()
    }
    
    func commoInit() -> Void {
        self.clipsToBounds       = false
        self.layer.borderWidth   = 5
        self.layer.borderColor   = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset  = CGSize(width:2,height:6)
        
        self.imageView.clipsToBounds    = true
        self.imageView.frame            = self.bounds
        self.imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.imageView.contentMode      = .scaleAspectFill
        
        self.addSubview(self.imageView)
    }
    
    var entity : BeautyImageEntity? {
        didSet {
            if let urlString = entity?.imageUrl {
                let url = URL.init(string: urlString)
                self.imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "loading"), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageUrl) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.imageView.alpha = 1
                    })
                })
            }
        }
    }
}
