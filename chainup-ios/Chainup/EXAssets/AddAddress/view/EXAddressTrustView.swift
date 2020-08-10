//
//  EXAddressTrustView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAddressTrustView: NibBaseView {
    @IBOutlet var didTrustView: UIView!
    @IBOutlet var needTrustView: UIView!
    @IBOutlet var tipMsgLabel: UILabel!
    @IBOutlet var didTrustTitle: UILabel!
    @IBOutlet var trustTitle: UILabel!
    @IBOutlet var trustSwitch: EXSwitch!
    
    override func onCreate() {
        didTrustTitle.text = "withdraw_text_trustAddress".localized()
        trustTitle.text = "withdraw_action_trustAddress".localized()
        tipMsgLabel.text = "withdraw_tip_trustDesc".localized()
    }
    
    func isTrusted(_ istrust:Bool) {
        if istrust {
            needTrustView.isHidden = true
        }else {
            didTrustView.isHidden = true
        }
    }

}
