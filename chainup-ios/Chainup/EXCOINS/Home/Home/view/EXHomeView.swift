//
//  EXHomeView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EXHomeView: UIView {
    
    var tableViewRowData1 : [HomeListEntity] = []
    
    var tableViewRowData2 : [HomeListEntity] = []
    
    var tableViewRowData3 : [HomeListEntity] = []
    
    let balance: PublishSubject<EXHomeAssetModel> = PublishSubject.init()
    let coBalance: PublishSubject<String> = PublishSubject.init()
    let interval = PublishSubject<Int>.interval(1, scheduler: MainScheduler.instance)
    var homedisposeBag = DisposeBag()
    
    var assetModel:EXHomeAssetModel = EXHomeAssetModel()
    var coBalanceStr:String = "0"
    
    var index = 0
    {
        didSet{
            clickSectionIndex()
            getList()
        }
    }
    
    var entity = HomeEntity()
    
    var tableViewRowData : [HomeEntity] = []
    
    //第一种
    lazy var headView : EXHomeHeadView = {
        let view = EXHomeHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pagewheelHeight + 80 + 10 + 40 + 89 + 10 + 226 + 16))
        view.changeHeadHeightBlock = {[weak self] in
            self?.setHeadHeight()
        }
        return view
    }()
    
    //第二种
    lazy var headTwoView : EXTwoHomeHeadView = {
        let view = EXTwoHomeHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pagewheelHeight))
        view.changeHeadHeightBlock = {[weak self] in
            self?.setHeadHeight()
        }
        return view
    }()
    
    //第三种
    lazy var headThreeView : EXThreeHomeHeadView = {
        let view = EXThreeHomeHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pagewheelHeight))
        view.changeHeadHeightBlock = {[weak self] in
            self?.setHeadHeight()
        }
        return view
    }()
    
    var listStrArr : [String : [String]] = [:]

    func setListStrArr(){
        listStrArr = ["rasing":[LanguageTools.getString(key: "home_action_coinNameTitle"),LanguageTools.getString(key: "home_text_dealLatestPrice"),LanguageTools.getString(key: "common_text_priceLimit")],"falling":[LanguageTools.getString(key: "home_action_coinNameTitle"),LanguageTools.getString(key: "home_text_dealLatestPrice"),LanguageTools.getString(key: "common_text_priceLimit")],"deal" : [LanguageTools.getString(key: "home_action_coinNameTitle"),LanguageTools.getString(key: "home_text_dealLatestPrice") + "(" + PublicInfoManager.sharedInstance.getRateLangCoin() + ")" , LanguageTools.getString(key: "home_text_deal24hour") + "(BTC)"]]
    }
    
    var timer : Timer?
    
    var homeSuccess = "0"//首页信息获取成功标志 0 失败 1成功
    
    //涨幅榜
    lazy var homeSectionHeadView : EXHomeSectionHeadView = {
        let view = EXHomeSectionHeadView()
        view.clickListBlock = {[weak self]index in
            guard let mySelf = self else{return}
            mySelf.index = index
        }
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.bounces = false
        tableView.extRegistCell([EXHomeListTC.classForCoder()], ["EXHomeListTC"])
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    func updateCoBalance(balance:String) {
        self.coBalanceStr = balance
        self.coBalance.onNext(balance)
    }
    
    func configZipBalance() {
        if PublicInfoManager.sharedInstance.isSupportContract(),PublicInfoManager.sharedInstance.isNewContracct() {
            homedisposeBag = DisposeBag()
               Observable.zip(balance, coBalance)
                   .timeout(5, scheduler: MainScheduler.instance)
                   .subscribe(onNext: {[weak self] tuple in
                       guard let `self` = self else {return}
                       let (assetModel, coBalance) = tuple
                       assetModel.updateTotalBalanceWithCoBalance(cobalance: coBalance)
                       self.handleHomeAssetView(model: assetModel)
                       }, onError: {[weak self]  (error) in
                           guard let `self` = self else {return}
                           self.handleHomeAssetView(model: self.assetModel)
                   })
                   .disposed(by: homedisposeBag)
            SLPlatformSDK.sharedInstance()?.sl_loadUserContractPerpoty()
        }else {
            homedisposeBag = DisposeBag()
            balance
                .subscribe(onNext: {[weak self] assetModel in
                    guard let `self` = self else {return}
                    self.handleHomeAssetView(model: self.assetModel)
                })
                .disposed(by: homedisposeBag)
        }
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setHeadHeight()
        initTime()
        clickSectionIndex()
        
        //默认塞10个占位实体
        for _ in 0..<10{
            tableViewRowData1.append(HomeListEntity())
            tableViewRowData2.append(HomeListEntity())
            tableViewRowData3.append(HomeListEntity())
        }
        
        setListStrArr()
        
        setView()
        
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (i) in
            guard let mySelf = self else{return}
            mySelf.setListStrArr()
            mySelf.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    func setView(){
        if EXHomeViewModel.status() == .one {
            tableView.tableHeaderView = self.headView
        }else if EXHomeViewModel.status() == .two{
            tableView.tableHeaderView = self.headTwoView
        }else if EXHomeViewModel.status() == .three{
            tableView.tableHeaderView = self.headThreeView
        }
    }
    
    func initTime(){
        self.timer = Timer.init(timeInterval: 60, repeats: true, block: {[weak self] (timer1) in
            guard let mySelf = self else{return}
            if timer1 == mySelf.timer{
                mySelf.getDatas()
            }
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    //设置头部高度
    func setHeadHeight(){
        if EXHomeViewModel.status() == .one{
            headView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: headView.headHeight)
        }else if EXHomeViewModel.status() == .two{
            headTwoView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: headTwoView.headHeight)
        }else if EXHomeViewModel.status() == .three{
            headThreeView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: headThreeView.headHeight)
        }
        tableView.reloadData()
    }
    
    func setTableViewCellInfo(_ arr : [HomeListEntity] , index : Int){
        switch index {
        case 0:
            if arr.count > 10{
                tableViewRowData1 = Array(arr[0...9])
            }else{
                tableViewRowData1 = arr
            }
        case 1:
            if arr.count > 10{
                tableViewRowData2 = Array(arr[0...9])
            }else{
                tableViewRowData2 = arr
            }
        case 2:
            if arr.count > 10{
                tableViewRowData3 = Array(arr[0...9])
            }else{
                tableViewRowData3 = arr
            }
        default:
            break
        }
        tableView.reloadData()
    }
    
    func setScrollViewSize(){
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? EXHomeListTC{
            cell.setScrollViewSize(entity.switchArray.count)
        }
    }
    
    //点击涨跌幅榜
    func clickSectionIndex(){
        if let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? EXHomeListTC{
            cell.setScrollView(CGFloat(index))
        }
        setListHead()
    }
    
    //设置榜单头部
    func setListHead(){
        if entity.switchArray.count > 0 {
            let swarr = entity.switchArray
            var arr : [EXHomeSectionHeadEntity] = []
            for i in 0..<swarr.count{
                let e = EXHomeSectionHeadEntity()
                switch swarr[i]{
                case "rasing":
                    e.name = LanguageTools.getString(key: "home_text_upRanking")
                case "falling":
                    e.name = LanguageTools.getString(key: "home_text_downRanking")
                case "deal":
                    e.name = LanguageTools.getString(key: "home_text_dealRanking")
                default:
                    break
                }
                if self.index == i {
                    e.select = "1"
                }else{
                    e.select = "0"
                }
                arr.append(e)
            }
            //设置名称栏
            if let list = listStrArr[entity.switchArray[index]]{
                homeSectionHeadView.setSectionView(list[0], middle: list[1], right: list[2])
            }
            homeSectionHeadView.tableViewRowDatas = arr//设置涨跌幅榜
            tableView.reloadData()
        }
    }
    
    //设置首页
    func setHeadView(){
        if EXHomeViewModel.status() == .one{
            self.headView.setView(self.entity)
        }else if EXHomeViewModel.status() == .two{
            self.headTwoView.setView(self.entity)
        }else if EXHomeViewModel.status() == .three{
            self.headThreeView.setView(self.entity)
        }
        self.tableView.reloadData()
    }
    
    //设置首页推荐
    func setRecomendView(_ arr : [HomeRecommendedEntity]){
        if EXHomeViewModel.status() == .one{
            self.headView.setRecomendView(arr)
        }else if EXHomeViewModel.status() == .two{
            self.headTwoView.setRecomendView(arr)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//网络
extension EXHomeView{
    
    //获取首页数据
    func getHomeData(){
        let param = NetManager.sharedInstance.handleParamter()
//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.index)
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.index)
        var isShowLoading = true
        if homeSuccess == "1"{
            isShowLoading = false
        }
        NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading: isShowLoading, success: {[weak self] (result, reponse, nil) in
            guard let mySelf = self else{return}
            if let dict = result as? [String : Any]{
                if let data = dict["data"] as? [String : Any]{
                    mySelf.entity.setEntityWithDict(data)
                    mySelf.setHeadView()
                    mySelf.homeSuccess = "1"
                    mySelf.getDatas()
                    mySelf.clickSectionIndex()
                    mySelf.setScrollViewSize()
                }
            }
        }) { (state, error, inl) in
            
        }
    }
    
    //获取数据
    func getDatas(){
        if self.homeSuccess == "1"{
            self.getRecommended()
            self.getList()
        }
    }
    
    //获取推荐数据
    func getRecommended(){
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.header_symbol)

//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.header_symbol)
        NetManager.sharedInstance.sendRequest(url, parameters: [:] , mothed: .get, isShowLoading : false  , success: {[weak self] (result, response, nil) in
            guard let mySelf = self else{return}
            if let dict = result as? [String : Any]{
                if let data = dict["data"] as? [[String : Any]]{
                    var arr : [HomeRecommendedEntity] = []
                    for dic in data{
                        let entity = HomeRecommendedEntity()
                        entity.setEntityWithDict(dic)
                        if entity.name != ""{
                            arr.append(entity)
                        }
                    }
                    mySelf.setRecomendView(arr)
                }
            }
            }, fail: { (state, error, nil) in
                
        })
    }
    
    //获取涨跌幅榜单
    func getList(){
        if entity.switchArray.count <= self.index{
            return
        }
        let param = NetManager.sharedInstance.handleParamter(["type" : entity.switchArray[self.index]])
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.trade_list)
//        let url = NetManager.sharedInstance.url(NetDefine.http_host_url, model: NetDefine.common, action: NetDefine.trade_list)
        NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading : false , requestEntity : self.index, success: { [weak self](result, response, requestEntity) in
            guard let mySelf = self else{return}
            if let dict = result as? [String : Any]{
                if let data = dict["data"] as? [[String : Any]]{
                    guard let index1 = requestEntity as? Int else{return}
                    var array : [HomeListEntity] = []
                    for dic in data{
                        let entity = HomeListEntity()
                        entity.setEntityWithDict(dic)
                        if entity.name != ""{
                            array.append(entity)
                        }
                    }
                    mySelf.setTableViewCellInfo(array, index: index1)
                }
            }
            }, fail: { (state, error, nil) in
                
        })
    }
    
    //获取资产余额
    func getAssets(){
        if XUserDefault.getToken() == nil{
            return
        }
        configZipBalance()
      
        appApi.hideAutoLoading()
        let manager = EXAccountBalanceManager.manager
        manager.updateAllAccountBalance()
        manager.allAccountCallback = {[weak self]model in
            guard let `self` = self else {return}
            self.assetModel = model
            self.balance.onNext(model)
        }
    }
    
    func handleHomeAssetView(model:EXHomeAssetModel) {
        if EXHomeViewModel.status() == .one{
            self.headView.homeAssetsView.homeLoginAssetsView.setView(model)
        }else if EXHomeViewModel.status() == .three{
            self.headThreeView.setAssetView(model.totalBalance)
        }
    }
}

