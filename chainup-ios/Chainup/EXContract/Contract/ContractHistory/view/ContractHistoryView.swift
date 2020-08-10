//
//  ContractHistoryView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class ContractHistoryView: UIView {
    
    var params : [String : String] = [:]
    
    var entity = ContractContentModel()
    {
        didSet{
            params["symbol"] = entity.baseSymbol + entity.quoteSymbol
            params["contractType"] = entity.contractType
            params["side"] = ""
            params["orderType"] = ""
            params["isShowCanceled"] = "1"
            params["startTime"] = ""
            params["endTime"] = ""
            params["action"] = ""
        }
    }
    
    var tableViewRowDatas : [ContractCurrentEntity] = []
    
    var page = 1
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.estimatedRowHeight = 207
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([ContractHistoryTC.classForCoder()], ["ContractHistoryTC"])
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
            mySelf.getContractHistory()
        })
        
        self.tableView.mj_footer = EXRefreshFooterView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.getContractHistory()
        })
    }
    
    func setParams(_ param : [String : String]){
        if let symbol = param["symbol"] {
            params["symbol"] = symbol
        }
        
        if let contractType = param["contractType"] {
            params["contractType"] = contractType
        }
        
        if let action = param["action"]{
            params["action"] = action
        }
        
        if let side = param["side"] {
            params["side"] = side
        }
        
        if let orderType = param["orderType"] {
            params["orderType"] = orderType
        }
        
        if let isShowCanceled = param["isShowCanceled"] {
            if isShowCanceled == "0"{
                params["isShowCanceled"] = "1"
            }else{
                params["isShowCanceled"] = "0"
            }
        }
        
        if let startTime = param["startTime"] {
            params["startTime"] = startTime
        }
        
        if let endTime = param["endTime"] {
            params["endTime"] = endTime
        }
    }
    
    //获取历史合约
    func getContractHistory(){
        guard let symbol = params["symbol"] else{return}
        guard let contractType = params["contractType"] else{return}
        guard let side = params["side"] else{return}
        guard let orderType = params["orderType"] else{return}
        guard let isShowCanceled = params["isShowCanceled"] else{return}
        guard let startTime = params["startTime"] else{return}
        guard let endTime = params["endTime"] else{return}
        guard let action = params["action"] else{return}
        
        contractApi.rx.request(ContractAPIEndPoint.getHistoryList(symbol : symbol , contractType: contractType, pageSize: "20", page: "\(page)", side: side, orderType : orderType,isShowCanceled: isShowCanceled, startTime: startTime, endTime: endTime,action:action)).MJObjectMap(ContractCurrentList.self).subscribe(onSuccess: {[weak self] (model) in
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
    
    func endrefresh(){
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ContractHistoryView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : ContractHistoryTC = tableView.dequeueReusableCell(withIdentifier: "ContractHistoryTC") as! ContractHistoryTC
        cell.setCell(entity)
        return cell
    }
    
}
