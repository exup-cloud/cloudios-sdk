//
//  EXLeverageAccountListModel.swift
//  Chainup
//
//  Created by ljw on 2019/11/4.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverageAccountListModel: EXBaseModel {
    static let shareInstance = EXLeverageAccountListModel()
    var memoryLeverCoinMapListArr = [EXLeverageCoinMapItem]()//内存存储
    var totalBalanceSymbol = ""
    var totalBalance = ""
    var leverCoinMapListArr = [EXLeverageCoinMapItem]()
    var leverMap : [String : Any] = [:]
    {
        didSet{
            for item in leverMap.values {
                if let model = EXLeverageCoinMapItem.mj_object(withKeyValues: item) {
                    leverCoinMapListArr.append(model)
                  let coinMap =  PublicInfoManager.sharedInstance.getCoinMapInfo(model.name)
                    if coinMap.name.count > 0 {
                        model.doubleSort = coinMap.doubleSort
                    }
                }
            }
            leverCoinMapListArr = leverCoinMapListArr.sorted(by: { (item1, item2) -> Bool in
               return item1.doubleSort < item2.doubleSort
            })
        }
    }
    
}

