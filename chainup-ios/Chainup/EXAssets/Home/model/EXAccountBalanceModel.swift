//
//  EXAccountBalanceModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit


class EXAccountCoinMapItem: EXBaseModel {
//    var withdrawAddressMap:[AddressItem] = []
//    var feeMin = ""
    var isFiat = ""
    var normal_balance = ""
    var allBalance = ""
    var present_coin_balance = ""
    var lock_position_balance = ""
    var btcValuatin = ""
    var sort = ""
//    var withdraw_min = ""
    var depositOpen = ""
    var total_balance = ""
    var nc_lock_balance = ""
//    var feeMax = ""
    var otcOpen = ""
    var depositMin = ""
//    var defaultFee = ""
    var checked = ""
    var coinName = ""
    var lock_balance = ""
    var allBtcValuatin = ""
//    var withdraw_max = ""
    var withdrawOpen = ""
    var lock_grant_divided_balance = ""
    var overcharge_balance = ""//定制用户，充值即锁仓余额。可用
    var lock_position_v2_amount = ""//代币锁仓
    override func mj_keyValuesDidFinishConvertingToObject() {
//        self.withdrawAddressMap = AddressItem.mj_objectArray(withKeyValuesArray: self.withdrawAddressMap).copy() as! [AddressItem]
    }
}


class EXAccountBalanceModel: EXBaseModel {
    
    var totalBalanceSymbol = "--"
    var totalBalance = "--"
    var allCoinMapList :[EXAccountCoinMapItem] = []
    var allCoinMap : [String : Any] = [:] {
        didSet {
            var temp : [EXAccountCoinMapItem] = []
            for (_,value) in allCoinMap {
                if let item = value as? [String : Any] {
                    let model = EXAccountCoinMapItem.mj_object(withKeyValues: item)
                    if let coinModel = model {
                        temp.append(coinModel)
                    }
                }
            }
            
            let array = temp.sorted { (model, model2) -> Bool in
                let sortNumber = [model.sort,model.coinName]
                let sortName = [model2.sort,model2.coinName]
                return sortNumber.lexicographicallyPrecedes(sortName, by: {
                    return  $0 .localizedStandardCompare($1) == .orderedAscending
                })
            }
            allCoinMapList = array
        }
    }
}

extension EXAccountBalanceModel{
    
    //根据币种名字获取币种账户
    func getItemWithCoinName(_ coinName : String) -> EXAccountCoinMapItem{
        var coinMapItem = EXAccountCoinMapItem()
        for item in allCoinMapList{
            if item.coinName == coinName{
                coinMapItem = item
            }
        }
        return coinMapItem
    }
}
