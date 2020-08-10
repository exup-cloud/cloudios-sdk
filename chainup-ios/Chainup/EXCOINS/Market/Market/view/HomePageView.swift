//
//  HomePageView.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

enum MarkSortingType {
    case nameUp//名字正序
    case nameDown//名字倒序
    case priceUp//价格正序
    case priceDown//价格倒序
    case chargeUp//涨跌幅正序
    case chargeDown//涨跌幅倒序
    case normal//默认
}

class HomePageView: UIView {
    
    
    var tableViewisScroll = false
    
    let pageVHeight : CGFloat = {
        if EXHomeViewModel.status() == EXHomeViewModelType.three{
            return 0
        }else{
            return 33
        }
    }()
    
//    var vm : MarketVM?
    
    var key = ""//view的标志

    var tableViewRowDatas : [CoinDetailsEntity] = []//主区
    
    var deputyTableViewRowDatas : [CoinDetailsEntity] = []//创新区
    
    var observeTableViewRowDatas : [CoinDetailsEntity] = []//观察区
    
    var unlockTableViewRowDatas : [CoinDetailsEntity] = []//解锁区
    
    var halveTableViewRowDatas : [CoinDetailsEntity] = []//减半区
    
    var ws_tableViewRowDatas : [CoinDetailsEntity] = []//主区ws
    
    var ws_deputyTableViewRowDatas : [CoinDetailsEntity] = []//副区ws
    
    var ws_observeTableViewRowDatas : [CoinDetailsEntity] = []//观察区
    
    var ws_unlockTableViewRowDatas : [CoinDetailsEntity] = []//解锁区
    
    var ws_halveTableViewRowDatas : [CoinDetailsEntity] = []//减半区
    
    var markSortingType = MarkSortingType.normal
    
    var canRefresh = false
        
    lazy var homepageH : HomePageHV = {
        let view = HomePageHV.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pageVHeight))
        view.clickBtnBlock = {[weak self](sender) in
            guard let mySelf = self else{return}
            switch sender{
            case mySelf.homepageH.nameBtn:
                switch sender.dirState{
                case .none:
                    mySelf.markSortingType = .normal
                case .ascending:
                    mySelf.markSortingType = .nameUp
                case .descending:
                    mySelf.markSortingType = .nameDown
                }
            case mySelf.homepageH.newpriceBtn:
                switch sender.dirState{
                case .none:
                    mySelf.markSortingType = .normal
                case .ascending:
                    mySelf.markSortingType = .priceUp
                case .descending:
                    mySelf.markSortingType = .priceDown
                }
            case mySelf.homepageH.amplitudeBtn:
                switch sender.dirState{
                case .none:
                    mySelf.markSortingType = .normal
                case .ascending:
                    mySelf.markSortingType = .chargeUp
                case .descending:
                    mySelf.markSortingType = .chargeDown
                }
            default:
                break
            }
            mySelf.reloadSorting()
        }
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.extUseAutoLayout()
        tableView.separatorStyle = .none
        tableView.register(HomePageTC.classForCoder(), forCellReuseIdentifier: "HomePageTC")
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = homepageH
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(setCanRefresh), name: NSNotification.Name.init("MarketScrollViewEnd"), object: nil)
    }
    
