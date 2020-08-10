//
//  SLSwapScreeningView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 委托列表筛选条件
class SLSwapScreeningView: UIView {
    
    var screeningValueChanged: ((Int, Int, Int) -> Void)?
    
    var swapNameArray: [String] = [] {
        didSet {
            self.initialSwapName = self.swapNameArray.first ?? "-"
        }
    }
    var priceTypeArray: [String] = ["contract_normal_price".localized(), "contract_plan_order".localized()] {
        didSet {
            self.limitPriceButton.text(content: self.priceTypeArray.first ?? "-")
        }
    }
    var orderTypeArray: [String] = [] {
        didSet {
            self.orderTypeButton.text(content: self.orderTypeArray.first ?? "-")
        }
    }
    
    var initialSwapName: String? {
        didSet {
            self.nameButton.text(content: self.initialSwapName ?? "-")
        }
    }
    
    var isHiddenPriceType: Bool = false {
        didSet {
            self.limitPriceButton.isHidden = self.isHiddenPriceType
            self.verLineView2.isHidden = self.isHiddenPriceType
            self.nameButton.snp_remakeConstraints { (make) in
                let scale = self.isHiddenPriceType ? 0.5 : 1.0/3.0
                make.left.equalTo(0)
                make.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(scale)
                make.top.equalTo(self.horLineView.snp_bottom)
            }
        }
    }
    
    var isOnlyShowName: Bool = false {
        didSet {
            self.limitPriceButton.isHidden = true
            self.verLineView2.isHidden = true
            self.nameButton.setAlighment(margin: .marginLeft)
            self.nameButton.snp_remakeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(self.horLineView.snp_bottom)
            }
        }
    }
    
    
    var swapNameIndex: Int {
        get {
            var idx = 0
            for i in 0..<self.swapNameArray.count {
                if self.swapNameArray[i] == self.nameButton.titleLabel.text {
                    idx = i
                    break
                }
            }
            return idx
        }
    }
    var priceTypeIndex: Int {
        get {
            var idx = 0
            for i in 0..<self.priceTypeArray.count {
                if self.priceTypeArray[i] == self.limitPriceButton.titleLabel.text {
                    idx = i
                    break
                }
            }
            return idx
        }
    }
    var orderTypeIndex: Int {
        get {
            var idx = 0
            for i in 0..<self.orderTypeArray.count {
                if self.orderTypeArray[i] == self.orderTypeButton.titleLabel.text {
                    idx = i
                    break
                }
            }
            return idx
        }
    }
    
    lazy var horLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    lazy var nameButton: EXDirectionButton = {
        let button = EXDirectionButton()
        button.setAlighment(margin: .marginCenter)
        button.lableRightmargin = 6
        button.titleLabel.font = UIFont.ThemeFont.BodyRegular
        button.text(content: "-")
        button.addTarget(self, action: #selector(clickNameButton), for: .touchUpInside)
        return button
    }()
    
    lazy var verLineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    lazy var limitPriceButton: EXDirectionButton = {
        let button = EXDirectionButton()
        button.setAlighment(margin: .marginCenter)
        button.lableRightmargin = 6
        button.titleLabel.font = UIFont.ThemeFont.BodyRegular
        button.text(content: "contract_normal_price".localized())
        button.addTarget(self, action: #selector(clickLimitPriceButton), for: .touchUpInside)
        return button
    }()
    
    lazy var verLineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    lazy var orderTypeButton: EXDirectionButton = {
        let button = EXDirectionButton()
        button.setAlighment(margin: .marginCenter)
        button.lableRightmargin = 6
        button.titleLabel.font = UIFont.ThemeFont.BodyRegular
        button.text(content: "contract_transaction_all_types".localized())
        button.addTarget(self, action: #selector(clickSwapTypeButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        self.addSubViews([horLineView, nameButton, limitPriceButton, orderTypeButton, verLineView1, verLineView2])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.horLineView.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.nameButton.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0/3.0)
            make.top.equalTo(self.horLineView.snp_bottom)
        }
        self.verLineView1.snp_makeConstraints { (make) in
            make.left.equalTo(self.nameButton.snp_right)
            make.height.equalToSuperview()
            make.width.equalTo(0.6)
            make.top.equalTo(self.horLineView.snp_bottom)
        }
        self.limitPriceButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.verLineView1.snp_right)
            make.height.equalTo(self.nameButton)
            make.width.equalTo(self.nameButton)
            make.top.equalTo(self.nameButton)
        }
        self.verLineView2.snp_makeConstraints { (make) in
            make.left.equalTo(self.limitPriceButton.snp_right)
            make.height.equalTo(self.verLineView1)
            make.width.equalTo(self.verLineView1)
            make.top.equalTo(self.verLineView1)
        }
        self.orderTypeButton.snp_makeConstraints { (make) in
            make.height.equalTo(self.nameButton)
            make.width.equalTo(self.nameButton)
            make.right.equalToSuperview()
            make.top.equalTo(self.nameButton)
        }
    }
}


// MARK: - Click Events

extension SLSwapScreeningView {
    
    /// 点击合约名称
    @objc func clickNameButton() {
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else { return }
            mySelf.nameButton.text(content: mySelf.swapNameArray[idx])
            mySelf.nameButton.checked(check: false)
            mySelf.valueChanged()
        }
        sheet.actionCancelCallback = {[weak self]() in
            guard let mySelf = self else { return }
            mySelf.nameButton.checked(check: false)
        }
        sheet.configButtonTitles(buttons: self.swapNameArray, selectedIdx: self.swapNameIndex)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    /// 点击限价类型
    @objc func clickLimitPriceButton() {
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else { return }
            mySelf.limitPriceButton.text(content: mySelf.priceTypeArray[idx])
            mySelf.limitPriceButton.checked(check: false)
            mySelf.valueChanged()
        }
        sheet.actionCancelCallback = {[weak self]() in
            guard let mySelf = self else { return }
            mySelf.limitPriceButton.checked(check: false)
        }
        sheet.configButtonTitles(buttons: self.priceTypeArray, selectedIdx: self.priceTypeIndex)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    /// 点击交易方向
    @objc func clickSwapTypeButton() {
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else { return }
            mySelf.orderTypeButton.text(content: mySelf.orderTypeArray[idx])
            mySelf.orderTypeButton.checked(check: false)
            mySelf.valueChanged()
        }
        sheet.actionCancelCallback = {[weak self]() in
            guard let mySelf = self else { return }
            mySelf.orderTypeButton.checked(check: false)
        }
        sheet.configButtonTitles(buttons: self.orderTypeArray, selectedIdx: self.orderTypeIndex)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    private func valueChanged() {
        guard let screeningValueChanged = screeningValueChanged else {
            return
        }
        screeningValueChanged(self.swapNameIndex, self.priceTypeIndex, self.orderTypeIndex)
    }
}
