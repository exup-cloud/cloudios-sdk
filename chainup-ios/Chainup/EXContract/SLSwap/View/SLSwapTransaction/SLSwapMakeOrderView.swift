//
//  SLSwapMakeOrderView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

enum SLSwapMarketOrderViewShowType {
    case normalOrder
    case highOrder
    case planOrder
}

enum SLSwapMarketOrderPriceType {
    case limitPrice
    case marketPrice
    case buyOnePrice
    case sellOnePrice
}

enum SLSwapPlanOrderPriceType {
    case limitPlan
    case marketPlan
}

enum SLSwapHighOrderType {
    case postOnly
    case fillOrKill
    case immediateOrCance
}

class SLSwapMakeOrderView: UIView {
    // 点击深度价格
    typealias ClickBuyOrSellBlock = (BTContractOrderModel) -> ()
    var clickTradeBlock : ClickBuyOrSellBlock?
    
    typealias ChangeLayoutBlock = (CGFloat) -> ()
    var changeLayoutBlock : ChangeLayoutBlock?
    
    /// 开仓平仓
    var transactionShowType : SLSwapTransationViewShowType? {
        didSet {
            reloadTransationTypeView()
            reloadMakeOrderData()
        }
    }
    let inputVaild:SLInputLimitDelegate = SLInputLimitDelegate()
    
    var makeOrderViewModel : SLSwapMarkOrderViewModel? {
        didSet {
            if makeOrderViewModel?.itemModel != nil {
                reloadUnitData()
                isHiddenEqualLabel()
                self.priceTextField.input.text = makeOrderViewModel!.itemModel?.last_px ?? ""
                self.inputVaild.decail = makeOrderViewModel!.itemModel?.contractInfo.px_unit ?? "0.01"
                textFieldValueHasChanged(textField:self.priceTextField.input)
                makeOrderViewModel!.makerOrderAssetChangeBlock = {[weak self] in
                    self?.reloadMakeOrderData()
                }
                makeOrderViewModel!.makerOrderUnitChangeBlock = {[weak self] in
                    self?.reloadUnitData()
                }
                
            }
        }
    }
    /// 委托类型 (限价委托，市价委托，计划委托)
    var defineOrderType : SLSwapMarketOrderViewShowType = .normalOrder
    /// 普通合约价格类型
    var normalPriceType : SLSwapMarketOrderPriceType = .limitPrice
    /// 执行价格类型
    var performPriceType : SLSwapPlanOrderPriceType = .limitPlan
    /// 高级委托类型
    var highOrderType : SLSwapHighOrderType = .postOnly
    /// 委托类型 数组
    var priceArr = ["contract_normal_price".localized() , "contract_highlimit_order".localized(), "contract_plan_order".localized()]
    /// 高级委托类型字段
    var highOrderArr = ["contract_high_postonly".localized() , "contract_high_fok".localized(), "contract_high_ioc".localized()]
    
    
    /// 委托类型按钮
    lazy var orderTypeBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.addTarget(self, action: #selector(clickOrderTypeBtn), for: UIControlEvents.touchUpInside)
//        btn.text(content: priceArr[0])
        btn.titleLabel.font = UIFont.ThemeFont.BodyRegular
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        btn.titleLabel.text = "contract_normal_price".localized()
        btn.layer.borderColor = UIColor.ThemeView.seperator.cgColor
        btn.layer.borderWidth = 0.5
        btn.setAlighment(margin: .marginCenter)
        return btn
    }()
    /// 高级委托类型
    lazy var highTypeBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.addTarget(self, action: #selector(clickHighTypeBtn), for: UIControlEvents.touchUpInside)
        btn.titleLabel.font = UIFont.ThemeFont.BodyRegular
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        btn.titleLabel.text = "contract_postonly".localized()
        btn.layer.borderColor = UIColor.ThemeView.seperator.cgColor
        btn.layer.borderWidth = 0.5
        btn.setAlighment(margin: .marginCenter)
        btn.isHidden = true
        return btn
    }()
    