//    @objc func setCanRefresh(_ noti : Notification){
//        if let key = noti.object as? String{
//            canRefresh = key == self.key
//            if canRefresh{
//                tableView.reloadData()
//            }
//        }
//    }
    
    //这里接收到ws，将数据传入到实体，更新cell
    func setVM(){
//        _ = vm?.vc?.subject.asObserver().subscribe({[weak self] (event) in
//            guard let mySelf = self else{return}
//            if let dict = event.element{
//                if let tick = dict["tick"] as? [String : Any]{
//                    if let channel = dict["channel"] as? String{
//                        let array = mySelf.containsEntity(channel, tick: tick)
//                        if array.count > 0{
//                            mySelf.reloadSorting()
//                        }
//                    }
//                }
//            }
//        }).disposed(by: disposeBag)
        
//        vm?.vc?.subjects.asObserver().subscribe(onNext:{[weak self] models in
//            guard let mySelf = self else { return }
//            mySelf.updateCoinsWith(allCoinModel: models)
//        }).disposed(by: disposeBag)
        
    }
    
    //排序
    func reloadSorting(){
        switch markSortingType {
        case .normal:
            tableViewRowDatas = ws_tableViewRowDatas
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas
            observeTableViewRowDatas = ws_observeTableViewRowDatas
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas
            halveTableViewRowDatas = ws_halveTableViewRowDatas
        case .chargeDown:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 > entity2.rose1
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 > entity2.rose1
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 > entity2.rose1
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 > entity2.rose1
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 > entity2.rose1
            }
        case .chargeUp:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 < entity2.rose1
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 < entity2.rose1
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 < entity2.rose1
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 < entity2.rose1
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.rose1 < entity2.rose1
            }
        case .nameDown:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name > entity2.name
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name > entity2.name
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name > entity2.name
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name > entity2.name
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name > entity2.name
            }
        case .nameUp:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name < entity2.name
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name < entity2.name
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name < entity2.name
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name < entity2.name
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.name < entity2.name
            }
        case .priceDown:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose > entity2.doubleClose
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose > entity2.doubleClose
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose > entity2.doubleClose
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose > entity2.doubleClose
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose > entity2.doubleClose
            }
        case .priceUp:
            tableViewRowDatas = ws_tableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose < entity2.doubleClose
            }
            deputyTableViewRowDatas = ws_deputyTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose < entity2.doubleClose
            }
            observeTableViewRowDatas = ws_observeTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose < entity2.doubleClose
            }
            unlockTableViewRowDatas = ws_unlockTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose < entity2.doubleClose
            }
            halveTableViewRowDatas = ws_halveTableViewRowDatas.sorted { (entity1, entity2) -> Bool in
                return entity1.doubleClose < entity2.doubleClose
            }
        default:
            break
        }
        
        if self.tableViewisScroll == false {
        
//            print("item 数据刷新")
            self.tableView.reloadData()
        }else{
//             print("item 滑动ing")
        }

    }
    
    func updateSection(datas:[CoinDetailsEntity],allData:EXMarketWsModel) {
        for item in datas{
            let ticker = item.name.replacingOccurrences(of: "/", with: "").lowercased()
            if let wsData = allData.data[ticker] as? [String:Any] {
                item.setEntityWithDict(wsData)
            }
        }
    }
    
    func updateCoinsWith(allCoinModel:EXMarketWsModel) {
        self.updateSection(datas: ws_unlockTableViewRowDatas,allData: allCoinModel)
        self.updateSection(datas: ws_tableViewRowDatas,allData: allCoinModel)
        self.updateSection(datas: ws_deputyTableViewRowDatas,allData: allCoinModel)
        self.updateSection(datas: ws_observeTableViewRowDatas,allData: allCoinModel)
        self.updateSection(datas: ws_halveTableViewRowDatas,allData: allCoinModel)
        self.reloadSorting()
//        self.tableView.reloadData()
    }
    
    func containsEntity(_ channel : String , tick : [String : Any]) -> [CoinDetailsEntity]{
        
        //解锁区
        for item in ws_unlockTableViewRowDatas{
            if item.name.replacingOccurrences(of: "/", with: "").lowercased() == dealChannel(channel){
                item.setEntityWithDict(tick)
            }
        }
        
        for item in ws_tableViewRowDatas{
            if item.name.replacingOccurrences(of: "/", with: "").lowercased() == dealChannel(channel){
                item.setEntityWithDict(tick)
                return ws_tableViewRowDatas
            }
        }
        for item in ws_deputyTableViewRowDatas{
            if item.name.replacingOccurrences(of: "/", with: "").lowercased() == dealChannel(channel){
                item.setEntityWithDict(tick)
                return ws_deputyTableViewRowDatas
            }
        }
        for item in ws_observeTableViewRowDatas{
            if item.name.replacingOccurrences(of: "/", with: "").lowercased() == dealChannel(channel){
                item.setEntityWithDict(tick)
                return ws_observeTableViewRowDatas
            }
        }
        for item in ws_halveTableViewRowDatas{
            if item.name.replacingOccurrences(of: "/", with: "").lowercased() == dealChannel(channel){
                item.setEntityWithDict(tick)
                return ws_halveTableViewRowDatas
            }
        }
        return []
    }
    
    func dealChannel(_ channel : String) -> String{
        let arr1 = channel.components(separatedBy: "_")
        if arr1.count > 1{
            let channel1 = arr1[1]
            let arr2 = channel1.components(separatedBy: "_")
            if arr2.count > 0 {
                return arr2[0]
            }
        }
        return channel
    }
    
    func setTableViewDatas(_ arr : [CoinMapEntity] , isvalue : Bool = false){
        var tmpa : [CoinDetailsEntity] = []//主区
        var tmpd : [CoinDetailsEntity] = []//创新
        var tmpo : [CoinDetailsEntity] = []//观察
        var tmpu : [CoinDetailsEntity] = []//解锁
        var tmph : [CoinDetailsEntity] = []//减半
        for item in arr{
            let entity = CoinDetailsEntity()
            entity.name = item.name
            if let i = Int(item.price){
                entity.precision = i
            }
            if let i = Int(item.volume){
                entity.volprecision = i
            }
            if key == "market_text_customZone".localized(){
                if item.coinListEntity.isOvercharge == "1"{
                    tmpu.append(entity)
                }else{
                    if item.newcoinFlag == "0"{
                        tmpa.append(entity)
                    }else if item.newcoinFlag == "1"{
                        tmpd.append(entity)
                    }else if item.newcoinFlag == "2"{
                        tmpo.append(entity)
                    }else if item.newcoinFlag == "3"{
                        tmph.append(entity)
                    }
                    
                }
            }else if key.lowercased() == "etf"{
                if item.coinListEntity.isOvercharge == "1"{
                    tmpu.append(entity)
                }else{
                    if item.newcoinFlag == "0"{
                        tmpa.append(entity)
                    }else if item.newcoinFlag == "1"{
                        tmpd.append(entity)
                    }else if item.newcoinFlag == "2"{
                        tmpo.append(entity)
                    }else if item.newcoinFlag == "3"{
                        tmph.append(entity)
                    }
                    
                }
            }else{
                if item.isShow == "1" && item.etfOpen != "1"{//如果后台返回展示才展示
                    if item.coinListEntity.isOvercharge == "1"{
                        tmpu.append(entity)
                    }else{
                        if item.newcoinFlag == "0"{
                            tmpa.append(entity)
                        }else if item.newcoinFlag == "1"{
                            tmpd.append(entity)
                        }else if item.newcoinFlag == "2"{
                            tmpo.append(entity)
                        }else if item.newcoinFlag == "3"{
                            tmph.append(entity)
                        }
                    }
                }
            }
        }
        
        if isvalue == true{
            setTmp(tableViewRowDatas, b: tmpa)
            setTmp(deputyTableViewRowDatas, b: tmpd)
            setTmp(observeTableViewRowDatas, b: tmpo)
            setTmp(unlockTableViewRowDatas, b: tmpu)
            setTmp(halveTableViewRowDatas, b: tmph)
        }
        
        self.ws_tableViewRowDatas = tmpa
        self.tableViewRowDatas = tmpa
        
        self.ws_deputyTableViewRowDatas = tmpd
        self.deputyTableViewRowDatas = tmpd
        
        self.ws_observeTableViewRowDatas = tmpo
        self.observeTableViewRowDatas = tmpo
        
        self.ws_unlockTableViewRowDatas = tmpu
        self.unlockTableViewRowDatas = tmpu
        
        self.ws_halveTableViewRowDatas = tmph
        self.halveTableViewRowDatas = tmph
        
        self.tableView.reloadData()
    }
    
    func setTmp(_ a : [CoinDetailsEntity] , b : [CoinDetailsEntity]){
        for entity in a{
            for item in b{
                if item.name == entity.name{
                    item.setEntityWithDict(entity.dict)
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension HomePageView : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "common_text_halveZone"))
            return view
        case 1:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "transaction_text_mainZone"))
            return view
        case 2:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "market_text_innovationZone"))
            return view
        case 3:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "market_text_observeZone"))
            return view
        case 4:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "market_text_unlockZone"))
            return view
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if halveTableViewRowDatas.count == 0 && section == 0{
            return 0
        }
        if tableViewRowDatas.count == 0 && section == 1{
            return 0
        }
        if deputyTableViewRowDatas.count == 0 && section == 2{
            return 0
        }
        if observeTableViewRowDatas.count == 0 && section == 3{
            return 0
        }
        if unlockTableViewRowDatas.count == 0 && section == 4{
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return halveTableViewRowDatas.count
        case 1:
            return tableViewRowDatas.count
        case 2:
            return deputyTableViewRowDatas.count
        case 3:
            return observeTableViewRowDatas.count
        case 4:
            return unlockTableViewRowDatas.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tmparr : [CoinDetailsEntity] = []
        switch indexPath.section {
        case 0:
            tmparr = halveTableViewRowDatas
        case 1:
            tmparr = tableViewRowDatas
        case 2:
            tmparr = deputyTableViewRowDatas
        case 3:
            tmparr = observeTableViewRowDatas
        case 4:
            tmparr = unlockTableViewRowDatas
        default:
            return UITableViewCell()
        }
        let entity = tmparr[indexPath.row]
        let cell : HomePageTC = tableView.dequeueReusableCell(withIdentifier: "HomePageTC") as! HomePageTC
//            UIView.performWithoutAnimation {
                cell.setCellWithEntity(entity)
//            }
            if key == "market_text_customZone".localized(){
            cell.addTap()
            cell.longCellBlock = {[weak self]entity in
                XUserDefault.cancelCollectionCoinMap(entity.name)
//                self?.vm?.vc?.reloadInitHomview()
                }
            }
            if indexPath.row < tmparr.count{
                cell.ws_setCellWithEntity(tmparr[indexPath.row])
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        var entity = CoinMapEntity()
//        switch indexPath.section{
//        case 0:
//            entity = PublicInfoManager.sharedInstance.getCoinMapInfo(tableViewRowDatas[indexPath.row].name)
//        case 1:
//            entity = PublicInfoManager.sharedInstance.getCoinMapInfo(deputyTableViewRowDatas[indexPath.row].name)
//        case 2:
//            entity = PublicInfoManager.sharedInstance.getCoinMapInfo(observeTableViewRowDatas[indexPath.row].name)
//        default:
//            break
//        }
//
//        let vc = EXMarketDetailVc.instanceFromStoryboard(name: StoryBoardNameMarket)
//
//        vc.entity = entity
//        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomePageView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.tableView {
            self.tableViewisScroll = true;
        }
       
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tableViewisScroll = false
        self.tableView.reloadData()
    }
}
