//
//  MyApi.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/12.
//  Copyright © 2017年 高临原. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

let API_DATA_URL   = "http://gank.io/api/data/%E7%A6%8F%E5%88%A9/"
let API_DAY_URL    = "http://gank.avosapps.com/api/day/"
let API_RANDOM_URL = "http://gank.avosapps.com/api/random/data/%E7%A6%8F%E5%88%A9/"
let API_SPARE_URL  = "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg"

enum MyAPI {
    case todayData
    case historyData(page:Int)
}

extension MyAPI:TargetType{
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        return URL.init(string: API_DATA_URL)!
    }
    
    var path: String {
        switch self {
        case .todayData:
            return "1/1"
        case .historyData(let page):
            return "10/\(page)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
}
