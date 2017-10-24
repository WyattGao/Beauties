//
//  Utils.swift
//  Beauties
//
//  Created by 高临原 on 2017/10/12.
//  Copyright © 2017年 高临原. All rights reserved.
//

import UIKit
import SwiftyJSON
import ChameleonFramework

let ThemeColor = HexColor("#969696")

func RGB(R:CGFloat,G:CGFloat,B:CGFloat) -> UIColor{
    let color = UIColor.init(red: R, green: G, blue: B, alpha: 1)
    return color
}

class BeautyDateUtil{
    static let PAGE_SIZE  = 20
    static let API_FORMAT = "yyyy/MM/dd"
    static let MAX_PAGE   = 10
    
    //    class func generateHistoryDateString(page:Int) -> [String]{
    ////        return self.generateHistoryDateString(f:)
    //    }
    //
    //    class func generateHistoryDateString(format format:String, historyCount:Int, page:Int) -> [String] {
    //        let today            = NSDate()
    //        let calendar         = NSCalendar.current
    //        let formatter        = DateFormatter()
    //        formatter.dateFormat = format
    //
    //        let unit = ((page - 1) * self.PAGE_SIZE)...(page * self.PAGE_SIZE - 1)
    ////        return unit.map({calendar.dateByAddingUnit(.Day, value: -$0, toDate: today, options: [])}).filter({$0 != nil}).map({formatter.stringFromDate($0!)})
    //
    //
    //        return unit.map({calendar.date(byAdding: .day, value: -$0, to: today as Date, options:[])}).filter({$0 != nil}).map({formatter.string(from: $0!)})
    //    }
    
    class func toDayString()->String{
        let today            = NSDate()
        let formatter        = DateFormatter()
        formatter.dateFormat = self.API_FORMAT
        
        return formatter.string(from: today as Date)
    }
}



class NetworkUtil{
    
    static let PAGE_SIZE = 20
    
    class func getTodayBeauty(complete:([NSString]) -> Void){
        
    }
}


