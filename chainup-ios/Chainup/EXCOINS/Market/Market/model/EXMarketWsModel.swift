//
//  EXMarketWsModel.swift
//  Chainup
//
//  Created by liuxuan on 2020/3/25.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class EXTickerModel:EXBaseModel {
    var amount:String = ""
    var close:String = ""
    var high:String = ""
    var low:String = ""
    var open:String = ""
    var rose:String = ""
    var ticker:String = ""
}

class EXMarketWsModel: EXBaseModel {
    var channel:String = ""
    var event_rep:String = ""
    var ts:String = ""
    var status:String = ""
    var data:[String:Any] = [:]
//    var tickerData:[EXTickerModel] = []
//    var tickerKeys:[String] = []
//
//    override func mj_keyValuesDidFinishConvertingToObject() {
//        for (key,value) in data {
//            if let tickerItem = EXTickerModel.mj_object(withKeyValues: value) {
//                tickerItem.ticker = key
//                self.tickerData.append(tickerItem)
//                self.tickerKeys.append(key)
//            }
//        }
//    }
    
}
