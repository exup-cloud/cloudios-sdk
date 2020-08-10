//
//  SLSwapMarketPriceFlatAlertView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/13.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLSwapMarketPriceFlatAlertView: UIView {
    
    var confirmCallback: (() -> ())?
    
    var isShowConfirmView = false {
        didSet {
            self.confirmView.isHidden = !self.isShowConfirmView
            if self.isShowConfirmView {
                self.confirmButton.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.confirmView.snp_bottom).offset(26)
                    make.right.equalTo(self.confirmView)
                    make.height.equalTo(20)
                    make.bottom.equalTo(-16)
                }
            } else {
                self.confirmButton.snp_remakeConstraints { (make) in
                    make.top.equalTo(self.messageLabel.snp_bottom).offset(26)
                    make.right.equalTo(self.confirmView)
                    make.height.equalTo(20)
                    make.bottom.equalTo(-16)
                }
            }
        }
    }

    private lazy var titleLabel: UILabel = UILabel(text: "contract_text_marketPriceFlat".localized(), font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    private lazy var tipsLabel: UILabel = UILabel(text: "", font: UIFont.ThemeFont.SecondaryBold, textColor: UIColor.red, alignment: .left)
    private lazy var messageLabel: UILabel = UILabel(text: nil, font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var confirmView: SLSwapAlertConfirmView = {
        let view = SLSwapAlertConfirmView()
        view.backgroundColor = UIColor.ThemeView.bgTab
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnCancel".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
    private lazy var confirmButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnConfirm".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeBtn.highlight)
        button.extSetAddTarget(self, #selector(clickConfirmButton))
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 1.5
        self.backgroundColor = UIColor.ThemeView.bg
        self.messageLabel.numberOfLines = 0
        self.addSubViews([titleLabel, tipsLabel,messageLabel, confirmView, cancelButton, confirmButton])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(18)
        }
        self.tipsLabel.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.right.equalTo(-20)
        }
        self.messageLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.right.equalTo(-20)
            make.top.equalTo(self.tipsLabel.snp_bottom).offset(10)
        }
        self.confirmView.snp_makeConstraints { (make) in
            make.top.equalTo(self.messageLabel.snp_bottom).offset(15)
            make.left.equalTo(self.messageLabel)
            make.right.equalTo(self.messageLabel)
            make.height.equalTo(36)
        }
        self.confirmButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.messageLabel.snp_bottom).offset(26)
            make.right.equalTo(self.confirmView)
            make.height.equalTo(20)
            make.bottom.equalTo(-16)
        }
        self.cancelButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.confirmButton)
            make.right.equalTo(self.confirmButton.snp_left).offset(-30)
        }
    }
    
    
    // MARK: - Update
    
    func config(title: String, message: String, cancelText: String = "common_text_btnCancel".localized(), confirmText: String = "common_text_btnConfirm".localized(),tipsText : String) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.cancelButton.setTitle(cancelText, for: .normal)
        self.confirmButton.setTitle(confirmText, for: .normal)
        if tipsText != "" {
            self.tipsLabel.text = tipsText
            self.tipsLabel.snp_remakeConstraints { (make) in
                make.left.equalTo(20)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                make.right.equalTo(-20)
                make.height.equalTo(30)
            }
        }
    }
    
    func updateVolume(_ volume: String, _ color: UIColor, _ type : String, _ name : String) {
        self.isShowConfirmView = true
        self.confirmView.volumeLabel.text = volume
        self.confirmView.typeLabel.textColor = color
        self.confirmView.typeLabel.text = type
        self.confirmView.nameLabel.text = name
    }
    
    
    // MARK: - Click Events
    
    @objc func clickCancelButton() {
        EXAlert.dismiss()
    }
    
    @objc func clickConfirmButton() {
        
        let strongSelf = self
        
        EXAlert.dismissEnd {
           strongSelf.confirmCallback?()
        }
        
    }
}


class SLSwapAlertConfirmView: UIView {
    lazy var typeLabel: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
    lazy var nameLabel: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    lazy var volumeLeftLabel: UILabel = UILabel(text: "contract_swap_market_price_flat_volume".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    lazy var volumeLabel: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
    lazy var volumeRightLabel: UILabel = UILabel(text: "contract_text_volumeUnit".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([typeLabel, nameLabel, volumeLeftLabel, volumeLabel, volumeRightLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.typeLabel.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        self.nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel.snp_right).offset(6)
            make.centerY.equalToSuperview()
        }
        self.volumeRightLabel.snp_makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        self.volumeLabel.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.volumeRightLabel.snp_left).offset(-4)
        }
        self.volumeLeftLabel.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.volumeLabel.snp_left).offset(-4)
        }
    }
}
