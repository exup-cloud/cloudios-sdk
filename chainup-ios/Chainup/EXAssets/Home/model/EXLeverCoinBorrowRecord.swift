//
//  EXLeverCoinBorrowRecord.swift
//  Chainup
//
//  Created by ljw on 2019/11/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverCoinBorrowRecord: EXBaseModel {
    var quoteReturnPrecision: String = ""
    var baseTotalBorrow: String = ""
    var quoteCanBorrow: String = ""
    var quoteBorrowBalance: String = ""
    var quoteMinBorrow: String = ""
    var riskRate: String = ""
    var baseNormalBalance: String = ""
    var baseTotalBalance: String = ""
    var multiple: String = ""
    var quoteNormalBalance: String = ""
    var baseMinBorrow: String = ""
    var burstPrice: String = ""
    var quoteEXNormalBalance: String = ""
    var quoteCoin: String = ""
    var quoteMinPayment: String = ""
    var quoteCanTransfer: String = ""
    var baseCanBorrow: String = ""
    var baseBorrowBalance: String = ""
    var quoteLockBalance: String = ""
    var baseLockBalance: String = ""
    var name: String = ""
    var symbol: String = ""
    var baseReturnPrecision: String = ""
    var baseMinPayment: String = ""
    var quoteTotalBorrow: String = ""
    var quoteTotalBalance: String = ""
    var baseCanTransfer: String = ""
    var rate: String = "" {
        didSet {
            if rate.count > 0 {
                let str = NSString.init(string: "100").multiplying(by: rate, decimals: 2) as NSString
                let str1 = str.decimalString1(2) as String
                rate = str1 + "%"
            }
        }
    }
    var baseCoin: String = ""
    var baseExNormalBalance: String = ""
    var symbolBalance : String = ""
    
}
