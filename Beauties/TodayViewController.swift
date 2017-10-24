//
//  ViewController.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/12.
//  Copyright © 2017年 高临原. All rights reserved.
//

import UIKit
import ChameleonFramework
import Kingfisher
import Foundation
import Moya
import SwiftyJSON

class TodayViewController: UIViewController,UIScrollViewDelegate {
    
    var beautyImageView : UIImageView?
    var todayBeauty     : BeautyImageEntity?
    var loadingindicator : UIActivityIndicatorView!
    var canBeClosed = false
    var scrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThemeUsingPrimaryColor(ThemeColor, with:.contrast)
        
        loadingindicator                  = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        loadingindicator.hidesWhenStopped = true
        self.view.addSubview(loadingindicator)
        loadingindicator.startAnimating()
        
        beautyImageView                           = UIImageView.init(frame: self.view.bounds)
        beautyImageView?.autoresizingMask         = [.flexibleWidth,.flexibleHeight]
        beautyImageView?.contentMode              = .scaleAspectFit
        beautyImageView?.isUserInteractionEnabled = true
        beautyImageView?.backgroundColor          = UIColor.clear
        
        if canBeClosed {
            let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(onSwipe(sender:)))
            swipeGesture.direction = .down
            beautyImageView?.addGestureRecognizer(swipeGesture)
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onSwipe(sender:)))
            beautyImageView?.addGestureRecognizer(tapGesture)
        }
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPress(sender:)))
        beautyImageView?.addGestureRecognizer(longPressGesture)
        
        let doubleClick = UITapGestureRecognizer.init(target: self, action: #selector(imageViewRecover))
        doubleClick.numberOfTapsRequired = 2
        beautyImageView?.addGestureRecognizer(doubleClick)
        
        if todayBeauty != nil {
            setImage(todayBeauty!)
        } else {
            getTodayBeauty()
        }
        
        self.setUpScrolleView()
        
        setZoomScaleFor(scrollViewSize: scrollView.bounds.size)
        imageViewRecover()
        
        recenterImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if loadingindicator.isAnimating {
            loadingindicator.center = self.view.center
        }
    }
    
    func setUpScrolleView(){
        scrollView = UIScrollView.init(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = beautyImageView!.bounds.size
        scrollView.delegate = self
        
        scrollView.addSubview(beautyImageView!)
        view.addSubview(scrollView)
    }
    
    func setImage(_ entity: BeautyImageEntity){
        if let imageURLString =  entity.imageUrl {
            if let imageUrl = URL.init(string: imageURLString) {
                self.beautyImageView?.alpha = 0
                KingfisherManager.shared.downloader.downloadTimeout = 1
                KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    DispatchQueue.main.async {
                        self.loadingindicator.stopAnimating()
                        //self?.loadingIndicator.stopAnimating()
                        var beauty = Image()
                        if image == nil {
                            beauty = UIImage.init(data: try! Data.init(contentsOf: URL.init(string: API_SPARE_URL)!))!
                        } else {
                            beauty = image!
                        }
                        self.beautyImageView?.image = beauty
                        self.setBackgroundImage(image: beauty)
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                            self.beautyImageView?.alpha = 1
                        }, completion: nil)

                        self.view.setNeedsLayout()
                    }
                })
            }
        }
    }
    
    func getTodayBeauty(){
        let provider = MoyaProvider<MyAPI>()
        provider.request(.todayData) { (result) in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    let json                   = JSON(moyaResponse.data)
                    self.todayBeauty           = BeautyImageEntity()
                    self.todayBeauty?.imageUrl = json["results"][0]["url"].stringValue
                    self.setImage(self.todayBeauty!)
                }
            case let .failure(error):
                let alert = UIAlertController.init(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setBackgroundImage(image:UIImage) {
        let bgi         = UIImageView(image:image)
        bgi.contentMode = .scaleToFill
        bgi.frame       = self.view.bounds
        self.view.addSubview(bgi)
        self.view.sendSubview(toBack: bgi)
        
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        let blurView   = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bgi.frame
        bgi.addSubview(blurView)
    }
    
    func saveImage(){
        if let image = self.beautyImageView?.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageFinished(image:error:contextInfo:)), nil)
        }
    }
    
    func shareImage(){
        if let image = self.beautyImageView?.image{
            let text = "分享姑娘"
            let activityController = UIActivityViewController.init(activityItems: [text,image], applicationActivities: nil)
            self.present(activityController, animated: true, completion: {
                let alert = UIAlertController.init(title: "分享成功", message: nil, preferredStyle: .actionSheet)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @objc func onSwipe(sender:UISwipeGestureRecognizer){
        if canBeClosed {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onLongPress(sender:UILongPressGestureRecognizer){
        if sender.state == .began {
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let saveAction = UIAlertAction.init(title: "保存", style: .default, handler: { (action) in
                self.saveImage()
            })
            let shareAction = UIAlertAction.init(title: "分享", style: .default, handler: { (action) in
                self.shareImage()
            })
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            alert.addAction(shareAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func saveImageFinished(image:UIImage,error:NSErrorPointer,contextInfo:UnsafeRawPointer){
        var message = "保存失败，请开启访问相册的权限"
        var confirm = "好的"

        if error == nil {
            message = "保存成功"
            confirm = "好的"
        }
        
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction.init(title: confirm, style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil);
    }
    
    //MARK : ScrollViewDelegate
    private func setZoomScaleFor(scrollViewSize:CGSize){
        let imageSize   = beautyImageView?.bounds.size
        let widthScale  = scrollViewSize.width / imageSize!.width
        let heightScale = scrollViewSize.height / imageSize!.height
        let minimunScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minimunScale
        scrollView.maximumZoomScale = 3.0
    }
    
    @objc private func recenterImage(){
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = beautyImageView?.frame.size
        let horizontalSpace = imageViewSize!.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize!.width) / 2.0 : 0
        let verticalSpace = imageViewSize!.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize!.height) / 2.0 : 0
        scrollView.contentInset = UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.beautyImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.recenterImage()
    }
    
    @objc func imageViewRecover(){
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

