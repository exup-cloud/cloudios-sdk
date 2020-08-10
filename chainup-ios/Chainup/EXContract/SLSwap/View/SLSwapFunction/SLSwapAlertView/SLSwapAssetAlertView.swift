//
//  SLSwapAssetAlertView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapAssetAlertView: UIView {
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    
    lazy var mainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        self.addSubview(view)
        return view
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textAlignment = .left
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.numberOfLines = 0
        return label
    }()
    
    lazy var headBg : UIView = {
        let view = UIView()
        if EXThemeManager.isNight() {
            view.backgroundColor = UIColor.extColorWithHex("0F192A")
        } else {
            view.backgroundColor = UIColor.extColorWithHex("F0F7FF")
        }
        return view
    }()
    
    lazy var iconView : UIImageView = {
        let icon = UIImageView(image: UIImage.themeImageNamed(imageName: "reminders"))
        return icon
    }()
    
    lazy var confirm : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.textAlignment = .right
        btn.extSetAddTarget(self, #selector(clickBuyCoin))
        btn.setTitle("contract_fast_buy_coins".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        btn.titleLabel!.font = UIFont.ThemeFont.BodyBold
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    lazy var cancel : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.textAlignment = .right
        btn.extSetAddTarget(self, #selector(clickCancel))
        btn.setTitle("common_text_btnCancel".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
        btn.titleLabel!.font = UIFont.ThemeFont.BodyBold
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    @objc func clickBuyCoin(_ : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(1)
        }
        SLSwapAssetAlertView.dismiss(v: self)
    }
    
    @objc func clickCancel(_ : UIButton){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.alertCallback?(0)
        }
        SLSwapAssetAlertView.dismiss(v: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.backgroundColor = UIColor.ThemeView.mask
        mainView.frame = frame
        mainView.center = self.center
        mainView.layer.cornerRadius = 3
        mainView.layer.masksToBounds = true
        mainView.addSubViews([contentLabel,headBg,iconView,confirm,cancel])
        headBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(175)
        }
        iconView.snp.makeConstraints { (make) in
            make.height.equalTo(139)
            make.width.equalTo(144)
            make.centerX.equalTo(mainView.width * 0.5)
            make.top.equalToSuperview().offset(20)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headBg.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        confirm.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(26)
        }
        cancel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.right.equalTo(confirm.snp.left).offset(-30)
            make.top.equalTo(contentLabel.snp.bottom).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- interface
    static func createAlert(contentStr: String, btnTitle: String, imageStr: String, frame:CGRect) -> SLSwapAssetAlertView {
        let alert = SLSwapAssetAlertView(frame: frame)
        alert.contentLabel.text = contentStr
        alert.confirm.setTitle(btnTitle, for: .normal)
        alert.iconView.image = UIImage.themeImageNamed(imageName: imageStr)
        return alert
    }
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    static func dismiss(v: UIView) {
        for view in UIApplication.shared.keyWindow!.subviews {
            if view is SLSwapAssetAlertView {
                v.removeFromSuperview()
                break
            }
        }
    }
}
