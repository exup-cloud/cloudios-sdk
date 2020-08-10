//
//  SLSwapVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation




class SLSwapVc: NavCustomVC, EXEmptyDataSetable, SLFutureDataRefreshProtocol {
    
    /// 是否需要重置深度数据订阅 (进入详情页时不需要取消, 每次界面重新显示时重置)
    var isNeedUpdateSubscribeDepthData = true
    
    /// 是否需要刷新Ticker UI
    var isNeedUpdateSubscribeTickerUI = false
    
    override func setNavCustomV() {
        self.navtype = .nopopback
        self.navCustomView.backView.addSubViews([chooseBtn,titleLabel,chargeBtn,detailBtn])
        setNavUI()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickChooseBtn))
        titleLabel.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotes()
        setVcUI()
        SLPlatformSDK.sharedInstance()!.setPlatformDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFirstItemModel()
        self.swapTransactionView.requestTransactionData(instrument_id: self.currentItemModel?.instrument_id ?? 0)
        self.addSocketSubscribe()
        // 重置为true
        self.isNeedUpdateSubscribeDepthData = true
        self.isNeedUpdateSubscribeTickerUI = true
        // 判断是否需要开通合约
        alertOpenSwapView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isNeedUpdateSubscribeTickerUI = false
        self.removeSocketSubscibe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 当前显示合约模型
    var _currentItemModel : BTItemModel?
    var currentItemModel : BTItemModel? {
        set {
            if newValue?.instrument_id != _currentItemModel?.instrument_id {
                self.swapPositionView.requestPositionData(newValue?.instrument_id ?? 0)
            }
            _currentItemModel = newValue
            if _currentItemModel != nil {
                self.updateItemModel(entity: _currentItemModel!)
            }
        }
        get {
            return _currentItemModel
        }
    }
    
    func updateItemModel(entity : BTItemModel) {
        /// 切换合约 修改顶部数据
        self.swapTransactionView.itemModel = entity
        self.swapPositionView.itemModel = entity
        self.titleLabel.text = entity.name
        if entity.trend == BTPriceFluctuationType.up {
            self.toolView.priceLabel.textColor = UIColor.ThemekLine.up
            self.toolView.rateLabel.textColor = UIColor.ThemekLine.up
            self.toolView.rateLabel.backgroundColor = UIColor.ThemekLine.up15
        } else {
            self.toolView.priceLabel.textColor = UIColor.ThemekLine.down
            self.toolView.rateLabel.textColor = UIColor.ThemekLine.down
            self.toolView.rateLabel.backgroundColor = UIColor.ThemekLine.down15
        }
        
        var unit = 0
        if entity.contractInfo.px_unit.ch_length > 3 {
            unit = entity.contractInfo.px_unit.ch_length - 3
        }
        self.toolView.priceLabel.text = entity.last_px.toString(Int32(unit))
        self.toolView.rateLabel.text = String(format: " %@ ", entity.change_rate.toPercentString(2))
        /// 切换合约修改下单数据
    }
    
    func alertOpenSwapView() {
        if XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance().activeAccount != nil { // 已经登录
            if currentItemModel != nil  {
                SLPlatformSDK.sharedInstance().sl_loadUserContractPerpoty()
            }
        } else {
            if SLPlatformSDK.sharedInstance()!.activeAccount != nil {
                SLPlatformSDK.sharedInstance()!.activeAccount = nil
                SLPlatformSDK.sharedInstance()!.sl_logout()
                swapTransactionView.transactionShowType = .showOpen
                toolView.updataHoldPositionNumber(String(0))
                swapTransactionView.makeOrderView.makeOrderViewModel?.asset = nil
            }
        }
    }
    
    // MARK: - Delegate
    func sl_refreshUserContractPerpoty(_ perpoty: [BTItemCoinModel]!) {
        if SLPlatformSDK.sharedInstance()!.sl_determineWhetherToOpenContract(withCoinCode: currentItemModel?.contractInfo?.margin_coin ?? "") == false && (self.tabBarController?.getCurrentTabbarVC().isKind(of: SLSwapVc.classForCoder()) ?? false) {
            // 开通合约
            let alert = SLSwapOpenSwapView()
            alert.alertCallback = { [weak self] idx in
                guard let mySelf = self else { return }
                BTContractTool.createContractAccount(withContractID: mySelf.currentItemModel!.instrument_id, success: { (result) in
                    print(result ?? "false")
                }) { (error) in
                    print(error ?? "false")
                }
            }
            alert.show()
        } else {
            swapTransactionView.makeOrderView.makeOrderViewModel?.asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: currentItemModel?.contractInfo.margin_coin)
        }
    }
    
    // MARK: - Even Click
    // 点击选择合约按钮
    @objc func clickChooseBtn(){
        self.view.isUserInteractionEnabled = false
        let vc = EXDrawerVC()
        let view = SLSwapDrawerView.getSharedInstance()
        view.clickCellBlock = {[weak self](entity) in
            guard let mySelf = self else{return}
            vc.pullAnimation()
            if entity.instrument_id != mySelf.currentItemModel?.instrument_id {
                // 订阅深度
                SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: entity.instrument_id)
                mySelf.swapTransactionView.marketPriceView.clearDepathData()
                mySelf.currentItemModel = entity
                BTStoreData.setStoreObjectAndKey(String(entity.instrument_id), key: BTFuturesContractID)
                // 请求委托列表
                mySelf.swapTransactionView.requestTransactionData(instrument_id: mySelf.currentItemModel?.instrument_id ?? 0)
            }
            mySelf.alertOpenSwapView()
        }
        vc.pullBlock = {[weak self] in
            self?.view.isUserInteractionEnabled = true
        }
        vc.addView(view)
        view.tableView.reloadEmptyDataSet()
    }
    
    // 点击合约详情按钮
    @objc func clickDetailBtn(){
        self.isNeedUpdateSubscribeDepthData = false
        let vc = SLSwapMarketDetailVC()
        vc.itemModel = self.currentItemModel
        vc.changeItemCallback = {[weak self] itemModel in
            // 这里直接记录下来
            if itemModel.instrument_id > 0 {
                BTStoreData.setStoreObjectAndKey(String(itemModel.instrument_id), key: BTFuturesContractID)
                // 订阅新的深度数据
                SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: itemModel.instrument_id)
                self?.swapTransactionView.marketPriceView.clearDepathData()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击更多按钮
    @objc func clickMoreBtn(){
        let view = EXBouncedView()
        view.setData(getmodels())
        view.clickViewBlock = {[weak self]tag in
            guard let mySelf = self else{return}
            switch tag {
            case "contract_fund_setting".localized(): // 合约设置
                let settingVc = SLSwapSettingVc()
                settingVc.selectUnitBlock = {[weak self] in
                    guard let weakSelf = self else{return}
                    let isCoin = BTStoreData.storeBool(forKey: BT_UNIT_VOL)
                    weakSelf.swapTransactionView.marketPriceView.isCoin = isCoin
                    weakSelf.swapTransactionView.marketPriceView.updateDepthData(instrument_id: weakSelf.currentItemModel?.instrument_id ?? 0)
                    weakSelf.swapTransactionView.makeOrderView.makeOrderViewModel?.makerOrderUnitChangeBlock?()
                }
                settingVc.triggerChangeBlock = {[weak self] in
                    guard let weakSelf = self else{return}
                    let isCoin = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
                    if isCoin == 0 {
                        weakSelf.swapTransactionView.makeOrderView.clickTiggerPriceTypeBtn(weakSelf.swapTransactionView.makeOrderView.lastPriceBtn)
                    } else if isCoin == 1 {
                        weakSelf.swapTransactionView.makeOrderView.clickTiggerPriceTypeBtn(weakSelf.swapTransactionView.makeOrderView.fairPriceBtn)
                    } else {
                        weakSelf.swapTransactionView.makeOrderView.clickTiggerPriceTypeBtn(weakSelf.swapTransactionView.makeOrderView.indexPriceBtn)
                    }
                }
                mySelf.navigationController?.pushViewController(settingVc, animated: true)
            case "contract_fund_guide".localized(): // 合约指南
                let vc = WebVC()
                vc.title = "contract_fund_guide".localized()
                vc.loadUrl(PublicInfoEntity.sharedInstance.online_swap_guide)
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "contract_fund_calculator".localized(): // 合约 计算器
                let calculatorVc = SLSwapCalculatorVc()
                calculatorVc.itemModel = mySelf.currentItemModel
                mySelf.navigationController?.pushViewController(calculatorVc, animated: true)
            case "contract_fund_transaction".localized(): // 资金划转
                if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
                    BusinessTools.modalLoginVC()
                    return
                }
                EXAccountBalanceManager.manager.updateContractAccountBalance()
                let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                transfer.isPopRoot = true
                transfer.symbol = mySelf.currentItemModel?.contractInfo.margin_coin ?? ""
                transfer.transferFlow = .contractToExchagne
                transfer.onTrasferSuccessCallback = { (ftype,ttype) in
                }
                mySelf.navigationController?.pushViewController(transfer, animated: true)
            case "contract_swap_info".localized():  // 资金费率
                let vc = SLSwapFundRateVC()
                vc.itemModel = mySelf.currentItemModel
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "contract_profit_record".localized():
                if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
                    BusinessTools.modalLoginVC()
                    return
                }
                let vc = SLSwapProfitRecordVc()
                vc.itemModel = mySelf.currentItemModel
                mySelf.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        view.show()
    }
    
    // MARK: - Lazy
    let height = SCREEN_HEIGHT - TABBAR_HEIGHT - NAV_SCREEN_HEIGHT - 44
    
    // 切换合约
    lazy var chooseBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_sidepull"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickChooseBtn))
        return btn
    }()
    
    // 合约名称
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.isUserInteractionEnabled = true
        label.font = UIFont.ThemeFont.H3Bold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = "--"
        return label
    }()
    
    // 合约详情
    lazy var detailBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_klinediagram"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickDetailBtn))
        return btn
    }()
    
    // 更多按钮
    lazy var chargeBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "margin_more"), for: UIControlState.normal)
        btn.extSetAddTarget(self , #selector(clickMoreBtn))
        return btn
    }()
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 44, width: SCREEN_WIDTH, height: height))
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * 2, height: height)
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    var beforeTag = 1000
    
    lazy var toolView : SLSwapSegmentView = {
        let view = SLSwapSegmentView()
        view.extUseAutoLayout()
        view.clickBtnBlock = {[weak self](tag) in
            guard let mySelf = self else{return}
            if tag == 1000 { // 开仓
                mySelf.scrollView.setContentOffset(CGPoint.init(x: CGFloat(0) * SCREEN_WIDTH, y: 0), animated: true)
                mySelf.swapTransactionView.transactionShowType = .showOpen
            } else if tag == 1001 { // 平仓
                mySelf.scrollView.setContentOffset(CGPoint.init(x: CGFloat(0) * SCREEN_WIDTH, y: 0), animated: true)
                mySelf.swapTransactionView.transactionShowType = .showClose
            } else if tag == 1002 { // 持仓
                if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil {
                    BusinessTools.modalLoginVC()
                    if mySelf.beforeTag == 1000 {
                        mySelf.swapTransactionView.transactionShowType = .showOpen
                        view.reloadBtnStatus(view.openBtn)
                    } else if mySelf.beforeTag == 1001 {
                        mySelf.swapTransactionView.transactionShowType = .showClose
                        view.reloadBtnStatus(view.closeBtn)
                    }
                    return
                }
                // 获取持仓列表数据
                mySelf.swapPositionView.requestPositionData(self?.currentItemModel?.instrument_id ?? 0)
                mySelf.scrollView.setContentOffset(CGPoint.init(x: CGFloat(1) * SCREEN_WIDTH, y: 0), animated: true)
            }
            mySelf.beforeTag = tag
        }
        return view
    }()
    
    // 合约交易页面
    lazy var swapTransactionView : SLSwapTransactionView = {
        let view = SLSwapTransactionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height))
        view.jumpToAllTransactionVCCallback = {[weak self] in
            let vc = SLSwapAllTransactionsVC()
            vc.itemModel = self?.currentItemModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        view.clickTakeOrderBlock = {[weak self] orderModel in
            guard let mySelf = self else{return}
            if mySelf.swapTransactionView.makeOrderView.defineOrderType == .normalOrder {
                mySelf.swapTransactionView.makeOrderView.priceTextField.input.text = orderModel.px
                mySelf.swapTransactionView.makeOrderView.textFieldValueHasChanged(textField: mySelf.swapTransactionView.makeOrderView.priceTextField.input)
            } else if mySelf.swapTransactionView.makeOrderView.defineOrderType == .highOrder {
                mySelf.swapTransactionView.makeOrderView.priceTextField.input.text = orderModel.px
                mySelf.swapTransactionView.makeOrderView.textFieldValueHasChanged(textField: mySelf.swapTransactionView.makeOrderView.priceTextField.input)
            } else {
                mySelf.swapTransactionView.makeOrderView.triggerTextField.input.text = orderModel.px
                mySelf.swapTransactionView.makeOrderView.textFieldValueHasChanged(textField: mySelf.swapTransactionView.makeOrderView.triggerTextField.input)
            }
            
        }
        return view
    }()
    
    // 持仓页面
    lazy var swapPositionView : SLSwapPositionListView = {
        let view = SLSwapPositionListView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: height))
        view.loadPositionSuccess = {[weak self] idx in
            guard let mySelf = self else{return}
            mySelf.toolView.updataHoldPositionNumber(String(idx))
        }
        return view
    }()
}

