//
//  SLStopProfitLossVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/31.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLStopProfitLossVc : NavCustomVC {
    typealias ClickStopProfitLoss = (Bool) -> ()
    var clickStopProfitLoss : ClickStopProfitLoss?
    
    var positionModel : BTPositionModel? {
        didSet {
            px_unit = positionModel?.contractInfo?.quote_coin ?? "-"
            infoVaild.decail = positionModel?.contractInfo.px_unit ?? "0.01"
        }
    }
    
    var stopProfitOrder : BTContractOrderModel? {
        didSet {
            tiggerIndex = stopProfitOrder?.trigger_type ?? BTContractOrderPriceType.tradePriceType
            
        }
    }
    var stopLossOrder : BTContractOrderModel? {
        didSet {
            tiggerIndex = stopLossOrder?.trigger_type ?? BTContractOrderPriceType.tradePriceType
        }
    }
    
    var px_unit : String = "-"
    
    var cy = (BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0) == 0 ? "24" : "168"
    
    var tiggerIndex = BTContractOrderPriceType.tradePriceType
    
    var submitCount = 0
    
    var pxTypeStr = ""
    
    let infoVaild:SLInputLimitDelegate = SLInputLimitDelegate()
    
    /// 触发价格
    lazy var tiggerType: UILabel = {
        let text = "contract_trigger_type".localized()
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        label.isHidden = true
        return label
    }()
    
    /// 最新价
    lazy var lastPriceBtn : EXTextButton = {
        let btn = EXTextButton()
        btn.setColor(color:  UIColor.ThemeView.bgTab)
        btn.setFont(font: UIFont.ThemeFont.BodyRegular)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        btn.supportCheckHighlight = true
        btn.setTitle("contract_tiggertype_latest".localized(), for: .normal)
        btn.addTarget(self, action: #selector(tiggerPriceTapAction(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    /// 合理价
    lazy var fairPriceBtn : EXTextButton = {
        let btn = EXTextButton()
        btn.setColor(color:  UIColor.ThemeView.bgTab)
        btn.setFont(font: UIFont.ThemeFont.BodyRegular)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        btn.supportCheckHighlight = true
        btn.setTitle("contract_tiggertype_fair".localized(), for: .normal)
        btn.addTarget(self, action: #selector(tiggerPriceTapAction(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    /// 指数价
    lazy var indexPriceBtn : EXTextButton = {
        let btn = EXTextButton()
        btn.setColor(color:  UIColor.ThemeView.bgTab)
        btn.setFont(font: UIFont.ThemeFont.BodyRegular)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        btn.supportCheckHighlight = true
        btn.setTitle("contract_tiggertype_index".localized(), for: .normal)
        btn.addTarget(self, action: #selector(tiggerPriceTapAction(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var openProfitBtn : EXButton = {
        let btn = EXButton()
        btn.setTitle(String(format:" %@","contract_open_stop_profit".localized()), for: .normal)
        btn.clearColors()
        btn.setFont(UIFont.ThemeFont.BodyBold)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        btn.extSetImages([UIImage.themeImageNamed(imageName: "contract_checkbox_default"),UIImage.themeImageNamed(imageName: "contract_checkbox_Focus")], controlStates: [.normal,.selected])
        btn.addTarget(self, action: #selector(openProfitOrLoss(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var openLossBtn : EXButton = {
        let btn = EXButton()
        btn.setTitle(String(format:" %@","contract_open_stop_loss".localized()), for: .normal)
        btn.clearColors()
        btn.setFont(UIFont.ThemeFont.BodyBold)
        btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        btn.extSetImages([UIImage.themeImageNamed(imageName: "contract_checkbox_default"),UIImage.themeImageNamed(imageName: "contract_checkbox_Focus")], controlStates: [.normal,.selected])
        btn.addTarget(self, action: #selector(openProfitOrLoss(sender:)), for: .touchUpInside)
        return btn
    }()
    
    /// 止盈触发价格
    lazy var profitTiggerInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText(px_unit)
        input.titleLabel.secondaryRegular()
        input.setTitle(title: "contract_trigger_price".localized())
        input.setPlaceHolder(placeHolder: "contract_trigger_price".localized())
        input.isUserInteractionEnabled = false
        input.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: input.input)
        }
        return input
    }()
    
    /// 止盈执行价格
    lazy var profitExcutiveInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText(px_unit)
        input.titleLabel.secondaryRegular()
        input.setTitle(title: "contract_excutive_price".localized())
        input.setPlaceHolder(placeHolder: "contract_excutive_price".localized())
        input.isUserInteractionEnabled = false
        let verLine = UIView()
        verLine.backgroundColor = UIColor.ThemeView.seperator
        input.addSubview(profitMarketLabel)
        input.addSubview(verLine)
        profitMarketLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.centerY.equalTo(input.input)
            make.width.equalTo(40)
        }
        verLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(input.input)
            make.right.equalTo(profitMarketLabel.snp.left)
        }
        input.extraLabel.snp.updateConstraints { (make) in
            make.right.equalTo(verLine.snp.left).offset(-10)
        }
        profitMarketLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickProfitMarketBtn(recognizer:)))
        profitMarketLabel.addGestureRecognizer(tap)
        
        input.addSubview(profitMarketCover)
        profitMarketCover.snp.makeConstraints { (make) in
            make.left.right.centerY.bottom.equalTo(input.input)
            make.height.equalTo(20)
        }
        input.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: input.input)
        }
        return input
    }()
    
    lazy var profitMessage :UILabel = {
        
        let lable = UILabel()
        lable.font = UIFont.ThemeFont.SecondaryRegular
        lable.textColor = UIColor.ThemeState.warning
        return lable
        
    }()
    
    
    lazy var profitMarketLabel : UILabel = {
        let marketLabel = UILabel.init(text: "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .right)
        return marketLabel
    }()
    
    lazy var profitMarketCover : UILabel = {
        let marketCover = UILabel.init(text: "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        marketCover.backgroundColor = UIColor.ThemeView.bg
        marketCover.isHidden = true
        return marketCover
    }()
    
    /// 止损触发价格
    lazy var lossTiggerInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText(px_unit)
        input.titleLabel.secondaryRegular()
        input.setTitle(title: "contract_trigger_price".localized())
        input.setPlaceHolder(placeHolder: "contract_trigger_price".localized())
        input.isUserInteractionEnabled = false
        input.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: input.input)
        }
        return input
    }()
    
    /// 止损执行价格
    lazy var lossExcutiveInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setExtraText(px_unit)
        input.titleLabel.secondaryRegular()
        input.setTitle(title: "contract_excutive_price".localized())
        input.setPlaceHolder(placeHolder: "contract_excutive_price".localized())
        input.isUserInteractionEnabled = false
        let verLine = UIView()
        verLine.backgroundColor = UIColor.ThemeView.seperator
        input.addSubview(lossMarketLabel)
        input.addSubview(verLine)
        lossMarketLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.centerY.equalTo(input.input)
            make.width.equalTo(40)
        }
        verLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(input.input)
            make.right.equalTo(lossMarketLabel.snp.left)
        }
        input.extraLabel.snp.updateConstraints { (make) in
            make.right.equalTo(verLine.snp.left).offset(-10)
        }
        lossMarketLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickLossMarketBtn(recognizer:)))
        lossMarketLabel.addGestureRecognizer(tap)
        
        input.addSubview(lossMarketCover)
        lossMarketCover.snp.makeConstraints { (make) in
            make.left.right.centerY.equalTo(input.input)
            make.height.equalTo(20)
        }
        input.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: input.input)
        }
        return input
    }()
    
    lazy var lossMarketLabel : UILabel = {
        let marketLabel = UILabel.init(text: "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .right)
        return marketLabel
    }()
    
    lazy var lossMarketCover : UILabel = {
        let marketCover = UILabel.init(text: "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        marketCover.backgroundColor = UIColor.ThemeView.bg
        marketCover.isHidden = true
        return marketCover
    }()
    
    /// 提示
    lazy var tipsLabel: UILabel = {
        
        let label = UILabel(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeState.warning, alignment: .left)
        
        return label
    }()
    
    /// 确认
    lazy var confirmButton: EXButton = {
        let button = EXButton()
        button.setTitle("common_text_btnConfirm".localized(), for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func setNavCustomV() {
        self.setTitle("contract_stop_profit_loss".localized())
        self.navtype = .list
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addSubViews([tiggerType,lastPriceBtn,indexPriceBtn,fairPriceBtn,openProfitBtn,openLossBtn,profitTiggerInput,profitExcutiveInput,lossTiggerInput,lossExcutiveInput,tipsLabel,confirmButton,profitMessage])
        self.initLayout()
        setInfoVaildDelegate()
        let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
        if idx == 0 {
            tiggerIndex = BTContractOrderPriceType.tradePriceType
        } else if idx == 1 {
            tiggerIndex = BTContractOrderPriceType.markPriceType
        } else {
            tiggerIndex = BTContractOrderPriceType.indexPriceType
        }
        self.requestProfitOrLossOrder()
    }
    func setInfoVaildDelegate() {
        profitTiggerInput.input.delegate = infoVaild
        profitExcutiveInput.input.delegate = infoVaild
        lossTiggerInput.input.delegate = infoVaild
        lossExcutiveInput.input.delegate = infoVaild
    }
    
    private func requestProfitOrLossOrder() {
        BTContractTool.getUserPlanContractOrders(
            withContractID: self.positionModel?.instrument_id ?? 0,
            status: .allWait,
            offset: 0,
            size: 0,
            success: {[weak self] (models: [BTContractOrderModel]?) in
                guard let mySelf = self else {return}
                guard let planArr = models else {return}
                for planOrder in planArr {
                    if planOrder.type == .profitType {
                        mySelf.stopProfitOrder = planOrder
                    } else if planOrder.type == .lossType {
                        mySelf.stopLossOrder = planOrder
                    }
                }
                mySelf.reloadVcData()
        }) { (error) in
            
        }
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        var px = textField.text ?? "0"
        px = px.forDecimals((positionModel?.contractInfo?.px_unit ?? "0").bigMul("10")) // 价格精度少一位
        textField.text = px;
        
        if textField == profitTiggerInput.input {
            relaodMessage(messageLabel: profitMessage, price: px)
        }
        if textField == lossTiggerInput.input {
            relaodMessage(messageLabel: tipsLabel, price: px)
        }
        
    }
    
    func relaodMessage(messageLabel:UILabel,price:String)  {
        
        let message = price == "" ? "" : String(format: "contract_sting_newPriceMessage".localized(), price)
        messageLabel.text = message
    }
    
}




extension SLStopProfitLossVc {
    
    private func reloadVcData() {
        if self.stopProfitOrder != nil {
            openProfitOrLoss(sender: self.openProfitBtn)
        }
        if self.stopLossOrder != nil {
            openProfitOrLoss(sender: self.openLossBtn)
        }
        if tiggerIndex == BTContractOrderPriceType.tradePriceType {
            tiggerPriceTapAction(sender: lastPriceBtn)
        } else if tiggerIndex == BTContractOrderPriceType.markPriceType {
            tiggerPriceTapAction(sender: fairPriceBtn)
        } else if tiggerIndex == BTContractOrderPriceType.indexPriceType {
            tiggerPriceTapAction(sender: indexPriceBtn)
        }
    }
    
    private func initLayout() {
        tiggerType.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.navCustomView.snp.bottom).offset(15)
            make.height.equalTo(0)
        }
        lastPriceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(tiggerType.snp.bottom).offset(0)
            make.height.equalTo(0)
        }
        fairPriceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lastPriceBtn.snp_right).offset(22)
            make.top.width.height.equalTo(lastPriceBtn)
        }
        indexPriceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(fairPriceBtn.snp_right).offset(22)
            make.top.width.height.equalTo(lastPriceBtn)
            make.right.equalToSuperview().offset(-15)
        }
        openProfitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lastPriceBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(14)
        }
        profitTiggerInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(openProfitBtn.snp.bottom).offset(14)
        }
        profitExcutiveInput.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(profitTiggerInput)
            make.top.equalTo(profitTiggerInput.snp.bottom).offset(10)
        }
        
        profitMessage.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitExcutiveInput);
            make.top.equalTo(profitExcutiveInput.snp.bottom).offset(10)
            //            make.height.equalTo(15)
        }
        
        openLossBtn.snp.makeConstraints { (make) in
            make.top.equalTo(profitMessage.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(14)
        }
        lossTiggerInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(openLossBtn.snp.bottom).offset(14)
        }
        lossExcutiveInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitTiggerInput)
            make.top.equalTo(lossTiggerInput.snp.bottom).offset(10)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitTiggerInput)
            make.top.equalTo(lossExcutiveInput.snp.bottom).offset(20)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitTiggerInput)
            make.top.equalTo(tipsLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    @objc func tiggerPriceTapAction(sender : EXTextButton) {
        sender.isSelected = true
        
        if sender == lastPriceBtn {
            pxTypeStr = "contract_last_price".localized()
            tiggerIndex = .tradePriceType
            fairPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
        } else if sender == fairPriceBtn {
            pxTypeStr = "contract_text_fairPrice".localized()
            tiggerIndex = .markPriceType
            lastPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
        } else if sender == indexPriceBtn {
            pxTypeStr = "contract_text_indexPrice".localized()
            tiggerIndex = .indexPriceType
            lastPriceBtn.isSelected = false
            fairPriceBtn.isSelected = false
        }
        //        tipsLabel.text = String(format:"contract_stop_profitloss_tips".localized(),pxTypeStr)
    }
    
    @objc func openProfitOrLoss(sender : EXButton) {
        sender.isSelected = !sender.isSelected
        
        if sender == openProfitBtn {
            
            //默认选中
            profitMarketCover.isHidden = !profitMarketCover.isHidden
            if profitMarketCover.isHidden == true {
                self.profitExcutiveInput.input.endEditing(true)
            } else {
                self.profitExcutiveInput.input.text = positionModel?.lastPrice ?? "0"
            }
            
            if sender.isSelected == true {
                self.profitTiggerInput.isUserInteractionEnabled = true
                self.profitExcutiveInput.isUserInteractionEnabled = true
                if self.stopProfitOrder != nil {
                    self.profitTiggerInput.input.text = self.stopProfitOrder?.px ?? ""
                    if self.stopProfitOrder?.category == BTContractOrderCategory.market {
                        self.profitMarketCover.isHidden = false
                    } else {
                        self.profitExcutiveInput.input.text = self.stopProfitOrder?.exec_px ?? ""
                    }
                }
            } else {
                self.profitTiggerInput.isUserInteractionEnabled = false
                self.profitExcutiveInput.isUserInteractionEnabled = false
                self.profitTiggerInput.input.text = ""
                self.profitExcutiveInput.input.text = ""
                self.profitMarketCover.isHidden = true
            }
        } else if sender == openLossBtn {
            
            lossMarketCover.isHidden = !lossMarketCover.isHidden
            if lossMarketCover.isHidden == true {
                self.lossExcutiveInput.input.endEditing(true)
            } else {
                self.lossExcutiveInput.input.text = positionModel?.lastPrice ?? "0"
            }
            if sender.isSelected == true {
                self.lossTiggerInput.isUserInteractionEnabled = true
                self.lossExcutiveInput.isUserInteractionEnabled = true
                if self.stopLossOrder != nil {
                    self.lossTiggerInput.input.text = self.stopLossOrder?.px ?? ""
                    if self.stopLossOrder?.category == BTContractOrderCategory.market {
                        self.lossMarketCover.isHidden = false
                    } else {
                        self.lossExcutiveInput.input.text = self.stopLossOrder?.exec_px ?? ""
                    }
                }
            } else {
                self.lossTiggerInput.isUserInteractionEnabled = false
                self.lossExcutiveInput.isUserInteractionEnabled = false
                self.lossTiggerInput.input.text = ""
                self.lossExcutiveInput.input.text = ""
                self.lossMarketCover.isHidden = true
            }
        }
    }
    
    @objc func clickProfitMarketBtn(recognizer:UITapGestureRecognizer) {
        guard (recognizer.view as? UILabel) != nil else {
            return
        }
        profitMarketCover.isHidden = !profitMarketCover.isHidden
        if profitMarketCover.isHidden == true {
            self.profitExcutiveInput.input.endEditing(true)
        } else {
            self.profitExcutiveInput.input.text = positionModel?.lastPrice ?? "0"
        }
    }
    
    @objc func clickLossMarketBtn(recognizer:UITapGestureRecognizer) {
        guard (recognizer.view as? UILabel) != nil else {
            return
        }
        lossMarketCover.isHidden = !lossMarketCover.isHidden
        if lossMarketCover.isHidden == true {
            self.lossExcutiveInput.input.endEditing(true)
        } else {
            self.lossExcutiveInput.input.text = positionModel?.lastPrice ?? "0"
        }
    }
    
    @objc func clickConfirmButton() {
        
        
        guard let postionModel = positionModel else {
            return
        }
        
        if openProfitBtn.isSelected == true {
            if self.profitTiggerInput.input.text?.count == 0 {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_please_enter_tigger"))
                return
            }
            if self.profitExcutiveInput.input.text?.count == 0 && profitMarketCover.isHidden == true {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_please_enter_exten"))
                return
            }
        } else if openLossBtn.isSelected == true {
            if self.lossTiggerInput.input.text?.count == 0 {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_please_enter_tigger"))
                return
            }
            if self.lossExcutiveInput.input.text?.count == 0 && lossMarketCover.isHidden == true {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_please_enter_exten"))
                return
            }
        }
        
        
        
        submitCount = 0
        let profitResult = takeProfitOrder()
        if profitResult.hasError == true {return}
        let lossResult = takeLossOrder()
        if lossResult.hasError == true { return }
        let profitOrder = profitResult.profit
        let lossOrder = lossResult.loss
      
        
        
      
        if let lossOrder = lossOrder{
            
            let isMore = postionModel.side == .openMore
            if isMore{
                if ((lossOrder.exec_px as NSString).isSmall(postionModel.earlyWarningPx)) || ((lossOrder.px as NSString).isSmall(postionModel.earlyWarningPx)) {
                    
                    let alert = EXNormalAlert()
                  
                    alert.configAlert(title: "common_text_tip".localized(), message: String(format: "contract_sting_moreProfitWaring".localized(),postionModel.earlyWarningPx), passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "kyc_action_submit".localized())
                    
                    alert.alertCallback = { [weak self] idx in
                        
                        if idx == 0{
                            self?.exuteSsumintOrder(profit: profitOrder, loss: lossOrder)
                        }
                    }
                    EXAlert.showAlert(alertView: alert)
                }else{
                    exuteSsumintOrder(profit: profitOrder, loss: lossOrder)
                }
                
            }else{
                
                if ((lossOrder.exec_px as NSString).isBig(postionModel.earlyWarningPx)) || ((lossOrder.px as NSString).isBig(postionModel.earlyWarningPx)){
                    let alert = EXNormalAlert()
            
                     alert.configAlert(title: "common_text_tip".localized(), message: String(format: "contract_sting_lessLossWaring".localized(), postionModel.earlyWarningPx), passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "kyc_action_submit".localized())
                    alert.alertCallback = { [weak self] idx in
                        if idx == 0{
                            self?.exuteSsumintOrder(profit: profitOrder, loss: lossOrder)
                        }
                    }
                    EXAlert.showAlert(alertView: alert)
                }else{
                    exuteSsumintOrder(profit: profitOrder, loss: lossOrder)
                }
                
            }
            return
        }
        
        exuteSsumintOrder(profit: profitOrder, loss: lossOrder)
        

    }
    
    private func exuteSsumintOrder(profit:BTContractOrderModel?,loss:BTContractOrderModel?){
        
        if profit != nil {
            submitOrder(profit!)
        } else {
            if stopProfitOrder != nil && openProfitBtn.isSelected == false {
                cancelOrders(stopProfitOrder!)
            }
        }
        if loss != nil {
            submitOrder(loss!)
        } else {
            if stopLossOrder != nil && openLossBtn.isSelected == false {
                cancelOrders(stopLossOrder!)
            }
        }
    }
    
    
    /// 提交止盈单
    private func takeProfitOrder() -> (profit: BTContractOrderModel?, hasError:Bool)  {
        let tigg_px = self.profitTiggerInput.input.text ?? "0"
        let ex_px = self.profitExcutiveInput.input.text ?? "0"
        if tigg_px.greaterThan("0") &&
            ex_px.greaterThan("0") &&
            (tigg_px != self.stopProfitOrder?.px || ex_px != self.stopProfitOrder?.exec_px || tiggerIndex != stopProfitOrder?.trigger_type) {
            let category = profitMarketCover.isHidden ? BTContractOrderCategory.normal : BTContractOrderCategory.market
            let side = (positionModel!.side == .openMore) ? BTContractOrderWay.sell_CloseLong : BTContractOrderWay.buy_CloseShort
            var pxWay = BTContractOrderPriceType.tradePriceType
            var trend = BTContractOrderPriceWay.up
            // 触发标准
            var tiggerStandardS = positionModel!.lastPrice
            if fairPriceBtn.isSelected {
                pxWay = .markPriceType
                tiggerStandardS = positionModel!.markPrice
            } else if indexPriceBtn.isSelected {
                pxWay = .indexPriceType
                tiggerStandardS = positionModel!.indexPrice
            }
            if (tigg_px.lessThan(tiggerStandardS)) { // 计划价格低于触发标准价格
                trend = .down;
            } else if (tigg_px.greaterThan(tiggerStandardS)) {
                trend = .up;
            } else {
                trend = .up;
            }
            /// 价格合理判断
            if positionModel?.side == .openMore { // 多头仓位 止盈
                if tigg_px.lessThan(tiggerStandardS) {
                    EXAlert.showFail(msg: String(format:LanguageTools.getString(key: "contract_stop_profit_long"),pxTypeStr))
                    return (nil,true)
                }
            } else if positionModel?.side == .openEmpty { // 空头仓位 止盈
                if tigg_px.greaterThan(tiggerStandardS) {
                    EXAlert.showFail(msg:  String(format:LanguageTools.getString(key: "contract_stop_profit_short"),pxTypeStr))
                    return (nil,true)
                }
            }
            let profitOrder = BTContractOrderModel.createPlanProfitOrLossOrder(withContractId: positionModel!.instrument_id,
                                                                               category: category,
                                                                               way: side,
                                                                               trigger_type: pxWay,
                                                                               trend: trend,
                                                                               exec_px: ex_px,
                                                                               cycle: cy,
                                                                               positionID: positionModel!.pid,
                                                                               profitOrLossType: .profitType,
                                                                               price: tigg_px)
            return (profitOrder,false)
        }
        EXAlert.showFail(msg: "contract_tips_price_limit".localized())
        
        return (nil,false)
    }
    
    /// 提交止损单
    private func takeLossOrder() -> (loss:BTContractOrderModel?,hasError:Bool) {
        let tigg_px = self.lossTiggerInput.input.text ?? "0"
        let ex_px = self.lossExcutiveInput.input.text ?? "0"
        if tigg_px.greaterThan("0") &&
            ex_px.greaterThan("0") &&
            (tigg_px != self.stopLossOrder?.px || ex_px != self.stopLossOrder?.exec_px || tiggerIndex != stopLossOrder?.trigger_type) {
            let category = lossMarketCover.isHidden ? BTContractOrderCategory.normal : BTContractOrderCategory.market
            let side = (positionModel!.side == .openMore) ? BTContractOrderWay.sell_CloseLong : BTContractOrderWay.buy_CloseShort
            var pxWay = BTContractOrderPriceType.tradePriceType
            var trend = BTContractOrderPriceWay.up
            // 触发标准
            var tiggerStandardS = positionModel!.lastPrice
            if fairPriceBtn.isSelected {
                pxWay = .markPriceType
                tiggerStandardS = positionModel!.markPrice
            } else if indexPriceBtn.isSelected {
                pxWay = .indexPriceType
                tiggerStandardS = positionModel!.indexPrice
            }
            if (tigg_px.lessThan(tiggerStandardS)) { // 计划价格低于当前价格
                trend = .down;
            } else if (tigg_px.greaterThan(tiggerStandardS)) {
                trend = .up;
            } else {
                trend = .up;
            }
            /// 价格合理判断
            if positionModel?.side == .openMore { // 多头仓位 止损
                if tigg_px.greaterThan(tiggerStandardS) {
                    EXAlert.showFail(msg: String(format:LanguageTools.getString(key: "contract_stop_loss_long"),pxTypeStr))
                    return (nil,true)
                }
                if tigg_px.lessThan(positionModel?.liquidate_price){
                    
                    EXAlert.showFail(msg: String(format: "contract_stop_loss_short".localized(), positionModel?.liquidate_price ?? ""))
                    
                    return (nil,true)
                }
                
                
            } else if positionModel?.side == .openEmpty { // 空头仓位 止损
                if tigg_px.lessThan(tiggerStandardS) {
                    EXAlert.showFail(msg: String(format:LanguageTools.getString(key: "contract_stop_loss_short"),pxTypeStr))
                    return (nil,true)
                }
                
                if tigg_px.greaterThan(positionModel?.liquidate_price){
                    
                    EXAlert.showFail(msg: String(format: "contract_stop_loss_long".localized(), positionModel?.liquidate_price ?? ""))
                                      
                        return (nil,true)
                }
                
            }
            let lossOrder = BTContractOrderModel.createPlanProfitOrLossOrder(withContractId: positionModel!.instrument_id,
                                                                             category: category,
                                                                             way: side,
                                                                             trigger_type: pxWay,
                                                                             trend: trend,
                                                                             exec_px: ex_px,
                                                                             cycle: cy,
                                                                             positionID: positionModel!.pid,
                                                                             profitOrLossType: .lossType,
                                                                             price: tigg_px)
            return (lossOrder,false)
        }
        EXAlert.showFail(msg: "contract_tips_price_limit".localized())
               
        return (nil,false)
    }
    
    private func submitOrder(_ order : BTContractOrderModel) {
        submitCount += 1
        BTContractTool.submitProfitOrLossOrder(order, assetPassword: nil, success: {[weak self] (idx) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            mySelf.clickStopProfitLoss?(true)
            if mySelf.submitCount == 0 {
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_tip_submitSuccess"))
                mySelf.navigationController?.popViewController(animated: true)
            }
        }) {[weak self] (error) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            guard let errStr = error as? String else {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tip_submitFailure"))
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
    
    private func cancelOrders(_ order : BTContractOrderModel) {
        submitCount += 1
        BTContractTool.cancelProfitOrLossOrder(order, assetPassword: nil, success: {[weak self] (idx) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            mySelf.clickStopProfitLoss?(true)
            if mySelf.submitCount == 0 {
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_tip_submitSuccess"))
                mySelf.navigationController?.popViewController(animated: true)
            }
        }) {[weak self] (error) in
            guard let mySelf = self else {return}
            mySelf.submitCount -= 1
            guard let errStr = error as? String else {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tip_submitFailure"))
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
    
    
    
}
