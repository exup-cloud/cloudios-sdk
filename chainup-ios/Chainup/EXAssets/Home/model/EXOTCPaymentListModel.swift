//
//  EXOTCPaymentListModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXOTCPaymentListModel: EXBaseModel {
    var id:String = ""
    var payment:String = ""
    var userName :String = ""
    var account :String = ""
    var qrcodeImg :String = ""
    var bankName :String = ""
    var bankOfDeposit :String = ""
    var ifscCode :String = ""
    var remittanceInformation :String = ""
    var isChoose : Bool = false//广告页用来记录是否选中
    var isOpen :String = ""
    var icon :String = ""
    var title :String = ""
}