// MARK: - loadData
extension SLSwapVc {
    // MARK: - data Config
    func getmodels() -> [EXBouncedModel]{
        var models = [EXBouncedModel]()
        let model = EXBouncedModel()
        model.img = "contract_settings"
        model.name = "contract_fund_setting".localized()
        models.append(model) // 合约设置
        
//        let model1 = EXBouncedModel()
//        model1.img = "contract_guide"
//        model1.name = "contract_fund_guide".localized()
//        models.append(model1) // 合约指南
        
        let model2 = EXBouncedModel()
        model2.img = "contract_calculator"
        model2.name = "contract_fund_calculator".localized()
        models.append(model2) // 合约计算器
       
        let model3 = EXBouncedModel()
        model3.img = "contract_transfer"
        model3.name = "contract_fund_transaction".localized()
        models.append(model3) // 资金划转
        
        let model4 = EXBouncedModel()
        model4.img = "contract_information"
        model4.name = "contract_swap_info".localized()
        models.append(model4) // 合约信息
        
        let model5 = EXBouncedModel()
        model5.img = "contract_positionRecord"
        model5.name = "contract_profit_record".localized()
        models.append(model5) // 合约信息
        return models
    }
    
    func setupNotes() {
        // 当接口请求Futures ticker数据更新时候获得通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setFuturesDataUpdata),
                                               name: NSNotification.Name(rawValue: BTLoadFuturesData_Notification),
                                               object: nil)
        // 当websocket合约ticker的时候刷新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(webSocketUpdateContractTicker),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification),
                                               object: nil)
        // 合约私有信息
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(websocketUpdataUnicast),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification),
                                               object: nil)
        // 合约深度
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(webSocketUpdateContractData),
                                                name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Depth_Notification),
                                                object: nil)
        // 监听登录成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLoginSuccess),
                                               name: NSNotification.Name(rawValue: "EXLoginSuccess"),
                                               object: nil)
        // 添加退出登录通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLogout),
                                               name: NSNotification.Name(rawValue: "Logout_notification_name"),
                                               object: nil)
        // websocket重新连接成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rearrangeSwapConnect),
                                               name: NSNotification.Name(rawValue: ContractWebSocketDidOpenNote),
                                               object: nil)
        // token失效
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenLoseEffectiveness),
                                               name: NSNotification.Name(rawValue: SLToken_Lose_effectiveness_Notification),
                                               object: nil)
    }
    
    func getFirstItemModel() {
        let tickerArr = SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? []
        if tickerArr.count == 0 {
            return
        }
        var instrument_id : Int64 = Int64(BTStoreData.storeObject(forKey: BTFuturesContractID) as? String ?? "0") ?? 0
        var firstItem = tickerArr[0]
        if instrument_id <= 0 && tickerArr.count > 0 {
            instrument_id = firstItem.instrument_id
            for itemModel in tickerArr {
                if itemModel.instrument_id < instrument_id {
                    instrument_id = itemModel.instrument_id
                    firstItem = itemModel
                }
            }
            self.currentItemModel = firstItem
            BTStoreData.setStoreObjectAndKey(String(instrument_id), key: BTFuturesContractID)
        } else {
            for item in tickerArr {
                if item.instrument_id == instrument_id {
                    self.currentItemModel = item
                    break
                }
            }
            if self.currentItemModel == nil {
                self.currentItemModel = firstItem
                BTStoreData.setStoreObjectAndKey(String(instrument_id), key: BTFuturesContractID)
            }
        }
        if currentItemModel == nil {
            SLSDK.sl_loadFutureMarketData {(result, error) in
                if SLContractSocketManager.shared().isConnected == false {
                    SLContractSocketManager.shared().srWebSocketOpen(withURLString: NetDefine.wss_host_contract)
                }
            }
        } else {
            
            if SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(0) == nil {
                SLSDK.sl_loadOrderBooks(withContractID: currentItemModel?.instrument_id ?? 0, price: currentItemModel?.last_px, count: 50, success: { (depthModel) in
                    self.swapTransactionView.marketPriceView.updateDepthData(instrument_id:self.currentItemModel!.instrument_id)
                }) { (error) in
                    
                }
            }
        }
    }
    
    /// 添加 socket 订阅

    private func addSocketSubscribe() {

    
        let instrument_id = self.currentItemModel?.instrument_id ?? 0
        
        SLSDK.sl_loadOrderBooks(withContractID: instrument_id, price: self.currentItemModel?.last_px, count: 20, success: { [weak self] (depthModel) in
            guard let _ = depthModel,
                let `self` = self else {
                    return
            }
            self.swapTransactionView.marketPriceView.updateDepthData(instrument_id: instrument_id)
            if self.isNeedUpdateSubscribeDepthData {
                // 订阅深度
                SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: self.currentItemModel?.instrument_id ?? 0)
            }
        }) { (error) in
            
            if self.isNeedUpdateSubscribeDepthData {
                // 订阅深度
                SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: self.currentItemModel?.instrument_id ?? 0)
            }
            
        }
        

    }
    
    /// 移出不需要的 socket 订阅
    private func removeSocketSubscibe() {
        if self.isNeedUpdateSubscribeDepthData {
            /// 取消订阅深度
            SLSocketDataManager.sharedInstance().sl_unSubscribeContractDepthData(withInstrument: self.currentItemModel?.instrument_id ?? 0)
            /// 取消订阅ticket
            
        }
    }
}

