//
//  SLSwapAllTransactionsVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum SLSwapHistoryTransactionWay: Int {
    /// 全部类型
    case allTypes = 0
    /// 订单完成
    case finished
    /// 用户取消
    case userCancel
    /// 系统取消
    case systemCancel
    /// 部分成交
    case subDeal
}

/// 全部委托
class SLSwapAllTransactionsVC: NavCustomVC, EXEmptyDataSetable {
    
    var itemModel: BTItemModel?
    
    /// 委托状态
    var transactionStatus: BTContractOrderStatus {
        get {
            if self.currentButton.isSelected {
                return .allWait
            } else {
                return .finished
            }
        }
    }
    
    /// 计划委托/限价委托
    var transactionPriceType = SLSwapTransactionPriceType.limit {
        didSet {
            self.currentTransactionView.transactionPriceType = self.transactionPriceType
            self.historyTransactionView.transactionPriceType = self.transactionPriceType
        }
    }
    
    /// 当前委托类型 (开多/开空/平多/平空)
    var transactionWay: BTContractOrderWay = .unkown
    
    /// 历史委托类型
    var historyTransactionWay: SLSwapHistoryTransactionWay = .allTypes
    
    /// 币种数组倒序
    let itemModelArray: [BTItemModel] = {
        var arrM = [BTItemModel]()
        for obj in SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? [] where obj.contractInfo != nil {
            arrM.append(obj)
        }
        arrM.sort { (obj1, obj2) -> Bool in
            obj1.instrument_id < obj2.instrument_id
        }
        return arrM
    }()
    
