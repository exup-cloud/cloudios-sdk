//
//  EXContractHoldModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXContractHoldModel: EXBaseModel {
    var contractId = ""//合约id
    var contractName = ""//合约名称
    var volume = ""//未平合约数
    var volumeColor = UIColor.ThemeLabel.colorLite
    var realisedAmount = ""//已实现盈亏
    var realisedColor = UIColor.ThemeLabel.colorLite
    var unrealisedAmount = ""//未实现盈亏
    var unrealisedColor = UIColor.ThemeLabel.colorLite
    var quoteSymbol = ""//计价币种
    var side = ""//BUY 多   SELL空
    var bond = ""//保证金币种
    var symbol = ""//
    var contractSeries = ""//合约系列
    var showPrecision = ""
    var leverageLevel = ""
    
 
    func valueDecimal() ->Int? {
        let tmpPrecision = Int(showPrecision)
        if let precision = tmpPrecision {
            return precision
        }
        return nil
    }
    
    
    func fmtRealisedAmount() ->String {
        let precision = self.valueDecimal()
        if precision != nil, !realisedAmount.isEmpty {
            let nsMargin = realisedAmount as NSString
            if nsMargin.hasPrefix("-") {
                let newStr = nsMargin.substring(from: 1) as NSString
                return "-\(newStr.decimalString(precision!) ?? "")"
            }
            let rst = nsMargin.decimalString(precision!)
            if let realRst = rst {
                return realRst
            }
        }
        return realisedAmount
    }

    func fmtUnrealisedAmountMarket() ->String {
        let precision = self.valueDecimal()
        if precision != nil, !unrealisedAmount.isEmpty {
            let nsMargin = unrealisedAmount as NSString
            if nsMargin.hasPrefix("-") {
                let newStr = nsMargin.substring(from: 1) as NSString
                return "-\(newStr.decimalString(precision!) ?? "")"
            }
            return nsMargin.decimalString(precision!)
        }
        return unrealisedAmount
    }

}
