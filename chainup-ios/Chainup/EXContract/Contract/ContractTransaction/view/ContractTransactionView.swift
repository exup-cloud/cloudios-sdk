//
//  ContractTransactionView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//  合约交易

import UIKit
import RxSwift

class ContractTransactionView: UIView {
    
    typealias NewPriceBlock = (PriceTick) -> ()
    var newPriceBlock : NewPriceBlock?
    
    var timer : Timer?
    
    let wsVm = ContractWsVm()
    
    var entity = ContractContentModel()
    {
        didSet{
            self.close = ""
            sectionView.entity = self.entity
            contractTransactionHeadView.leftView.entity = self.entity
            contractTransactionHeadView.rightView.entity = self.entity
            contractTransactionHeadView.contractTransactionStatusView.entity = self.entity
        }
    }
    
    let sectionView = ContractTransactionSectionView()
    
    var tableViewRowDatas : [ContractCurrentEntity] = []
    
    var close = ""//
    
    lazy var contractTransactionHeadView : ContractTransactionHeadView = {
        let view = ContractTransactionHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 476))
        view.leftView.clickTakeOrderBlock = {[weak self]param in
            self?.takeOrder(param)
        }
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.extUseAutoLayout()
        tableView.estimatedRowHeight = 231
        tableView.estimatedSectionFooterHeight = 0.1
        tableView.estimatedSectionHeaderHeight = 476
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([ContractTransactionTC.classForCoder(),EXTransactionEmptyTC.classForCoder()], ["ContractTransactionTC","EXTransactionEmptyTC"])
        tableView.tableHeaderView = contractTransactionHeadView
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        timer = Timer.init(timeInterval: 5, repeats: true, block: {[weak self] (timer1) in
            if timer1 == self?.timer{
                self?.getNetDatas()
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        startWs()
        configWsRx()
    }
    
    func startWs(){
        wsVm.contractSymbol = self.entity.symbol
        wsVm.priceDecimal = self.entity.getPriceDecimal()
        wsVm.disconnectws()
        wsVm.wsRequestData()
    }
    
    func configWsRx() {
        wsVm.closePriceSubject.subscribe(onNext:{[weak self] tick in
            guard let mySelf = self else { return }
            if let pricePrecision = Int(mySelf.entity.pricePrecision){
                tick.close = (tick.close as NSString).decimalString1(pricePrecision)
            }
            if mySelf.close == ""{//第一次进入
                mySelf.contractTransactionHeadView.leftView.setPrice(tick.close)
            }
            mySelf.close = tick.close
            mySelf.newPriceBlock?(tick)
        }).disposed(by: disposeBag)
        
        wsVm.buysSubject.subscribe(onNext:{[weak self] tuple in
            let (prices, volumes, max) = tuple
            self?.contractTransactionHeadView.rightView.setBuy(prices, volums: volumes, max: max)
        }).disposed(by: disposeBag)
        
        wsVm.sellsSubject.subscribe(onNext:{[weak self] tuple in
            let (prices, volumes, max) = tuple
            self?.contractTransactionHeadView.rightView.setSell(prices, volums: volumes, max: max)
        }).disposed(by: disposeBag)
    }
    
    func disAppear(){
        wsVm.disconnectws()
        timer?.fireDate = Date.distantFuture
        contractTransactionHeadView.leftView.timer?.fireDate = Date.distantFuture
    }
    
    func appear(){
        contractTransactionHeadView.leftView.isRequest = true
        contractTransactionHeadView.leftView.getInitTakeOrder {
            
        }
        contractTransactionHeadView.leftView.setPrice(self.close)
        timer?.fireDate = Date.init()
        contractTransactionHeadView.leftView.timer?.fireDate = Date.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractTransactionView{
    
    func reloadHeadViewHeight(){
        if XUserDefault.getToken() == nil || ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            contractTransactionHeadView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 402)
        }else{
            contractTransactionHeadView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 476)
        }
        contractTransactionHeadView.reloadView()
    }
    
    //刷新页面
    func reloadView(){
        tableViewRowDatas.removeAll()
        tableView.reloadData()
        startWs()
        configWsRx()
        reloadHeadViewHeight()
        getNetDatas()
        contractTransactionHeadView.rightView.reloadView()
    }
    
}

