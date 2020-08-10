//
//  EXOTCAccountListModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class CoinMapItem:EXBaseModel {
/*
     {
     "coinSymbol": "BTC",币种
     "normal": "0.00000000",//正常余额
     "exNormal":"0.0000000",//交易所正常余额
     "lock": "0.00000000",//冻结金额
     "exLock": "0.00000000",//交易所冻结金额
     "total_balance": 0.00000000,//总资产
     "btcValuation"： "0.00000000",//资产折合
     "exchangeNormal": 999.00000//现货余额
     "checked":"true"
     }
 */
    var coinSymbol :String = ""
    var normal :String = ""
    var exNormal :String = ""
    var lock :String = ""
    var total_balance :String = ""
    var btcValuation :String = ""
    var exchangeNormal :String = ""
    var checked :String = ""
    
    
}

class EXOTCAccountListModel: EXBaseModel {
    var allCoinMap:[CoinMapItem] = []
    var totalBalance :String = ""
    var totalBalanceSymbol :String = ""
    
    //b2c用到的
    var withdrawTip : String = ""//提现提示
    var depositTip : String = ""//充值提示
    //b2c返回的是这个字段totalBtcValue
   override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
       return ["totalBtcValue":"totalBalance"]
   }
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.allCoinMap = CoinMapItem.mj_objectArray(withKeyValuesArray: self.allCoinMap).copy() as! [CoinMapItem]
    }
    
    func isBalanceEmpty(coinSymbol:String) -> Bool{
        var isEmpty = false
        if self.allCoinMap.count > 0 {
            var coinItem:CoinMapItem?
            for item in self.allCoinMap {
                if item.coinSymbol == coinSymbol {
                    coinItem = item
                    break
                }
            }
            if let selectItem = coinItem {

                let balance = selectItem.normal as NSString
                if !balance.isBig("0") {
                    isEmpty = true
                }
            }
        }
        return isEmpty
    }
    
    func getCoinMap(coinSymbol:String) -> CoinMapItem{
        var coinMap:CoinMapItem = CoinMapItem()
        if self.allCoinMap.count > 0 {
            for item in self.allCoinMap {
                if item.coinSymbol == coinSymbol {
                    coinMap = item
                    break
                }
            }
        }
        return coinMap
    }
}


//b2c模块用
class B2CCoinMapItem:EXBaseModel {
    var depositMin: String = ""
    var withdrawOpen: String = ""//提现开关，1打开，0关闭
    var normalBalance: String = ""
    var symbol: String = ""
    var isAuth: String = ""
    var withdrawMin: String = ""
    var withdrawMax: String = ""
    var title: String = ""
    var lockBalance: String = ""
    var canWithdrawBalance: String = ""
    var btcValue: String = ""
    var totalBalance: String = ""
    var sort: String = ""
    var depositOpen: String = ""//充值
    var showPrecision : String = "2"//精度
    
}
class EXB2CAccountListModel: EXBaseModel {
    static let shareInstance : EXB2CAccountListModel = EXB2CAccountListModel()
    
    func getAllCoinMap() -> [B2CCoinMapItem] {
        return allCoinMap
    }
    var allCoinMap:[B2CCoinMapItem] = []
    var totalBtcValue :String = ""
    var totalBalanceSymbol :String = ""
    var withdrawTip : String = ""//提现提示
    var depositTip : String = ""//充值提示
   
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.allCoinMap = B2CCoinMapItem.mj_objectArray(withKeyValuesArray: self.allCoinMap).copy() as! [B2CCoinMapItem]
    }
    
    func isBalanceEmpty(coinSymbol:String) -> Bool{
        var isEmpty = false
        if self.allCoinMap.count > 0 {
            var coinItem:B2CCoinMapItem?
            for item in self.allCoinMap {
                if item.symbol == coinSymbol {
                    coinItem = item
                    break
                }
            }
            if let selectItem = coinItem {

                let balance = selectItem.normalBalance as NSString
                if !balance.isBig("0") {
                    isEmpty = true
                }
            }
        }
        return isEmpty
    }
    
    func getCoinMap(coinSymbol:String) -> B2CCoinMapItem{
        var coinMap:B2CCoinMapItem = B2CCoinMapItem()
        if self.allCoinMap.count > 0 {
            for item in self.allCoinMap {
                if item.symbol == coinSymbol {
                    coinMap = item
                    break
                }
            }
        }
        return coinMap
    }
}
