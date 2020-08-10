//
//  SLSwapDoubleComfirmAlertView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/14.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

// 开仓二次确认框
class SLSwapDoubleComfirmAlertView: UIView {
    

    var confirmCallback: (() -> ())?
    var confimModelCallBack:((BTProfitOrLossModel) -> ())?
    
    var currentModel:BTContractOrderModel?
    
    lazy var typeLabel: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemekLine.up, alignment: .left)
    lazy var nameLabel: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.HeadMedium, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    let tempHidProOrLoss:Bool = true
    
    lazy var stopProfitV : SLStopProfitOrLossV = {
        let object = SLStopProfitOrLossV()
        object.setView(.profit)
        
        object.backgroundColor = UIColor.ThemeView.bg
        
        return object
    }()

    lazy var stopLossV : SLStopProfitOrLossV = {
        let object = SLStopProfitOrLossV()
        object.setView(.loss)
        object.backgroundColor = UIColor.ThemeView.bg
        
        return object
    }()
    
    lazy var headerbg : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg

        return view
    }()
    
    lazy var priceView : SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.bottomLabel.font = UIFont.ThemeFont.BodyBold
        return view
    }()
    
    lazy var volumeView : SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.contentAlignment = .center
        view.bottomLabel.font = UIFont.ThemeFont.BodyBold
        return view
    }()
    
    lazy var leverageView : SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.contentAlignment = .right
        view.bottomLabel.font = UIFont.ThemeFont.BodyBold
        return view
    }()
    
    lazy var tipsLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.red, alignment: .left)
    
    lazy var orderValueView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("contract_text_entrustValue".localized())
        return view
    }()
    
    lazy var costView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("contract_text_cost".localized()+"@10X")
        return view
    }()
    
    lazy var balanceView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("withdraw_text_available".localized())
        return view
    }()
    
    lazy var positionSizeView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("contract_position_size_after_closing".localized())
        return view
    }()
    
    lazy var tipsBtn : UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "Checkbox_default"))
        button.setImage(UIImage.themeImageNamed(imageName: "Checkbox_Focus"), for: .selected)
        button.extSetAddTarget(self, #selector(clickNextComfirmButton))
        return button
    }()
    
    lazy var nextComfirmLabel: UILabel = UILabel(text: "contract_next_remind".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnCancel".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
    private lazy var confirmButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnConfirm".localized(), titleFont: UIFont.ThemeFont.HeadBold, titleColor: UIColor.ThemeBtn.highlight)
        button.extSetAddTarget(self, #selector(clickConfirmButton))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 1.5
        self.backgroundColor = UIColor.ThemeView.bg
        self.tipsLabel.numberOfLines = 0
        self.addSubViews([typeLabel,
                          nameLabel,
                          stopProfitV,
                          stopLossV,
                          headerbg,
                          priceView,
                          volumeView,
                          leverageView,
                          tipsLabel,
                          orderValueView,
                          costView,
                          balanceView,
                          positionSizeView,
                          tipsBtn,
                          nextComfirmLabel,
                          cancelButton,
                          confirmButton])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        typeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(18)
        }
        nameLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(typeLabel)
            make.top.equalTo(typeLabel.snp_bottom).offset(5)
        }
        stopProfitV.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(nameLabel.snp_bottom).offset(15)
        }

        stopLossV.snp.makeConstraints { (make) in
            make.left.right.equalTo(stopProfitV)
            make.top.equalTo(stopProfitV.snp_bottom).offset(10)
        }
        
        headerbg.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(stopLossV.snp_bottom).offset(30)
            make.height.equalTo(62)
        }
        
        priceView.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(headerbg.snp_top).offset(10)
            make.centerY.equalTo(headerbg.snp.centerY)
            make.height.equalTo(32)
        }
        volumeView.snp_makeConstraints { (make) in
            make.top.height.width.equalTo(priceView)
            make.centerX.equalToSuperview()
        }
        leverageView.snp_makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.height.width.equalTo(priceView)
        }
        tipsLabel.snp_makeConstraints { (make) in
            make.left.equalTo(typeLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headerbg.snp_bottom).offset(5)
        }
        orderValueView.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(tipsLabel.snp_bottom)
            make.height.equalTo(30)
        }
        costView.snp_makeConstraints { (make) in
            make.left.right.equalTo(orderValueView)
            make.top.equalTo(orderValueView.snp_bottom)
            make.height.equalTo(30)
        }
        balanceView.snp_makeConstraints { (make) in
            make.left.right.equalTo(orderValueView)
            make.top.equalTo(costView.snp_bottom)
            make.height.equalTo(30)
        }
        positionSizeView.snp_makeConstraints { (make) in
            make.left.right.equalTo(orderValueView)
            make.top.equalTo(balanceView.snp_bottom)
            make.height.equalTo(30)
        }
        tipsBtn.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel).offset(-5)
            make.top.equalTo(positionSizeView.snp_bottom).offset(10)
            make.height.width.equalTo(25)
        }
        nextComfirmLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipsBtn.snp.right)
            make.right.equalTo(orderValueView)
            make.height.equalTo(20)
            make.centerY.equalTo(tipsBtn)
        }
        confirmButton.snp_makeConstraints { (make) in
            make.top.equalTo(tipsBtn.snp_bottom).offset(20)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(20)
            make.bottom.equalTo(-56)
        }
        cancelButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(confirmButton)
            make.right.equalTo(confirmButton.snp_left).offset(-30)
        }
        tipsLabel.isHidden = true
    }
    
