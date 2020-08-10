//
//  SLSwapMarketDetailVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 市场详情 k 线
class SLSwapMarketDetailVC: UIViewController, NavigationPlugin {
    
    var changeItemCallback: ((BTItemModel) -> ())?
    
    var itemModel: BTItemModel?
    
    var depthModel = BTDepthModel()
    
    var dealRecordDataArray: [SLTransactionRecordModel]?
    
    
    
    private var kLineVM = SLKLineVM()
    
    private var maxOrderVolume: Double = 0.0
    
    private var infoType = TransactionDetailsType.depth
    private var menuModel = EXMenuSelectionModel.init()
    var menuRelay = BehaviorRelay<EXMenuSelectionModel>(value:EXMenuSelectionModel())
    
    private let depthCellReUseID = "SLMarketDetailDepthCell_ID"
    private let transactionCellReUseID = "SLTransactionDepthCell_ID"
    private let recordTitleReUseID = "SLTransactionRecordTitleCell_ID"
    private let recordCellReUseID = "SLTransactionRecordCell_ID"

    internal lazy var navigation: EXNavigation = EXNavigation.init(affectScroll: nil, presenter: self)
    private var customNaviItem = EXNaviDrawerView()
    
    private lazy var tableHeaderView: SLSwapMarketDetailHeader = {
        let view = SLSwapMarketDetailHeader(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 537))
        view.enterFundRateVCCallBack = {[weak self] in
            let vc = SLSwapFundRateVC()
            vc.itemModel = self?.itemModel
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.extSetTableView(self, self)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableHeaderView = self.tableHeaderView
        tableView.extRegistCell([SLMarketDetailDepthCell.classForCoder(), SLTransactionDepthCell.classForCoder(), SLTransactionRecordTitleCell.classForCoder(), SLTransactionRecordCell.classForCoder()], [depthCellReUseID, transactionCellReUseID, recordTitleReUseID, recordCellReUseID])
        return tableView
    }()
    
