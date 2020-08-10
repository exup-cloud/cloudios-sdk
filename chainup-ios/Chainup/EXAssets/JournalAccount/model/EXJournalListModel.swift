//
//  EXJournalListModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class FinanceItem:EXBaseModel {
    var amount:String  = ""
    var coinSymbol:String =  ""
    var transactionScene:String = ""
//    var createdAtTime:String = ""
    var status_text:String = ""
    var status:String = ""
    var txid:String = ""
    var fee:String = ""
    var label:String = ""
    var confirmDesc:String = ""
    var addressTo:String = ""
    var id:String = ""
    var createTime:String = ""
    var walletTime = ""{
       didSet {
            if walletTime.count > 0 && !walletTime.contains("-") {
              walletTime = DateTools.strToTimeString(walletTime,dateFormat: "yyyy/MM/dd HH:mm:ss")
            }else {
               walletTime = "--"
            }
            
        }
    }
    var updateTime:String = ""{
        didSet {
            if updateTime.count > 0 && !updateTime.contains("-") {
              updateTime = DateTools.strToTimeString(updateTime,dateFormat: "yyyy/MM/dd HH:mm:ss")
            }else {
               updateTime = "--"
            }
            
        }
    }
    var settledAmount = ""//b2c实际到账金额
    var transferVoucher = ""//转账凭证
    var userName = ""//收款人名称
    var transferType = ""//1银行卡
    
    var createdAtTime:String = "" {
        didSet {
            if createdAtTime.count > 0 && !createdAtTime.contains("-"){
              createdAtTime = DateTools.strToTimeString(createdAtTime,dateFormat: "yyyy/MM/dd HH:mm:ss")
            }else {
               createdAtTime = "--"
            }
            
        }
    }
}

class EXJournalListModel: EXBaseModel {
    
    var financeList:[FinanceItem] = []
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.financeList = FinanceItem.mj_objectArray(withKeyValuesArray: self.financeList).copy() as! [FinanceItem]
    }
    
}