    lazy var cancelAllButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_cancel_all_transaction".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.extSetAddTarget(self, #selector(clickCancelAllButton))
        return button
    }()
    
    lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = self.navCustomView.backgroundColor
        self.contentView.addSubview(topView)
        
        topView.addSubViews([self.currentButton, self.historyButton, self.screeningView])
        
        let marginView = UIView()
        marginView.backgroundColor = UIColor.ThemeNav.bg
        topView.addSubview(marginView)
        
        marginView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.screeningView.snp_bottom)
        }
        return topView
    }()
    
    lazy var currentButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_text_currentEntrust".localized(), titleFont: UIFont.ThemeFont.H1Bold, titleColor: UIColor.ThemeLabel.colorMedium)
        button.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        button.isSelected = true
        button.extSetAddTarget(self, #selector(clickCurrentButton))
        return button
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_text_historyCommision".localized(), titleFont: UIFont.ThemeFont.HeadRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        button.extSetAddTarget(self, #selector(clickHistoryButton))
        return button
    }()
    
    lazy var screeningView = SLSwapScreeningView()
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        let container = UIView()
        scrollView.addSubview(container)
        container.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        // 跳转至历史委托详情
        historyTransactionView.selectHistoryTransactionCallback = {[weak self] orderModel in
            let vc = SLSwapDetailTransactionVC()
            vc.itemMdoel = self?.itemModel
            vc.orderModel = orderModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        container.addSubViews([currentTransactionView, historyTransactionView])
        self.exEmptyDataSet(currentTransactionView.contentTableView)
        self.exEmptyDataSet(historyTransactionView.contentTableView)
        
        currentTransactionView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        historyTransactionView.snp_makeConstraints { (make) in
            make.left.equalTo(currentTransactionView.snp_right)
            make.width.top.bottom.equalTo(currentTransactionView)
            make.right.equalToSuperview()
        }
        return scrollView
    }()
    
    lazy var currentTransactionView: SLSwapTransactionListView = {
        let view = SLSwapTransactionListView()
        view.transactionType = .current
        return view
    }()
    
    lazy var historyTransactionView: SLSwapTransactionListView = {
        let view = SLSwapTransactionListView()
        view.transactionType = .history
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 11.0, *) {
            self.contentScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if let gesArr = self.navigationController?.view.gestureRecognizers {
            for ges in gesArr {
                if ges is UIScreenEdgePanGestureRecognizer {
                    self.contentScrollView.panGestureRecognizer.require(toFail: ges)
                }
            }
        }
        
        self.contentView.addSubview(self.contentScrollView)
        self.contentScrollView.delegate = self
        
        self.initLayout()
        
        self.p_selectCurrentButton()
        
        // 设置合约类型
        var arr = [String]()
        var initialSwapName = "-"
        for itemModel in self.itemModelArray {
            arr.append(itemModel.contractInfo.symbol ?? "-")
            if itemModel.instrument_id == self.itemModel?.instrument_id {
                initialSwapName = itemModel.contractInfo.symbol ?? "-"
            }
        }
        // 设置合约数组
        self.screeningView.swapNameArray = arr
        // 设置初始选中的合约
        self.screeningView.initialSwapName = initialSwapName
        
        // 切换筛选条件
        self.screeningView.screeningValueChanged = {[weak self]
            (swapNameIndex: Int, pirceTypeIndex: Int, orderTypeIndex: Int) in
            guard let mySelf = self else { return }
            if pirceTypeIndex == 0 { // 限价委托
                mySelf.transactionPriceType = .limit
            } else if pirceTypeIndex == 1 { // 计划委托
                mySelf.transactionPriceType = .plan
            }
            if mySelf.currentButton.isSelected {
                switch orderTypeIndex {
                    case 0:
                        mySelf.transactionWay = .unkown
                    case 1:
                        mySelf.transactionWay = .buy_OpenLong
                    case 2:
                        mySelf.transactionWay = .sell_OpenShort
                    case 3:
                        mySelf.transactionWay = .buy_CloseShort
                    case 4:
                        mySelf.transactionWay = .sell_CloseLong
                    default: break
                }
            } else {
                switch orderTypeIndex {
                    case 0:
                        mySelf.historyTransactionWay = .allTypes
                    case 1:
                        mySelf.historyTransactionWay = .finished
                    case 2:
                        mySelf.historyTransactionWay = .userCancel
                    case 3:
                        mySelf.historyTransactionWay = .systemCancel
                    case 4:
                        mySelf.historyTransactionWay = .subDeal
                    default: break
                }
            }
            
            mySelf.itemModel = mySelf.itemModelArray[swapNameIndex]
            mySelf.requestTransactionData(instrument_id: mySelf.itemModel?.instrument_id ?? 0, priceType: mySelf.transactionPriceType, status: mySelf.transactionStatus, way: mySelf.transactionWay)
        }
        
        self.currentTransactionView.contentTableView.mj_header = EXRefreshHeaderView(refreshingBlock: {[weak self] in
            guard let mySelf = self else { return }
            mySelf.requestTransactionData(instrument_id: mySelf.itemModel?.instrument_id ?? 0, priceType: mySelf.transactionPriceType, status: .allWait, way: mySelf.transactionWay)
        })
        self.currentTransactionView.cancelTransactionCallback = {[weak self] order, priceType in
            self?.cancelOneTransaction(order: order, priceType: priceType)
        }
        self.historyTransactionView.contentTableView.mj_header = EXRefreshHeaderView(refreshingBlock: {[weak self] in
            guard let mySelf = self else { return }
            mySelf.requestTransactionData(instrument_id: mySelf.itemModel?.instrument_id ?? 0, priceType: mySelf.transactionPriceType, status: .finished, way: mySelf.transactionWay)
        })
        self.historyTransactionView.cancelTransactionCallback = {[weak self] order, priceType in
            self?.cancelOneTransaction(order: order, priceType: priceType)
        }
        
        self.addSocketNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setNavCustomV() {
        self.lastVC = true
        
        self.navCustomView.addSubview(cancelAllButton)
        cancelAllButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(self.navCustomView.popBtn)
            make.centerY.equalTo(self.navCustomView.popBtn)
        }
    }
    
    private func initLayout() {
        self.topView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(self.navCustomView.snp_bottom)
            make.width.equalToSuperview()
            make.height.equalTo(106)
        }
        self.currentButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.equalTo(40)
            make.top.equalTo(10)
        }
        self.historyButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.currentButton.snp_right).offset(15)
            make.bottom.equalTo(self.currentButton)
            make.height.equalTo(28)
        }
        self.screeningView.snp_makeConstraints { (make) in
            make.top.equalTo(self.currentButton.snp_bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        self.contentScrollView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp_bottom)
        }
    }
    
    /// 更改筛选条件
    private func updateSwapScreeningView(type: SLSwapTransactionType) {
        var orderTypeArray: [String]
        if type == .current {
            orderTypeArray = ["contract_transaction_all_types".localized(),
                              "contract_buy_openMore".localized(),
                              "contract_sell_openLess".localized(),
                              "contract_buy_closeLess".localized(),
                              "contract_sell_closeMore".localized()]
        } else {
            orderTypeArray = ["contract_transaction_all_types".localized(),
                              "contract_transaction_type_done".localized(),
                              "contract_transaction_type_user_cancel".localized(),
                              "contract_transaction_type_system_cancel".localized(),
                              "contract_transaction_types_subDone".localized()]
        }
        self.screeningView.orderTypeArray = orderTypeArray
//        self.screeningView.priceTypeArray = ["contract_normal_price".localized(), "contract_plan_order".localized()]
    }
}


