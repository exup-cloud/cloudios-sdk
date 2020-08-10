//
//  ContractCurrentEntrustView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class ContractCurrentEntrustView: UIView {
    
    var entity = ContractContentModel()
    
    var page = 1
    
    var tableViewRowDatas : [ContractCurrentEntity] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([ContractTransactionTC.classForCoder()], ["ContractTransactionTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.mj_header = EXRefreshHeaderView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.page = 1
            mySelf.getContractCurrent()
        })
        
        self.tableView.mj_footer = EXRefreshFooterView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.getContractCurrent()
        })
    }
    
    //获取合约当前数据
    func getContractCurrent(){
        contractApi.rx.request(ContractAPIEndPoint.getOrderList(contractId: entity.id, pageSize: "20", page: "\(page)", side: "")).MJObjectMap(ContractCurrentList.self).subscribe(onSuccess: {[weak self] (model) in
            guard let mySelf = self else{return}
            if mySelf.page == 1{
                mySelf.tableViewRowDatas.removeAll()
            }
            let orderList = model.orderList
            for model in orderList{
                mySelf.tableViewRowDatas.append(model)
            }
            mySelf.tableView.reloadData()
            mySelf.page = mySelf.page + 1
            mySelf.endrefresh()
        }) {[weak self] (error) in
            self?.endrefresh()
            }.disposed(by: disposeBag)
    }
    
    //撤销合约订单
    func cancelContractCurrent(_ entity : ContractCurrentEntity){
        contractApi.rx.request(ContractAPIEndPoint.cancelOrder(orderId: entity.orderId, contractId: entity.contractId)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            guard let mySelf = self else{return}
            EXAlert.showSuccess(msg: "common_tip_cancelSuccess".localized())
            mySelf.page = 1
            mySelf.getContractCurrent()
        }) { (error) in
            
            }.disposed(by: disposeBag)
    }
    
    func endrefresh(){
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractCurrentEntrustView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : ContractTransactionTC = tableView.dequeueReusableCell(withIdentifier: "ContractTransactionTC") as! ContractTransactionTC
        cell.setCell(entity)
        cell.clickCancelBlock = {[weak self]entity in
            self?.cancelContractCurrent(entity)
        }
        return cell
    }
    
}
