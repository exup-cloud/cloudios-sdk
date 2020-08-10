//
//  ContractTransactionLeftView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

let proportion_width : CGFloat = 215 / 375 * SCREEN_WIDTH//左边的宽度

class ContractTransactionLeftView: UIView {
    
    typealias ClickTakeOrderBlock = ([String : String]) -> ()
    var clickTakeOrderBlock : ClickTakeOrderBlock?
    
    var entity = ContractContentModel()
    {
        didSet{
            self.priceTextField.decimal = entity.pricePrecision
            self.leverageView.setView("")
            self.leverageView.leverageBtn.titleLabel.text = entity.maxLeverageLevel + "X"
            self.priceTextField.unitLabel.text = entity.quoteSymbol
            self.reloadTemporary()
        }
    }
    
    let btcPrecision = ContractPublicInfoManager.manager.getBtcPrecision()
    
    var timer : Timer?
    
    var temporary : [String : String] = ["contractId": "" , "volume" : "", "price" : "", "level" : "" , "orderType" : ""]
    
    var priceArr = ["contract_action_limitPrice".localized() , "contract_action_marketPrice".localized()]
    
    var initEntity = ContractTransactionInitEntity()
    
    var tagPriceEntity = ContractTransactionTagPrice()
    
    var isRequest = true
    
    //限价交易按钮
    lazy var priceBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.addTarget(self, action: #selector(clickPriceBtn), for: UIControlEvents.touchUpInside)
        btn.text(content: priceArr[0])
        btn.titleLabel.font = UIFont.ThemeFont.BodyRegular
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        return btn
    }()
    
    //杠杆
    lazy var leverageView : LeverageView = {
        let view = LeverageView()
        view.extUseAutoLayout()
        if entity.leverTypes_arr.count > 0{
            view.setView(entity.leverTypes_arr[0])
        }
        view.clickLeverageBlock = {[weak self] in
            self?.popupLeverage()
        }
        return view
    }()
    
    //价格
    lazy var priceTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.setPlaceHolder(placeHolder: "contract_text_price".localized())
//        textField.pre
        textField.textfieldValueChangeBlock = {[weak self]str in
            self?.reloadTemporary()
        }
        textField.input.rx.text.orEmpty.changed.asObservable().subscribe { (event) in
            if let str = event.element{
                if str.count > 15{
                    textField.input.text = str[0...15]
                }
            }
        }.disposed(by: self.disposeBag)
        textField.input.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()

    //仓位
    lazy var positionsTextField : EXBorderField = {
        let textField = EXBorderField()
        textField.extUseAutoLayout()
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.setPlaceHolder(placeHolder: "contract_text_positionNumber".localized())
        textField.unitLabel.text = "contract_text_volumeUnit".localized()
        textField.textfieldValueChangeBlock = {[weak self]str in
            self?.reloadTemporary()
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
    
    //委托价值
    lazy var entrustLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "contract_text_entrustValue".localized() + "--"
        return label
    }()
    
    //可用余额
    lazy var availableLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.text = "withdraw_text_available".localized() + "--"
        return label
    }()
    
