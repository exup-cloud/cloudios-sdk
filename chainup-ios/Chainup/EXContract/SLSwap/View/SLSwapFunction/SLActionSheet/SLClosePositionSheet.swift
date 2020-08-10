//
//  SLClosePositionSheet.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 平仓
class SLClosePositionSheet: UIView {
    
    /// 市价全平回调
    var marketPriceClosePositionCallback: ((String, String) -> ())?
    /// 平仓回调
    var closePositionCallback: ((String, String) -> ())?
    
    var positionM : BTPositionModel? {
        didSet {
            if positionM != nil {
                self.positionInput.input.text = positionM!.cur_qty//.bigSub(positionM!.freeze_qty)
                infoVaild.decail = positionM?.contractInfo.px_unit ?? "0.01"
            }
        }
    }
    
    let infoVaild :SLInputLimitDelegate = SLInputLimitDelegate()
    /// 标题
    let titleLabel: UILabel = {
        let label = UILabel(text: "contract_action_closeContract".localized(), font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return label
    }()
    /// 取消
    lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnCancel".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
    /// 价格
    lazy var priceInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText("-")
        input.titleLabel.bodyRegular()
        input.setTitle(title: "contract_text_price".localized())
        input.setPlaceHolder(placeHolder: "contract_text_price".localized())
        return input
    }()
    /// 仓位
    lazy var positionInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText("-")
        input.titleLabel.bodyRegular()
        input.setTitle(title: "contract_text_position".localized())
        input.setPlaceHolder(placeHolder: "contract_text_position".localized())
        input.setExtraText("contract_text_volumeUnit".localized())
        input.input.rx.text.orEmpty.asObservable().subscribe {[weak self] (event) in
            if let str = event.element{
                if str.greaterThan(self?.positionM?.cur_qty){
                    input.input.text = self?.positionM?.cur_qty
                    EXAlert.showFail(msg: "contract_tips_moreThan_close".localized())
                }
            }
        }.disposed(by: self.disposeBag)
        // 只能输入整数
        input.input.keyboardType = .numberPad
        return input
    }()
    
    /// 杠杆调整条
    lazy var levelSlider: SLSwapChangeLevelSlider = {
        let slider = SLSwapChangeLevelSlider()
        slider.updateSliderValue(value:100)
        return slider
    }()
    
    /// 市价全平
    lazy var marketPriceButton: UIButton = {
        let button = UIButton()
        button.setTitle("contract_text_marketPriceFlat".localized(), for: .normal)
        button.titleLabel?.font = UIFont.ThemeFont.HeadBold
        button.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ThemeLabel.colorHighlight.cgColor
        button.addTarget(self, action: #selector(clickMarketPriceButton), for: .touchUpInside)
        return button
    }()
    /// 平仓
    lazy var closePositionButton: EXButton = {
        let button = EXButton()
        button.setTitle("contract_action_closeContract".localized(), for: .normal)
        button.titleLabel?.font = UIFont.ThemeFont.HeadBold
        button.addTarget(self, action: #selector(clickClosePositionButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.ThemeView.bg
        
        self.addSubViews([titleLabel, cancelButton, priceInput, positionInput, levelSlider, marketPriceButton, closePositionButton])
        
        roundCorners(corners: [.topLeft, .topRight], radius: 10)
        priceInput.input.delegate = infoVaild
        self.initLayout()
        
        self.levelSlider.valueChangedCallback = {[weak self] value in
            guard let position = self?.positionM  else {
                return
            }
            self?.positionInput.input.text = String(format: "%d", value).bigDiv("100").bigMul(position.cur_qty).toString(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        let horMargin = 15
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(horMargin)
            make.height.equalTo(28)
        }
        self.cancelButton.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.top.height.equalTo(self.titleLabel)
        }
        self.priceInput.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.right.equalTo(-horMargin)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(28)
        }
        self.positionInput.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.right.equalTo(-horMargin)
            make.top.equalTo(self.priceInput.snp_bottom).offset(28)
        }
        self.levelSlider.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.priceInput)
            make.top.equalTo(self.positionInput.snp_bottom).offset(20)
            make.height.equalTo(40)
        }
        
        self.marketPriceButton.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(self.levelSlider.snp_bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(-30)
        }
        self.closePositionButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.marketPriceButton.snp_right).offset(10)
            make.top.height.width.equalTo(self.marketPriceButton)
            make.right.equalTo(-horMargin)
        }
    }
}


extension SLClosePositionSheet {
    /// 点击取消
    @objc func clickCancelButton() {
        EXAlert.dismiss()
    }
    /// 点击市价全平
    @objc func clickMarketPriceButton() {
        self.marketPriceClosePositionCallback?(self.priceInput.input.text ?? "0", self.positionInput.input.text ?? "0")

    }
    /// 点击平仓
    @objc func clickClosePositionButton() {
        self.closePositionCallback?(self.priceInput.input.text ?? "0", self.positionInput.input.text ?? "0")
    }
}
