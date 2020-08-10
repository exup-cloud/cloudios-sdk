//
//  SLSwapDetailTransactionVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 历史委托详情
class SLSwapDetailTransactionVC : NavCustomVC, EXEmptyDataSetable {

    var itemMdoel: BTItemModel?
    
    var orderModel: BTContractOrderModel?
    
    var tableViewRowDatas: [BTContractTradeModel] = []
    
    let cellReUseID = "SLDetailTransactionCell_ID"
    
    lazy var tableHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 94))
        let marginView = UIView(frame: CGRect(x: 0, y: self.titleView.frame.size.height, width: view.width, height: 10))
        marginView.backgroundColor = UIColor.ThemeNav.bg
        view.addSubViews([titleView, marginView])
        return view
    }()
    
    lazy var titleView: SLSwapDetailTitleView = SLSwapDetailTitleView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 84))
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = 158
        tableView.extSetTableView(self, self)
        tableView.tableHeaderView = self.tableHeaderView
        tableView.extRegistCell([SLDetailTransactionCell.classForCoder()], [cellReUseID])
        tableView.mj_header = EXRefreshHeaderView(refreshingBlock: {
            [weak self] in
            guard let mySelf = self else { return }
            mySelf.requestHistoryData(instrument_id: mySelf.itemMdoel?.instrument_id ?? 0, oid: self?.orderModel?.oid ?? 0)
        })
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.contentTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.contentView.addSubview(self.contentTableView)
        self.initLayout()
        
        self.exEmptyDataSet(self.contentTableView)
        
        if self.orderModel != nil {
            self.updateHeader(order: self.orderModel!)
        }
        
        self.requestHistoryData(instrument_id: self.itemMdoel?.instrument_id ?? 0, oid: self.orderModel?.oid ?? 0)
    }
    
    override func setNavCustomV() {
        self.setTitle(self.orderModel?.name ?? "--")
        self.lastVC = true
        self.navtype = .list
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom).offset(18)
        }
    }
     
    
    private func updateHeader(order: BTContractOrderModel) {
        self.setTitle(self.orderModel?.name ?? "--")
        self.titleView.updateView(model: order)
    }
}


// MARK: - Data

extension SLSwapDetailTransactionVC {
    /// 请求历史数据
    private func requestHistoryData(instrument_id: Int64, oid: Int64) {
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil || instrument_id == 0 || oid == 0 {
            self.endRefresh()
            return
        }
        BTContractTool.getUserDetailHistoryOrder(withContractID: instrument_id, orderID: oid, success: { (res: [BTContractTradeModel]?) in
            if let modelArray = res {
                self.tableViewRowDatas = modelArray
            } else {
                self.tableViewRowDatas = []
            }
            self.contentTableView.reloadData()
            self.endRefresh()
        }) { (error) in
            self.endRefresh()
        }
    }
    
    private func endRefresh(){
        self.contentTableView.mj_header?.endRefreshing()
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLSwapDetailTransactionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewRowDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLDetailTransactionCell
        cell.contractInfo = self.itemMdoel?.contractInfo
        cell.updateCell(model: self.tableViewRowDatas[indexPath.row])
        let detailType = SLSwapOrderTool().getDetailType(model:orderModel!)
        if detailType == .force {
            cell.updataForceCell()
        }
        return cell
    }
}


/// 历史委托详情 - 顶部视图
class SLSwapDetailTitleView : UIView {
    /// 多 空 类型
    lazy var typeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadBold, textColor: nil, alignment: .left)
        return label
    }()
    /// 合约名称
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return label
    }()
    /// 成交均价
    lazy var dealAverageView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_text_dealAverage".localized())
        return view
    }()
    /// 成交数量
    lazy var dealVolumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("kline_text_volume".localized() + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    /// 手续费
    lazy var withDrawView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.contentAlignment = .right
        view.setTopText("withdraw_text_fee".localized())
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([typeLabel, nameLabel, dealAverageView, dealVolumeView, withDrawView])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.typeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.equalTo(18)
            make.top.equalTo(0)
        }
        self.nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel.snp_right).offset(9)
            make.height.equalTo(19)
            make.centerY.equalTo(self.typeLabel)
        }
        self.dealAverageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel)
            make.top.equalTo(self.typeLabel.snp_bottom).offset(17)
            make.height.equalTo(32)
        }
        self.dealVolumeView.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.dealAverageView)
            make.centerX.equalToSuperview()
        }
        self.withDrawView.snp_makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.height.equalTo(self.dealAverageView)
        }
    }
    
    
    func updateView(model: BTContractOrderModel) {
        var color = UIColor.ThemekLine.up
        var typeStr = "contract_openLong".localized()
        if model.side == .sell_OpenShort {
            color = UIColor.ThemekLine.down
            typeStr = "contract_openShort".localized()
        } else if model.side == .buy_CloseShort {
            color = UIColor.ThemekLine.up
            typeStr = "contract_flat_short".localized()
        } else if model.side == .sell_CloseLong {
            color = UIColor.ThemekLine.down
            typeStr = "contract_flat_long".localized()
        }
        
        self.typeLabel.textColor = color
        self.typeLabel.text = typeStr
        self.nameLabel.text = model.name ?? "--"
        let detailType = SLSwapOrderTool().getDetailType(model:model)
        if detailType == .force {
            self.dealAverageView.setBottomText("--")
        } else {
            if model.avg_px != nil {
                self.dealAverageView.setBottomText(model.avg_px.toSmallPrice(withContractID:model.instrument_id))
            } else {
                self.dealAverageView.setBottomText("--")
            }
        }
        self.dealVolumeView.setBottomText(model.cum_qty ?? "--")
        
        // 手续费
        var fee = "0"
        let make_fee = (model.make_fee.contains("-") ? (model.make_fee.extStringSub(NSRange.init(location: 1, length: model.make_fee.ch_length - 1))) :  model.make_fee) ?? "0"
        fee = (model.take_fee != nil && model.take_fee != "0") ? String(format: "%f", BasicParameter.handleDouble(model.take_fee!)) : String(format: "%f", BasicParameter.handleDouble(make_fee))
        
        self.withDrawView.setBottomText(fee)
    }
}
