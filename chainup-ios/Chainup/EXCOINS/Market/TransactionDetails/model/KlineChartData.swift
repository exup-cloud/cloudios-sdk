//
//  KlineChartData.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/15.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
//import SwiftyJSON

class KlineChartData: SuperEntity,Codable {
    
    var time: Int = 0
    var lowPrice: Double = 0
    var highPrice: Double = 0
    var openPrice: Double = 0
    var closePrice: Double = 0
    var vol: Double = 0
//    var symbol: String = ""
//    var platfom: String = ""
//    var rise: Double = 0
//    var timeType: String = ""
    //振幅
    var amplitude: Double = 0
    var amplitudeRatio: Double = 0
    var type = "History"
    //"id":1506602880,//时间刻度起始值
    //"amount":123.1221,//交易额
    //"vol":1212.12211,//交易量
    //"open":2233.22,//开盘价
    //"close":1221.11,//收盘价
    //"high":22322.22,//最高价
    //"low":2321.22//最低价
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        if let amount = dict["amount"]{
            
        }
        if type == "History"{
            if let id = dict["id"] as? Int{
                time = id
            }
        }else{
            if let ts = dict["ts"] as? Int{
                let t = ts/1000
                time = t
            }
        }
        
        if let close = dict["close"]{
            self.closePrice = BasicParameter.handleDouble(close)
        }
        if let open = dict["open"]{
            self.openPrice = BasicParameter.handleDouble(open)
        }
        
        if let high = dict["high"]{
            self.highPrice =  BasicParameter.handleDouble(high)
        }
        
        if let low = dict["low"]{
            self.lowPrice =  BasicParameter.handleDouble(low)
        }
        
        if let vol = dict["vol"]{
            self.vol =  BasicParameter.handleDouble(vol)
        }
        if self.openPrice > 0 {
            self.amplitude = self.closePrice - self.openPrice
            self.amplitudeRatio = self.amplitude / self.openPrice * 100
        }

    }
    
    
    
    
    
//    convenience init(json: [JSON]) {
//        self.init()
//        self.time = json[0].intValue
//        self.highPrice = json[2].doubleValue
//        self.lowPrice = json[1].doubleValue
//        self.openPrice = json[3].doubleValue
//        self.closePrice = json[4].doubleValue
//        self.vol = json[5].doubleValue
//        //振幅
//        if self.openPrice > 0 {
//            self.amplitude = self.closePrice - self.openPrice
//            self.amplitudeRatio = self.amplitude / self.openPrice * 100
//        }
//
//    }
    
}


