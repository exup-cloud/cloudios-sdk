//
//  EXCommonAssetModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCommonAssetModel: EXBaseModel {
    
    var title:String = ""
    var bgIcon:String = ""
    var totalBalance:String = ""
    var totalBalanceSymbol:String = ""
   
    //合约用
    var canUseBalance = ""
    var positionMargin = ""
    var orderMargin = ""
    var assetType:EXAccountType?

    func getCaculatePrice()->String {
        //btc的汇率
        let currency = PublicInfoManager.sharedInstance.getCoinExchangeRate(totalBalanceSymbol)
        let unit = currency.0
        let rate = currency.1
        let decimal = currency.2
        let balance = totalBalance as NSString
        if let rst =  balance.multiplying(by: rate, decimals: decimal) {
            return "≈" + unit + rst
        }else {
            return "≈" + unit + "0"
        }
    }
}
