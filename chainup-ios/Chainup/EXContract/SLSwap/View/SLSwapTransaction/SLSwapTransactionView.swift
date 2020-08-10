//
//  SLSwapTransactionView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

enum SLSwapTransationViewShowType {
    case showOpen
    case showClose
}

class SLSwapTransactionView: UIView {
    typealias ClickTakeOrderBlock = (SLOrderBookModel) -> ()
    var clickTakeOrderBlock : ClickTakeOrderBlock?
    
    /// 跳转至全部委托 VC
    var jumpToAllTransactionVCCallback: (() -> (Void))?
    
    private let limitCellReUseID = "SLSwapLimitTransactionCell_ID"
    private let planCellReUseID = "SLSwapPlanTransactionCell_ID"
    
    var transactionPriceType: SLSwapTransactionPriceType = .limit
    
    var transactionShowType : SLSwapTransationViewShowType? {
        didSet {
            makeOrderView.transactionShowType = transactionShowType
        }
    }
    
    /// 基础模型数据
    var _itemModel : BTItemModel?
    
    var itemModel : BTItemModel? {
        set {
            if newValue?.instrument_id != _itemModel?.instrument_id {
                let vm = SLSwapMarkOrderViewModel()
                vm.itemModel = newValue
                makeOrderView.makeOrderViewModel = vm
            } else {
                makeOrderView.makeOrderViewModel?.itemModel = newValue!
            }
            _itemModel = newValue
            marketPriceView.itemModel = _itemModel
        }
        get {
            return _itemModel
        }
    }
    
