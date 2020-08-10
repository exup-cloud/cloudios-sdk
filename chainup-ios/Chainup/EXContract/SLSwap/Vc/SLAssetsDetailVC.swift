//
//  SLAssetsDetailVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 币种详情
class SLAssetsDetailVC: NavCustomVC, EXEmptyDataSetable {

    private let cellReUseID = "SLSwapPositionCell_ID"
    
    var property = SLMinePerprotyModel()
    
    var itemCoinModel : BTItemCoinModel? {
        didSet {
            if itemCoinModel != nil {
                self.setTitle(itemCoinModel!.coin_code ?? "--")
                property.conversionContractAssetsWithitemModel(itemCoinModel)
                loadPositionData()
            }
        }
    }
    
    var positionArr : [BTPositionModel] = []
    
    lazy var tableHeaderView: SLAssetsDetailSectionHeader = {
        let view = SLAssetsDetailSectionHeader(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 108))
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapPositionCell.classForCoder()], [cellReUseID])
        tableView.tableHeaderView = self.tableHeaderView
        tableView.mj_header = EXRefreshHeaderView(refreshingBlock: {
            [weak self] in
            guard let mySelf = self else { return }
            mySelf.loadPositionData()
        })
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubViews([self.contentTableView])
        
        self.initLayout()
        
        self.exEmptyDataSet(self.contentTableView)
        
        // ticker数据更新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(webSocketUpdateContractTicker),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification),
                                               object: nil)
        // 合约私有信息更新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(websocketUpdataUnicast),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setNavCustomV() {
        self.lastVC = true
        self.xscrollView = self.contentTableView
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom).offset(18)
        }
    }
}

// MARK: - load data

extension SLAssetsDetailVC {
    private func loadPositionData() {
        BTContractTool.getUserPositionWithcoinCode(itemCoinModel?.coin_code, contractID: 0, status: .holdSystem, offset: 0, size: 0, success: {[weak self] (positions) in
            self?.contentTableView.mj_header.endRefreshing()
            guard let mySelf = self else {return}
            mySelf.positionArr = positions ?? []
            mySelf.contentTableView.reloadData()
            mySelf.property.conversionContractAssetsWithitemModel(mySelf.itemCoinModel)
            mySelf.tableHeaderView.updateInfo(mySelf.property)
        }) {[weak self] (error) in
            self?.contentTableView.mj_header.endRefreshing()
            print(error ?? "error is nil")
        }
    }
    
    @objc private func webSocketUpdateContractTicker(notification: NSNotification) {
        let message = notification.userInfo
        guard let itemModel = message!["data"] as? BTItemModel, itemModel.instrument_id == self.itemCoinModel?.instrument_id else {
            return
        }
        // 每当ticker变化的时候就需要更新未实现盈亏等数据, 内部会取新的itemModel进行计算
        self.property.conversionContractAssetsWithitemModel(self.itemCoinModel)
        self.tableHeaderView.updateInfo(self.property)
        self.contentTableView.reloadData()
    }
    
    @objc private func websocketUpdataUnicast(notification: NSNotification) {
        guard let socketModelArray = notification.userInfo?["data"] as? [BTWebSocketModel] else {
            return
        }
        var modelArr: [BTPositionModel] = Array(self.positionArr)
        var isChanged = false
        
        for socketModel in socketModelArray {
            guard let socketPositionModel = socketModel.position else {
                continue
            }
            // 已平仓
            if socketPositionModel.status == .close {
                for idx in 0..<modelArr.count {
                    if modelArr[idx].pid == socketPositionModel.pid {
                        modelArr.remove(at: idx)
                        isChanged = true
                        break
                    }
                }
            } else if modelArr.count == 0 {
                if socketPositionModel.contractInfo.margin_coin == self.itemCoinModel?.coin_code {
                    modelArr.append(socketPositionModel)
                    isChanged = true
                }
            } else {
                for idx in 0..<modelArr.count {
                    if modelArr[idx].pid == socketPositionModel.pid {
                        modelArr[idx] = socketPositionModel
                        isChanged = true
                        break
                    }
                    if idx == modelArr.count - 1 && socketPositionModel.contractInfo.margin_coin == self.itemCoinModel?.coin_code {
                        modelArr.insert(socketPositionModel, at: 0)
                        isChanged = true
                    }
                }
            }
        }
        if isChanged == true {
            self.positionArr = modelArr
            self.property.conversionContractAssetsWithitemModel(self.itemCoinModel)
            self.tableHeaderView.updateInfo(self.property)
            self.contentTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLAssetsDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLSwapPositionCell
        if indexPath.row == 0 {
            cell.isShowTitleView = true
        } else {
            cell.isShowTitleView = false
        }
        let positionModel = positionArr[indexPath.row]
        cell.updateCell(model:positionModel)
        cell.needReloadCellBlock = {[weak self] in
            self?.loadPositionData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 375
        } else {
            return 315
        }
    }
}

class SLAssetsDetailSectionHeader: UIView {
    /// 账户权益
    lazy var accountEquityView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_assets_account_equity".localized())
        return view
    }()
    