extension EXHomeView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return homeSectionHeadView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if EXHomeViewModel.status() == .three{
            return 47
        }
        return 74
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch index {
        case 0:
            return CGFloat(58 * tableViewRowData1.count)
        case 1:
            return CGFloat(58 * tableViewRowData2.count)
        case 2:
            return CGFloat(58 * tableViewRowData3.count)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EXHomeListTC = tableView.dequeueReusableCell(withIdentifier: "EXHomeListTC") as! EXHomeListTC
        switch index {
        case 0:
            if entity.switchArray.count > index{
                cell.setCell(index, tableViewRowData: tableViewRowData1 ,type: entity.switchArray[index])
            }
        case 1:
            if entity.switchArray.count > index{
                cell.setCell(index, tableViewRowData: tableViewRowData2 ,type: entity.switchArray[index])
            }
        case 2:
            if entity.switchArray.count > index{
                cell.setCell(index, tableViewRowData: tableViewRowData3 ,type: entity.switchArray[index])
            }
        default:
            break
        }
        cell.slidingBlock = {[weak self] (index) in//滑动
            guard let mySelf = self else{return}
            mySelf.index = index
//            mySelf.vm.vc?.getTradeList(mySelf.entity.switchArray[index])
//            mySelf.homeListTableViewTHV.clickIndex(index)
        }
        return cell
    }
    
}
