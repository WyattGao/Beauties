//
//  BeautyCollectionViewFooter.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/13.
//  Copyright © 2017年 高临原. All rights reserved.
//

import Foundation
import UIKit

class BeautyCollectionViewFooter: UICollectionReusableView {
    
    var loadingIndicator : UIActivityIndicatorView
    
    override init(frame: CGRect) {
        loadingIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        loadingIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        super .init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(loadingIndicator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.loadingIndicator.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
    }
    
    func startAnimating(){
        self.loadingIndicator.startAnimating()
    }
    
    func stopAnimating(){
        self.loadingIndicator.stopAnimating()
    }
}

