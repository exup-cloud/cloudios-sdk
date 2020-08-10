//
//  EXReturnInfoModel.swift
//  Chainup
//
//  Created by ljw on 2019/11/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXReturnInfoModel: EXBaseModel {
    var financeList = [EXReturnInfoListModel]()
    var count = ""
    var pageSize = ""
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.financeList = EXReturnInfoListModel.mj_objectArray(withKeyValuesArray: self.financeList).copy() as! [EXReturnInfoListModel]
    }
}
class EXReturnInfoListModel: EXBaseModel {
    var repaymentTime = ""
    var coin = ""
    var returnMoney = ""
    var type = ""// 归还类型：1本金，2利息，3本金+利息
}
