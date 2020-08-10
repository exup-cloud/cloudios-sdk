//
//  EXHelpView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXHelpView: UIView {
    
    var tableViewRowDatas : [EXHelpEntity] = []
    
    var page = 1

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXHelpTC.classForCoder()], ["EXHelpTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        getData()
        self.tableView.mj_header = EXRefreshHeaderView (refreshingBlock: {[weak self] in
            guard let mySelf = self else {return}
            mySelf.getData()
        })
    }
    
    //获取数据
    func getData(){
        appApi.rx.request(AppAPIEndPoint.getHelp).MJObjectMap(CommonAryModel.self).subscribe(onSuccess: {[weak self] (model) in
            guard let mySelf = self else{return}
            if let arr = model.dictAry as? Array<[String : Any]>{
                mySelf.tableViewRowDatas.removeAll()
                for dict in arr{
                    let entity = EXHelpEntity()
                    entity.setEntityWithDict(dict)
                    mySelf.tableViewRowDatas.append(entity)
                }
            }
            mySelf.tableView.reloadData()
            mySelf.endRefresh()
        }) {[weak self] (error) in
            self?.endRefresh()
        }.disposed(by: disposeBag)
    }
    
    //结束刷新
    func endRefresh(){
        self.tableView.mj_header.endRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXHelpView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXHelpTC = tableView.dequeueReusableCell(withIdentifier: "EXHelpTC") as! EXHelpTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewRowDatas[indexPath.row]
        let vc = EXHelpDetailVC()
        vc.entity = entity
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
