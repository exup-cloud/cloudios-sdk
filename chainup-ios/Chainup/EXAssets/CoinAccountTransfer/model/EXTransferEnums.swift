//
//  EXTransferEnums.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXTransferFlow {
    case exchangeToOther
    case otcToExchange
    case contractToExchagne
    case leverageToExchagne//杠杆
}

enum EXTransferAccountKey:String {
    case accountKeyExchange = "1" // 交易账户
    case accountKeyOTC = "2" //场外账户
}
