//
//  SLSwapPositionListView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

/// 当前持仓
class SLSwapPositionListView: UIView {
    
    typealias LoadPositionSuccessBlock = (Int) -> ()
    var loadPositionSuccess : LoadPositionSuccessBlock?
    
    var itemModel : BTItemModel? {
        didSet {
            if let _itemModel = self.itemModel {
                self.updatePLNData(itemModel: _itemModel)
            }
        }
    }
    
    var tableViewRowDatas: [BTPositionModel] = []
    
    private let cellReUseID = "SLSwapPositionCell_ID"
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: UITableViewStyle.plain)
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.rowHeight = 315
        tableView.extRegistCell([SLSwapPositionCell.classForCoder()], [cellReUseID])
        tableView.mj_header = EXRefreshHeaderView(refreshingBlock: {
            [weak self] in
            guard let mySelf = self else { return }
            mySelf.requestPositionData(mySelf.itemModel?.instrument_id ?? 0)
        })
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentTableView)
        self.contentTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    } 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Data

extension SLSwapPositionListView {
    /// 请求持仓数据
    func requestPositionData(_ instrument_id : Int64) {
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil || instrument_id == 0 {
            self.endRefresh()
            return
        }
        BTContractTool.getUserPosition(withContractID: instrument_id, status: BTPositionStatus.holdSystem, offset: 0, size: 0, success: { (models: [BTPositionModel]?) in
            self.loadPositionSuccess?(models?.count ?? 0)
            self.tableViewRowDatas = models ?? []
            self.contentTableView.reloadData()
            self.endRefresh()
        }) { (error) in
            self.endRefresh()
        }
    }
    
    /// 处理私有信息 socket (这里只处理持仓列表)
    func handleUnicastSocketData(socketModelArray: [BTWebSocketModel]) {
        if socketModelArray.count == 0 {
            return
        }
        var modelArr: [BTPositionModel] = Array(self.tableViewRowDatas)
        var isChanged = false
        
        for socketModel in socketModelArray {
            guard let socketPositionModel = socketModel.position else {
                continue
            }
            // 已平仓
            if socketPositionModel.status == .close {
                for idx in 0..<modelArr.count {
                    if modelArr[idx].pid == socketPositionModel.pid {
                        // 如果websocket推送过来的是最新的
                        if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: modelArr[idx].updated_at) {
                            modelArr.remove(at: idx)
                            isChanged = true
                        }
                        break
                    }
                }
            } else if modelArr.count == 0 {
                if socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                    modelArr.append(socketPositionModel)
                    isChanged = true
                }
            } else {
                for idx in 0..<modelArr.count {
                    if modelArr[idx].pid == socketPositionModel.pid {
                        if BTFormat.getTimeStr(with: socketPositionModel.updated_at) >= BTFormat.getTimeStr(with: modelArr[idx].updated_at) {
                            modelArr[idx] = socketPositionModel
                            isChanged = true
                        }
                        break
                    }
                    if idx == modelArr.count - 1 && socketPositionModel.instrument_id == self.itemModel?.instrument_id {
                        modelArr.insert(socketPositionModel, at: 0)
                        isChanged = true
                    }
                }
            }
        }
        if isChanged == true {
            self.loadPositionSuccess?(modelArr.count)
            self.tableViewRowDatas = modelArr
            self.contentTableView.reloadData()
        }
    }
    
    /// 更新未实现盈亏数据 (当itemModel变化的时候就需要更新)
    func updatePLNData(itemModel: BTItemModel) {
        self.contentTableView.reloadData()
    }
    
    func cleanDataWhenLogout() {
        self.tableViewRowDatas = []
        self.contentTableView.reloadData()
    }
    
    private func endRefresh(){
        self.contentTableView.mj_header?.endRefreshing()
    }
}


// MARK: - <UITableViewDelegate & UITableViewDataSource>

extension SLSwapPositionListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableViewRowDatas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLSwapPositionCell
        cell.updateCell(model: model)
        cell.needReloadCellBlock = {[weak self] in
            self?.requestPositionData(self?.itemModel?.instrument_id ?? 0)
        }
        return cell
    }
}
