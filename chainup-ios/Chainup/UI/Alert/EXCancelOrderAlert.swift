//
//  EXCancelOrderAlert.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCancelOrderAlert: NibBaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var warninglabel: UILabel!
    @IBOutlet var checkBox: EXCheckBox!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cancleBtn: UIButton!
    
    override func onCreate() {
        self.titleLabel.headBold()
        self.titleLabel.textColor = UIColor.ThemeLabel.colorLite
        self.warninglabel.bodyRegular()
        self.warninglabel.textColor = UIColor.ThemeState.warning
        checkBox.text(content: "otc_tip_buyerCancelConfirm".localized())
    }
    
    func config(altTitle:String,msg:String,checkBoxText:String,passiveBtnTitle:String = "cancle".localized(),positiveBtnTitle:String="confirm".localized()) {
        
    }
    
    

}
