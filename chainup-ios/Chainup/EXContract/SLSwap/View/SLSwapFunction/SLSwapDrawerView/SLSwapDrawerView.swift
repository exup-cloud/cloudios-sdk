//
//  SLSwapDrawerView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapDrawerView: UIView {
    
    private static var sharedInstance: SLSwapDrawerView?
    
    class func getSharedInstance() -> SLSwapDrawerView {
        guard let instance = sharedInstance else {
            sharedInstance = SLSwapDrawerView()
            sharedInstance?.reloadSearchBar()
            sharedInstance?.reloadData()
            return sharedInstance!
        }
        instance.reloadSearchBar()
        instance.reloadData()
        
        return instance
    }
    
    class func clearSharedInstance(){
        sharedInstance = nil
    }
    
    typealias ClickCellBlock = (BTItemModel) -> ()
    var clickCellBlock : ClickCellBlock?
    
    var index = 0
    {
        didSet{
            setSearchArr()
        }
    }
    
    var searchText = ""
    
    var searchArray : [BTItemModel] = [] // 自选 显示源
    var tableViewRowDatas : [BTItemModel] = []
    
    var searchArray1 : [BTItemModel] = []// USDT 显示源
    var tableViewRowDatas1 : [BTItemModel] = []
    
    var searchArray2 : [BTItemModel] = []// 币本位 显示源
    var tableViewRowDatas2 : [BTItemModel] = []
    
    var searchArray3 : [BTItemModel] = []// 模拟 显示源
    var tableViewRowDatas3 : [BTItemModel] = []
    
    //搜索栏
    lazy var searchBar1 : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.extUseAutoLayout()
        searchBar.barTintColor = UIColor.ThemeNav.bg
        searchBar.layer.borderColor = UIColor.ThemeNav.bg.cgColor
        searchBar.subviews.first?.subviews.last?.backgroundColor = UIColor.ThemeNav.bg
        searchBar.tintColor = UIColor.ThemeLabel.colorMedium
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField{
            textfield.setPlaceHolderAtt(LanguageTools.getString(key: "common_action_searchCoinPair"), color: UIColor.ThemeLabel.colorDark, font: 14)
            textfield.textColor = UIColor.ThemeLabel.colorMedium
            textfield.font = UIFont.ThemeFont.BodyRegular
            textfield.setModifyClearButton()
            textfield.backgroundColor = UIColor.ThemeNav.bg
        }
        searchBar.layer.borderWidth = 1
        searchBar.delegate = self
        searchBar.setImage(UIImage.themeImageNamed(imageName: "search"), for: UISearchBarIcon.search, state: UIControlState.normal)
        return searchBar
    }()
    
    lazy var collectionV : ScreeningCollectionView = {
        let collectionV = ScreeningCollectionView()
        collectionV.num = 10
        collectionV.extUseAutoLayout()
        collectionV.F_width = dr_Width
        collectionV.collectionV.backgroundColor = UIColor.ThemeView.bg
        collectionV.clickCellBlock = {[weak self](row) in
            guard let mySelf = self else{return}
            mySelf.index = row
        }
        return collectionV
    }()
    
    lazy var topLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLSwapDrawerViewTC.classForCoder(),EXTransactionEmptyTC.classForCoder()], ["SLSwapDrawerViewTC","EXTransactionEmptyTC"])
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([searchBar1,tableView,collectionV,topLine])
        collectionV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar1.snp.bottom).offset(15)
            make.height.equalTo(collectionVH)
        }
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(collectionV.snp.bottom)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(collectionV.snp.bottom).offset(0.5)
        }
        searchBar1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(NAV_STATUS_HEIGHT)
            make.height.equalTo(30)
        }
        //收到接口返回成功的通知
        
        // 当websocket请求数据的时候刷新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(webSocketUpdateContractTicker),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification),
                                               object: nil)
    }
    
    //添加顶部显示和总数据源
    func addHomeCoin(){
        var getHomeCoin = ["USDT","contract_currency_standard".localized()]
        if (SLPublicSwapInfo.sharedInstance()?.hasMoni == true) {
            getHomeCoin.append("contract_simulation_swap".localized())
        }
        var arr : [CoinEntity] = []
        //更新顶部展示
        for item in getHomeCoin{
            let entity = CoinEntity()
            entity.name = item
            arr.append(entity)
        }
        self.collectionV.collectionDatas = arr
        
        if index < self.collectionV.collectionDatas.count{
            self.collectionV.slidingCollection(IndexPath.init(row: index, section: 0))
        }else{
            index = 0
            self.collectionV.slidingCollection(IndexPath.init(row: 0, section: 0))
        }
        
        self.collectionV.reloadCollectionVLayout()
    }
    
    func reloadSearchBar(){
        searchText = ""
        searchBar1.text = ""
        searchBar1.resignFirstResponder()
    }
    
    //刷新数据源
    func reloadData(){
        addHomeCoin()
        self.tableViewRowDatas.removeAll()
        self.tableViewRowDatas1.removeAll()
        self.tableViewRowDatas2.removeAll()
        self.tableViewRowDatas3.removeAll()
        self.tableViewRowDatas1 = SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_USDT) ?? []
        self.tableViewRowDatas2 = SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_INVERSE) ?? []
        self.tableViewRowDatas3 = SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_SIMULATION) ?? []
        self.tableViewRowDatas1.sort { $0.instrument_id < $1.instrument_id }
        self.tableViewRowDatas2.sort { $0.instrument_id < $1.instrument_id }
        self.tableViewRowDatas3.sort { $0.instrument_id < $1.instrument_id }
    
        self.reloadSearchView([tableViewRowDatas,tableViewRowDatas1,tableViewRowDatas2,self.tableViewRowDatas3])
        setSearchArr()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - websocket Ticker 刷新
    @objc func webSocketUpdateContractTicker(notification: NSNotification) {
        let message = notification.userInfo
        guard let item = message!["data"] as? BTItemModel else {
            return
        }
        var isChanged = false
        for obj in self.tableViewRowDatas {
            if obj.instrument_id == item.instrument_id {
                obj.change_rate = item.change_rate
                isChanged = true
                break
            }
        }
        if !isChanged {
            for obj in self.tableViewRowDatas1 {
                if obj.instrument_id == item.instrument_id {
                    obj.change_rate = item.change_rate
                    isChanged = true
                    break
                }
            }
        }
        if !isChanged {
            for obj in self.tableViewRowDatas2 {
                if obj.instrument_id == item.instrument_id {
                    obj.change_rate = item.change_rate
                    isChanged = true
                    break
                }
            }
        }
        if !isChanged {
            for obj in self.tableViewRowDatas3 {
                if obj.instrument_id == item.instrument_id {
                    obj.change_rate = item.change_rate
                    isChanged = true
                    break
                }
            }
        }
        if isChanged {
            self.tableView.reloadData()
        }
    }
}

