//
//  SLSwapDetailView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/31.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 两个左右分布的 label
class SLSwapHorDetailView : UIView {
    typealias ClickMiddleBtnBlock = () -> ()
       var clickMiddleBtnBlock : ClickMiddleBtnBlock?
    
    var isShowTipButton: Bool = false {
        didSet {
            self.tipButton.isHidden = !isShowTipButton
        }
    }
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        button.isHidden = true
        self.addSubview(button)
        button.extSetAddTarget(self, #selector(clickTipButton))
        return button
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([leftLabel, rightLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.lessThanOrEqualTo(self.snp.centerX)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.lessThanOrEqualTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        self.tipButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right).offset(5)
            make.height.width.equalTo(15)
            make.centerY.equalTo(self.leftLabel.snp.centerY)
        }
    }
    
    
    func setLeftText(_ text: String) {
        self.leftLabel.text = text
    }
    
    func setRightText(_ text: String) {
        self.rightLabel.text = text
    }
    
    @objc func clickTipButton(_ btn : UIButton) {
        clickMiddleBtnBlock?()
    }
}

/// 两个上下分布的 label
class SLSwapVerDetailView : UIView {
    typealias ClickMiddleBtnBlock = () -> ()
       var clickMiddleBtnBlock : ClickMiddleBtnBlock?
    
    var isShowTipButton: Bool = false {
        didSet {
            self.tipButton.isHidden = !isShowTipButton
            if isShowTipButton {
                self.topLabel.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.height.equalTo(12)
                    make.top.equalToSuperview()
                }
                self.tipButton.snp.remakeConstraints { (make) in
                    make.left.equalTo(self.topLabel.snp.right).offset(5)
                    make.height.width.equalTo(15)
                    make.centerY.equalTo(self.topLabel.snp.centerY)
                }
            }
        }
    }
    
    var contentAlignment: NSTextAlignment = .left {
        didSet {
            self.topLabel.textAlignment = contentAlignment
            self.bottomLabel.textAlignment = contentAlignment
        }
    }
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        button.isHidden = true
        self.addSubview(button)
        button.extSetAddTarget(self, #selector(clickTipButton))
        return button
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([topLabel, bottomLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.topLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
            make.top.equalToSuperview()
        }
        self.bottomLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setTopText(_ text: String) {
        self.topLabel.text = text
    }
    
    func setBottomText(_ text: String) {
        self.bottomLabel.text = text
    }
    
    @objc func clickTipButton(_ btn : UIButton) {
        clickMiddleBtnBlock?()
    }
}