    lazy var planTipsBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickPlanTipsBtn))
        btn.isHidden = true
        return btn
    }()
    /// 杠杆
    lazy var leverageView : LeverageView = {
        let view = LeverageView()
        view.leverageBtn.triangleView.isHidden = true
        view.extUseAutoLayout()
        view.setView("10")
        view.clickLeverageBlock = {[weak self] in
            guard let mySelf = self else{return}
            mySelf.popupLeverage()
        }
        view.leverageBtn.titleLabel.snp.remakeConstraints { (make ) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(16)
        }
        return view
    }()
    /// 价格
    lazy var priceTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.setPlaceHolder(placeHolder: "contract_text_price".localized())
        textField.unitLabel.text = ""
        textField.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: textField.input)
        }
        textField.maxLenth = 9
        textField.input.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    /// 触发价格
    lazy var triggerTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.unitLabel.text = ""
        textField.maxLenth = 9
        textField.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: textField.input)
        }

        textField.input.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    func changeTriggerPricePlaceHolder() {
        let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
        if idx == 0 {
            // 触发价格（最新价）
            triggerTextField.setPlaceHolder(placeHolder: "contract_trigger_placeHolder".localized()+"("+"contract_tiggertype_latest".localized()+")")
        } else if idx == 1 {
            // 触发价格（合理价）
            triggerTextField.setPlaceHolder(placeHolder: "contract_trigger_placeHolder".localized()+"("+"contract_tiggertype_fair".localized()+")")
        } else {
            // 触发价格（合理价）
            triggerTextField.setPlaceHolder(placeHolder: "contract_trigger_placeHolder".localized()+"("+"contract_tiggertype_index".localized()+")")
        }
    }
    /// 执行价格
    lazy var performTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.setPlaceHolder(placeHolder: "contract_excutive_placeHolder".localized())
        textField.unitLabel.isHidden = true
        textField.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: textField.input)
        }
        textField.maxLenth = 9
        textField.input.keyboardType = UIKeyboardType.decimalPad
        textField.input.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
        }
        return textField
    }()
    /// 执行市价
    lazy var marketPerformBtn : UIButton = {
        let btn = UIButton(buttonType: .custom, title: "contract_action_marketPrice".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorLite)
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickPlanMarketBtn))
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
        btn.extsetBackgroundColor(backgroundColor: UIColor.ThemeNav.bg, state: .normal)
        return btn
    }()
    /// 计划市价
    lazy var marketLabel : UILabel = {
        let label = UILabel(text: "  " + "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        label.backgroundColor = UIColor.ThemeNav.bg
        label.isHidden = true
        return label
    }()
    /// 价格转换
    lazy var equalLabel : UILabel = {
        let label = UILabel.init()
           label.extUseAutoLayout()
           label.textColor = UIColor.ThemeLabel.colorMedium
           label.font = UIFont.ThemeFont.SecondaryRegular
           label.text = "≈ ￥--"
           return label
    }()
    /// 最新价， 合理价， 指数家
    lazy var lastPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_latest".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isHidden = true
        return btn
    }()
    lazy var fairPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_fair".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isHidden = true
        return btn
    }()
    lazy var indexPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_index".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isHidden = true
        return btn
    }()
    /// 市价按钮 ，买一价按钮，卖一价按钮
    lazy var marketBtn : UIButton = {
        let btn = self.createTypeBtn("contract_text_typeMarket".localized(),#selector(clickDefinePriceBtn))
        btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .disabled)
        return btn
    }()
    lazy var buyOneBtn : UIButton = {
        let btn = self.createTypeBtn("contract_buyOne_price".localized(),#selector(clickDefinePriceBtn))
        return btn
    }()
    lazy var sellOneBtn : UIButton = {
        let btn = self.createTypeBtn("contract_sellOne_price".localized(),#selector(clickDefinePriceBtn))
        return btn
    }()
    private func createTypeBtn(_ title: String ,_ selector : Selector) -> UIButton {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, selector)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: UIControlState.selected)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.ThemeView.border.cgColor
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        return btn
    }
    /// 合约张数
    lazy var volumeTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.setPlaceHolder(placeHolder: "charge_text_volume".localized())
        textField.unitLabel.text = "contract_text_volumeUnit".localized()
        textField.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: textField.input)
        }
        textField.input.rx.text.orEmpty.changed.asObservable().subscribe { (event) in
            if let str = event.element{
                if str.count > 15{
                    textField.input.text = str[0...15]
                }
            }
            }.disposed(by: self.disposeBag)
        textField.input.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    /// 合约价值
    lazy var entrustLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "≈ ￥--"
        return label
    }()
    /// 可开多
    lazy var canOpenMoreLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_canopen_more".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        return label
    }()
    /// 可开空
    lazy var canOpenShortLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_canopen_empty".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        return label
    }()
    /// 市价提示框
    lazy var marketPriceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.backgroundColor = UIColor.ThemeNav.bg
        label.text = "   " + "contract_action_marketPrice".localized()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.extSetCornerRadius(1.5)
        label.font = UIFont.ThemeFont.BodyRegular
        label.extSetBorderWidth(0.5, color: UIColor.ThemeView.seperator)
        label.isHidden = true
        label.textAlignment = .left
        return label
    }()
    /// 开多按钮
    lazy var buyBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickBuyOrSellBtn))
        btn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.color = UIColor.ThemekLine.up
        return btn
    }()
    /// 开空按钮
    lazy var sellBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickBuyOrSellBtn))
        btn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.color = UIColor.ThemekLine.down
        return btn
    }()
    /// 可用余额
    lazy var availableLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "assets_text_available".localized() + "--"
        return label
    }()
    /// 可平多
    lazy var canCloseMoreLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_canclose_more".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        return label
    }()
    /// 可平空
    lazy var canCloseShortLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_canclose_empty".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        return label
    }()
    /// 持多仓
    lazy var holdLongLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_hold_position".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        label.textAlignment = .right
        return label
    }()
    /// 持空仓
    lazy var holdShortLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = String(format:"contract_makeorder_hold_position".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
        label.textAlignment = .right
        return label
    }()
    
    //预估成本
    lazy var canMoreCostLabel:UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_mybeCost".localized() + " --"
        return label
        
    }()
    lazy var canShortCostLabel:UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_mybeCost".localized() + " --"
        return label
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        transactionShowType = .showOpen
        self.backgroundColor = UIColor.ThemeView.bg
        self.addSubViews([
            orderTypeBtn,planTipsBtn,leverageView,triggerTextField,priceTextField,performTextField,equalLabel,marketBtn,buyOneBtn,sellOneBtn,volumeTextField,entrustLabel,marketPriceLabel,availableLabel,canOpenMoreLabel,buyBtn,canOpenShortLabel,sellBtn,holdLongLabel,holdShortLabel,canCloseMoreLabel,canCloseShortLabel,highTypeBtn,marketPerformBtn,lastPriceBtn,fairPriceBtn,indexPriceBtn,marketLabel,canMoreCostLabel,canShortCostLabel])
        setUpUI()
        self.priceTextField.input.delegate = self.inputVaild
        self.triggerTextField.input.delegate = self.inputVaild
        self.performTextField.input.delegate = self.inputVaild
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setupUI
extension SLSwapMakeOrderView {
    func setUpUI() {
        orderTypeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
//            make.width.lessThanOrEqualTo(proportion_width - 15)
            make.width.equalTo(90)
        }
        highTypeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(90)
        }
        planTipsBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(orderTypeBtn.snp.right).offset(5)
            make.centerY.equalTo(orderTypeBtn.snp.centerY)
            make.width.equalTo(20)
        }
        leverageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(36)
            make.top.equalTo(orderTypeBtn.snp.bottom).offset(12)
        }
        priceTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(leverageView.snp.bottom).offset(12)
        }
        marketPriceLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(priceTextField)
        }
        equalLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(12)
            make.top.equalTo(priceTextField.snp.bottom).offset(4)
        }
        marketBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo((proportion_width - 40)/3.0)
            make.height.equalTo(22)
            make.top.equalTo(equalLabel.snp.bottom).offset(15)
        }
        buyOneBtn.snp.makeConstraints { (make) in
            make.left.equalTo(marketBtn.snp.right).offset(5)
            make.width.equalTo(marketBtn.snp.width)
            make.height.equalTo(22)
            make.top.equalTo(marketBtn.snp.top)
        }
        sellOneBtn.snp.makeConstraints { (make) in
            make.left.equalTo(buyOneBtn.snp.right).offset(5)
            make.width.equalTo(marketBtn.snp.width)
            make.height.equalTo(22)
            make.top.equalTo(marketBtn.snp.top)
        }
        volumeTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(priceTextField)
            make.height.equalTo(36)
            make.top.equalTo(marketBtn.snp.bottom).offset(12)
        }
        entrustLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(12)
            make.top.equalTo(volumeTextField.snp.bottom).offset(4)
        }
        canOpenMoreLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(entrustLabel.snp.bottom).offset(10)
        }
        canMoreCostLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(canOpenMoreLabel)
            make.top.equalTo(canOpenMoreLabel.snp.bottom).offset(5)
        }
        canCloseShortLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(entrustLabel.snp.bottom).offset(10)
            make.width.lessThanOrEqualTo((proportion_width - 15) * 0.5)
        }
        holdShortLabel.snp.makeConstraints { (make) in
            make.left.equalTo(canCloseMoreLabel.snp.right)
            make.right.equalTo(leverageView.snp.right)
            make.height.equalTo(17)
            make.top.equalTo(entrustLabel.snp.bottom).offset(10)
        }
        buyBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(canMoreCostLabel.snp.bottom).offset(3)
        }
        canOpenShortLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(buyBtn.snp.bottom).offset(10)
        }
        canShortCostLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(canOpenShortLabel)
            make.top.equalTo(canOpenShortLabel.snp.bottom).offset(5)
        }
        canCloseMoreLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leverageView)
            make.width.lessThanOrEqualTo((proportion_width - 15) * 0.5)
            make.height.equalTo(17)
            make.top.equalTo(buyBtn.snp.bottom).offset(10)
        }
        holdLongLabel.snp.makeConstraints { (make) in
            make.left.equalTo(canCloseMoreLabel.snp.right)
            make.right.equalTo(leverageView.snp.right)
            make.height.equalTo(17)
            make.top.equalTo(buyBtn.snp.bottom).offset(10)
        }
        sellBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(canShortCostLabel.snp.bottom).offset(3)
        }
        triggerTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(leverageView.snp.bottom).offset(10)
        }
        lastPriceBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo((proportion_width - 40)/3.0)
            make.height.equalTo(22)
            make.top.equalTo(triggerTextField.snp.bottom).offset(5)
        }
        fairPriceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lastPriceBtn.snp.right).offset(5)
            make.width.height.top.equalTo(lastPriceBtn)
        }
        indexPriceBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(fairPriceBtn.snp.right).offset(5)
            make.width.height.top.equalTo(fairPriceBtn)
        }
        performTextField.snp.makeConstraints { (make) in
            make.left.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(lastPriceBtn.snp.bottom).offset(10)
        }
        marketLabel.snp.remakeConstraints { (make) in
            make.edges.equalTo(performTextField)
        }
        marketPerformBtn.snp.makeConstraints { (make) in
            make.left.equalTo(performTextField.snp.right).offset(5)
            make.right.equalTo(leverageView)
            make.width.equalTo(58)
            make.top.height.equalTo(performTextField)
        }
        
        availableLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(sellBtn.snp.bottom).offset(8)
            make.bottom.equalTo(self).offset(-10)
        }
        triggerTextField.isHidden = true
        performTextField.isHidden = true
        marketPerformBtn.isHidden = true
        let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
        if idx == 0 {
            clickTiggerPriceTypeBtn(lastPriceBtn)
        } else if idx == 1 {
            clickTiggerPriceTypeBtn(fairPriceBtn)
        } else {
            clickTiggerPriceTypeBtn(indexPriceBtn)
        }
        reloadTransationTypeView()
    }
    
    func reloadMarketOrderView() { // 委托类型加载界面
        if defineOrderType == .normalOrder { // 普通委托
            triggerTextField.isHidden = true
            performTextField.isHidden = true
            marketPerformBtn.isHidden = true
            priceTextField.isHidden = false
            marketBtn.isHidden = false
            buyOneBtn.isHidden = false
            sellOneBtn.isHidden = false
            highTypeBtn.isHidden = false
            marketBtn.isEnabled = true
            highTypeBtn.isHidden = true
            equalLabel.isHidden = false
            lastPriceBtn.isHidden = true
            fairPriceBtn.isHidden = true
            indexPriceBtn.isHidden = true
            marketLabel.isHidden = true
            planTipsBtn.isHidden = true
            if !marketBtn.isSelected && !buyOneBtn.isSelected && !sellOneBtn.isSelected {
                marketPriceLabel.isHidden = true
            } else {
                marketPriceLabel.isHidden = false
            }
            volumeTextField.snp.remakeConstraints { (make) in
                make.left.right.equalTo(priceTextField)
                make.height.equalTo(36)
                make.top.equalTo(marketBtn.snp.bottom).offset(12)
            }
        } else if defineOrderType == .highOrder {
            triggerTextField.isHidden = true
            performTextField.isHidden = true
            marketPerformBtn.isHidden = true
            priceTextField.isHidden = false
            marketBtn.isHidden = false
            buyOneBtn.isHidden = false
            sellOneBtn.isHidden = false
            highTypeBtn.isHidden = false
            marketBtn.isEnabled = false
            equalLabel.isHidden = false
            lastPriceBtn.isHidden = true
            fairPriceBtn.isHidden = true
            indexPriceBtn.isHidden = true
            marketLabel.isHidden = true
            planTipsBtn.isHidden = true
            if !marketBtn.isSelected && !buyOneBtn.isSelected && !sellOneBtn.isSelected {
                marketPriceLabel.isHidden = true
            } else {
                marketPriceLabel.isHidden = false
            }
            volumeTextField.snp.remakeConstraints { (make) in
                make.left.right.equalTo(priceTextField)
                make.height.equalTo(36)
                make.top.equalTo(marketBtn.snp.bottom).offset(12)
            }
        } else if defineOrderType == .planOrder { // 计划委托
            planTipsBtn.isHidden = false
            triggerTextField.isHidden = false
            performTextField.isHidden = false
            marketPerformBtn.isHidden = false
            marketPriceLabel.isHidden = true
            priceTextField.isHidden = true
            marketBtn.isHidden = true
            buyOneBtn.isHidden = true
            sellOneBtn.isHidden = true
            highTypeBtn.isHidden = true
            equalLabel.isHidden = true
            lastPriceBtn.isHidden = false
            fairPriceBtn.isHidden = false
            indexPriceBtn.isHidden = false
            if marketPerformBtn.isSelected {
                marketLabel.isHidden = false
            }
            volumeTextField.snp.remakeConstraints { (make) in
                make.left.right.equalTo(leverageView)
                make.height.equalTo(36)
                make.top.equalTo(performTextField.snp.bottom).offset(10)
            }
        }
    }
    
    func reloadTransationTypeView() { // 开平仓加载界面
        if transactionShowType == .showOpen { // 开仓
            if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil { // 未登录状态
                canOpenMoreLabel.text = String(format:"contract_makeorder_canopen_more".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
                canOpenShortLabel.text = String(format:"contract_makeorder_canopen_empty".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
            } else { // 登录状态
                canOpenMoreLabel.text = String(format:"contract_makeorder_canopen_more".localized(),(makeOrderViewModel?.canOpenMore ?? "0"), makeOrderViewModel?.volumeUnit ?? "-")
                canOpenShortLabel.text = String(format:"contract_makeorder_canopen_empty".localized(),(makeOrderViewModel?.canOpenShort ?? "0"),makeOrderViewModel?.volumeUnit ?? "-")
            }
            leverageView.setEnableEditing(true)
            holdLongLabel.isHidden = true
            holdShortLabel.isHidden = true
            canOpenMoreLabel.isHidden = false
            canOpenShortLabel.isHidden = false
            canCloseMoreLabel.isHidden = true
            canCloseShortLabel.isHidden = true
            
            canMoreCostLabel.isHidden = false
            canShortCostLabel.isHidden = false
            buyBtn.snp.remakeConstraints({ (make) in
                make.left.right.equalTo(leverageView)
                make.height.equalTo(36)
                make.top.equalTo(canMoreCostLabel.snp.bottom).offset(3)
            })
            sellBtn.snp.remakeConstraints { (make) in
                make.left.right.equalTo(leverageView)
                make.height.equalTo(36)
                make.top.equalTo(canShortCostLabel.snp.bottom).offset(3)
            }
        } else if transactionShowType == .showClose  { // 平仓
            if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil { // 未登录状态
                canCloseShortLabel.text = String(format:"contract_makeorder_canclose_empty".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
                canCloseMoreLabel.text = String(format:"contract_makeorder_canclose_more".localized(),"-",makeOrderViewModel?.volumeUnit ?? "-")
                holdLongLabel.text = String(format:"contract_makeorder_hold_position".localized(),"-" ,makeOrderViewModel?.volumeUnit ?? "-")
                holdShortLabel.text = String(format:"contract_makeorder_hold_position".localized(),"-" ,makeOrderViewModel?.volumeUnit ?? "-")
            } else { // 登录状态
                canCloseShortLabel.text = String(format:"contract_makeorder_canclose_empty".localized(),(makeOrderViewModel?.canCloseShort ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                canCloseMoreLabel.text = String(format:"contract_makeorder_canclose_more".localized(),(makeOrderViewModel?.canCloseMore ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                holdLongLabel.text = String(format:"contract_makeorder_hold_position".localized(),(makeOrderViewModel?.holdMoreNum ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                holdShortLabel.text = String(format:"contract_makeorder_hold_position".localized(),(makeOrderViewModel?.holdShortNum ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
            }
            leverageView.setEnableEditing(false)
            holdLongLabel.isHidden = false
            holdShortLabel.isHidden = false
            canOpenMoreLabel.isHidden = true
            canOpenShortLabel.isHidden = true
            canCloseMoreLabel.isHidden = false
            canCloseShortLabel.isHidden = false
            
            canMoreCostLabel.isHidden = true
            canShortCostLabel.isHidden = true
            
            buyBtn.snp.remakeConstraints { (make) in
                make.left.right.equalTo(leverageView)
                make.height.equalTo(36)
                make.top.equalTo(canCloseShortLabel.snp.bottom).offset(3)
            }
            sellBtn.snp.remakeConstraints { (make) in
                make.left.right.equalTo(leverageView)
                make.height.equalTo(36)
                make.top.equalTo(canCloseMoreLabel.snp.bottom).offset(3)
            }
        }
        refreshBtnTitle()
    }
    
    func refreshBtnTitle() {
        if transactionShowType == .showOpen { // 开仓
            if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil { // 未登录状态
                self.buyBtn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
                self.sellBtn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
                self.buyBtn.setAttributedTitle(nil, for: .normal)
                self.buyBtn.setAttributedTitle(nil, for: .selected)
                self.sellBtn.setAttributedTitle(nil, for: .normal)
                self.sellBtn.setAttributedTitle(nil, for: .selected)
            } else { // 登录状态
                let buyAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_buy_openMore2"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold]).add(string: String(format: "%@", "contract_buy_openMore_tip".localized()), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
                let sellAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_sell_openLess2"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold]).add(string: String(format: "%@", "contract_sell_openLess_tip".localized()), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
                self.buyBtn.setAttributedTitle(buyAttrString, for: .normal)
                self.buyBtn.setAttributedTitle(buyAttrString, for: .selected)
                self.sellBtn.setAttributedTitle(sellAttrString, for: .normal)
                self.sellBtn.setAttributedTitle(sellAttrString, for: .selected)
            }
            
        } else if transactionShowType == .showClose  { // 平仓
            if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil { // 未登录状态
                self.buyBtn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
                self.sellBtn.setTitle("contract_login_register".localized(), for: UIControlState.normal)
                self.buyBtn.setAttributedTitle(nil, for: .normal)
                self.buyBtn.setAttributedTitle(nil, for: .selected)
                self.sellBtn.setAttributedTitle(nil, for: .normal)
                self.sellBtn.setAttributedTitle(nil, for: .selected)
            } else { // 登录状态
                let buyAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_buy_closeLess2"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold]).add(string: String(format: "%@", "contract_buy_closeMore_tip".localized()), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
                let sellAttrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_sell_closeMore2"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold]).add(string: String(format: "%@", "contract_sell_closeLess_tip".localized()), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.white, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
                self.buyBtn.setAttributedTitle(buyAttrString, for: .normal)
                self.buyBtn.setAttributedTitle(buyAttrString, for: .selected)
                self.sellBtn.setAttributedTitle(sellAttrString, for: .normal)
                self.sellBtn.setAttributedTitle(sellAttrString, for: .selected)
            }
        }
    }
    
    func reloadMakeOrderData() { // 数据改变加载界面
        if makeOrderViewModel == nil || makeOrderViewModel?.itemModel == nil {
            return
        }
        // 杠杆
        let leverage = makeOrderViewModel!.leverageTypeStr + makeOrderViewModel!.leverage + "X"
        leverageView.setView(leverage)
        leverageView.leverage = leverage
        if XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance().activeAccount != nil {
            if transactionShowType == .showOpen { // 开仓页面
                if self.defineOrderType == .normalOrder {
                    makeOrderViewModel!.loadOpenOrder(px: self.priceTextField.input.text,
                                                      qty: self.volumeTextField.input.text,
                                                      perform_px: self.performTextField.input.text ?? "0",
                                                      contractType: defineOrderType,
                                                      priceType: normalPriceType,
                                                      planPriceType: performPriceType,
                                                      timeForce: 0)
                } else if self.defineOrderType == .highOrder {
                    var idx = 1
                    if highOrderType == .postOnly {
                        idx = 1
                    } else if highOrderType == .fillOrKill {
                        idx = 2
                    } else if highOrderType == .immediateOrCance {
                        idx = 3
                    }
                    makeOrderViewModel!.loadOpenOrder(px: self.priceTextField.input.text,
                                                                         qty: self.volumeTextField.input.text,
                                                                         perform_px: self.performTextField.input.text ?? "0",
                                                                         contractType: defineOrderType,
                                                                         priceType: normalPriceType,
                                                                         planPriceType: performPriceType,
                                                                         timeForce: idx)
                } else {
                    makeOrderViewModel!.loadOpenOrder(px: self.triggerTextField.input.text,
                                                      qty: self.volumeTextField.input.text,
                                                      perform_px: self.performTextField.input.text ?? "0",
                                                      contractType: defineOrderType,
                                                      priceType: normalPriceType,
                                                      planPriceType: performPriceType,
                                                      timeForce: 0)
                }
                canOpenMoreLabel.text = String(format:"contract_makeorder_canopen_more".localized(),(makeOrderViewModel?.canOpenMore ?? "0"), makeOrderViewModel?.volumeUnit ?? "-")
                canOpenShortLabel.text = String(format:"contract_makeorder_canopen_empty".localized(),(makeOrderViewModel?.canOpenShort ?? "0"),makeOrderViewModel?.volumeUnit ?? "-")
                
                if let openLongModel = makeOrderViewModel?.orderLongModel {
                    var cost = (openLongModel.freezAssets ?? "0").toSmallValue(withContract: openLongModel.instrument_id) ?? "0"
                    cost = cost + openLongModel.contractInfo.margin_coin
                    
                    self.canMoreCostLabel.text = "contract_text_mybeCost".localized() + " " + cost
                }
                if let openShorModel = makeOrderViewModel?.orderShortModel {
                    var cost = (openShorModel.freezAssets ?? "0").toSmallValue(withContract: openShorModel.instrument_id) ?? "0"
                    cost = cost + openShorModel.contractInfo.margin_coin
                    self.canShortCostLabel.text = "contract_text_mybeCost".localized() + " " + cost
                }
                
                self.buyBtn.isEnabled = true
                self.sellBtn.isEnabled = true
            } else { // 平仓页面
                if self.defineOrderType == .normalOrder {
                    makeOrderViewModel!.loadCloseOrder(px: self.priceTextField.input.text,
                                                      qty: self.volumeTextField.input.text,
                                                      perform_px: self.performTextField.input.text ?? "0",
                                                      contractType: defineOrderType,
                                                      priceType: normalPriceType,
                                                      planPriceType: performPriceType,
                                                      timeForce: 0)
                } else if self.defineOrderType == .highOrder {
                    var idx = 1
                    if highOrderType == .postOnly {
                        idx = 1
                    } else if highOrderType == .fillOrKill {
                        idx = 2
                    } else if highOrderType == .immediateOrCance {
                        idx = 3
                    }
                    makeOrderViewModel!.loadCloseOrder(px: self.priceTextField.input.text,
                                                      qty: self.volumeTextField.input.text,
                                                      perform_px: self.performTextField.input.text ?? "0",
                                                      contractType: defineOrderType,
                                                      priceType: normalPriceType,
                                                      planPriceType: performPriceType,
                                                      timeForce: idx)
                } else {
                    makeOrderViewModel!.loadCloseOrder(px: self.triggerTextField.input.text,
                                                      qty: self.volumeTextField.input.text,
                                                      perform_px: self.performTextField.input.text ?? "0",
                                                      contractType: defineOrderType,
                                                      priceType: normalPriceType,
                                                      planPriceType: performPriceType,
                                                      timeForce: 0)
                }
                canCloseShortLabel.text = String(format:"contract_makeorder_canclose_empty".localized(),(makeOrderViewModel?.canCloseShort ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                canCloseMoreLabel.text = String(format:"contract_makeorder_canclose_more".localized(),(makeOrderViewModel?.canCloseMore ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                holdLongLabel.text = String(format:"contract_makeorder_hold_position".localized(),(makeOrderViewModel?.holdMoreNum ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                holdShortLabel.text = String(format:"contract_makeorder_hold_position".localized(),(makeOrderViewModel?.holdShortNum ?? "0") ,makeOrderViewModel?.volumeUnit ?? "-")
                self.buyBtn.isEnabled = !makeOrderViewModel!.canCloseShort.lessThanOrEqual(BTZERO)
                self.sellBtn.isEnabled = !makeOrderViewModel!.canCloseMore.lessThanOrEqual(BTZERO)
            }
            self.availableLabel.text = "assets_text_available".localized() + (makeOrderViewModel?.canUseAmount ?? "0") + (makeOrderViewModel?.asset?.coin_code ?? "")
        } else {
            self.buyBtn.isEnabled = true
            self.sellBtn.isEnabled = true
            self.availableLabel.text = "assets_text_available".localized() + "-" + (makeOrderViewModel?.itemModel?.contractInfo?.margin_coin ?? "-")
        }
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        if makeOrderViewModel == nil || makeOrderViewModel?.itemModel == nil || makeOrderViewModel?.itemModel?.contractInfo == nil {
            return
        }
        var price = "0"
        if textField == self.priceTextField.input {
            var px = self.priceTextField.input.text ?? "0"
            px = px.forDecimals((makeOrderViewModel?.itemModel?.contractInfo?.px_unit ?? "0").bigMul("10")) // 价格精度少一位
            let coin = makeOrderViewModel?.itemModel?.contractInfo?.quote_coin ?? ""
            let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(coin)
            if let rmb = px.multiplyingBy1(t.1, decimals: t.2) {
                equalLabel.text = "≈\(t.0)" + rmb
            }
        } else if textField == self.volumeTextField.input {
            if (makeOrderViewModel?.isCoin ?? false) {
                var qty = self.volumeTextField.input.text ?? "0"
                let arr = qty.components(separatedBy: ".")
                let qty_decimal = (makeOrderViewModel?.itemModel?.contractInfo?.value_unit ?? "0.1").ch_length - 2
                if arr.count == 2 && arr[1].ch_length > qty_decimal {
                    qty = arr[0] + "." + arr[1].extStringSub(NSRange.init(location: 0, length: qty_decimal))
                    self.volumeTextField.input.text = qty
                }
            }
            
        } else if textField == self.triggerTextField.input {
            
        } else if textField == self.performTextField.input {
            let px = self.performTextField.input.text ?? "0"
            let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(makeOrderViewModel?.itemModel?.contractInfo?.quote_coin ?? "")
            if let rmb = px.multiplyingBy1(t.1, decimals: t.2) {
                equalLabel.text = "≈\(t.0)" + rmb
            }
        }
        if self.defineOrderType == .normalOrder {
            price = self.priceTextField.input.text ?? "0"
        } else if self.defineOrderType == .highOrder {
            price = self.priceTextField.input.text ?? "0"
        } else {
            if performPriceType == .marketPlan {
                price = self.triggerTextField.input.text ?? "0"
            } else {
                price = self.performTextField.input.text ?? "0"
            }
        }
        var vol = self.volumeTextField.input.text ?? "0"
        var amount = BT_ZERO;
        if makeOrderViewModel!.isCoin {
            vol = SLFormula.coin(toTicket: vol, price: price, contract: makeOrderViewModel!.itemModel!.contractInfo )
            amount = vol
            entrustLabel.text = "≈ " + amount + "contract_text_volumeUnit".localized()
        } else {
            amount = SLFormula.calculateContractBasicValue(withPrice: price, vol: vol, contract: makeOrderViewModel!.itemModel!.contractInfo )
            entrustLabel.text = "≈ " + amount + makeOrderViewModel!.itemModel!.contractInfo.base_coin
        }
        reloadMakeOrderData()
    }
    
    func reloadUnitData() {
        if BTStoreData.storeBool(forKey: BT_UNIT_VOL) {
            volumeTextField.unitLabel.text = makeOrderViewModel?.itemModel?.contractInfo.base_coin ?? "--"
            volumeTextField.input.keyboardType = UIKeyboardType.decimalPad
        } else {
            volumeTextField.unitLabel.text = "contract_text_volumeUnit".localized()
            volumeTextField.input.keyboardType = UIKeyboardType.numberPad
        }
       
        volumeTextField.input.text = ""
        priceTextField.unitLabel.text = makeOrderViewModel?.itemModel?.contractInfo.quote_coin
        triggerTextField.unitLabel.text = makeOrderViewModel?.itemModel?.contractInfo.quote_coin
        textFieldValueHasChanged(textField: volumeTextField.input)
    }
    
    func isHiddenEqualLabel()  {
        let is_reverse = makeOrderViewModel?.itemModel?.contractInfo.is_reverse
              
              if is_reverse == true {
                  
                  let baseCoin = ["USDT"]
                
                  if baseCoin.contains(makeOrderViewModel?.itemModel?.contractInfo.quote_coin ?? "") {
                      equalLabel.isHidden = false
                  }else{
                       equalLabel.isHidden = true
                  }
              }
              else{
                
                equalLabel.isHidden = false
        }
        
    }
    
}

// MARK: - Even Click
extension SLSwapMakeOrderView {
    /// 点击计划委托的市价
    @objc func clickPlanMarketBtn(_ btn : UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            marketLabel.isHidden = false
            performTextField.input.isUserInteractionEnabled = false
            performPriceType = .marketPlan
        } else {
            marketLabel.isHidden = true
            performTextField.input.isUserInteractionEnabled = true
            performPriceType = .limitPlan
        }
        reloadMakeOrderData()
    }
    /// 点击买卖下单
    @objc func clickBuyOrSellBtn(_ btn : UIButton){
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
            BusinessTools.modalLoginVC()
            return
        }
        reloadMakeOrderData()
        
        if defineOrderType == .normalOrder {
            if normalPriceType == .limitPrice {
                if priceTextField.input.text == nil || (priceTextField.input.text ?? "0").lessThanOrEqual(BTZERO) {
                    EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
                    return
                }
            }
        } else if defineOrderType == .highOrder {
            if normalPriceType == .limitPrice {
                if priceTextField.input.text == nil || (priceTextField.input.text ?? "0").lessThanOrEqual(BTZERO) {
                    EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
                    return
                }
            }
        } else  {
            if triggerTextField.input.text == nil || (triggerTextField.input.text ?? "0").lessThanOrEqual(BTZERO) {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
                return
            }
            if performPriceType == .limitPlan {
                if performTextField.input.text == nil || (performTextField.input.text ?? "0").lessThanOrEqual(BTZERO) {
                    EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
                    return
                }
            }
        }
        
        if volumeTextField.input.text == nil || (volumeTextField.input.text ?? "0").lessThanOrEqual(BTZERO) {
            EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_volume_limit".localized()))
            return
        }
        
        var order : BTContractOrderModel?
        if btn == self.buyBtn {
            if transactionShowType == .showOpen { // 开仓
                order = makeOrderViewModel?.orderLongModel
                if makeOrderViewModel?.isCoin == false {
                    if (order?.qty ?? "0").greaterThan(makeOrderViewModel?.canOpenMore ?? "0") {
                        EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_moreThan_volume".localized()))
                        return
                    }
                }
            } else if transactionShowType == .showClose { // 平仓
                order = makeOrderViewModel?.orderCloseShortModel
                if makeOrderViewModel?.isCoin == false {
                    if (order?.qty ?? "0").greaterThan(makeOrderViewModel?.canCloseShort ?? "0") {
                        EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_moreThan_close".localized()))
                        return
                    }
                }
            }
        } else {
            if transactionShowType == .showOpen { // 开仓
                order = makeOrderViewModel?.orderShortModel
                if makeOrderViewModel?.isCoin == false {
                    if (order?.qty ?? "0").greaterThan(makeOrderViewModel?.canOpenShort ?? "0") {
                        EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_moreThan_volume".localized()))
                        return
                    }
                }
            } else if transactionShowType == .showClose { // 平仓
                order = makeOrderViewModel?.orderCloseMoreModel
                if makeOrderViewModel?.isCoin == false {
                    if (order?.qty ?? "0").greaterThan(makeOrderViewModel?.canCloseMore ?? "0") {
                        EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_moreThan_close".localized()))
                        return
                    }
                }
            }
        }
        if order?.category == .market {
            order?.open_avg_px = "0"
        }
        order?.currentPrice = makeOrderViewModel!.itemModel!.last_px
        if order != nil {
            /// 价格不能为0
            if order!.px == nil || order!.px.lessThanOrEqual(BTZERO) {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
                return
            }
            
            /// 合约支持的最大交易量
            if order!.qty.greaterThan(makeOrderViewModel!.itemModel!.contractInfo.max_qty) {
                EXAlert.showFail(msg: LanguageTools.getString(key: String(format:"contract_max_volume_limit".localized(),makeOrderViewModel!.itemModel!.contractInfo.max_qty)))
                return
            }
            
            self.clickTradeBlock?(order!)
        }
    }
    /// 点击弹出计划委托提示
    @objc func clickPlanTipsBtn() {
        let alert = EXNormalAlert()
        alert.configSigleAlert(title: "contract_plan_order".localized(), message: "contract_tips_plan".localized())
        EXAlert.showAlert(alertView: alert)
    }
    /// 点击高级委托类型
    @objc func clickHighTypeBtn() {
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            if idx == 0 {
                mySelf.highOrderType = .postOnly
                mySelf.highTypeBtn.text(content: "contract_postonly".localized())
            } else if idx == 1 {
                mySelf.highOrderType = .fillOrKill
                 mySelf.highTypeBtn.text(content: "contract_fok".localized())
            } else if idx == 2 {
                mySelf.highOrderType = .immediateOrCance
                 mySelf.highTypeBtn.text(content: "contract_ioc".localized())
            }
            mySelf.highTypeBtn.reset()
            mySelf.reloadMarketOrderView()
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.orderTypeBtn.reset()
        }
        var idx = 0
        if highTypeBtn.titleLabel.text == "contract_postonly".localized() {
            idx = 0
        } else if highTypeBtn.titleLabel.text == "contract_fok".localized() {
            idx = 1
        } else if highTypeBtn.titleLabel.text == "contract_ioc".localized() {
            idx = 2
        }
        sheet.configButtonTitles(buttons:  highOrderArr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    /// 点击切换委托类型按钮
    @objc func clickOrderTypeBtn() {
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.orderTypeBtn.text(content: mySelf.priceArr[idx])
            mySelf.orderTypeBtn.reset()
            if idx == 0 {
                mySelf.defineOrderType = .normalOrder
            } else if idx == 1 {
                mySelf.defineOrderType = .highOrder
                if mySelf.marketBtn.isSelected {
                    mySelf.clickDefinePriceBtn(mySelf.marketBtn)
                }
            } else if idx == 2 {
                mySelf.defineOrderType = .planOrder
            }
            mySelf.reloadMarketOrderView()
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.orderTypeBtn.reset()
        }
        var idx = 0
        for i in 0..<priceArr.count{
            if priceArr[i] == orderTypeBtn.titleLabel.text{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  priceArr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    /// 选择触发价格类型
    @objc func clickTiggerPriceTypeBtn(_ btn : UIButton) {
        btn.isSelected = true
        var idx = 0
        if btn == lastPriceBtn {
            fairPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
        } else if btn == fairPriceBtn {
            lastPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
            idx = 1
        } else if btn == indexPriceBtn {
            lastPriceBtn.isSelected = false
            fairPriceBtn.isSelected = false
            idx = 2
        }
        BTStoreData.setStoreObjectAndKey(idx, key: ST_TIGGER_PRICE)
        changeTriggerPricePlaceHolder()
    }
    /// 选择市价按钮
    @objc func clickDefinePriceBtn(_ btn : UIButton){
        let coin = makeOrderViewModel?.itemModel?.contractInfo?.quote_coin ?? ""
        let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(coin)
        if btn == marketBtn {
            priceTextField.input.isUserInteractionEnabled = marketBtn.isSelected
            if marketBtn.isSelected == true {
                marketBtn.isSelected = false
                marketBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
                marketPriceLabel.isHidden = true
                normalPriceType = .limitPrice
                if let rmb = (priceTextField.input.text ?? "0").multiplyingBy1(t.1, decimals: t.2) {
                    equalLabel.text = "≈\(t.0)" + rmb
                }
                return
            }
            priceTextField.input.endEditing(true)
            normalPriceType = .marketPrice
            buyOneBtn.isSelected = false
            sellOneBtn.isSelected = false
            sellOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            buyOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            marketPriceLabel.text = "   " + "contract_action_marketPrice".localized()
            if let rmb = makeOrderViewModel?.itemModel!.last_px.multiplyingBy1(t.1, decimals: t.2) {
                equalLabel.text = "≈\(t.0)" + rmb
            }
        } else if buyOneBtn == btn {
            priceTextField.input.isUserInteractionEnabled = buyOneBtn.isSelected
            if buyOneBtn.isSelected == true {
                buyOneBtn.isSelected = false
                buyOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
                marketPriceLabel.isHidden = true
                normalPriceType = .limitPrice
                if let rmb = (priceTextField.input.text ?? "0").multiplyingBy1(t.1, decimals: t.2) {
                    equalLabel.text = "≈\(t.0)" + rmb
                }
                return
            }
            priceTextField.input.endEditing(true)
            normalPriceType = .buyOnePrice
            marketBtn.isSelected = false
            sellOneBtn.isSelected = false
            marketBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            sellOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            marketPriceLabel.text = "   " + "contract_buyOne_price".localized()
            let px = makeOrderViewModel?.buyDepthOrder?.first?.px ?? "0"
            if let rmb = px.multiplyingBy1(t.1, decimals: t.2) {
                equalLabel.text = "≈\(t.0)" + rmb
            }
        } else if sellOneBtn == btn {
            priceTextField.input.isUserInteractionEnabled = sellOneBtn.isSelected
            if sellOneBtn.isSelected == true {
                sellOneBtn.isSelected = false
                sellOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
                marketPriceLabel.isHidden = true
                normalPriceType = .limitPrice
                if let rmb = (priceTextField.input.text ?? "0").multiplyingBy1(t.1, decimals: t.2) {
                    equalLabel.text = "≈\(t.0)" + rmb
                }
                return
            }
            priceTextField.input.endEditing(true)
            normalPriceType = .sellOnePrice
            marketBtn.isSelected = false
            buyOneBtn.isSelected = false
            marketBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            buyOneBtn.layer.borderColor = UIColor.ThemeView.border.cgColor
            marketPriceLabel.text = "   " + "contract_sellOne_price".localized()
            let px = makeOrderViewModel?.sellDepthOrder?.first?.px ?? "0"
            if let rmb = px.multiplyingBy1(t.1, decimals: t.2) {
                equalLabel.text = "≈\(t.0)" + rmb
            }
        }
        btn.isSelected = true
        btn.layer.borderColor = UIColor.ThemeLabel.colorHighlight.cgColor
        marketPriceLabel.isHidden = false
        reloadMakeOrderData()
    }
    /// 弹出杠杆
    func popupLeverage(){
        if transactionShowType == .showClose {
            return
        }
        let arr = makeOrderViewModel?.leverageArr
        if (arr?.count ?? 0) <= 0 {
            return
        }
        let leverageVc = SLLeverageVc()
        leverageVc.makeOrderViewModel = self.makeOrderViewModel
        leverageVc.currentPx = self.priceTextField.input.text ?? (makeOrderViewModel?.itemModel?.fair_px ?? "0")
        leverageVc.clickComfirmLeverage = {[weak self] (positionType, leverage) in
            guard let mySelf = self else{return}
            mySelf.changeLevel(positionType,leverage)
            mySelf.leverageView.leverageBtn.reset()
        }
        self.yy_viewController?.navigationController?.pushViewController(leverageVc, animated: true)
    }
    /// 更新杠杆
    func changeLevel(_ level : String,_ idx : String){
        leverageView.setView(level)
        leverageView.leverage = level
        if level.contains("contract_Cross_position".localized()) {
            makeOrderViewModel?.leverageTypeStr = "contract_Cross_position".localized()
            makeOrderViewModel?.leverage_type = .allType
        } else if level.contains("contract_Fixed_position".localized()) {
            makeOrderViewModel?.leverageTypeStr = "contract_Fixed_position".localized()
            makeOrderViewModel?.leverage_type = .pursueType
        }
        makeOrderViewModel?.leverage = idx
        if defineOrderType == .normalOrder {
            textFieldValueHasChanged(textField: self.priceTextField.input)
        } else if defineOrderType == .highOrder {
            textFieldValueHasChanged(textField: self.priceTextField.input)
        } else {
            textFieldValueHasChanged(textField: self.performTextField.input)
        }
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeLayoutBlock?(self.frame.size.height)
    }
}

