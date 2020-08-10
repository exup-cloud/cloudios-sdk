//
//  EXCurrentBorrowModel.swift
//  Chainup
//
//  Created by ljw on 2019/11/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCurrentBorrowModel: EXBaseModel {
    var financeList = [EXCurrentBorrowListModel]()
    var count = ""
    var pageSize = ""
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.financeList = EXCurrentBorrowListModel.mj_objectArray(withKeyValuesArray: self.financeList).copy() as! [EXCurrentBorrowListModel]
    }
}

class EXCurrentBorrowListModel: EXBaseModel {
    
    var id = ""
    var base = ""
    var quote = ""
    var ctime = ""
    var symbol = ""
    var coin = ""
    var showName = ""
    var borrowMoney = ""
    var interestRate = "" {
        didSet {
            if interestRate.count > 0 {
                let str = NSString.init(string: "100").multiplying(by: interestRate, decimals: 2) as NSString
                let str1 = str.decimalString1(2) as String
                interestRate = str1 + "%"
            }
        }
    }
    var oweInterest = ""
    var oweAmount = ""
    var status = ""
    //历史记录用（已归还）
    var interest: String = ""
}