// MARK: - Update
    func config(_ order : BTContractOrderModel) {
        let tips = order.forceTips
        self.currentModel = order
        if tips != "" {
            tipsLabel.isHidden = false
            tipsLabel.text = tips
            tipsLabel.snp_remakeConstraints { (make) in
                make.left.equalTo(typeLabel)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(25)
                make.top.equalTo(headerbg.snp_bottom).offset(5)
            }
        }
        var category = "contract_action_limitPrice".localized()
        var type = "contract_action_buy".localized()
        var color = UIColor.ThemekLine.up
        nameLabel.text = order.name
        if order.side == .sell_OpenShort {
            type = "contract_action_sell".localized()
            color = UIColor.ThemekLine.down
        }
        typeLabel.textColor = color
        
         if order.cycle != nil{
            
            self.stopLossV.isHidden = true
            self.stopProfitV.isHidden = true
            headerbg.snp.remakeConstraints { (make) in
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.top.equalTo(nameLabel.snp_bottom).offset(20)
                    make.height.equalTo(62)
            }
          
            
        }
        
        self.configProfitOrLoss(order: order)
        
        if order.exec_px != nil && order.exec_px.greaterThan(BT_ZERO) {
            if order.category == .market {
                category = "contract_action_marketPrice".localized()
                volumeView.bottomLabel.text = category
                orderValueView.isHidden = true
                costView.isHidden = true
                balanceView.snp_remakeConstraints { (make) in
                    make.left.equalTo(10)
                    make.right.equalToSuperview().offset(-10)
                    make.top.equalTo(tipsLabel.snp_bottom).offset(5)
                    make.height.equalTo(30)
                }
            } else {
                volumeView.bottomLabel.text = order.exec_px
            }
            typeLabel.text = category + type + "contract_alert_plan".localized()
            priceView.topLabel.text = "contract_trigger_price".localized()
            priceView.bottomLabel.text = order.px
            
            volumeView.topLabel.text = "contract_excutive_price".localized()
            leverageView.topLabel.text = "charge_text_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")"
            leverageView.bottomLabel.text = order.qty
            
            orderValueView.setLeftText("contract_action_lever".localized())
            var leverage = "contract_Fixed_position".localized()
            if order.position_type == .allType {
                leverage = "contract_Cross_position".localized()
            }
            orderValueView.setRightText(leverage + order.leverage + "X")
            
            costView.setLeftText("contract_alert_tigger_type".localized())
            var priceType = "contract_text_indexPrice".localized()
            if order.trigger_type == .tradePriceType {
                priceType = "contract_last_price".localized()
            } else if order.trigger_type == .markPriceType {
                priceType = "contract_text_markPrice".localized()
            }
            costView.setRightText(priceType)
            
            var dateStr = "contract_cycle_oneweek".localized()
            if order.cycle.intValue == 24 {
                dateStr = "contract_cycle_oneday".localized()
            }
            balanceView.setLeftText("contract_effective_time".localized())
            balanceView.setRightText(dateStr)
        } else {
            if order.category == .market {
                category = "contract_action_marketPrice".localized()
                priceView.bottomLabel.text = category
                orderValueView.isHidden = true
                costView.isHidden = true
                balanceView.snp_remakeConstraints { (make) in
                    make.left.equalTo(10)
                    make.right.equalToSuperview().offset(-10)
                    make.top.equalTo(tipsLabel.snp_bottom).offset(5)
                    make.height.equalTo(30)
                }
            } else {
                priceView.bottomLabel.text = order.px
            }
            typeLabel.text = category + type
            
            priceView.topLabel.text = "contract_text_price".localized() + "(" + order.contractInfo.quote_coin + ")"
            
            volumeView.topLabel.text = "charge_text_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")"
            volumeView.bottomLabel.text = order.qty
            
            leverageView.topLabel.text = "contract_action_lever".localized()
            var leverage = "contract_Fixed_position".localized()
            if order.position_type == .allType {
                leverage = "contract_Cross_position".localized()
            }
            leverageView.bottomLabel.text = leverage + order.leverage + "X"
            
            var value = order.avai.toSmallValue(withContract:order.instrument_id) ?? "0"
            value = value + order.contractInfo.margin_coin
            orderValueView.setRightText(value)
            
            var cost = (order.freezAssets ?? "0").toSmallValue(withContract: order.instrument_id) ?? "0"
            cost = cost + order.contractInfo.margin_coin
            costView.setLeftText("contract_text_cost".localized() + "@" + order.leverage + "X")
            costView.setRightText(cost)
            
            var balance = order.balanceAssets.toSmallValue(withContract: order.instrument_id) ?? "0"
            balance = balance + order.contractInfo.margin_coin
            balanceView.setRightText(balance)
        }
        let itemModel = BTItemModel()
        itemModel.instrument_id = order.instrument_id
        let position = SLFormula.getUserPosition(with: itemModel, contractWay: order.side)
        var holdVol = order.qty ?? "0"
        holdVol = holdVol.bigAdd(position.cur_qty ?? "0")
        positionSizeView.setRightText(holdVol)
    }
    