extension SLSwapDrawerView : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchArray.count == 0 && searchArray1.count == 0 && searchArray2.count == 0 && searchArray3.count == 0{//如果没有数据
            return 1
        }
        if searchArray.count > 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return 1
                }
                return searchArray.count
            case 1:
                if searchArray1.count == 0 {
                    return 1
                }
                return searchArray1.count
            case 2:
                if searchArray2.count == 0 {
                    return 1
                }
                return searchArray2.count
            case 3:
                if searchArray3.count == 0 {
                    return 1
                }
                return searchArray3.count
            default:
                return 0
            }
        }
        if searchArray.count == 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return 1
                }
                return searchArray1.count
            case 1:
                if searchArray2.count == 0 {
                    return 1
                }
                return searchArray2.count
            case 2:
                if searchArray3.count == 0 {
                    return 1
                }
                return searchArray3.count
            
            default:
                return 0
            }
        }
        if searchArray.count > 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return 1
                }
                return searchArray.count
            case 1:
                if searchArray1.count == 0 {
                    return 1
                }
                return searchArray1.count
            case 2:
                if searchArray2.count == 0 {
                    return 1
                }
                return searchArray2.count
            
            default:
                return 0
            }
        }
        if searchArray.count == 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return 1
                }
                return searchArray1.count
            case 1:
                if searchArray2.count == 0 {
                    return 1
                }
                return searchArray2.count
            default:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = EXMarketSectionV()
            view.setView(LanguageTools.getString(key: "market_text_customZone"))
            return view
        case 1:
            let view = EXMarketSectionV()
            view.setView("USDT")
            return view
        case 2:
            let view = EXMarketSectionV()
            view.setView("contract_currency_standard".localized())
            return view
        case 3:
            let view = EXMarketSectionV()
            view.setView("contract_simulation_swap".localized())
            return view
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchArray.count == 0 && section == 0{
            return 0
        }
        if searchArray1.count == 0 && section == 1{
            return 0
        }
        if searchArray2.count == 0 && section == 2{
            return 0
        }
        if searchArray3.count == 0 && section == 3{
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchArray.count == 0 && searchArray1.count == 0 && searchArray2.count == 0 && searchArray3.count == 0{//如果没有数据
            return 240
        }
        return 52
    }
    
    func createEmptyCell(_ tableView: UITableView) -> UITableViewCell {
        let cell : EXTransactionEmptyTC = tableView.dequeueReusableCell(withIdentifier: "EXTransactionEmptyTC") as! EXTransactionEmptyTC
        cell.setBig()
        cell.reloadEmptyView(self.index)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchArray.count == 0 && searchArray1.count == 0 && searchArray2.count == 0 && searchArray3.count == 0{//如果没有数据
            return self.createEmptyCell(tableView)
        }
        var entity = BTItemModel()
        if searchArray.count > 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray[indexPath.row]
            case 1:
                if searchArray1.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray1[indexPath.row]
            case 2:
                if searchArray2.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray2[indexPath.row]
            case 3:
                if searchArray3.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray3[indexPath.row]
            default:
                break
            }
        }
        if searchArray.count == 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray1[indexPath.row]
            case 1:
                if searchArray2.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray2[indexPath.row]
            case 2:
                if searchArray3.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray3[indexPath.row]
            
            default:
                break
            }
        }
        if searchArray.count > 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray[indexPath.row]
            case 1:
                if searchArray1.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray1[indexPath.row]
            case 2:
                if searchArray2.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray2[indexPath.row]
            
            default:
                break
            }
        }
        if searchArray.count == 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray1[indexPath.row]
            case 1:
                if searchArray2.count == 0 {
                    return self.createEmptyCell(tableView)
                }
                entity = searchArray2[indexPath.row]
            default:
                break
            }
        }
        let cell : SLSwapDrawerViewTC = tableView.dequeueReusableCell(withIdentifier: "SLSwapDrawerViewTC") as! SLSwapDrawerViewTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchArray.count == 0 && searchArray1.count == 0 && searchArray2.count == 0 && searchArray3.count == 0{//如果没有数据
            return
        }
        if searchArray.count > 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return
                }
                clickCellBlock?(searchArray[indexPath.row])
            case 1:
                if searchArray1.count == 0 {
                    return
                }
                clickCellBlock?(searchArray1[indexPath.row])
            case 2:
                if searchArray2.count == 0 {
                    return
                }
                clickCellBlock?(searchArray2[indexPath.row])
            case 3:
                if searchArray3.count == 0 {
                    return
                }
                clickCellBlock?(searchArray3[indexPath.row])
            default:
                break
            }
        }
        if searchArray.count == 0 && searchArray3.count > 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return
                }
                clickCellBlock?(searchArray1[indexPath.row])
            case 1:
                if searchArray2.count == 0 {
                    return
                }
                clickCellBlock?(searchArray2[indexPath.row])
            case 2:
                if searchArray3.count == 0 {
                    return
                }
                clickCellBlock?(searchArray3[indexPath.row])
            default:
                break
            }
        }
        if searchArray.count > 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray.count == 0 {
                    return
                }
                clickCellBlock?(searchArray[indexPath.row])
            case 1:
                if searchArray1.count == 0 {
                    return
                }
                clickCellBlock?(searchArray1[indexPath.row])
            case 2:
                if searchArray2.count == 0 {
                    return
                }
                clickCellBlock?(searchArray2[indexPath.row])
            default:
                break
            }
        }
        if searchArray.count == 0 && searchArray3.count == 0 {
            switch index {
            case 0:
                if searchArray1.count == 0 {
                    return
                }
                clickCellBlock?(searchArray1[indexPath.row])
            case 1:
                if searchArray2.count == 0 {
                    return
                }
                clickCellBlock?(searchArray2[indexPath.row])
            default:
                break
            }
        }
    }
    
}

