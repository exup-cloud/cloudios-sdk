//
//  EXCoinWithdrawFooter.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithdrawFooter: NibBaseView {
    @IBOutlet var footerTitle: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var confirmBtn: EXButton!
    
    override func onCreate() {
        footerTitle.text = "withdraw_text_moneyWithoutFee".localized()
        footerTitle.font = UIFont.ThemeFont.BodyRegular
        amountLabel.text = ""
        amountLabel.font = UIFont.ThemeFont.BodyRegular
        confirmBtn.setTitle("common_text_btnConfirm".localized(), for: .normal)
    }
    
    func hideFooterTitle() {
        footerTitle.isHidden = true
    }

    static func getHeight()->CGFloat {
        return 112
    }
}