    private var tableViewRowDatas: [BTContractOrderModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([contentTableView])
        contentTableView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        transactionHeaderView.addSubViews([makeOrderView, marketPriceView, bottomView])
        transactionHeaderView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        makeOrderView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(proportion_width)
        }
        marketPriceView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(makeOrderView.snp.right)
            make.top.bottom.equalTo(makeOrderView)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(makeOrderView.snp.bottom)
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
        }
        makeOrderView.changeLayoutBlock = {[weak self] (height) in
            self?.transactionHeaderView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: height + 10)
            self?.contentTableView.tableHeaderView = self?.transactionHeaderView
        }
        contentTableView.layoutIfNeeded()
        reloadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadView() {
        // 如果未登录
        if XUserDefault.getToken() == nil || ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            
        }else{
            
        }
    }
    
    // MARK: - lazy
    lazy var makeOrderView : SLSwapMakeOrderView = {
        let view = SLSwapMakeOrderView()
        view.extUseAutoLayout()
        view.clickTradeBlock = {[weak self] order in
            self?.takeOrder(order: order)
        }
        return view
    }()
    
    lazy var marketPriceView : SLSwapMarketPriceView = {
        let view = SLSwapMarketPriceView()
        view.extUseAutoLayout()
        view.clickRightBlock = {[weak self] orderModel in
            guard let mySelf = self else{return}
            mySelf.clickTakeOrderBlock?(orderModel)
        }
        return view
    }()
    
    lazy var bottomView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    lazy var transactionHeaderView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 471))
        return view
    }()
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.extUseAutoLayout()
        tableView.rowHeight = 160
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapLimitTransactionCell.classForCoder(), SLSwapPlanTransactionCell.classForCoder(), EXTransactionEmptyTC.classForCoder()], [limitCellReUseID, planCellReUseID, "EXTransactionEmptyTC"])
        tableView.tableHeaderView = transactionHeaderView
        return tableView
    }()
    
    lazy var sectionHeaderView: SLSwapTransactionSectionHeaderView = {
        let view = SLSwapTransactionSectionHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 46))
        // 切换委托类型
        view.changeTransactionPriceType = {[weak self] transactionPriceType in
            guard let mySelf = self else {return}
            mySelf.transactionPriceType = transactionPriceType
            mySelf.contentTableView.rowHeight = 160
            mySelf.requestTransactionData(instrument_id: mySelf.itemModel?.instrument_id ?? 0)
        }
        // 跳转至全部委托 VC
        view.clickAllTransactionCallback = {[weak self] in
            self?.jumpToAllTransactionVCCallback?()
        }
        return view
    }()
    
    func getforceTips(_ order : BTContractOrderModel) -> String {
        var forceTips = ""
        if order.px == nil || order.currentPrice == nil {
            return forceTips
        }
        if (order.category == .normal) {
            if (order.side == .buy_OpenLong) {
                if (order.currentPrice != nil && order.px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            } else if (order.side == .buy_CloseShort) {
                if (order.currentPrice != nil && order.px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_CloseLong) {
                if (order.currentPrice != nil && order.px.lessThan(order.currentPrice.bigMul("0.95"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_OpenShort) {
                if (order.currentPrice != nil && order.px.lessThan(order.currentPrice.bigMul("0.95"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            }
        } else if (order.category == .market) {
            if (order.side == .buy_OpenLong) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            } else if (order.side == .buy_CloseShort) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.greaterThan(order.currentPrice.bigMul("1.05"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_CloseLong) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.lessThan(order.currentPrice.bigMul("0.97"))) {
                    forceTips = "contract_makerOrder_close_tips".localized()
                }
            } else if (order.side == .sell_OpenShort) {
                if (order.currentPrice != nil && order.open_avg_px != nil && order.open_avg_px.lessThan(order.currentPrice.bigMul("0.97"))) {
                    forceTips = "contract_makerOrder_open_tips".localized()
                }
            }
        }
        return forceTips
    }
    
    func takeOrder(order: BTContractOrderModel) {
        print(order.px)
        order.forceTips = getforceTips(order)
        if order.side == .buy_OpenLong || order.side == .sell_OpenShort { // 弹出开仓二次确认框
            if XUserDefault.getOnComfirmSwapAlert() {
                
                let alert = SLSwapDoubleComfirmAlertView()
                alert.config(order)
                alert.confimModelCallBack = { [weak self] model in
                    guard let mySelf = self else {return}
                    mySelf.submitOrder(order: order, password: nil, stopProfitOrLossMode: model)
                }
//                 EXAlert.showAlert(alertView: alert)
                if order.cycle != nil {
                     EXAlert.showAlert(alertView: alert)
                }else{
                    EXAlert.showSheet(sheetView: alert)
                }
                
               
            } else {
                submitOrder(order: order, password: nil)
            }
        } else { // 弹出平仓二次确认框
            if XUserDefault.getOnComfirmSwapAlert() {
                var side = "contract_action_buy".localized()
                if order.side == .sell_CloseLong {
                    side = "contract_action_sell".localized()
                }
                var p = order.px ?? ""
                let unit = order.contractInfo.quote_coin ?? ""
                let qty = order.qty ?? ""
                let swap = order.contractInfo!.symbol+"journalAccount_text_contract".localized()
                
                var title = "contract_text_limitPositions".localized()
                var message = "contract_action_limitPrice".localized()+p+unit+side+qty+"contract_text_volumeUnit".localized()+swap
                if order.category == .market {
                    title = "contract_action_marketClosing".localized()
                    p = "contract_action_marketPrice".localized()
                    message = p+side+qty+"contract_text_volumeUnit".localized()+swap
                }
                let closeAlert = SLSwapMarketPriceFlatAlertView()
                closeAlert.config(title: title, message: message, cancelText: "common_text_btnCancel".localized(), confirmText: "common_text_btnConfirm".localized(), tipsText:order.forceTips)
                closeAlert.isShowConfirmView = false
                closeAlert.confirmCallback = { [weak self] in
                    guard let mySelf = self else {return}
                    mySelf.submitOrder(order: order, password: nil)
                }
                EXAlert.showAlert(alertView: closeAlert)
            } else {
                submitOrder(order: order, password: nil)
            }
        }
    }
    
    func submitOrder(order: BTContractOrderModel, password : String?,stopProfitOrLossMode:BTProfitOrLossModel? = nil) {
        var positionType = BTContractOrderType.defineContractOpen
        if makeOrderView.transactionShowType == .showClose {
            positionType = BTContractOrderType.defineContractClose
        }
        if order.cycle != nil && order.trend.rawValue > 0 && order.trigger_type.rawValue > 0 {
            BTContractTool.submitPlanOrder(order, contractOrderType: positionType, assetPassword: nil, success: {[weak self] (idx) in
                guard let mySelf = self else {return}
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_tip_submitSuccess"))
                mySelf.handleSubmitSuccess(true)
            }) { (error) in
                guard let errStr = error as? String else {
                    EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tip_submitFailure"))
                    return
                }
                EXAlert.showFail(msg: errStr)
            }
        } else {
            
            
            BTContractTool.sendContractsOrder(order, contractOrderType: positionType, profitOrLossModel: stopProfitOrLossMode, assetPassword: nil, success: { [weak self] (idx) in
                guard let mySelf = self else {return}
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "contract_tip_submitSuccess"))
                mySelf.handleSubmitSuccess(false)
            }) { (error) in
                guard let errStr = error as? String else {
                    EXAlert.showFail(msg: LanguageTools.getString(key: "contract_tip_submitFailure"))
                    return
                }
                EXAlert.showFail(msg: errStr)
            }
            
        }
    }
    
    /// 处理下单成功
    func handleSubmitSuccess(_ isPlan : Bool) {
        if isPlan {
            requestTransactionData(instrument_id:itemModel?.instrument_id ?? 0)
        } else {
            // 强制刷新列表
            requestTransactionData(instrument_id:itemModel?.instrument_id ?? 0)
        }
        // 强制刷新资产
        SLPlatformSDK.sharedInstance().sl_loadUserContractPerpoty()
    }
}

// MARK: - Update Data

extension SLSwapTransactionView {
    /// 获取当前委托列表
    func requestTransactionData(instrument_id: Int64) {
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil || instrument_id == 0 {
            return
        }
        let priceType = self.transactionPriceType
        let status: BTContractOrderStatus = .allWait
        if priceType == .limit {
            BTContractTool.getUserContractOrders(withContractID: instrument_id, status: status, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                self.tableViewRowDatas = models ?? []
                self.contentTableView.reloadData()
            }) { (error) in
                
            }
        } else if priceType == .plan {
            BTContractTool.getUserPlanContractOrders(withContractID: instrument_id, status: status, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                self.tableViewRowDatas = models ?? []
                self.contentTableView.reloadData()
            }) { (error) in
                
            }
        }
    }
    
    /// 处理私有信息 socket (这里只处理委托列表)
    func handleUnicastSocketData(socketModelArray: [BTWebSocketModel]) {
        if self.transactionPriceType == .limit {
            if socketModelArray.count == 0 {
                return
            }
            var modelArr: [BTContractOrderModel] = Array(self.tableViewRowDatas)
            var isChanged = false
            
            for socketModel in socketModelArray {
                guard let socketOrderModel = socketModel.order else {
                    continue
                }
                // 如果订单结束
                if socketOrderModel.status == .finished {
                    for idx in 0..<modelArr.count {
                        if modelArr[idx].oid == socketOrderModel.oid {
                            if BTFormat.getTimeStr(with: socketOrderModel.updated_at) >= BTFormat.getTimeStr(with: modelArr[idx].updated_at) {
                                modelArr.remove(at: idx)
                                isChanged = true
                            }
                            break
                        }
                    }
                } else if modelArr.count == 0 {
                    if socketOrderModel.instrument_id == self.itemModel?.instrument_id {
                        modelArr.append(socketOrderModel)
                        isChanged = true
                    }
                } else {
                    for idx in 0..<modelArr.count {
                        if modelArr[idx].oid == socketOrderModel.oid {
                            if BTFormat.getTimeStr(with: socketOrderModel.updated_at) >= BTFormat.getTimeStr(with: modelArr[idx].updated_at) {
                                modelArr[idx] = socketOrderModel
                                isChanged = true
                            }
                            break
                        }
                        if idx == modelArr.count - 1 && socketOrderModel.instrument_id == self.itemModel?.instrument_id {
                            modelArr.insert(socketOrderModel, at: 0)
                            isChanged = true
                        }
                    }
                }
            }
            if isChanged == true {
                self.tableViewRowDatas = modelArr
                self.contentTableView.reloadData()
            }
        }
    }
    
    private func handleCancelOrder(_ order : BTContractOrderModel) {
        if transactionPriceType == .limit {
            BTContractTool.cancelContractOrders([order], contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
            
        } else {
            BTContractTool.cancelPlanOrders([order], contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        }
    }
    
    /// 退出登录时清空数据
    func cleanDataWhenLogout() {
        self.tableViewRowDatas = []
        self.contentTableView.reloadData()
    }
}

// MARK: - <UITableViewDelegate & UITableViewDataSource>

extension SLSwapTransactionView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableViewRowDatas.count == 0 {
            return 1
        }
        return self.tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableViewRowDatas.count == 0 {
            return 100
        } else {
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewRowDatas.count == 0 {
            let cell: EXTransactionEmptyTC = tableView.dequeueReusableCell(withIdentifier: "EXTransactionEmptyTC") as! EXTransactionEmptyTC
            return cell
        }
        let model = tableViewRowDatas[indexPath.row]
        var emptyCell: UITableViewCell
        if self.transactionPriceType == .limit {
            let cell = tableView.dequeueReusableCell(withIdentifier: limitCellReUseID, for: indexPath) as! SLSwapLimitTransactionCell
            cell.updateCell(model: model)
            cell.cancelOrderCallback = { [weak self] orderModel in // 取消普通委托
                guard let mySelf = self else {return}
                let alert = EXNormalAlert()
                alert.configAlert(title: "common_text_tip".localized(), message: "contract_alert_cancel_order".localized())
                alert.alertCallback = {idx in
                    if idx == 0 {
                        mySelf.handleCancelOrder(orderModel)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
            return cell
        } else if self.transactionPriceType == .plan {
            let cell = tableView.dequeueReusableCell(withIdentifier: planCellReUseID, for: indexPath) as! SLSwapPlanTransactionCell
            cell.updateCell(model: model)
            cell.cancelOrderCallback = { [weak self] orderModel in // 取消计划委托
                guard let mySelf = self else {return}
                let alert = EXNormalAlert()
                alert.configAlert(title: "common_text_tip".localized(), message: "contract_alert_cancel_order".localized())
                alert.alertCallback = {idx in
                    if idx == 0 {
                        mySelf.handleCancelOrder(orderModel)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
            return cell
        } else {
            emptyCell = UITableViewCell()
        }
        return emptyCell
    }
}


class SLSwapTransactionSectionHeaderView : UIView {
    /// 切换委托类型
    var changeTransactionPriceType: ((SLSwapTransactionPriceType) -> ())?
    
    /// 跳转至全部委托 VC
    var clickAllTransactionCallback: (() -> ())?
    
    /// 顶部标题
    lazy var selectionTitleBar: EXSelectionTitleBar = {
        let view = EXSelectionTitleBar()
        view.setSelected(atIdx: 0)
        view.bindTitleBar(with: ["contract_normal_price".localized(), "contract_plan_order".localized()])
        view.titleBarCallback = {
            [weak self] tag in
            if tag == 0 {
                self?.changeTransactionPriceType?(.limit)
            } else if tag == 1 {
                self?.changeTransactionPriceType?(.plan)
            }
        }
        return view
    }()
    /// 全部
    lazy var allTransactionButton: UIControl = {
        let ctl = UIControl()
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_order"))
        imageView.contentMode = .scaleAspectFit
        let label = UILabel(text: "common_action_sendall".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
        ctl.addSubViews([imageView, label])
        
        label.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(15)
        }
        imageView.snp_makeConstraints { (make) in
            make.right.equalTo(label.snp_left).offset(-5)
            make.height.equalTo(13)
            make.centerY.equalTo(label)
            make.left.equalToSuperview()
        }
        
        ctl.addTarget(self, action: #selector(clickAllTransactionButton), for: .touchUpInside)
        return ctl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([selectionTitleBar, allTransactionButton])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin = 15
        self.selectionTitleBar.snp_makeConstraints { (make) in
            make.left.right.top.height.equalToSuperview()
        }
        self.allTransactionButton.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.top.height.equalTo(self.selectionTitleBar)
        }
    }
    
    @objc func clickAllTransactionButton() {
        if XUserDefault.getToken() == nil {
            BusinessTools.modalLoginVC()
            return
        }
        self.clickAllTransactionCallback?()
    }
}

