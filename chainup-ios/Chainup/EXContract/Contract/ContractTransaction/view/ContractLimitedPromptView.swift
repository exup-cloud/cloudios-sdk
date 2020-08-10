//
//  ContractLimitedPromptView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//  限价提示

import UIKit

class ContractLimitedPromptView: UIView {
    
    var param : [String : String] = [:]
    
    typealias ClickConfirmBlock = ([String : String]) -> ()
    var clickConfirmBlock : ClickConfirmBlock?
    
    let btcPrecision = ContractPublicInfoManager.manager.getBtcPrecision()
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        view.extSetCornerRadius(1.5)
        return view
    }()
    
    //买入 卖出
    lazy var promptTitleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
        return label
    }()
    
    //合约名字
    lazy var contractView : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //可用余额
    lazy var availableBalance : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //标记价格
    lazy var tagPriceView : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //价值
    lazy var valueView : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //成本
    lazy var costView : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        return view
    }()
    
    //杠杆
    lazy var leverageView : ContractLimitedPromptDetailView = {
        let view = ContractLimitedPromptDetailView()
        view.extUseAutoLayout()
        view.setLeft("contract_text_lever".localized())
        return view
    }()
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        btn.layoutIfNeeded()
        btn.setTitle("common_text_btnCancel".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    //确认按钮
    lazy var confirmBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickConfirmBtn))
        btn.layoutIfNeeded()
        btn.setTitle("common_text_btnConfirm".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.extColorWithHex("000000", alpha: 0.4)
        self.addSubview(backView)
        backView.addSubViews([promptTitleLabel,contractView,availableBalance,tagPriceView,valueView,costView,leverageView,cancelBtn,confirmBtn])
        backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.bottom).offset(18)
        }
        promptTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        contractView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(promptTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        availableBalance.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(contractView.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
        }
        tagPriceView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(availableBalance.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
        }
        valueView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(tagPriceView.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
        }
        costView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(valueView.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
        }
        leverageView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.top.equalTo(costView.snp.bottom).offset(9)
            make.left.right.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(leverageView.snp.bottom).offset(30)
            make.right.equalTo(confirmBtn.snp.left).offset(-30)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(leverageView.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    //设置视图
    func setView(_ entity : ContractContentModel , param : [String : String]){
        self.param = param
        
        contractView.setLeft(entity.getContractName())
        
        if let orderType = param["orderType"] , orderType == "1"{
            //买入限价单
            if let side = param["side"] , side == "BUY"{
                promptTitleLabel.text = "contract_text_limitPriceBuy".localized()
            }else{//卖出限价单
                promptTitleLabel.text = "contract_text_limitPriceSell".localized()
            }
            if let price = param["price"]{
                let att = NSMutableAttributedString().add(string:price , attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeState.warning , NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold]).add(string: " \(entity.quoteSymbol)", attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite,NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold])
                contractView.rightLabel.attributedText = att
            }
        }else{
            //买入市价单
            if let side = param["side"] , side == "BUY"{
                promptTitleLabel.text = "contract_text_marketPriceBuy".localized()
            }else{//卖出市价单
                promptTitleLabel.text = "contract_text_marketPriceSell".localized()
            }
            contractView.rightLabel.text = "contract_action_marketPrice".localized()
        }
        
        availableBalance.setLeft("withdraw_text_available".localized() + " BTC")
        if let canUseBalance = param["canUseBalance"]{
            availableBalance.setRight((canUseBalance as NSString).decimalString1(btcPrecision))
        }
        
        tagPriceView.setLeft("contract_text_markPrice".localized() + " (\(entity.quoteSymbol))")
        if let tagPrice = param["tagPrice"]{
            tagPriceView.setRight((tagPrice as NSString).decimalString1(Int(entity.pricePrecision) ?? 8))
        }
        
        valueView.setLeft("contract_text_value".localized() + " BTC")
        if let orderPriceValue = param["orderPriceValue"]{
            valueView.setRight((orderPriceValue as NSString).decimalString1(btcPrecision))
        }
        
        costView.setLeft("contract_text_cost".localized() + " BTC")
        if let cost = param["cost"]{
            costView.setRight((cost as NSString).decimalString1(btcPrecision))
        }
        
        if let level = param["level"] {
            leverageView.setRight(level + "X")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractLimitedPromptView{
    
    //点击取消按钮
    @objc func clickCancelBtn(){
        self.removeFromSuperview()
    }
    
    //点击确认按钮
    @objc func clickConfirmBtn(){
        self.removeFromSuperview()
        self.clickConfirmBlock?(self.param)
    }
    
}

class ContractLimitedPromptDetailView : UIView{
    lazy var leftLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        label.layoutIfNeeded()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([leftLabel,rightLabel])
//        let width = (SCREEN_WIDTH - 80) / 2
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(14)
            make.right.equalTo(rightLabel.snp.left).offset(-10)
//            make.width.equalTo(width)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(16)
//            make.width.equalTo(width)
            make.centerY.equalToSuperview()
        }
    }
    
    func setLeft(_ left : String){
        leftLabel.text = left
    }
    
    func setRight(_ right : String){
        rightLabel.text = right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
