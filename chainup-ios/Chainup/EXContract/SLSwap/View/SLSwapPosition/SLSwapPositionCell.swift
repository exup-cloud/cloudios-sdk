//
//  SLSwapPositionCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 仓位 cell 也用于 币种详情
class SLSwapPositionCell : UITableViewCell {
    
    typealias NeedReloadCellBlock = () -> ()
    var needReloadCellBlock : NeedReloadCellBlock?
    
    /// 是否显示顶部 title, 区分 仓位 和 币种详情
    var isShowTitleView: Bool = false {
        didSet {
            self.titleLabel.isHidden = !self.isShowTitleView
            self.marginLine1.isHidden = !self.isShowTitleView
            if (self.isShowTitleView) {
                dealTypeLabel.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(15)
                    make.top.equalTo(marginLine1.snp_bottom).offset(15)
                    make.height.equalTo(22)
                }
            } else {
                dealTypeLabel.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(15)
                    make.top.equalToSuperview().offset(15)
                    make.height.equalTo(22)
                }
            }
        }
    }
    
    var positionModel : BTPositionModel?
    
    /// 持仓
    private lazy var titleLabel: UILabel = {
        let label = UILabel(text: "--"+"contract_action_holdMargin".localized(), font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        label.isHidden = true
        return label
    }()
    
    private lazy var marginLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        view.isHidden = true
        return view
    }()

    /// 多 空 类型
    lazy var dealTypeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadMedium, textColor: nil, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 合约名称
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 合约类型
    lazy var contractTypeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        label.layer.borderWidth = 0.6
        label.layer.borderColor = UIColor.ThemeView.border.cgColor
        label.layer.cornerRadius = 1.5
        label.layer.masksToBounds = true
        return label
    }()
    
    /// 分享
    lazy var shareButton: UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "contract_share"))
        button.extSetAddTarget(self, #selector(clickShareButton))
        return button
    }()
    
    lazy var shareLabel: UILabel = {
        let label = UILabel(text: "contract_share_label".localized(), font: UIFont.ThemeFont.SecondaryMedium, textColor: UIColor.ThemeLabel.colorHighlight, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickShareButton))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    /// 开仓均价
    lazy var openAverageView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_cost_position_price".localized())
        return view
    }()
    
    /// 未实现盈亏
    lazy var PLNView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_unrealisedPNL".localized())
//        view.isShowTipButton = true
//        view.clickMiddleBtnBlock = { [weak self] in
//            let alert = EXNormalAlert()
//            var pxtype = "contract_text_fairPrice".localized()
//            let idx = BTStoreData.storeObject(forKey: ST_UNREA_CARCUL) as? Int ?? 0
//            if idx == 1 {
//                pxtype = "contract_last_price".localized()
//            }
//            alert.configSigleAlert(title: "common_text_tip".localized(), message: String(format: "contract_alert_text_unrealized_profit_and_loss".localized(), pxtype))
//            EXAlert.showAlert(alertView: alert)
//        }
        return view
    }()
    
    lazy var PLNRate: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_returnRateUnit".localized())
        return view
    }()
    
    /// 虚线
    lazy var dottedLineView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    /// 实际杠杆
    lazy var actualLevel: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_position_actual_level".localized() + " (" + "contract_position_level".localized() + ")")
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        return view
    }()
    
    /// 持仓量
    lazy var holdingVolumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_position_holding".localized() + " (" + "contract_text_volumeUnit".localized() + ")")
        view.contentAlignment = .right
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        return view
    }()
    
    /// 可平仓数量
    lazy var canCloseVolumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_positon_can_close".localized() + " (\("contract_text_volumeUnit".localized()))")
        view.contentAlignment = .right
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        return view
    }()
    
    /// 仓位价值
    lazy var valueView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_positon_value".localized() + " (USDT)")
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        return view
    }()
    
    /// 预期强平价格
    lazy var flatPriceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_positon_expect_liqPrice".localized())
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        view.isShowTipButton = true
        view.clickMiddleBtnBlock = { [weak self] in
            let alert = EXNormalAlert()
            alert.configSigleAlert(title: "common_text_tip".localized(), message: "contract_alert_text_forced_liquidation".localized())
            EXAlert.showAlert(alertView: alert)
        }
        return view
    }()
    
    /// 保证金
    lazy var depositView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_margin".localized() + " (USDT)")
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
        return view
    }()
    
    /// 已实现盈亏额
    lazy var PLEDView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_positon_realised_value".localized() + " (USDT)")
        view.bottomLabel.font = UIFont.ThemeFont.SecondaryRegular
