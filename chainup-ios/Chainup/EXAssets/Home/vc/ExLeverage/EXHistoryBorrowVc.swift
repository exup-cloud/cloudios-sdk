//
//  EXHistoryBorrowVc.swift
//  Chainup
//
//  Created by ljw on 2019/11/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHistoryBorrowVc:  UIViewController,NavigationPlugin,EXEmptyDataSetable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topCon: NSLayoutConstraint!
    var page = 1
    var coinMapName = ""//传进来
    var modelsArr = [EXCurrentBorrowListModel]()
    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: self.tableView, presenter: self)
        nav.isLastNavigationStyle = true
        return nav
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        handNavigationBar()
        bindCell()
        self.exEmptyDataSet(self.tableView, attributeBlock: { () -> ([EXEmptyDataSetAttributeKeyType : Any]) in
            return [
                .verticalOffset:(CGFloat(-110)),
            ]
        })
    }
    func handNavigationBar() {
       self.navigation.setTitle(title:"leverage_history_borrow".localized())
       self.navigation.setdefaultType(type: .list)
     
    }
    func largeTitleValueChanged(height: CGFloat) {
        topCon.constant = height
    }
    func bindCell()  {
        tableView.register(UINib.init(nibName: "EXCoinBorrowRecordCell", bundle: nil), forCellReuseIdentifier: "EXCoinBorrowRecordCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200;
        self.tableView.backgroundColor = UIColor.ThemeView.bg
        self.tableView.mj_header = EXRefreshHeaderView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.page = 1
            mySelf.getListData()
        })
        self.tableView.mj_footer = EXRefreshFooterView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.getListData()
        })
        getListData()
    }
}
extension EXHistoryBorrowVc {
    //获取表格数据
    func getListData(){
        appApi.rx.request(.leverBorrowHistory(symbol: coinMapName.uppercased(), startTime: nil, endTime: nil, page: String(self.page), pageSize: nil))
            .MJObjectMap(EXCurrentBorrowModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    guard let mySelf = self else{return}
                    if mySelf.page == 1{
                        mySelf.modelsArr.removeAll()
                    }
                    mySelf.modelsArr += model.financeList
                    mySelf.tableView.reloadData()
                    mySelf.page = mySelf.page + 1
                    mySelf.endRefresh()
                    break
                case .error(_):
                    break
                }
        }.disposed(by: self.disposeBag)
    }
    
    //结束刷新
    func endRefresh(){
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
    
}
extension EXHistoryBorrowVc:UITableViewDataSource,UITableViewDelegate {
         func numberOfSections(in tableView: UITableView) -> Int {
                return 1
         }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return modelsArr.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let element = modelsArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "EXCoinBorrowRecordCell", for: indexPath) as! EXCoinBorrowRecordCell
            cell.type = .history
            cell.setModel(model: element)
            return cell
        }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let element = modelsArr[indexPath.row]
          let vc = EXBorrowRecordDetailVc.init(nibName: "EXBorrowRecordDetailVc", bundle: nil)
            vc.id = element.id
           self.navigationController?.pushViewController(vc, animated: true)
        }
}
