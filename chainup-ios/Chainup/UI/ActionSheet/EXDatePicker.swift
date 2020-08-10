//
//  EXDatePicker.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXDatePicker: NibBaseView {

    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var datePickerView: UIDatePicker!
    typealias DateConfirmedBlock = (Date) -> ()
    var dateConfirmCallback : DateConfirmedBlock?
    typealias DateCanceledBlock = () -> ()
    var dateCancelCallback : DateCanceledBlock?
    @IBOutlet var iphonexBottom: NSLayoutConstraint!
    
    override func onCreate() {
        datePickerView.locale = Locale(identifier: BasicParameter.getPhoneLanguage(ignoreServer: true))
        datePickerView.setValue(UIColor.ThemeLabel.colorLite, forKeyPath: "textColor")
        datePickerView.setValue(false, forKeyPath: "highlightsToday")
        cancelBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        cancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        confirmBtn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        confirmBtn.setTitle("common_text_btnConfirm".localized(), for: .normal)
        iphonexBottom.constant = isiPhoneX ? 34 : 0
    }
    
    func setDatePickerMode(mode:UIDatePickerMode) {
        datePickerView.datePickerMode = mode
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        EXAlert.dismiss()
        dateCancelCallback?()
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        EXAlert.dismiss()
        dateConfirmCallback?(datePickerView.date)
    }
    
}
