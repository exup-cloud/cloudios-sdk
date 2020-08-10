//
//  EXAddressListModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class AddressItem: EXBaseModel {
    var id = ""
    var uid = ""
    var symbol = ""
    var address = ""
    var label = ""
    var status = ""
    var ctime = ""
    var trustType = ""
}

class EXAddressListModel: EXBaseModel {
    var addressList:[AddressItem] = []
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.addressList = AddressItem.mj_objectArray(withKeyValuesArray: self.addressList).copy() as! [AddressItem]
    }
}
