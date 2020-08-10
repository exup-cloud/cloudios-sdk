//
//  EXCoinWithDrawEmptyRemark.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithDrawEmptyRemark: NibBaseView {
    @IBOutlet var remarkField: EXTextField!
    
    override func onCreate() {
        remarkField.enableTitleModel = true
        remarkField.setPlaceHolder(placeHolder: "withdraw_tip_pleaseInputRemark".localized())
        remarkField.setTitle(title: "withdraw_text_remark".localized())
    }

    func setEmpty() {
        remarkField.setText(text: "")
    }
}
