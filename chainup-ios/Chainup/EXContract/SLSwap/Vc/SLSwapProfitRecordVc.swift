//
//  SLSwapProfitRecordVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/27.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapProfitRecordVc: NavCustomVC, EXEmptyDataSetable {
     
    let cellReUseID = "SLSwapPositionHistoryCell"
    
    var itemModel: BTItemModel?
    
    /// 币种数组倒序
    let itemModelArray: [BTItemModel] = {
        var arrM = [BTItemModel]()
        for obj in SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? [] where obj.contractInfo != nil {
            if obj.name != nil {
                arrM.append(obj)
            }
        }
        arrM.sort { (obj1, obj2) -> Bool in
            obj1.instrument_id < obj2.instrument_id
        }
        return arrM
    }()
    
    var positionArr : [BTPositionModel] = []
    
    lazy var sectionHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 46))
        view.backgroundColor = UIColor.ThemeNav.bg
        view.addSubview(self.screeningView)
        return view
    }()
    
    lazy var screeningView: SLSwapScreeningView = {
        let view = SLSwapScreeningView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 36))
        view.isOnlyShowName = true
        return view
    }()
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = 154
        tableView.extSetTableView(self, self)
//        tableView.tableHeaderView = self.sectionHeaderView
        tableView.extRegistCell([SLSwapPositionHistoryCell.classForCoder()], [cellReUseID])
        tableView.mj_header = EXRefreshHeaderView(refreshingBlock: {
            [weak self] in
            guard let mySelf = self else { return }
            mySelf.requestPositionHistory()
        })
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
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
        var arr = [String]()
        for itemModel in self.itemModelArray {
            arr.append(itemModel.name ?? "-")
        }
        self.screeningView.swapNameArray = arr
        self.screeningView.orderTypeButton.isHidden = true
        self.screeningView.screeningValueChanged = {[weak self]
            (swapNameIndex: Int, pirceTypeIndex: Int, orderTypeIndex: Int) in
            guard let mySelf = self else { return }
            let currentItemModel = mySelf.itemModelArray[swapNameIndex]
            mySelf.itemModel = currentItemModel
            mySelf.requestPositionHistory()
        }
        requestPositionHistory()
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_profit_record".localized())
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

extension SLSwapProfitRecordVc {
    /// 获取盈亏记录
    private func requestPositionHistory() {
        if itemModel == nil {
            return
        }
        BTContractTool.getUserPosition(withContractID: itemModel!.instrument_id, status: .close, offset: 0, size: 0, success: {[weak self] (positions) in
            guard let mySelf = self else {return}
            guard let modelArray = positions else {
                mySelf.endRefresh()
                return
            }
            mySelf.endRefresh()
            mySelf.positionArr = modelArray
            mySelf.contentTableView.reloadData()
        }) { (error) in
            self.endRefresh()
        }
    }
    private func endRefresh() {
        self.contentTableView.mj_header?.endRefreshing()
    }
}

extension SLSwapProfitRecordVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLSwapPositionHistoryCell
        let positionModel = positionArr[indexPath.row]
        cell.updateCell(model:positionModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}