// MARK: - 接收通知
extension SLSwapVc {
    /// token失效
    @objc func tokenLoseEffectiveness() {
        XUserDefault.removeKey(key: XUserDefault.token)
        BusinessTools.modalLoginVC()
        self.swapTransactionView.transactionShowType = .showClose
        self.swapTransactionView.makeOrderView.reloadTransationTypeView()
        self.toolView.reloadBtnStatus(self.toolView.openBtn)
        refreshLogout()
    }
    
    func rearrangeSwapConnect() {
        SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: self.currentItemModel?.instrument_id ?? 0)
    }
    
    /// 登录成功刷新
    func refreshLoginSuccess(notification: NSNotification) {
        swapTransactionView.makeOrderView.refreshBtnTitle()
        swapTransactionView.makeOrderView.reloadMakeOrderData()
        // 加载仓位
        swapPositionView.requestPositionData(currentItemModel?.instrument_id ?? 0)
    }
    
    @objc private func refreshLogout() {
        self.swapTransactionView.cleanDataWhenLogout()
        self.swapPositionView.cleanDataWhenLogout()
        self.toolView.updataHoldPositionNumber("0")
    }
    
    func setFuturesDataUpdata(notification: NSNotification) {
        if notification.userInfo == nil || currentItemModel == nil {
            getFirstItemModel()
        }
    }
    
    func webSocketUpdateContractTicker(notification: NSNotification) {
        let message = notification.userInfo
        guard let item = message!["data"] as? BTItemModel else {
            return
        }
        if self.isNeedUpdateSubscribeTickerUI == false {
            return
        }
        if self.currentItemModel?.instrument_id == item.instrument_id {
            self.currentItemModel = item
        }
    }
    
    func websocketUpdataUnicast(notify: Notification) {
        guard let socketModelArray = notify.userInfo?["data"] as? [BTWebSocketModel] else {
            return
        }
        self.swapTransactionView.handleUnicastSocketData(socketModelArray: socketModelArray)
        
        var hasPosition = false
        var hasAsset = false
        for socketModel in socketModelArray {
            if socketModel.position != nil {
                hasPosition = true
            }
            if socketModel.c_assets != nil {
                hasAsset = true
            }
        }
        if hasPosition {
            self.swapPositionView.handleUnicastSocketData(socketModelArray: socketModelArray)
            if swapTransactionView.makeOrderView.transactionShowType == .showClose { // 平仓页面
                swapTransactionView.makeOrderView.reloadTransationTypeView()
            }
        }
        if hasAsset {
            swapTransactionView.makeOrderView.makeOrderViewModel?.asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: currentItemModel?.contractInfo.margin_coin)
        }
    }
    
    func webSocketUpdateContractData(notification: NSNotification) {
        guard let instrument_id = notification.userInfo!["instrument_id"] as? Int64 else {return}
        if instrument_id == self.currentItemModel?.instrument_id {
            swapTransactionView.marketPriceView.updateDepthData(instrument_id: instrument_id)
            guard let action = notification.userInfo!["action"] as? Int else {return}
            if action == 1 {
                swapTransactionView.makeOrderView.reloadMakeOrderData()
            }
        }
    }
}


// MARK: - 设置界面
extension SLSwapVc {
    private func setNavUI() {
        chooseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(16)
            make.height.equalTo(14)
            make.centerY.equalTo(self.navCustomView.popBtn)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chooseBtn.snp.right).offset(10)
            make.height.equalTo(25)
            make.right.equalTo(detailBtn.snp.left).offset(-10)
            make.centerY.equalTo(chooseBtn)
        }
        chargeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(17)
            make.width.equalTo(14)
            make.centerY.equalTo(chooseBtn)
        }
        detailBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(chooseBtn)
            make.right.equalTo(chargeBtn.snp.left).offset(-20)
            make.height.equalTo(14)
            make.width.equalTo(16)
        }
    }
    private func setVcUI() {
        contentView.addSubViews([toolView,scrollView])
        scrollView.addSubViews([swapTransactionView,swapPositionView])
        toolView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        forbidMoveFromScreenLeft()
        
        self.exEmptyDataSet(self.swapPositionView.contentTableView)
    }
}
