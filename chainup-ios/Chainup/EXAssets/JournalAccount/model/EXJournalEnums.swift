//
//  EXJournalEnums.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXJournalListSceneKey : String {
    case withdraw = "withdraw"
    case deposit = "deposit"
    case otctransfer = "otc_transfer"
    case none = "noscene"
}

enum EXWithDrawVerifyStep : String {
    case notStated = "0" //未审核
    case verified = "1" //已审核
    case reject = "2" //审核拒绝
    case duringPayment = "3" //支付中
    case paymentFail = "4" //支付失败
    case complete = "5" //已完成
    case canceled = "6" //已撤销

}