// MARK: - Click Events
    
    func configProfitOrLoss(order : BTContractOrderModel)  {
        self.stopLossV.px_unit = order.quote_coin
        self.stopLossV.px_unitValue = order.contractInfo.px_unit
        self.stopProfitV.px_unit = order.quote_coin
        self.stopProfitV.px_unitValue = order.contractInfo.px_unit
        self.stopLossV.forceClosePrice = order.liquidatePrice
        self.stopLossV.lastPrice = order.currentPrice
        self.stopProfitV.forceClosePrice = order.liquidatePrice
        self.stopProfitV.lastPrice = order.currentPrice
        self.stopProfitV.side = order.side
        self.stopLossV.side = order.side
        self.stopProfitV.isProfit = true
        self.stopLossV.isProfit = false
    }
    
    @objc func clickCancelButton() {
        EXAlert.dismiss()
    }
    
    @objc func clickConfirmButton() {
        
        
        let isStopprofit = stopProfitV.isSetProfitOrLoss()
        let isStopLoss = stopLossV.isSetProfitOrLoss()
        if isStopprofit && !stopProfitV.isInfoVaild(){
            stopProfitV.errorShake()
            return
        }
        if isStopLoss && !stopLossV.isInfoVaild(){
            stopLossV.errorShake()
            return
        }
        let model = BTProfitOrLossModel()
        setmMssionType(isStopprofit: isStopprofit, isStopLoss: isStopLoss, model: model)
        setLossInfo(info: stopLossV.profitOrLossInfo(), model: model)
        setProifInfo(info: stopProfitV.profitOrLossInfo(), model: model)
        
        if tipsBtn.isSelected {
            XUserDefault.setComfirmSwapAlert(false)
        }
        
        let strongtempself = self
        
        EXAlert.dismissEnd{
            
            //止损
            if isStopLoss {
                guard let order = self.currentModel else {
                    return
                }
                let isMore = order.side == .buy_OpenLong
                //多
                if isMore {
                    
                    if (model.loss_price as NSString) .isSmall(order.earlyWarningPx) ||
                        (model.loss_ex_price as NSString) .isSmall(order.earlyWarningPx){
                        
                        let message = String(format: "contract_sting_moreProfitWaring".localized(), order.earlyWarningPx)
                        let alert = EXNormalAlert()
                        alert.configAlert(title: "common_text_tip".localized(), message: message, passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "kyc_action_submit".localized())
                        
                        alert.alertCallback = {  tag in
                            
                            if tag == 0 {
                        
                                 strongtempself.confimModelCallBack?(model)
                            }
                            
                        }
                        EXAlert.showAlert(alertView: alert)
                        
                    }else{
                        self.confimModelCallBack?(model)
                    }
                    
                }else{
                    //空
                    if (model.loss_price as NSString).isBig(order.earlyWarningPx) ||
                        (model.loss_ex_price as NSString) .isBig(order.earlyWarningPx){
                        
                        
                        let message = String(format: "contract_sting_lessLossWaring".localized(), order.earlyWarningPx)
                        
                        let alert = EXNormalAlert()
                        alert.configAlert(title: "common_text_tip".localized(), message: message, passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "kyc_action_submit".localized())
                        alert.alertCallback = {  tag in
                    
                            if tag == 0 {
                                strongtempself.confimModelCallBack?(model)
                            }
                            
                        }
                        EXAlert.showAlert(alertView: alert)
                        
                    }else{
                        self.confimModelCallBack?(model)
                    }
                    
                }
                
            }else{
                self.confimModelCallBack?(model)
            }

          
        }
        

       
    }
    
 
    
    @objc func clickNextComfirmButton() {
        tipsBtn.isSelected = !tipsBtn.isSelected
    }
}