    //市价提示框
    lazy var marketPriceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.backgroundColor = UIColor.ThemeNav.bg
        label.text = "   " + "common_tip_bestPriceTransaction".localized()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.extSetCornerRadius(1.5)
        label.font = UIFont.ThemeFont.BodyRegular
        label.extSetBorderWidth(0.5, color: UIColor.ThemeView.seperator)
        label.isHidden = true
        label.textAlignment = .left
        return label
    }()
    
    //买入成本
    lazy var buyCostLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        return label
    }()
    
    //买入按钮
    lazy var buyBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(popupLimitedPromptView))
        btn.setTitle("contract_action_long".localized(), for: UIControlState.normal)
        btn.color = UIColor.ThemekLine.up
        return btn
    }()
    
    //卖出成本
    lazy var sellCostLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        return label
    }()
    
    //卖出按钮
    lazy var sellBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(popupLimitedPromptView))
        btn.setTitle("contract_action_short".localized(), for: UIControlState.normal)
        btn.color = UIColor.ThemekLine.down
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        self.addSubViews([priceBtn,leverageView,priceTextField,positionsTextField,marketPriceLabel,entrustLabel,availableLabel,buyCostLabel,buyBtn,sellCostLabel,sellBtn])
        priceBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(proportion_width - 15)
        }
        
        leverageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(36)
            make.top.equalTo(priceBtn.snp.bottom).offset(12)
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(leverageView.snp.bottom).offset(15)
        }
        
        positionsTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(priceTextField.snp.bottom).offset(15)
        }
        
        marketPriceLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(priceTextField)
        }
        
        entrustLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(positionsTextField.snp.bottom).offset(8)
        }
        
        availableLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(17)
            make.top.equalTo(entrustLabel.snp.bottom).offset(7)
        }
        
        buyCostLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(20)
            make.top.equalTo(availableLabel.snp.bottom).offset(12)
        }
        
        buyBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(buyCostLabel.snp.bottom).offset(3)
        }
        
        sellCostLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(20)
            make.top.equalTo(buyBtn.snp.bottom).offset(13)
        }
        
        sellBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(leverageView)
            make.height.equalTo(36)
            make.top.equalTo(sellCostLabel.snp.bottom).offset(3)
        }
        
        timer = Timer.init(timeInterval: 1, repeats: true, block: {[weak self] (timer1) in
            guard let mySelf = self else{return}
            if timer1 == mySelf.timer{
                mySelf.getInitTakeOrder(completion: {
                    
                })
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ContractTransactionLeftView{
    
//    func fireTimer(){
//        timer?.fireDate = Date.init()
//    }
//
//    func stopTimer(){
//        timer?.fireDate = Date.distantFuture
//    }
    
    //弹出杠杆
    func popupLeverage(){
        var arr = entity.leverTypes_arr
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
//            mySelf.leverageView.setView(mySelf.entity.leverTypes_arr[idx])
            mySelf.changeLevel(mySelf.entity.leverTypes_arr[idx])
            mySelf.leverageView.leverageBtn.reset()
//            mySelf.reloadTemporary()
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.leverageView.leverageBtn.reset()
        }
        var idx = 0
        for i in 0..<arr.count{
            if arr[i] == leverageView.leverage{
                idx = i
                break
            }
        }
        for i in 0..<arr.count{
            arr[i] = arr[i] + "X"
        }
        sheet.configButtonTitles(buttons:  arr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    //更新杠杆
    func changeLevel(_ level : String){
        contractApi.rx.request(ContractAPIEndPoint.changeLevel(contractId: self.entity.id, level: level)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            guard let mySelf = self else{return}
            mySelf.leverageView.setView(level)
            mySelf.reloadTemporary()
            mySelf.getInitTakeOrder(completion: {
                
            })
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    //更新合约交易页面
    func reloadView(){
        setBuyCost(self.setCost("--"))
        setSellCost(self.setCost("--"))
        positionsTextField.input.text = ""
        priceTextField.input.text = ""
        entrustLabel.text = "contract_text_entrustValue".localized() + "--"
        availableLabel.text = "withdraw_text_available".localized() + "--"
    }
    
    //更新临时字典
    func reloadTemporary(){
        if temporary["contractId"] != entity.id{
            temporary["contractId"] = entity.id
            isRequest = true
        }
        if temporary["volume"] != positionsTextField.input.text{
            temporary["volume"] = positionsTextField.input.text
            isRequest = true
        }
        
        if temporary["price"] != priceTextField.input.text{
            temporary["price"] = priceTextField.input.text
            isRequest = true
        }
        if temporary["level"] != leverageView.leverage{
            temporary["level"] = leverageView.leverage
            isRequest = true
        }
        if priceBtn.titleLabel.text == priceArr[0]{
            if temporary["orderType"] != "1"{
                temporary["orderType"] = "1"
                isRequest = true
            }
        }else{
            if temporary["orderType"] != "2"{
                temporary["orderType"] = "2"
                isRequest = true
            }
        }
    }
    
    //获取initTakeOrder
    func getInitTakeOrder(_ hideAutoLoading : Bool = true , completion : @escaping (() -> ())){
        
        if XUserDefault.getToken() == nil{
            return
        }
        if isRequest == false{
            return
        }
        guard let id = temporary["contractId"] else{return}
        if id == ""{return}
        guard let volume = temporary["volume"] else{return}
        guard let price = temporary["price"] else{return}
        guard let level = temporary["level"] else{return}
        guard let orderType = temporary["orderType"] else{return}
        if hideAutoLoading == true{
            contractApi.hideAutoLoading()
        }
        contractApi.rx.request(ContractAPIEndPoint.initTakeOrder(contractId: id, volume: volume, price: price, level: level, orderType: orderType)).MJObjectMap(ContractTransactionInitEntity.self).subscribe(onSuccess: {[weak self] (entity) in
            guard let mySelf = self else{return}
            mySelf.initEntity = entity
            if (self?.priceTextField.input.text == "" && self?.temporary["orderType"] == "1") || self?.positionsTextField.input.text == ""{
                self?.setEntrust("contract_text_entrustValue".localized() + " " + "--")
                self?.setBuyCost(mySelf.setCost("--"))
                self?.setSellCost(mySelf.setCost("--"))
            }else{
                self?.setEntrust("contract_text_entrustValue".localized() + " " + (entity.orderPriceValue as NSString).decimalString1(mySelf.btcPrecision) + " BTC")
                self?.setBuyCost(mySelf.setCost((entity.buyOrderCost as NSString).decimalString1(mySelf.btcPrecision) + " BTC"))
                self?.setSellCost(mySelf.setCost((entity.sellOrderCost as NSString).decimalString1(mySelf.btcPrecision) + " BTC"))
            }
            
            self?.setAvailable("withdraw_text_available".localized() + " " + (entity.canUseBalance as NSString).decimalString1(mySelf.btcPrecision) + " " + "BTC")
            self?.leverageView.setView(entity.level)
            self?.isRequest = false
            completion()
        }) {[weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self?.isRequest = true
//                self?.getInitTakeOrder(completion: {
//
//                })
            })
        }.disposed(by: disposeBag)
    }
    
    //设置成本
    func setCost(_ str : String) -> NSMutableAttributedString{
        let att = NSMutableAttributedString().add(string: "contract_text_cost".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium , NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular]).add(string: " " + str, attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite , NSAttributedStringKey.font : UIFont.ThemeFont.BodyRegular])
        return att
    }
    
    //更细杠杆倍数
    func reloadLevel(){
        self.leverageView.setView("")
        self.reloadTemporary()
        self.isRequest = true
    }
    
    //弹出限价
    @objc func popupLimitedPromptView(_ btn : UIButton){
        
        if XUserDefault.getToken() == nil{
            BusinessTools.modalLoginVC()
            return
        }
        
        var param : [String : String] = [:]
        
        if positionsTextField.input.text == ""{
            EXAlert.showFail(msg: "contract_tip_pleaseInputPosition".localized())
            return
        }
        param["volume"] = positionsTextField.input.text
        
        if priceBtn.titleLabel.text == priceArr[0]{
            param["orderType"] = "1"
        }else{
            param["orderType"] = "2"
        }
        
        if param["orderType"] == "1"{
            if priceTextField.input.text == ""{
                EXAlert.showFail(msg: "contract_tip_pleaseInputPrice".localized())
                return
            }
            param["price"] = priceTextField.input.text
        }else{
            param["price"] = ""
        }
        
        param["level"] = leverageView.leverage
        if btn == buyBtn{
            param["side"] = "BUY"
            param["cost"] = self.initEntity.buyOrderCost
        }else{
            param["side"] = "SELL"
            param["cost"] = self.initEntity.sellOrderCost
        }
        
        param["canUseBalance"] = self.initEntity.canUseBalance
        param["orderPriceValue"] = self.initEntity.orderPriceValue
        param["tagPrice"] = self.tagPriceEntity.tagPrice
        
//        if let orderType = param["orderType"] , orderType == "1"{
        isRequest = true
        self.getInitTakeOrder(false, completion: {
            let view = ContractLimitedPromptView()
            view.extUseAutoLayout()
            view.setView(self.entity, param: param)
            view.clickConfirmBlock = {[weak self]param in
                self?.takeOrder(param)
            }
            guard let appDelegate  = UIApplication.shared.delegate else {
                return
            }
            if appDelegate.window != nil   {
                appDelegate.window??.rootViewController?.view.addSubview(view)
                appDelegate.window??.rootViewController?.view.bringSubview(toFront: view)
                view.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        })
//            return
//        }
//        takeOrder(param)
    }
    
    //下单
    func takeOrder(_ param : [String : String]){
        self.clickTakeOrderBlock?(param)
    }
    
    //设置价格
    func setPrice(_ price : String){
        if priceTextField.input.text == "" && price != ""{
            priceTextField.input.text = price
        }
    }
    
}

extension ContractTransactionLeftView{
    
    //点击限价
    @objc func clickPriceBtn(){
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.marketPriceLabel.isHidden = idx == 0
            mySelf.priceBtn.text(content: mySelf.priceArr[idx])
            mySelf.priceBtn.reset()
            mySelf.reloadTemporary()
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.priceBtn.reset()
        }
        var idx = 0
        for i in 0..<priceArr.count{
            if priceArr[i] == priceBtn.titleLabel.text{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  priceArr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    //设置委托价值
    func setEntrust(_ price : String){
        entrustLabel.text = price
    }
    
    //设置余额
    func setAvailable(_ price : String){
        availableLabel.text = price
    }
    
    //设置买入成本
    func setBuyCost(_ buy : NSMutableAttributedString){
        buyCostLabel.attributedText = buy
    }
    
    //设置卖出成本
    func setSellCost(_ sell : NSMutableAttributedString){
        sellCostLabel.attributedText = sell
    }
    
}

class LeverageView : UIView{
    
    typealias ClickLeverageBlock = () -> ()
    var clickLeverageBlock : ClickLeverageBlock?
    var leverage = ""
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.text = LanguageTools.getString(key: "contract_action_lever")
        return label
    }()
    
    lazy var leverageBtn : EXDirectionButton = {
        let btn = EXDirectionButton()
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        btn.titleLabel.textColor = UIColor.ThemeLabel.colorLite
        btn.titleLabel.font = UIFont.ThemeFont.SecondaryRegular
        btn.layoutIfNeeded()
        btn.setAlighment(margin: HorizontalMargin.marginRight)
        btn.backgroundColor = UIColor.ThemeNav.bg
        btn.container.backgroundColor = UIColor.ThemeNav.bg
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([nameLabel,leverageBtn])
        self.backgroundColor = UIColor.ThemeNav.bg
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(leverageBtn.snp.left)
        }
        leverageBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickSelf))
        self.addGestureRecognizer(tap)
    }
    
    @objc func clickSelf(){
        self.clickLeverageBlock?()
    }
    
    func setView(_ leverage : String){
        self.leverage = leverage
        leverageBtn.titleLabel.text = leverage
    }
    
    func setEnableEditing(_ isEdit : Bool) {
        if isEdit == true {
            nameLabel.textColor = UIColor.ThemeLabel.colorLite
            leverageBtn.titleLabel.textColor = UIColor.ThemeLabel.colorLite
        } else {
            leverageBtn.titleLabel.textColor = UIColor.ThemeLabel.colorLite.withAlphaComponent(0.5)
            nameLabel.textColor = UIColor.ThemeLabel.colorLite.withAlphaComponent(0.5)
        }
        leverageBtn.isEnabled = isEdit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
