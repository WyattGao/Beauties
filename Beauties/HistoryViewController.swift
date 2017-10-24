//
//  HistoryViewController.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/13.
//  Copyright © 2017年 高临原. All rights reserved.
//

import Foundation
import UIKit
import Moya
import SwiftyJSON
import Kingfisher

//---------------------Views
var beautyCollectionView:UICollectionView!
var refreshControl:UIRefreshControl!
//---------------------Data


class HistoryViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var page = 1
    var beauties : [BeautyImageEntity] = []
    var isLoadingNow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor   = UIColor.white
        
        let collectionViewLayout                     = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize                = CGSize.init(width: (self.view.bounds.width - 10 * 3) / 2, height: 200)
        collectionViewLayout.minimumLineSpacing      = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.sectionInset            = UIEdgeInsetsMake(0, 10, (self.tabBarController?.tabBar.frame.height)!, 10)
        
        beautyCollectionView                      = UICollectionView.init(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        beautyCollectionView.alwaysBounceVertical = true
        beautyCollectionView.backgroundColor      = UIColor.clear
        beautyCollectionView.collectionViewLayout = collectionViewLayout
        beautyCollectionView.delegate             = self
        beautyCollectionView.dataSource           = self
        beautyCollectionView.register(BeautyCollectionCell.self, forCellWithReuseIdentifier: "BeautyCollectionCell")
        beautyCollectionView.register(BeautyCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "BeautyCollectionViewFoooter")
        self.view.addSubview(beautyCollectionView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        beautyCollectionView.addSubview(refreshControl)
        
        //start loading data
        self.refreshData()
    }
    
    @objc func refreshData(){
        page = 1
        beauties.removeAll(keepingCapacity: true)
        fetchNextPage(page: page)
    }
    
    func fetchNextPage(page:Int){
        if self.page > BeautyDateUtil.MAX_PAGE{
            return
        }
        if self.isLoadingNow {
            return
        }
        
        self.isLoadingNow = true
        print("------- Starting page \(page) -------")
        
        let provider = MoyaProvider<MyAPI>()
        
        provider.request(.historyData(page: page)) { (result) in
            self.isLoadingNow = false
            refreshControl.endRefreshing()
            switch result {
            case let .success(response):
                let json      = JSON(response.data)
                self.page     += 1
                let arr       = json["results"].arrayValue
                self.beauties += arr.map(self.buildEntityWithDictionary)
                beautyCollectionView.reloadData()
            case let .failure(error):
                let alert = UIAlertController.init(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.show(self, sender: nil)
                break
                
            }
        }
    }
    
    func buildEntityWithDictionary(dic:JSON)->BeautyImageEntity{
        
        let entity      = BeautyImageEntity.init()
        let url         = dic["url"].stringValue
        entity.imageUrl = url
        
        return entity
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beauties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeautyCollectionCell", for: indexPath) as! BeautyCollectionCell
        if indexPath.row < beauties.count {
            cell.entity = beauties[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.beauties.count {
            let entity = self.beauties[indexPath.row]
            let todayViewController         = TodayViewController()
            todayViewController.todayBeauty = entity
            todayViewController.canBeClosed = true
            self.present(todayViewController, animated: true, completion: nil)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footver:BeautyCollectionViewFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BeautyCollectionViewFoooter", for: indexPath) as! BeautyCollectionViewFooter
        if kind == UICollectionElementKindSectionFooter {
            footver.startAnimating()
            self.fetchNextPage(page: self.page)
        }
        return footver
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if page >= BeautyDateUtil.MAX_PAGE{
            return CGSize.zero
        } else {
            return CGSize.init(width: collectionView.bounds.width, height: 50)
        }
    }
}