extension SLSwapDoubleComfirmAlertView {
    
    func setmMssionType(isStopprofit:Bool,isStopLoss:Bool,model:BTProfitOrLossModel) {
        
        if isStopprofit && isStopLoss {
            model.missionType = .SWAPMISSIONORDER_TYPE_ALL
        }else if isStopprofit && !isStopLoss {
            model.missionType = .SWAPMISSIONORDER_TYPE_PROFIT
        }else if !isStopprofit && isStopLoss {
            
            model.missionType = .SWAPMISSIONORDER_TYPE_LOSS
        }else{
            
            model.missionType = .SWAPMISSIONORDER_TYPE_NONE
        }
    }
    
    func setProifInfo(info:(triggerprice:String,excutePrice:String,isMarket:Bool),model:BTProfitOrLossModel)  {
        
        model.profit_price_type = .tradePriceType
        model.profit_price = info.triggerprice
        model.profit_ex_price = info.isMarket ? info.triggerprice : info.excutePrice
        model.profit_category = info.isMarket ? 2 : 1
        
    }
    
    func setLossInfo(info:(triggerprice:String,excutePrice:String,isMarket:Bool),model:BTProfitOrLossModel)  {
        
        model.loss_price_type = .tradePriceType
        model.loss_price = info.triggerprice
        model.loss_ex_price = info.isMarket ? info.triggerprice : info.excutePrice
        model.loss_category = info.isMarket ? 2 : 1
        
    }
    
    
    
    
    
    
}