//        view.isShowTipButton = true
//        view.clickMiddleBtnBlock = { [weak self] in
//            let alert = EXNormalAlert()
//            alert.configSigleAlert(title: "common_text_tip".localized(), message: "contract_alert_text_currentposition_realityprofit".localized())
//            EXAlert.showAlert(alertView: alert)
//        }
        return view
    }()
    
    /// 横线
    lazy var horLineView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    /// 竖线
    lazy var verLineView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    /// 竖线
    lazy var verLineView2: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    /// 调整保证金
    lazy var adjustDepositButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_adjust_deposit".localized(), titleFont: UIFont.ThemeFont.HeadBold, titleColor: UIColor.ThemeBtn.highlight)
        button.extSetAddTarget(self, #selector(clickAdjustDepositButton))
        return button
    }()
    
    /// 止盈止损
    lazy var stopProfitOrLossButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_stop_profit_loss".localized(), titleFont: UIFont.ThemeFont.HeadBold, titleColor: UIColor.ThemeBtn.highlight)
        button.extSetAddTarget(self, #selector(clickStopProfitOrLossButton))
        return button
    }()
    
    /// 平仓
    lazy var closeContractButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_action_closeContract".localized(), titleFont: UIFont.ThemeFont.HeadBold, titleColor: UIColor.ThemeBtn.highlight)
        button.extUseAutoLayout()
        button.extSetAddTarget(self, #selector(clickCloseContractButton))
        return button
    }()
    
    /// 底部分隔视图
    lazy var bottomMarginView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([titleLabel, marginLine1, dealTypeLabel, nameLabel, contractTypeLabel, shareButton, openAverageView, PLNView, PLNRate, dottedLineView, actualLevel, holdingVolumeView, canCloseVolumeView, valueView, flatPriceView, depositView, PLEDView, horLineView, verLineView, adjustDepositButton, closeContractButton, bottomMarginView,shareLabel,stopProfitOrLossButton,verLineView2])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin = 15
        let verMargin = 10
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horMargin)
            make.top.equalToSuperview().offset(horMargin)
            make.height.equalTo(22)
        }
        marginLine1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(titleLabel.snp_bottom).offset(horMargin)
        }
        dealTypeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horMargin)
            make.top.equalToSuperview().offset(horMargin)
            make.height.equalTo(22)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel.snp.right).offset(5)
            make.height.equalTo(19)
            make.centerY.equalTo(dealTypeLabel)
        }
        contractTypeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        shareLabel.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.right.equalTo(-horMargin)
            make.centerY.equalTo(dealTypeLabel)
        }
        shareButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(shareLabel.snp.left).offset(-5)
            make.centerY.equalTo(dealTypeLabel)
        }
        openAverageView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(dealTypeLabel.snp.bottom).offset(15)
        }
        PLNView.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(openAverageView)
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(openAverageView.snp.right).offset(15)
        }
        flatPriceView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(openAverageView)
            make.top.equalTo(openAverageView.snp.bottom).offset(verMargin)
        }
        PLNRate.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(PLNView)
            make.top.equalTo(PLNView.snp.bottom).offset(verMargin)
        }

        dottedLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1.0/UIScreen.main.scale)
            make.top.equalTo(flatPriceView.snp.bottom).offset(15)
        }
        
        depositView.snp.makeConstraints { (make) in
            make.height.equalTo(32)
            make.left.equalTo(openAverageView)
            make.top.equalTo(dottedLineView.snp.bottom).offset(15)
        }
        actualLevel.snp.makeConstraints { (make) in
            make.height.equalTo(depositView)
            make.width.equalTo(depositView)
            make.left.equalTo(depositView.snp.right).offset(10)
            make.top.equalTo(depositView)
        }
        holdingVolumeView.snp.makeConstraints { (make) in
            make.height.top.equalTo(depositView)
            make.width.equalTo(actualLevel.snp.width)
            make.left.equalTo(actualLevel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        PLEDView.snp.makeConstraints { (make) in
            make.height.width.left.equalTo(depositView)
            make.top.equalTo(depositView.snp.bottom).offset(verMargin)
        }
        valueView.snp.makeConstraints { (make) in
            make.height.equalTo(actualLevel)
            make.width.equalTo(actualLevel)
            make.left.equalTo(depositView.snp.right).offset(10)
            make.top.equalTo(PLEDView)
        }
        canCloseVolumeView.snp.makeConstraints { (make) in
            make.height.equalTo(holdingVolumeView)
            make.width.equalTo(holdingVolumeView)
            make.left.equalTo(holdingVolumeView)
            make.top.equalTo(PLEDView)
        }
        horLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0/UIScreen.main.scale)
            make.top.equalTo(PLEDView.snp.bottom).offset(15)
        }
        adjustDepositButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(56)
            make.top.equalTo(horLineView.snp.bottom)
        }
        verLineView.snp.makeConstraints { (make) in
            make.left.equalTo(adjustDepositButton.snp.right)
            make.width.equalTo(1.0/UIScreen.main.scale)
            make.top.equalTo(horLineView.snp.bottom).offset(10)
            make.centerY.equalTo(adjustDepositButton.snp.centerY)
        }
        stopProfitOrLossButton.snp.makeConstraints { (make) in
            make.left.equalTo(verLineView.snp.right)
            make.top.width.height.equalTo(adjustDepositButton)
        }
        verLineView2.snp.makeConstraints { (make) in
            make.left.equalTo(stopProfitOrLossButton.snp.right)
            make.width.equalTo(1.0/UIScreen.main.scale)
            make.top.equalTo(horLineView.snp.bottom).offset(10)
            make.centerY.equalTo(adjustDepositButton.snp.centerY)
        }
        closeContractButton.snp.makeConstraints { (make) in
            make.left.equalTo(verLineView2.snp.right)
            make.right.equalToSuperview()
            make.top.width.height.equalTo(adjustDepositButton)
        }
        bottomMarginView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}


