//
//  EXKlineModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
class KLineChartItem : NSObject {
    
    @objc var time:Int = 0 //id
    @objc var low:Double = 0
    @objc var high:Double = 0
    @objc var amount:Double = 0
    @objc var close:Double = 0
    @objc var vol:Double = 0
    @objc var ds:String = ""//日期
    @objc var tradeId:String = ""//日期
    //振幅
    @objc var amplitude: Double = 0
    @objc var amplitudeRatio: Double = 0
    
    @objc var `id`:Int = 0 {
        didSet {
            time = id
        }
    }
    @objc var open:Double = 0 {
        didSet {
            if open > 0 {
                amplitude = close - open
                amplitudeRatio = amplitude / open * 100
            }
        }
    }
}

class EXKlineModel: NSObject {
    @objc var tick :KLineChartItem = KLineChartItem()
    @objc var data :[KLineChartItem] = []
    @objc var channel :String = ""
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.data = KLineChartItem.mj_objectArray(withKeyValuesArray: self.data).copy() as! [KLineChartItem]
    }
}
