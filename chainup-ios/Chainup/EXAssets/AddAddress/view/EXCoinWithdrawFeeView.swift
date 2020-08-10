//
//  EXCoinWithdrawFeeView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithdrawFeeView: NibBaseView {
    @IBOutlet var feeInputView: EXTextField!
    
    override func onCreate() {
        feeInputView.input.keyboardType = UIKeyboardType.decimalPad
        feeInputView.enableTitleModel = true
        feeInputView.setTitle(title: "withdraw_text_fee".localized())
        feeInputView.setPlaceHolder(placeHolder:"withdraw_text_fee".localized())
    }
    
    func setFee(_ fee:String,_ symbol:String) {
        feeInputView.setText(text: fee)
    }
}
