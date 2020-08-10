//
//  EXNormalAlert.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit



class EXNormalAlert: NibBaseView {

    @IBOutlet var titleView: UIView!
    @IBOutlet var messageView: UIView!
    @IBOutlet var btnView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var passiveBtn: EXButton!
    @IBOutlet var positiveBtn: EXButton!
    @IBOutlet var btnHeight: NSLayoutConstraint!
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.allCorners], radius: 2)
    }
    
    override func onCreate() {
        titleLabel.headBold()
        titleLabel.textColor = UIColor.ThemeLabel.colorLite
        msgLabel.textColor = UIColor.ThemeLabel.colorLite
        passiveBtn.clearColors()
        positiveBtn.clearColors()
        
        passiveBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        positiveBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
    }
    
    func configSigleAlert(title:String?,
                          message:String,
                          sigleBtnTitle:String = "alert_common_iknow".localized())
    {
        passiveBtn.isHidden = true
        if let altTitle = title,!altTitle.isEmpty {
            btnHeight.constant = 36
            titleLabel.text = altTitle
        }else {
            btnHeight.constant = 0
        }
        msgLabel.text = message
        positiveBtn.setTitle(sigleBtnTitle, for: .normal)
    }

    func configAlert(title:String?,
                     message:String,
                     passiveBtnTitle:String = "common_text_btnCancel".localized(),
                     positiveBtnTitle:String="common_text_btnConfirm".localized())
    {
        if let altTitle = title,!altTitle.isEmpty {
            btnHeight.constant = 36
            titleLabel.text = altTitle
        }else {
            btnHeight.constant = 0
        }
        if message.isEmpty {
            messageView.isHidden = true
        }
        msgLabel.text = message
        passiveBtn.setTitle(passiveBtnTitle, for: .normal)
        positiveBtn.setTitle(positiveBtnTitle, for: .normal)
    }

    func configAttributeAlert(title:String?,
                     message:NSAttributedString,
                     passiveBtnTitle:String = "common_text_btnCancel".localized(),
                     positiveBtnTitle:String="common_text_btnConfirm".localized())
    {
        if let altTitle = title,!altTitle.isEmpty {
            btnHeight.constant = 36
            titleLabel.text = altTitle
        }else {
            btnHeight.constant = 0
        }
        if message.string.isEmpty {
            messageView.isHidden = true
        }
        msgLabel.attributedText = message
        passiveBtn.setTitle(passiveBtnTitle, for: .normal)
        positiveBtn.setTitle(positiveBtnTitle, for: .normal)
    }
    
    @IBAction func positveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        EXAlert.dismiss()
    }
    
    @IBAction func passtiveAction(_ sender: EXButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(1)
        }
        EXAlert.dismiss()
    }
    
}
