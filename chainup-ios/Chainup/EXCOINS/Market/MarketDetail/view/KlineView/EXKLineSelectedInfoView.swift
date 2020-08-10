//
//  EXKLineSelectedInfoView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/17.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXKLineSelectedInfoView: NibBaseView {
    
    var rowItems = ["kline_text_dealTime".localized(),
                    "kline_text_open".localized(),
                    "kline_text_high".localized(),
                    "kline_text_low".localized(),
                    "kline_text_close".localized(),
                    "kline_text_changeValue".localized(),
                    "kline_text_changeRate".localized(),
                    "kline_text_volume".localized()]
    var chartItem:CHChartItem = CHChartItem()
    @IBOutlet var titles: [UILabel]!
    @IBOutlet var contents: [UILabel]!
    
    override func onCreate() {
        for (idx, tlabel) in titles.enumerated() {
            tlabel.text = rowItems[idx]
            tlabel.minimumRegular()
        }
        
        for clabel in contents {
            clabel.minimumRegular()
        }
    }
        
    func updateItems(item:CHChartItem,priceDecimal:String,volumeDecimal:String) {
        self.chartItem = item
        for (idx, clabel)  in contents.enumerated() {
            if idx == 0 {
                clabel.text = DateTools.dateToString(TimeInterval.init(item.time), dateFormat: "yy-MM-dd HH:mm")
            }else if (idx == 1) {
                clabel.text = item.openPrice.ch_toString().formatAmountUseDecimal(priceDecimal)
            }else if (idx == 2) {
                clabel.text = item.highPrice.ch_toString().formatAmountUseDecimal(priceDecimal)
            }else if (idx == 3) {
                clabel.text = item.lowPrice.ch_toString().formatAmountUseDecimal(priceDecimal)
            }else if (idx == 4) {
                clabel.text = item.closePrice.ch_toString().formatAmountUseDecimal(priceDecimal)
            }else if (idx == 5) {
                let changeValue = item.closePrice - item.openPrice
                if changeValue >= 0 {
                    clabel.textColor = UIColor.ThemekLine.up
                    clabel.text = "+" + changeValue.ch_toString().formatAmountUseDecimal(priceDecimal)
                }else {
                    clabel.textColor = UIColor.ThemekLine.down
                    clabel.text = changeValue.ch_toString().formatAmountUseDecimal(priceDecimal)
                }
            }else if (idx == 6) {
                let changeRate = ((item.closePrice - item.openPrice)/item.openPrice) * 100
                if changeRate >= 0 {
                    clabel.textColor = UIColor.ThemekLine.up
                    clabel.text = "+" + changeRate.ch_toString().formatAmountUseDecimal("2") + "%"
                }else {
                    clabel.textColor = UIColor.ThemekLine.down
                    clabel.text = changeRate.ch_toString().formatAmountUseDecimal("2") + "%"
                }
            }else if (idx == 7) {
                clabel.text = item.vol.ch_toString().formatAmountUseDecimal(volumeDecimal)
            }
        }
    }

}

