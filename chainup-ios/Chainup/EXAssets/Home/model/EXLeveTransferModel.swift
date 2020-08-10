

//
//  EXLeveTransferModel.swift
//  Chainup
//
//  Created by ljw on 2019/11/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeveTransferModel: EXBaseModel {
    var financeList = [EXLeveTransferListModel]()
    var count = ""
    var pageSize = ""
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.financeList = EXLeveTransferListModel.mj_objectArray(withKeyValuesArray: self.financeList).copy() as! [EXLeveTransferListModel]
    }
}

class SLSwapTransferModel: EXBaseModel {
    var financeList = [SLSwapTransferListModel]()
    var count = ""
    var pageSize = ""
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.financeList = SLSwapTransferListModel.mj_objectArray(withKeyValuesArray: self.financeList).copy() as! [SLSwapTransferListModel]
    }
}

class SLSwapTransferListModel: EXBaseModel {
    var createTime = ""
    var createdAtTime = ""
    var amount = ""//数量
    var coinSymbol = ""//币种
    var status_text = ""
    var status = ""//1.币币转合约，2. 合约转币币
}

class EXLeveTransferListModel: EXBaseModel {
    var createTime = ""
    var amount = ""//数量
    var symbol = ""//币对
    var coinSymbol = ""//币种
    var showName = ""
    var transferType = ""//1.转入杠杆，2. 转出杠杆
}