    /// 钱包余额
    lazy var walletBalanceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_assets_wallet_balance".localized())
        return view
    }()
    
    /// 保证金余额
    lazy var marginBalanceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_assets_margin_balance".localized())
        view.topLabel.textAlignment = .right
        view.bottomLabel.textAlignment = .right
        return view
    }()
    
    /// 未实现盈亏额
    lazy var unrealisedPNLView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_assets_unrealisedPNL".localized())
        return view
    }()
    
    /// 仓位保证金
    lazy var positionMarginView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_text_positionMargin".localized())
        return view
    }()
    
    /// 委托保证金
    lazy var orderMarginView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_text_orderMargin".localized())
        view.topLabel.textAlignment = .right
        view.bottomLabel.textAlignment = .right
        return view
    }()
    
    /// 分隔线
    lazy var bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([accountEquityView, walletBalanceView, marginBalanceView, unrealisedPNLView, positionMarginView, orderMarginView, bottomMarginView])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin: CGFloat = 15.0
        let width = (SCREEN_WIDTH - horMargin * 2) / 3
        self.accountEquityView.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.width.equalTo(width)
            make.height.equalTo(34)
            make.top.equalTo(0)
        }
        self.walletBalanceView.snp_makeConstraints { (make) in
            make.left.equalTo(self.accountEquityView.snp_right)
            make.width.equalTo(self.accountEquityView)
            make.height.equalTo(self.accountEquityView)
            make.top.equalTo(self.accountEquityView)
        }
        self.marginBalanceView.snp_makeConstraints { (make) in
            make.left.equalTo(self.walletBalanceView.snp_right)
            make.width.equalTo(self.accountEquityView)
            make.height.equalTo(self.accountEquityView)
            make.top.equalTo(self.accountEquityView)
        }
        self.unrealisedPNLView.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.width.equalTo(width)
            make.height.equalTo(34)
            make.top.equalTo(self.accountEquityView.snp_bottom).offset(15)
        }
        self.positionMarginView.snp_makeConstraints { (make) in
            make.left.equalTo(self.unrealisedPNLView.snp_right)
            make.width.equalTo(self.unrealisedPNLView)
            make.height.equalTo(self.unrealisedPNLView)
            make.top.equalTo(self.unrealisedPNLView)
        }
        self.orderMarginView.snp_makeConstraints { (make) in
            make.left.equalTo(self.positionMarginView.snp_right)
            make.width.equalTo(self.positionMarginView)
            make.height.equalTo(self.positionMarginView)
            make.top.equalTo(self.positionMarginView)
        }
        self.bottomMarginView.snp_makeConstraints { (make) in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func updateInfo(_ property : SLMinePerprotyModel) {
        let entity = PublicInfoManager.sharedInstance.coinPrecision(property.coin_code)
        accountEquityView.bottomLabel.text = property.total_amount.decimalString(entity)
        walletBalanceView.bottomLabel.text = property.walletBalance.decimalString(entity)
        marginBalanceView.bottomLabel.text = property.avail_funds.decimalString(entity)
        unrealisedPNLView.bottomLabel.text = property.profitOrLoss.decimalString(entity)
        positionMarginView.bottomLabel.text = property.holdDeposit.decimalString(entity)
        orderMarginView.bottomLabel.text = property.entrustDeposit.decimalString(entity)
    }
}