extension SLSwapDrawerView : UISearchBarDelegate{
    
    func reloadSearchView(_ arr : [[BTItemModel]]){
        self.searchArray = arr[0]
        self.searchArray1 = arr[1]
        self.searchArray2 = arr[2]
        self.searchArray3 = arr[3]
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        setSearchArr()
    }
    
    func setSearchArr(){
        if searchText == "" {
            reloadSearchView([tableViewRowDatas,tableViewRowDatas1,tableViewRowDatas2,tableViewRowDatas3])
        }else{
            var array : [BTItemModel] = []
            for item in tableViewRowDatas{
                if item.name.contains(searchText.uppercased()){
                    array.append(item)
                }
            }
            var array1 : [BTItemModel] = []
            for item in tableViewRowDatas1{
                if item.name.contains(searchText.uppercased()){
                    array1.append(item)
                }
            }
            var array2 : [BTItemModel] = []
            for item in tableViewRowDatas2{
                if item.name.contains(searchText.uppercased()){
                    array2.append(item)
                }
            }
            var array3 : [BTItemModel] = []
            for item in tableViewRowDatas3{
                if item.name.contains(searchText.uppercased()){
                    array3.append(item)
                }
            }
            reloadSearchView([array,array1,array2,array3])
        }
    }
    
}