// MARK: - Click Events

extension SLSwapPositionCell {
    /// 点击调整保证金
    @objc func clickAdjustDepositButton() {
        let adjustVc = SLAdjustDepositVc()
        adjustVc.updatePositionModel(self.positionModel!)
        adjustVc.clickAdjustDeposit = {[weak self] (bool) in
            EXAlert.dismiss()
            if bool {
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_margin_adjustment_success".localized()))
                self?.needReloadCellBlock?()
            } else {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_margin_adjustment_failed".localized()))
            }
        }
        self.yy_viewController?.navigationController?.pushViewController(adjustVc, animated: true)
    }
    
    /// 点击止盈止损
    @objc func clickStopProfitOrLossButton() {
        if self.positionModel == nil {
            return
        }
        let profitLossVc = SLStopProfitLossVc()
        profitLossVc.positionModel = self.positionModel
        self.yy_viewController?.navigationController?.pushViewController(profitLossVc, animated: true)
    }
    
    /// 点击平仓
    @objc func clickCloseContractButton() {
        if self.positionModel == nil {
            return
        }
        let sheet = SLClosePositionSheet(frame: CGRect(x: 0, y: 0, width: self.width, height: 360))
        sheet.backgroundColor = UIColor.ThemeView.bg
        sheet.positionM = self.positionModel
        
        sheet.priceInput.decimal = "\(self.getDecimal(unit: self.positionModel?.contractInfo.px_unit ?? "0.00000001"))"
        sheet.priceInput.extraLabel.text = self.positionModel?.contractInfo.margin_coin ?? "-"
        sheet.marketPriceClosePositionCallback = {[weak self](price, position) in // 市价全平
            guard let mySelf = self else { return }
            mySelf.handleMarketCloseOrder(price: price, volume: position)
        }
        sheet.closePositionCallback = {[weak self](price, position) in // 平仓
            guard let mySelf = self else { return }
            
            var side = "contract_buy_closeLess".localized()
            if mySelf.positionModel!.side == .openMore {
                side = "contract_sell_closeMore".localized()
            }
            let p = sheet.priceInput.input.text ?? "0"
            let unit = sheet.priceInput.extraLabel.text ?? "--"
            let qty = sheet.positionInput.input.text ?? "0"
            let swap = mySelf.positionModel!.contractInfo!.symbol ?? "--"
            let message = "contract_action_limitPrice".localized() + p + unit + side + qty + "contract_text_volumeUnit".localized() + swap + "mainTab_text_contract".localized()
            if p.greaterThan(BT_ZERO) && qty.greaterThan(BT_ZERO) {
                let closeAlert = SLSwapMarketPriceFlatAlertView()
                closeAlert.config(title: "contract_text_limitPositions".localized(), message: message, cancelText: "common_text_btnCancel".localized(), confirmText: "contract_text_limitPositions".localized(), tipsText: "")
                closeAlert.isShowConfirmView = false
                closeAlert.confirmCallback = {
                    if position.greaterThan(mySelf.positionModel!.cur_qty.bigSub(mySelf.positionModel!.freeze_qty)) {
                        let entrustOrders = SLFormula.getCloseEntrustOrder(withPosition: mySelf.positionModel!)
                        mySelf.handleCancelAllEntrustOrders((entrustOrders as? [BTContractOrderModel]) ?? [],position,.normal,price)
                    } else {
                        mySelf.handleCloseOrder(price: price, volume: position, category: .normal)
                    }
                    
                }
                EXAlert.showAlert(alertView: closeAlert)
            } else {
                mySelf.handleCloseOrder(price: price, volume: position, category: .normal)
            }
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    private func getDecimal(unit: String) -> Int {
        let arr = unit.components(separatedBy: ".")
        var count = 0
        if arr.count == 2 {
            count = arr.last?.count ?? 8
        }
        return count
    }
    
    /// 点击分享
    @objc func clickShareButton() {
        let alert = SLShareSheet.createShareViewWithPosition(self.positionModel!)
        alert.alertCallback = { [weak self] (idx, image) in
            if idx == 2 {
                let activity = UIActivity()
                var activityItems : [Any] = []
                if image == nil {
                    return
                }
                activityItems.append(image!)
                let activities = [activity]
                let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
                activityController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.assignToContact]
                activityController.modalPresentationStyle = .fullScreen
                let vc = self!.findController()
                vc?.present(activityController, animated: true) { () -> Void in
                }
                activityController.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
                    if activityError == nil , completed == true{
                    }else{
                        NSLog("失败")
                    }
                }
            } else if idx == 1 {
                if image != nil {
                    UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self?.saveImg(image:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
        alert.show()
    }
    
    @objc func saveImg(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            EXAlert.showFail(msg: "common_tip_saveImgFail".localized())
            return
        }
        EXAlert.showSuccess(msg: "common_tip_saveImgSuccess".localized())
    }

}

extension SLSwapPositionCell {
    
    func handleCancelAllEntrustOrders(_ entrustOrders : [BTContractOrderModel],_ volume:String,_ category:BTContractOrderCategory,_ px: String) {
        BTContractTool.cancelContractOrders(entrustOrders, contractOrderType: .defineContractClose, assetPassword: nil, success: { (number) in
//            if !SLContractSocketManager.shared().isConnected {
//                self.positionModel?.freeze_qty = "0"
//            } else {
//                let itemModel = BTItemModel()
//                itemModel.instrument_id = self.positionModel!.instrument_id
//                var way = BTContractOrderWay.buy_OpenLong
//                if self.positionModel!.side == .openEmpty {
//                    way = BTContractOrderWay.sell_OpenShort
//                }
//                self.positionModel = SLFormula.getUserPosition(with: itemModel, contractWay: way)
//                self.positionModel?.freeze_qty = "0"
//            }
            
            // 弹出市价全平框
//            let alert = SLSwapMarketPriceFlatAlertView()
//            alert.config(title: "contract_text_marketPriceFlat".localized(), message: "contract_alert_text_marketcloseorder".localized(), cancelText: "common_text_btnCancel".localized(), confirmText: "contract_text_marketPriceFlat".localized(), tipsText: "")
//            alert.isShowConfirmView = false
//            alert.confirmCallback = { [weak self] in
//                guard let mySelf = self else { return }
//                let newprice = BTMaskFutureTool.marketPrice(withContractID: mySelf.positionModel!.instrument_id) ?? "0"
//                let vol = mySelf.positionModel!.cur_qty ?? "0"
//                mySelf.handleCloseOrder(price: newprice, volume: vol, category: .market)
//            }
//            EXAlert.showAlert(alertView: alert)
            
//            let vol = self.positionModel!.cur_qty ?? "0"
            if category == .market {
                let newprice = BTMaskFutureTool.marketPrice(withContractID: self.positionModel!.instrument_id) ?? "0"
                self.handleCloseOrder(price: newprice, volume: volume, category: .market)
            } else {
                self.handleCloseOrder(price: px, volume: volume, category: .normal)
            }
        }) { (error) in
        }
    }
    
    func handleMarketCloseOrder(price:String,volume:String) {
        if self.positionModel == nil {
            return
        }
        let entrustOrders = SLFormula.getCloseEntrustOrder(withPosition: self.positionModel!)
        var orderVol = "0"
        for item in entrustOrders {
            guard let model = item as? BTContractOrderModel else { return }
            orderVol = orderVol.bigAdd((model.qty.bigSub(model.cum_qty)))
        }
        if entrustOrders.count <= 0 || orderVol.lessThanOrEqual(BT_ZERO) { // 没有未成交的平仓委托单
            let newprice = BTMaskFutureTool.marketPrice(withContractID: self.positionModel!.instrument_id) ?? "0"
            let vol = self.positionModel!.cur_qty.bigSub(self.positionModel!.freeze_qty)  ?? "0"
            let alert = EXNormalAlert()
            alert.configAlert(title: "contract_text_marketPriceFlat".localized(), message: String(format:"contract_markit_price_close".localized(),volume))
            alert.alertCallback = {idx in
                if idx == 0 {
                    self.handleCloseOrder(price: newprice, volume: vol, category: .market)
                }
            }
            EXAlert.showAlert(alertView: alert)
        } else { // 有未成交的平仓委托单则需要先撤销所有的平仓委托单
            
//             let alert = SLSwapMarketPriceFlatAlertView()
            //            alert.config(title: "contract_text_marketPriceFlat".localized(), message: "contract_alert_text_cancel_allorder".localized(), cancelText: "common_text_btnCancel".localized(), confirmText: "contract_alert_btn_text_allcancel".localized(), tipsText: "")
            //            var color = UIColor.ThemekLine.up
            //            var type = "contract_flat_short".localized()
            //            if self.positionModel!.side == .openMore {
            //                color = UIColor.ThemekLine.down
            //                type = "contract_flat_long".localized()
            //            }
            //            alert.updateVolume(orderVol, color, type, self.positionModel!.contractInfo.symbol)
            //            alert.confirmCallback = { [weak self] in
            //                guard let mySelf = self else { return }
            //                if volume.greaterThan(mySelf.positionModel?.cur_qty.bigSub(mySelf.positionModel?.freeze_qty)) {
            //                    mySelf.handleCancelAllEntrustOrders((entrustOrders as? [BTContractOrderModel]) ?? [],volume,.market,"")
            //                } else {
            //                    let newprice = BTMaskFutureTool.marketPrice(withContractID: mySelf.positionModel!.instrument_id) ?? "0"
            //                    mySelf.handleCloseOrder(price: newprice, volume: volume, category: .market)
            //                }
            //            }
            //            EXAlert.showAlert(alertView: alert)
            
            let alert = EXNormalAlert()
            alert.configAlert(title: "contract_text_marketPriceFlat".localized(), message: String(format:"contract_markit_price_close".localized(),volume))
            alert.alertCallback = {idx in
                if idx == 0 {
                    if volume.greaterThan(self.positionModel?.cur_qty.bigSub(self.positionModel?.freeze_qty)) {
                        self.handleCancelAllEntrustOrders((entrustOrders as? [BTContractOrderModel]) ?? [],volume,.market,"")
                    } else {
                        let newprice = BTMaskFutureTool.marketPrice(withContractID: self.positionModel!.instrument_id) ?? "0"
                        self.handleCloseOrder(price: newprice, volume: volume, category: .market)
                    }
                }
            }
            EXAlert.showAlert(alertView: alert)
        }
    }
    
    
    
    func handleCloseOrder(price:String,volume:String, category:BTContractOrderCategory) {
        if price.lessThanOrEqual(BT_ZERO) {
            EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_price_limit".localized()))
            return
        }
        if volume.lessThanOrEqual(BT_ZERO) {
            EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tips_volume_limit".localized()))
            return
        }
        var way : BTContractOrderWay
        if self.positionModel!.side == .openMore {
            way = .sell_CloseLong
        } else {
            way = .buy_CloseShort
        }
        let orderModel = BTContractOrderModel.newContractCloseOrder(withContractId: self.positionModel!.instrument_id, category: category, way: way, positionID: self.positionModel!.pid, price: price, vol: volume)
        orderModel!.position_type = self.positionModel!.position_type
        BTContractTool.sendContractsOrder(orderModel!, contractOrderType: .defineContractClose, assetPassword: nil, success: {[weak self] (oid) in
            EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_tip_closeOrderSuccess".localized()))
            self?.needReloadCellBlock?()
        }) { (error) in
            guard let errStr = error as? String else {
                EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tip_submitFailure"))
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
    
    func updateCell(model: BTPositionModel) {
        if model.contractInfo == nil {
            return
        }
        let coin = model.contractInfo.is_reverse ? model.contractInfo.base_coin : model.contractInfo.quote_coin
        positionModel = model
        titleLabel.text = model.contractInfo?.margin_coin ?? "" + "contract_action_holdMargin".localized()
        var color = UIColor.ThemekLine.down
        if model.side == .openMore {
            color = UIColor.ThemekLine.up
            dealTypeLabel.text = "contract_openLong".localized()
        } else {
            dealTypeLabel.text = "contract_openShort".localized()
        }
        dealTypeLabel.textColor = color
        nameLabel.text = model.contractInfo?.symbol ?? ""
        
        if model.position_type  == .allType{
            contractTypeLabel.text = String(format:" %@ ","contract_Cross_position".localized())
        } else {
            contractTypeLabel.text = String(format:" %@ ","contract_Fixed_position".localized())
        }
        openAverageView.setBottomText(model.avg_cost_px.toSmallPrice(withContractID:model.instrument_id))
        if model.unrealised_profit.greaterThan(BTZERO) {
            PLNView.bottomLabel.textColor = UIColor.ThemekLine.up
        
            PLNView.setBottomText("+" + model.unrealised_profit)
          
        } else {
            PLNView.bottomLabel.textColor = UIColor.ThemekLine.down
          
            PLNView.setBottomText(model.unrealised_profit)
           
        }
        
        if model.repayRate.greaterThan(BTZERO) {
            PLNRate.setBottomText("+" + model.repayRate.toPercentString(2))
            PLNRate.bottomLabel.textColor = UIColor.ThemekLine.up
        }else{
            
             PLNRate.bottomLabel.textColor = UIColor.ThemekLine.down
             PLNRate.setBottomText(model.repayRate.toPercentString(2))
        }
        
        
        var reality = model.realityLeverage ?? "1"
        let arrLeverage = reality.components(separatedBy: ".")
        if arrLeverage.count == 2 {
            reality = arrLeverage[0].bigAdd(DecimalOne)
        }
        actualLevel.setBottomText(reality + "X")
        holdingVolumeView.setBottomText(model.cur_qty)
        canCloseVolumeView.setBottomText(model.cur_qty.bigSub(model.freeze_qty))
        valueView.setBottomText(model.positionValue)
        valueView.setTopText(String(format:"%@(%@)","contract_positon_value".localized(),coin ?? ""))
        flatPriceView.setBottomText(model.liquidate_price ?? "0")
        depositView.setBottomText(model.im.toString(4))
        depositView.setTopText(String(format:"%@(%@)","contract_text_margin".localized(),coin ?? ""))
        PLEDView.setBottomText(model.realised_pnl.toSmallValue(withContract:model.instrument_id))
        PLEDView.setTopText(String(format:"%@(%@)","contract_positon_realised_value".localized(),coin ?? ""))
    }
}