// MARK: - Update Data

extension SLSwapAllTransactionsVC {
    /// 请求委托列表
    func requestTransactionData(instrument_id: Int64, priceType: SLSwapTransactionPriceType, status: BTContractOrderStatus, way: BTContractOrderWay) {
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil || instrument_id == 0 {
            self.resetTransactionView()
            self.endRefresh()
            return
        }
        if priceType == .limit {
            BTContractTool.getUserContractOrders(withContractID: instrument_id, status: status, way: way, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                if let modelArray = models {
                    if self.currentButton.isSelected && status == .allWait {
                        self.currentTransactionView.updateView(modelArray: modelArray)
                    } else if self.historyButton.isSelected && status == .finished {
                        // 取出对应类型的数据
                        let tempModels = self.findHistoryModels(models: modelArray)
                        if tempModels.count == 0 {
                            self.resetTransactionView()
                        } else {
                            self.historyTransactionView.updateView(modelArray: tempModels)
                        }
                    }
                }
                self.endRefresh()
            }) { (error) in
                self.endRefresh()
            }
        } else if priceType == .plan {
            BTContractTool.getUserPlanContractOrders(withContractID: instrument_id, status: status, way: way, offset: 0, size: 0, success: { (models: [BTContractOrderModel]?) in
                if let modelArray = models {
                    if self.currentButton.isSelected && status == .allWait {
                        self.currentTransactionView.updateView(modelArray: modelArray)
                    } else if self.historyButton.isSelected && status == .finished {
                        // 取出对应类型的数据
                        let tempModels = self.findHistoryModels(models: modelArray)
                        if tempModels.count == 0 {
                            self.resetTransactionView()
                        } else {
                            self.historyTransactionView.updateView(modelArray: tempModels)
                        }
                    }
                }
                self.endRefresh()
            }) { (error) in
                self.endRefresh()
            }
        }
    }
    
    private func endRefresh() {
        self.currentTransactionView.contentTableView.mj_header?.endRefreshing()
        self.historyTransactionView.contentTableView.mj_header?.endRefreshing()
    }
    
    /// 重置视图
    private func resetTransactionView() {
        self.currentTransactionView.updateView(modelArray: [])
        self.historyTransactionView.updateView(modelArray: [])
    }
    
    private func findHistoryModels(models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var tempModels: [BTContractOrderModel] = []
        switch self.historyTransactionWay {
            case .allTypes:
                tempModels = models
            case .finished:
                tempModels = self.findHistoryModels(finishTypes: [.noNoErr], models: models)
            case .userCancel:
                tempModels = self.findHistoryModels(finishTypes: [.cancel], models: models)
            case .systemCancel:
                tempModels = self.findHistoryModels(finishTypes: [.timeout, .ASSETS, .CLOSE, .reduce, .compensate, .positionErr, .UNDO, .FORBBIDN, .OPPSITE, .FOK , .FORCE , .MARKET, .IOC , .PLAY,.HANDOVER,.PASSIVE], models: models)
            case .subDeal:
                tempModels = self.findSubDealModels(models: models)
        }
        return tempModels
    }
    
    private func findHistoryModels(finishTypes: [BTContractOrderErrNO], models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var res = [BTContractOrderModel]()
        for model in models {
            for type in finishTypes {
                if model.errorno == type {
                    res.append(model)
                }
            }
        }
        return res
    }
    
    /// 获取部分成交记录
    private func findSubDealModels(models: [BTContractOrderModel]) -> [BTContractOrderModel] {
        var res = [BTContractOrderModel]()
        // 判断订单是否存在已成交
        for model in models {
            if model.errorno == .cancel && BasicParameter.handleDouble(model.cum_qty) > 0 && BasicParameter.handleDouble(model.qty) > BasicParameter.handleDouble(model.cum_qty) {
                res.append(model)
            }
        }
        return res
    }
    
    private func cancelOneTransaction(order: BTContractOrderModel, priceType: SLSwapTransactionPriceType) {
        if priceType == .limit {
            BTContractTool.cancelContractOrders([order], contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                // 撤销成功后刷新列表
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        } else {
            BTContractTool.cancelPlanOrders([order], contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                // 撤销成功后刷新列表
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        }
    }
    
    private func cancelAllTransactions() {
        if self.transactionPriceType == .limit {
            BTContractTool.cancelContractOrders(self.currentTransactionView.tableViewRowDatas, contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                // 撤销成功后刷新列表
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        } else {
            BTContractTool.cancelPlanOrders(self.currentTransactionView.tableViewRowDatas, contractOrderType: .defineContractOpen, assetPassword: nil, success: { (oid) in
                print(oid ?? "oid is 0")
                EXAlert.showSuccess(msg: "contract_cancelorder_success".localized())
                // 撤销成功后刷新列表
                self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
            }) { (error) in
                print(error ?? "error is nil")
                EXAlert.showFail(msg: "contract_cancelorder_failure".localized())
            }
        }
    }
    
    // MARK: Socket Data
    
    /// 添加 socket 数据通知
    private func addSocketNotification() {
        // 私有信息
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnicastSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification), object: nil)
    }
    
    /// 私有信息
    @objc private func handleUnicastSocketData(notify: Notification) {
        guard let socketModelArray = notify.userInfo?["data"] as? [BTWebSocketModel] else {
            return
        }
        if socketModelArray.count == 0 {
            return
        }
        var modelArr: [BTContractOrderModel]
        var isChanged = false
        // 当前委托
        if self.currentButton.isSelected {
            modelArr = Array(self.currentTransactionView.tableViewRowDatas)
            
            for socketModel in socketModelArray {
//                guard Int(socketModel.action.rawValue) < 10 else {
//                    continue
//                }
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
                self.currentTransactionView.updateView(modelArray: modelArr)
            }
        }
        // 历史委托
        else {
            modelArr = Array(self.historyTransactionView.tableViewRowDatas)
            
            for socketModel in socketModelArray {
//                guard Int(socketModel.action.rawValue) >= 10 else {
//                    continue
//                }
                guard let socketOrderModel = socketModel.order else {
                    continue
                }
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
            if isChanged == true {
                self.historyTransactionView.updateView(modelArray: modelArr)
            }
        }
    }
}


// MARK: - Click Events

extension SLSwapAllTransactionsVC {
    @objc func clickCurrentButton() {
        self.p_selectCurrentButton()
        self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func clickHistoryButton() {
        self.p_selectHistoryButton()
        self.contentScrollView.setContentOffset(CGPoint(x: self.contentScrollView.width, y: 0), animated: true)
    }
    
    /// 取消全部委托
    @objc func clickCancelAllButton() {
        if self.currentTransactionView.tableViewRowDatas.count <= 0 {
            return
        }
        let alert = EXNormalAlert()
        alert.configAlert(title: "common_text_tip".localized(), message: "contract_cancel_all_orders".localized())
        alert.alertCallback = {idx in
            if idx == 0 {
                self.cancelAllTransactions()
            }
        }
        EXAlert.showAlert(alertView: alert)
    }
    
    private func p_selectCurrentButton() {
        self.cancelAllButton.isHidden = false
        self.currentButton.titleLabel?.font = UIFont.ThemeFont.H1Bold
        self.historyButton.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        self.currentButton.isSelected = true
        self.historyButton.isSelected = false
        self.currentButton.snp_updateConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(10)
        }
        self.historyButton.snp_updateConstraints { (make) in
            make.height.equalTo(28)
        }
        self.transactionWay = .unkown
        self.historyTransactionWay = .allTypes
        self.updateSwapScreeningView(type: .current)
        self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
    }
    
    private func p_selectHistoryButton() {
        self.cancelAllButton.isHidden = true
        self.currentButton.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        self.historyButton.titleLabel?.font = UIFont.ThemeFont.H1Bold
        self.currentButton.isSelected = false
        self.historyButton.isSelected = true
        self.historyButton.snp_updateConstraints { (make) in
            make.height.equalTo(40)
        }
        self.currentButton.snp_updateConstraints { (make) in
            make.height.equalTo(28)
            make.top.equalTo(22)
        }
        self.transactionWay = .unkown
        self.historyTransactionWay = .allTypes
        self.updateSwapScreeningView(type: .history)
        self.requestTransactionData(instrument_id: self.itemModel?.instrument_id ?? 0, priceType: self.transactionPriceType, status: self.transactionStatus, way: self.transactionWay)
    }
}


// MARK: - UIScrollViewDelegate

extension SLSwapAllTransactionsVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            let i = Int(scrollView.contentOffset.x / scrollView.width)
            if i < 1 {
                self.p_selectCurrentButton()
            } else {
                self.p_selectHistoryButton()
            }
        }
    }
}
