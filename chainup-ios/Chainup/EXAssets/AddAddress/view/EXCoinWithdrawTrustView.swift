//
//  EXCoinWithdrawTrustView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithdrawTrustView: NibBaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var trustSwitch: EXSwitch!
    @IBOutlet var contentLabel: UILabel!
    
    override func onCreate() {
        titleLabel.textColor = UIColor.ThemeLabel.colorLite
        titleLabel.font = UIFont.ThemeFont.BodyRegular
        contentLabel.textColor = UIColor.ThemeLabel.colorMedium
        contentLabel.font = UIFont.ThemeFont.SecondaryRegular
        
        titleLabel.text = "withdraw_action_trustAddress".localized()
        contentLabel.text = "withdraw_tip_trustDesc".localized()
    }
}
