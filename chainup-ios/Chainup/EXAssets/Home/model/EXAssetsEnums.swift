//
//  EXAssetsEnums.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

enum EXAccountType {
    case coin
    case otc
    case contract
    case b2c
    case leverage
}

enum EXAssetToolBarAction {
    case none
    case recharge //充值
    case withdraw //提现
    case transfer //划转
    case journalAccount //流水
    case paymentTerm//支付方式
    case contract//合约
    case transaction //交易
    case redPack //红包
    case B2CRecharge //B2C的充币
    case B2CWithdraw //B2C的提币
    case B2CJournalAccount //B2C的资金流水
    case borrow//借贷
    case swapGift //合约赠金
}

class EXAssetToolBarItem:NSObject {
    var title :String = ""
    var iconImageName :String = ""
    var action :EXAssetToolBarAction = .none
}