    private lazy var sectionHeader: EXMarketDetailSectionHeader = {
        let view = EXMarketDetailSectionHeader(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 43))
        view.hideIntroduce()
        view.type = .depth
        view.headerActionCallback = {[weak self] type in
            self?.infoType = type
            if type == .depth {
                self?.requestDepthData()
            } else if type == .deal {
                self?.requestDealData()
            }
        }
        return view
    }()
    
    private lazy var buyButton: EXFlatBtn = {
        let button = EXFlatBtn()
        let attrString = NSMutableAttributedString().add(string: "contract_buy_openMore2".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: "contract_buy_openMore_tip".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold])
        button.setAttributedTitle(attrString, for: .normal)
        button.bgColor = UIColor.ThemekLine.up
        button.extSetAddTarget(self, #selector(buyButtonClick))
        return button
    }()
    
    private lazy var sellButton: EXFlatBtn = {
        let button = EXFlatBtn()
        let attrString = NSMutableAttributedString().add(string: "contract_sell_openLess2".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: "contract_sell_openLess_tip".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.ThemeFont.BodyBold])
        button.setAttributedTitle(attrString, for: .normal)
        button.bgColor = UIColor.ThemekLine.down
        button.extSetAddTarget(self, #selector(sellButtonClick))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.ThemeView.bg
        
        self.initNavigation()
        
        self.view.addSubViews([contentTableView, buyButton, sellButton])
        
        self.initLayout()
        
        self.handleTableHeader()
        
        menuRelay.asObservable().subscribe(onNext: {[weak self] model in
            guard let `self` = self else {return}
            
            self.tableHeaderView.menuModel = model
        }).disposed(by: self.disposeBag)
        
        self.kLineVM.reciveKLineSocketData = {[weak self] itemArr in
            self?.tableHeaderView.kLineView.appendData(data: itemArr)
        }
        // 添加 socket 订阅
        self.addSocketSubscribe()
        
        // 更新整体
        self.updateAllContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSocketNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        self.removeSocketSubscribe()
    }
    
    private func initNavigation() {
        navigation.setdefaultType(type: .listtitle)

        let custom = EXNaviDrawerView()
        navigation.addSubview(custom)
        
        custom.bind("--")
        
        custom.tapBtn.addTarget(self, action: #selector(changeItemClick), for: .touchUpInside)
        custom.snp.makeConstraints { (make) in
            make.left.equalTo(navigation.popBtn.snp.right).offset(15)
            make.centerY.equalTo(navigation.popBtn)
            make.height.equalTo(14)
        }
        customNaviItem = custom
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigation.snp_bottom)
            make.bottom.equalTo(self.buyButton.snp_top)
        }
        self.buyButton.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
        self.sellButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.buyButton.snp_right)
            make.bottom.equalTo(self.buyButton)
            make.height.equalTo(self.buyButton)
            make.width.equalTo(self.buyButton)
        }
    }
    
    private func handleTableHeader() {
        /// 进入全屏 k 线
        self.tableHeaderView.enterFullScreenCallBack = {[weak self] in
            guard let `self` = self else {return}
            self.tableHeaderView.dismissDropView()
            let vc = SLSwapMarketDetailHorVC()
            vc.itemModel = self.itemModel
            vc.menuModel = self.menuModel
            vc.menuPublish.subscribe(onNext:{[weak self] model in
                guard let `self` = self else {return}
                self.menuRelay.accept(model)
            }).disposed(by: self.disposeBag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        /// 更改 k 线时间间隔
        self.tableHeaderView.scalePublish.subscribe(onNext:{[weak self] key in
            guard let `self` = self else {return}
            self.menuModel.scaleKey = key
            self.tableHeaderView.kLineView.hideSelection()
            // 重新请求 K 线数据
            self.requestLineChartData(scaleKey: key)
        }).disposed(by: self.disposeBag)
        
        /// 更改 k 线主图指标
        self.tableHeaderView.masterType.subscribe(onNext:{[weak self] type in
            guard let `self` = self else {return}
            self.menuModel.masterType = type
            self.tableHeaderView.kLineView.hideSelection()
        }).disposed(by: self.disposeBag)
        
        /// 更改 k 线副图指标
        self.tableHeaderView.assistantType.subscribe(onNext:{[weak self] type in
            guard let `self` = self else {return}
            self.menuModel.assitantType = type
            self.tableHeaderView.kLineView.hideSelection()
        }).disposed(by: self.disposeBag)
        
        /// 点击 k 线
        self.tableHeaderView.kLineView.didTapklineCallback = {[weak self] in
            self?.tableHeaderView.dismissDropView()
        }
    }
}


// MARK: - Update Data

extension SLSwapMarketDetailVC {
    /// 更新全部数据
    private func updateAllContent() {
        self.updateHeader()
        if self.infoType == .depth {
            self.requestDepthData()
        } else {
            self.requestDealData()
        }
        self.requestLineChartData(scaleKey: self.menuModel.scaleKey)
    }
    
    private func updateHeader() {
        guard let _itemModel = self.itemModel else {
            return
        }
        self.customNaviItem.bind(_itemModel.name ?? "--")
        self.tableHeaderView.updateHeader(_itemModel)
    }
    
    /// 请求 k 线数据
    private func requestLineChartData(scaleKey: String) {
        guard let _itemModel = self.itemModel else {
            return
        }
        
        self.kLineVM.requestKLineData(scaleKey: scaleKey, contract_id:  _itemModel.instrument_id, complete: {[weak self] (itemArray) in
            guard let _itemArray = itemArray else {
                return
            }
            self?.tableHeaderView.kLineView.reloadData(data: _itemArray)
            self?.requestLineChartData(scaleKey:scaleKey)
        }) { [weak self](fullItemArray) in
            guard let _itemArray = fullItemArray else {
                return
            }
            self?.tableHeaderView.kLineView.reloadData(data: _itemArray)
            self?.kLineVM.subscribKLineSocketData(contract_id: _itemModel.instrument_id, scaleKey: scaleKey)
        }
    }
    
    /// 更新挂单深度数据列表
    private func requestDepthData() {
        guard let _itemModel = self.itemModel else {
            return
        }
        self.contentTableView.reloadData()
        SLSDK.sl_loadOrderBooks(withContractID: _itemModel.instrument_id, price: _itemModel.last_px, count: 20, success: { (depthModel) in
            guard let _depthModel = depthModel else {
                return
            }
            // 需要取出前 20 条数据中的最大值
            self.maxOrderVolume = self.findMaxVolFromDepthData(depthModel: _depthModel)
            
            self.depthModel = _depthModel
            if self.infoType == .depth {
                self.contentTableView.reloadData()
            }
        }) { (error) in

        }
    }
    
    /// 取出前 20 条数据中的最大值
    private func findMaxVolFromDepthData(depthModel: BTDepthModel) -> (Double) {
        var maxBuyVol: Double = 0
        var maxSellVol: Double = 0
        
        for i in 0..<20 {
            if let buyModel = depthModel.buys[safe: i] {
                if BasicParameter.handleDouble(buyModel.qty) > maxBuyVol {
                    maxBuyVol = BasicParameter.handleDouble(buyModel.qty)
                }
            }
            if let sellModel = depthModel.sells[safe: i] {
                if BasicParameter.handleDouble(sellModel.qty) > maxSellVol {
                    maxSellVol = BasicParameter.handleDouble(sellModel.qty)
                }
            }
        }
        return max(maxBuyVol, maxSellVol)
    }
    
    /// 获取成交记录列表
    private func requestDealData() {
        guard let _itemModel = self.itemModel else {
            return
        }
        SLSDK.sl_loadFutureLatestDeal(withContractID: _itemModel.instrument_id) { (resArr: [BTContractTradeModel]?) in
            guard let array = resArr else {
                return
            }
            self.dealRecordDataArray = self.handleDealRecordData(dataArray: array)
            if self.infoType == .deal {
                self.contentTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Socket Data
    
    /// 添加 socket 订阅
    private func addSocketSubscribe() {
        if let _itemModel = self.itemModel {
            // 订阅深度
            SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: _itemModel.instrument_id)
            // 订阅最新成交
            SLSocketDataManager.sharedInstance().sl_subscribeContractTradeData(withInstrument: _itemModel.instrument_id)
        }
    }
    
    private func removeSocketSubscribe() {
        if let instrument_id = self.itemModel?.instrument_id {
            // 取消订阅最新成交
            SLSocketDataManager.sharedInstance().sl_unSubscribeContractTradeData(withInstrument: instrument_id)
            // 取消订阅 k 线数据
            self.kLineVM.unsubscribeKLineScoketData(contract_id: instrument_id)
        }
    }
    
    /// 添加 socket 数据通知
    private func addSocketNotification() {
        // ticker
        NotificationCenter.default.addObserver(self, selector: #selector(handleTickerSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification), object: nil)
        // 深度
        NotificationCenter.default.addObserver(self, selector: #selector(handleDepthSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Depth_Notification), object: nil)
        // 最新成交
        NotificationCenter.default.addObserver(self, selector: #selector(handleTradeSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Trade_Notification), object: nil)
        // websocket重新连接成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rearrangeSwapConnect),
                                               name: NSNotification.Name(rawValue: ContractWebSocketDidOpenNote),
                                               object: nil)
    }
    
    @objc func rearrangeSwapConnect() {
        self.addSocketSubscribe()
        updateAllContent()
    }
    
    /// ticker 数据
    @objc func handleTickerSocketData(notify: Notification) {
        guard let itemModel = notify.userInfo?["data"] as? BTItemModel else {
            return
        }
        if itemModel.instrument_id == self.itemModel?.instrument_id {
            self.itemModel = itemModel
            self.updateHeader()
        }
    }
    
    /// 深度数据
    @objc func handleDepthSocketData(notify: Notification) {
        guard let instrument_id = notify.userInfo!["instrument_id"] as? Int64 else { return }
        if instrument_id == self.itemModel?.instrument_id && self.infoType == .depth {
            self.depthModel.buys = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(20)
            self.depthModel.sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(20)
            self.maxOrderVolume = self.findMaxVolFromDepthData(depthModel: self.depthModel)
            
            self.contentTableView.reloadData()
        }
    }
    
    /// 最新成交
    @objc func handleTradeSocketData(notify: Notification) {
        guard let trades = notify.userInfo?["data"] as? [BTContractTradeModel] else {
            return
        }
        
        if self.infoType == .deal {
            self.dealRecordDataArray = self.handleDealRecordData(dataArray: trades)
            self.contentTableView.reloadData()
        }
    }
    
    /// 处理接口返回的数据并转换为视图需要的格式
    private func handleDealRecordData(dataArray: [BTContractTradeModel]) -> [SLTransactionRecordModel] {
        var tempArrM = [SLTransactionRecordModel]()
        for i in 0..<20 {
            let model = SLTransactionRecordModel()
            if let tempModel = dataArray[safe: i] {
                model.time = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: tempModel.created_at), format: "HH:mm:ss")
                model.price = tempModel.px
                model.vol = tempModel.qty
                if tempModel.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_OLOS_1 || tempModel.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_OLCL_2 || tempModel.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_CSOS_3 || tempModel.side == BTContractTradeWay.CONTRACT_TRADE_WAY_BUY_CSCL_4 {
                    model.side = .buy
                } else {
                    model.side = .sell
                }
                tempArrM.append(model)
            } else {
                tempArrM.append(model)
            }
        }
        return tempArrM
    }
}

// MARK: - Click Events

extension SLSwapMarketDetailVC {
    /// 切换合约
    @objc func changeItemClick() {
        self.view.isUserInteractionEnabled = false
        let vc = EXDrawerVC()
        let view = SLSwapDrawerView.getSharedInstance()
        view.clickCellBlock = {[weak self](entity) in
            if entity.instrument_id != self?.itemModel?.instrument_id {
                self?.itemModel = entity
                self?.addSocketSubscribe()
                self?.updateAllContent()
                self?.changeItemCallback?(entity)
            }
            vc.pullAnimation()
        }
        vc.pullBlock = {[weak self] in
            self?.view.isUserInteractionEnabled = true
        }
        vc.addView(view)
        view.tableView.reloadEmptyDataSet()
        vc.pullBlock = {[weak self] in
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    @objc func buyButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sellButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLSwapMarketDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch infoType {
            case .depth:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: depthCellReUseID) as! SLMarketDetailDepthCell
                    cell.depthView.updateView(depthModel: self.depthModel, lastestPrice: self.itemModel?.last_px ?? "--")
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellReUseID) as! SLTransactionDepthCell
                    let buyModel = self.depthModel.buys[safe: indexPath.row - 1]
                    let sellModel = self.depthModel.sells[safe: indexPath.row - 1]
                    cell.updateCell(buyModel: buyModel, sellModel: sellModel, maxVol: self.maxOrderVolume)
                    return cell
                }
            case .deal:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: recordTitleReUseID) as! SLTransactionRecordTitleCell
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: recordCellReUseID) as! SLTransactionRecordCell
                    let model = self.dealRecordDataArray?[safe: indexPath.row - 1]
                    cell.updateCell(model)
                    return cell
                }
            case .introduce:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.infoType == .depth) {
            if indexPath.row == 0 {
                return 255
            }
            return 30
        }
        if infoType == .deal {
            if indexPath.row == 0 {
                return 36
            }
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableHeaderView.dismissDropView()
    }
}
