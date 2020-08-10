//
//  ContractPosstionView.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//  持仓

import UIKit
import RxSwift

class ContractPosstionView: UIView {
    
    //修改杠杆倍数
    typealias ChangeLevelBlock = () -> ()
    var changeLevelBlock : ChangeLevelBlock?
    
    var entity = ContractContentModel()
    {
        didSet{
            getDatas()
        }
    }
    
    var tableViewRowDatas : [ContractUserPositionEntity] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.estimatedRowHeight = 320
        tableView.estimatedSectionFooterHeight = 0.1
        tableView.estimatedSectionHeaderHeight = 0.1
        tableView.extRegistCell([ContractPositionTC.classForCoder()], ["ContractPositionTC"])
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.mj_header = EXRefreshHeaderView (refreshingBlock: {[weak self] in
            guard let mySelf = self else{return}
            mySelf.getDatas()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContractPosstionView{
    
    func getDatas(){
        if XUserDefault.getToken() == nil{
            return
        }
        contractApi.rx.request(ContractAPIEndPoint.userPosition(contractId: "")).MJObjectMap(ContractUserPositionModels.self).subscribe(onSuccess: {[weak self] (models) in
            guard let mySelf = self else{return}
            mySelf.tableViewRowDatas = mySelf.placeTop(models.positions)
            mySelf.tableView.reloadData()
            mySelf.endRefresh()
        }) {[weak self] (error) in
            self?.endRefresh()
        }.disposed(by: disposeBag)
    }
    
    //置顶
    func placeTop(_ models : [ContractUserPositionEntity]) -> [ContractUserPositionEntity]{
        var tmpModels = models
        var arr : [ContractUserPositionEntity] = []
        for i in 0..<models.count{
            let model = models[i]
            if model.contractId == self.entity.id{
                arr.append(model)
            }
        }
        for entity in arr {
            for i in 0..<tmpModels.count{
                let model = tmpModels[i]
                if model.id == entity.id{
                    tmpModels.remove(at: i)
                    break
                }
            }
        }
        arr = arr + tmpModels
        return arr
    }
    
    //弹出杠杆
    func popupLeverage(_ entity : ContractUserPositionEntity){
        let arr = entity.contractContentModel.leverTypes_arr
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.changeLevel(entity.contractContentModel.leverTypes_arr[idx], contractId: entity.contractId)
//            mySelf.getDatas()
        }
        var idx = 0
        for i in 0..<arr.count{
            if arr[i] == entity.leverageLevel{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  arr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
    
    //调节杠杆
    func changeLevel(_ level : String , contractId : String){
        contractApi.rx.request(ContractAPIEndPoint.changeLevel(contractId: contractId, level: level)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
//            EXAlert.showSuccess(msg: "contract_tip_marginAdjustmentSuccess".localized())
            self?.changeLevelBlock?()
            self?.getDatas()
        }) { (error) in
            
        }.disposed(by: disposeBag)
    }
    
    //市价全平
    func marketPricetTakeOrder(_ entity : ContractUserPositionEntity){
        let side = entity.side == "BUY" ? "SELL" : "BUY"
        contractApi.rx.request(ContractAPIEndPoint.takeOrder(contractId: entity.contractId, volume: entity.volume, price: entity.indexPrice, orderType: "2", copType: "2", side: side, closeType: "1", level: entity.leverageLevel,positionId : entity.id)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            EXAlert.showSuccess(msg: "contract_tip_closeOrderSuccess".localized())
            
            self?.getDatas()
        }) { (error) in

            }.disposed(by: disposeBag)
    }
    
    //调整仓位保证金
    func adjust(_ entity : ContractUserPositionEntity){
        let sheet = EXContractPositionSheet()
        sheet.positonNumberValue.textColor = entity.side_color
        var volume = ""
        if entity.side == "BUY"{
            volume = "+" + entity.volume
        }else{
            volume = "-" + entity.volume
        }
//        sheet.positonNumberValue
        sheet.input.decimal = "\(ContractPublicInfoManager.manager.getBtcPrecision())"
        sheet.bindInfos(contractPositionNumber: volume, assignedPosition: entity.fmtUsedMargin(), avaliablePosition: entity.fmtCanUsedMargin(), symbol: "BTC")
        sheet.onPositionCallback = {[weak self](str , bool) in
            
            if let f = Float(str) , f == 0{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                    EXAlert.showFail(msg: "transfer_tip_emptyVolume".localized())
                }
                return
            }
            
            if bool == true{//增加保证金
                if let sub = (entity.fmtCanUsedMargin() as NSString).subtracting(str, decimals: 18) , sub.contains("-"){
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                        EXAlert.showFail(msg: "contract_tip_volumeError".localized())
                    }
                    return
                }
                self?.transferMargin(entity.contractId, amount: "+" + str , positionId : entity.id)
            }else{//减少保证金
                self?.transferMargin(entity.contractId, amount: "-" + str , positionId : entity.id)
            }
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    //调整保证金
    func transferMargin(_ contractId : String , amount : String , positionId : String){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            contractApi.rx.request(ContractAPIEndPoint.transferMargin(contractId: contractId, amount: amount , positionId : positionId )).MJObjectMap(EXBaseModel.self).subscribe(onSuccess: {[weak self] (model) in
                
                EXAlert.showSuccess(msg: "contract_tip_marginAdjustmentSuccess".localized())
                self?.getDatas()
            }) { (error) in
                
                }.disposed(by: self.disposeBag)
        }
    }
    
    //限价平仓
    func limitedPosition(_ entity : ContractUserPositionEntity){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: "contract_text_limitPositions".localized(), itemModels:self.limitedModels(entity))
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            var price = ""
            var num = ""
            if let price1 = formDic["price"]{
                price = price1
            }
//            if let num1 = formDic["num"]{
//                num = num1
//            }
            if price == ""{
                EXAlert.showFail(msg: "contract_tip_pleaseInputPrice".localized())
                return
            }
//            if num == ""{
//                EXAlert.showFail(msg: "transfer_tip_emptyVolume".localized())
//                return
//            }
//            if let sub = (entity.volume as NSString).subtracting(num, decimals: 18) , sub.contains("-"){
//                EXAlert.showFail(msg: String.init(format: "当前仓位的最大数量为%@".localized(), entity.volume))
//                return
//            }
            mySelf.limitPricetTakeOrder(entity, volume: num, price: price)
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    //限价平仓
    func limitPricetTakeOrder(_ entity : ContractUserPositionEntity , volume : String , price : String){
        let side = entity.side == "BUY" ? "SELL" : "BUY"
        contractApi.rx.request(ContractAPIEndPoint.takeOrder(contractId: entity.contractId, volume: volume, price: price, orderType: "1", copType: "2", side: side, closeType: "1", level: entity.leverageLevel,positionId : entity.id)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (model) in
            EXAlert.showSuccess(msg: "contract_tip_closeOrderSuccess".localized())
            
            self?.getDatas()
        }) { (error) in
            
            }.disposed(by: disposeBag)
    }
    
    func limitedModels(_ entity : ContractUserPositionEntity)->[EXInputSheetModel] {
        let symbol = ContractPublicInfoManager.manager.getContractWithContractId(entity.contractId).quoteSymbol
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:"contract_text_price".localized(),key:"price",placeHolder: "filter_Input_placeholder".localized(), type: .input,keyBoard : .decimalPad , unit : symbol)
        models.append(model1)
        let model2 = EXInputSheetModel.setModel(withTitle:"charge_text_volume".localized(),key:"num",placeHolder: "filter_Input_placeholder".localized(), type: .input, keyBoard : .numberPad, unit : "contract_text_volumeUnit".localized())
//        models.append(model2)
        return models
    }
    
    func endRefresh(){
        self.tableView.mj_header.endRefreshing()
    }
    
}

extension ContractPosstionView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            return 336
        }
        return 320
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractPositionTC") as! ContractPositionTC
        cell.setCell(entity)
        cell.clickLeverageBlock = {[weak self]entity in
            //分仓模式
            if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
                self?.limitedPosition(entity)
            }else{
                self?.popupLeverage(entity)
            }
        }
        cell.clickMarketPositionsBlock = {[weak self]entity in
            self?.marketPricetTakeOrder(entity)
        }
        cell.marginView.clickRightLabelBlock = {[weak self]entity in
            self?.adjust(entity)
        }
        return cell
    }
    
//    //弹起保证金
//    func showMarginSheet(){
//        let sheet = EXContractPositionSheet()
//        sheet.bindInfos(contractPositionNumber: <#T##String#>, assignedPosition: <#T##String#>, avaliablePosition: <#T##String#>, symbol: <#T##String#>)
//        sheet.onPositionCallback = {[weak self](str , b) in
//            if b == true{//增加
//
//            }else{//减少
//
//            }
//        }
//        EXAlert.showSheet(sheetView: sheet)
//    }
    
}
