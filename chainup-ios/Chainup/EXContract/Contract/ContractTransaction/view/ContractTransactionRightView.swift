//
//  ContractTransactionRightView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class ContractTransactionRightView: UIView {
    
    typealias GetEntityBlock = (ContractTransactionTagPrice) -> ()
    var getEntityBlock : GetEntityBlock?
    
    //点击右边的钱数
    typealias ClickRightBlock = (ContractTransactionWSEntity) -> ()
    var clickRightBlock : ClickRightBlock?
    
    var buyTableViewRowDatas : [ContractTransactionWSEntity] = []
    var sellTableViewRowDatas : [ContractTransactionWSEntity] = []
    
    var tableViewRowDatas : [ContractTransactionWSEntity] = []
    
    var middleTCRow = 5
    
    var entity = ContractContentModel()
    
    lazy var headView : ContractTransactionRightHeaderView = {
        let view = ContractTransactionRightHeaderView()
        return view
    }()
    
    lazy var footView : ContractTransactionRightFooterView = {
        let view = ContractTransactionRightFooterView()
        view.clickPankouBlock = {[weak self](type) in
            switch type{
            case .defaultPan://默认盘口
                self?.middleTCRow = 5
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
                }else{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "default_reversepankou"), for: UIControlState.normal)
                }
//                self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "defaultpankou"), for: UIControlState.normal)
            case .buy://买
                self?.middleTCRow = 0
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "buy"), for: UIControlState.normal)
                }else{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "sell"), for: UIControlState.normal)
                }
//                self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "buy"), for: UIControlState.normal)
            case .sell://卖
                self?.middleTCRow = 10
                if EXKLineManager.isGreen() == true{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "sell"), for: UIControlState.normal)
                }else{
                    self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "buy"), for: UIControlState.normal)
                }
//                self?.footView.dishBtn.setImage(UIImage.themeImageNamed(imageName: "sell"), for: UIControlState.normal)
            }
            self?.setTableViewRowDatas()
        }
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.bounces = false
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([ContractTransactionRightTC.classForCoder(),ContractTransationMiddleTC.classForCoder()], ["ContractTransactionRightTC","ContractTransationMiddleTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        reloadView()
    }
    
    func reloadView(){
        tableViewRowDatas.removeAll()
        buyTableViewRowDatas.removeAll()
        sellTableViewRowDatas.removeAll()
        for i in 0..<11{
            if i < 5{
                let entity = ContractTransactionWSEntity()
                entity.side = "2"
                tableViewRowDatas.append(entity)
            }else{
                let entity = ContractTransactionWSEntity()
                entity.side = "1"
                tableViewRowDatas.append(entity)
            }
            buyTableViewRowDatas.append(ContractTransactionWSEntity())
            
            let sell = ContractTransactionWSEntity()
            sell.side = "2"
            sellTableViewRowDatas.append(sell)
        }
        tableView.reloadData()
        
        footView.reloadView()
    }
    
    //设置买
    func setBuy(_ prices : [String] , volums : [String] , max : String){
        buyTableViewRowDatas.removeAll()
        for _ in 0..<11{
            buyTableViewRowDatas.append(ContractTransactionWSEntity())
        }
        for i in 0..<prices.count{
            buyTableViewRowDatas[i].price = prices[i]
            buyTableViewRowDatas[i].volum = volums[i]
            buyTableViewRowDatas[i].max = max
        }
        setTableViewRowDatas()
    }
    
    //设置卖
    func setSell(_ prices : [String] , volums : [String] , max : String){
        sellTableViewRowDatas.removeAll()
        for _ in 0..<11{
            let sell = ContractTransactionWSEntity()
            sell.side = "2"
            sellTableViewRowDatas.append(sell)
        }
        for i in 0..<prices.count{
            sellTableViewRowDatas[10 - i].price = prices[i]
            sellTableViewRowDatas[10 - i].volum = volums[i]
            sellTableViewRowDatas[10 - i].max = max
        }
        setTableViewRowDatas()
    }
    
    //
    func setTableViewRowDatas(){
        tableViewRowDatas = []
        for _ in 0..<11{
            tableViewRowDatas.append(ContractTransactionWSEntity())
        }
        if middleTCRow == 0{
            tableViewRowDatas[1..<11] = buyTableViewRowDatas[0..<10]
        }else if middleTCRow == 5{
            tableViewRowDatas[6..<11] = buyTableViewRowDatas[0..<5]
            tableViewRowDatas[0..<5] = sellTableViewRowDatas[6..<11]
        }else{
            tableViewRowDatas[0..<10] = sellTableViewRowDatas[1..<11]
        }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractTransactionRightView{
    
    //获取指数价格 标记价格
    func getIndex(){
        contractApi.hideAutoLoading()
        contractApi.rx.request(ContractAPIEndPoint.tagPrice(contractId: entity.id)).MJObjectMap(ContractTransactionTagPrice.self).subscribe(onSuccess: {[weak self] (entity) in
            guard let mySelf = self else{return}
            self?.getEntityBlock?(entity)
            self?.footView.indicatorsPrice.text = (entity.indexPrice.decimalNumberWithDouble() as NSString).decimalString1(Int(mySelf.entity.pricePrecision) ?? 4)
            self?.footView.tagPrice.text = (entity.tagPrice.decimalNumberWithDouble() as NSString).decimalString1(Int(mySelf.entity.pricePrecision) ?? 4)
            self?.tableView.reloadData()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    func getLiquidationRate(){
        contractApi.hideAutoLoading()
        contractApi.rx.request(ContractAPIEndPoint.liquidationRate(contractId: entity.id)).MJObjectMap(ContactTransactionLiquidationRate.self).subscribe(onSuccess: { [weak self](entity) in
            guard let mySelf = self else{return}
            if let cell = mySelf.tableView.cellForRow(at: IndexPath.init(row: mySelf.middleTCRow, section: 0)) as? ContractTransationMiddleTC{
                cell.setCell(entity.liquidationRate_num)
            }
            mySelf.tableView.reloadData()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
}

extension ContractTransactionRightView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == middleTCRow{
            return 22
        }else{
            return 24
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == middleTCRow{
            let cell : ContractTransationMiddleTC = tableView.dequeueReusableCell(withIdentifier: "ContractTransationMiddleTC") as! ContractTransationMiddleTC
            return cell
        }else{
            let cell : ContractTransactionRightTC = tableView.dequeueReusableCell(withIdentifier: "ContractTransactionRightTC") as! ContractTransactionRightTC
            let entity = tableViewRowDatas[indexPath.row]
            cell.setCell(entity, model : self.entity)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != middleTCRow{
            let entity = tableViewRowDatas[indexPath.row]
            if entity.price != "--"{
                self.clickRightBlock?(entity)
            }
        }
    }
}