extension ContractTransactionView{
    
    //获取数据
    func getNetDatas(){
        if XUserDefault.getToken() != nil{
            getContractCurrent()
            contractTransactionHeadView.contractTransactionStatusView.getUserPosition()
        }
        contractTransactionHeadView.rightView.getIndex()
        contractTransactionHeadView.rightView.getLiquidationRate()
    }
    
    //获取合约当前数据
    func getContractCurrent(){
        contractApi.hideAutoLoading()
        contractApi.rx.request(ContractAPIEndPoint.getOrderList(contractId: entity.id, pageSize: "20", page: "1", side: "")).MJObjectMap(ContractCurrentList.self).subscribe(onSuccess: {[weak self] (model) in
            let orderList = model.orderList
            self?.tableViewRowDatas = orderList
            self?.tableView.reloadData()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    //撤销合约订单
    func cancelContractCurrent(_ entity : ContractCurrentEntity){
        contractApi.rx.request(ContractAPIEndPoint.cancelOrder(orderId: entity.orderId, contractId: entity.contractId)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            EXAlert.showSuccess(msg: "common_tip_cancelSuccess".localized())
            self?.getContractCurrent()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    //下单
    func takeOrder(_ dict : [String : String]){
        guard let volume = dict["volume"] else{return}
        if let vol = (entity.maxOrderVolume as NSString).subtracting(volume, decimals: 18) , vol.contains("-"){
            EXAlert.showFail(msg: String.init(format: "contract_text_positionsMaxinput".localized(), entity.maxOrderVolume))
            return
        }
        guard let price = dict["price"] else{return}
        guard let orderType = dict["orderType"] else{return}
        guard let side = dict["side"] else{return}
        guard let level = dict["level"] else{return}
        contractApi.rx.request(ContractAPIEndPoint.takeOrder(contractId: entity.id, volume: volume, price: price, orderType: orderType, copType: "2", side: side, closeType: "0", level: level, positionId: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            EXAlert.showSuccess(msg: "contract_tip_submitSuccess".localized())
            self?.getContractCurrent()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
}

extension ContractTransactionView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewRowDatas.count == 0{
            return 121
        }
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewRowDatas.count == 0{
            return 1
        }
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewRowDatas.count == 0{
            let cell : EXTransactionEmptyTC = tableView.dequeueReusableCell(withIdentifier: "EXTransactionEmptyTC") as! EXTransactionEmptyTC
            return cell
        }
        let entity = tableViewRowDatas[indexPath.row]
        let cell : ContractTransactionTC = tableView.dequeueReusableCell(withIdentifier: "ContractTransactionTC") as! ContractTransactionTC
        cell.setCell(entity)
        cell.clickCancelBlock = {[weak self]entity in
            self?.cancelContractCurrent(entity)
        }
        return cell
    }
}

class ContractTransactionSectionView : UIView{
    
    var entity = ContractContentModel()

    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
        label.text = "contract_text_currentEntrust".localized()
        return label
    }()
    
    lazy var allImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "fiat_order")
        return imgV
    }()
    
    lazy var allBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setTitle(LanguageTools.getString(key: "common_action_sendall"), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickAllBtn))
        btn.setEnlargeEdgeWithTop(10, left: 20, bottom: 10, right: 10)
        btn.layoutIfNeeded()
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeView.bg
        addSubViews([nameLabel,allImgV,allBtn])
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(allImgV.snp.left).offset(-10)
        }
        allImgV.snp.makeConstraints { (make) in
            make.height.equalTo(13)
            make.width.equalTo(12)
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(allBtn.snp.left).offset(-5)
        }
        allBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    @objc func clickAllBtn(){
        let vc = ContractCurrentEntrustVC()
        vc.mainView.entity = self.entity
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
