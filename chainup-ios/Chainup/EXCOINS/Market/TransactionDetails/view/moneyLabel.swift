//
//  TransactionDetailsVC.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/14.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class TransactionDetailsVC: NavCustomVC {
    
    var entity = CoinMapEntity()
    
    var middleBtn : UIButton?
    
    var rightBtn : UIButton?
    
    var tableViewRowDatas : [TransacionEntity] = []
    
    var depthTableViewRowDatas : [TransactionDepthEntity] = []
    
    var precision = 2//精度
    
    var asksAlllength = "0"//卖总深度
    
    var buysAlllength = "0"//买总深度
    
    var type = TransactionDetailsType.depth
    
    //历史k线
    lazy var ws_klineHistory : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_klineHistory"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
    //实时k线
    lazy var ws_klineNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_klineNow"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
    //实时价格
    lazy var ws_PriceNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_PriceNow"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
    //深度图
    lazy var ws_DepthNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_DepthNow"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
    //历史成交
    lazy var ws_historyDeal : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_historyDeal"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
    //实时成交
    lazy var ws_nowDeal : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_nowDeal"
        manager.connectSever(NetDefine.wss_host_url)
        return manager
    }()
    
//    lazy var ws_
    
    var kcandleType = "30min"//深度
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.estimatedRowHeight = 44
        tableView.estimatedSectionHeaderHeight = 20
        tableView.estimatedSectionFooterHeight = 20
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.tableHeaderView = transactionDetailsHeadV
        tableView.extRegistCell([TransactionDetailsTC.classForCoder(),TransactionDepthTC.classForCoder()], ["TransactionDetailsTC","TransactionDepthTC"])
        return tableView
    }()
    
    //买
    lazy var buyBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.backgroundColor = UIColor.ThemekLine.up
        btn.extSetTitle(LanguageTools.getString(key: "tab_buy"), 15, UIColor.ThemeView.bg, UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickBottomBtn))
        return btn
    }()
    
    //卖
    lazy var sellBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.backgroundColor = UIColor.ThemekLine.down
        btn.extSetTitle(LanguageTools.getString(key: "tab_sell"), 15, UIColor.ThemeView.bg, UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickBottomBtn))
        return btn
    }()
    
    lazy var transactionDetailsHeadV : TransactionDetailsHeadV = {
        let view = TransactionDetailsHeadV.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 152 + 425 + 210 + 50 + 25 + 20))
        //接收点击k线时间的通知
        _ = view.kLineDetailsV.kLineTimeView.subject.asObserver().subscribe({[weak self] (event) in
            guard let mySelf = self else{return}
            if let tag = event.element{
                if tag < 2000{
                    view.kLineDetailsV.kLineView.chartView.setSerie(hidden: true, by: "", inSection: 0)
                    if tag == 1000{
                        
                        view.kLineDetailsV.kLineView.chartView.setSerie(hidden: false, by: "Timeline", inSection: 0)
                    }else{
                    
                        view.kLineDetailsV.kLineView.chartView.setSerie(hidden: false, by: "Candle", inSection: 0)

                    }
                    view.kLineDetailsV.kLineView.chartView.setSerie(hidden: false, by: "MA", inSection: 0)
                    view.kLineDetailsV.kLineView.chartView.setSerie(hidden: false, by: "KDJ", inSection: 0)
                    view.kLineDetailsV.kLineView.chartView.setSerie(hidden: false, by: "Volue", inSection: 0)
                
                mySelf.setKCandleTypeWithTag(tag - 999)
                mySelf.ws_klineHistory.disconnect()
                mySelf.ws_klineHistory.connectSever(NetDefine.wss_host_url)
                }
            }
        })
        
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        reloadDepthTableViewRowDatas()
    }
    
    func reloadDepthTableViewRowDatas(){
        var array : [TransactionDepthEntity] = []
        for _ in 0..<20{
            let entity = TransactionDepthEntity()
            array.append(entity)
        }
        depthTableViewRowDatas = array
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentView.backgroundColor = UIColor.ThemeView.bg
        if let i = Int(entity.price){//默认精度
            precision = i
        }
//            PublicInfoManager.sharedInstance.getCoinPrecision(entity.name)//默认精度
        //点击深度和成交的按钮切换
        transactionDetailsHeadV.clickSwitchBtnBlock = {[weak self](tag) in
            guard let mySelf = self else{return}
            if tag == 10000{
                mySelf.type = TransactionDetailsType.depth
            }else{
                mySelf.type = TransactionDetailsType.deal
            }
            mySelf.tableView.reloadData()
        }
    }
    
    override func addConstraint() {
        super.addConstraint()
        contentView.addSubViews([tableView,buyBtn,sellBtn])
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(buyBtn.snp.top)
        }
        buyBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
            make.height.equalTo(45)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
        sellBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalTo(buyBtn)
            make.height.equalTo(45)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
    }
    
    override func setNavCustomV() {
        let middleBtn = UIButton()
        middleBtn.setEnlargeEdgeWithTop(10, left: 20, bottom: 10, right: 20)
        middleBtn.extUseAutoLayout()
        middleBtn.tag = 1001
        middleBtn.extSetAddTarget(self, #selector(clickNavBtn))
        navCustomView.addSubview(middleBtn)
        middleBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
            make.height.lessThanOrEqualTo(20)
            make.bottom.equalToSuperview().offset(-13)
        }
        self.middleBtn = middleBtn
        
        let imgV = UIImageView.init(image: UIImage.init(named: "down"))
        navCustomView.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.centerY.equalTo(middleBtn)
            make.width.equalTo(14)
            make.height.equalTo(8)
            make.left.equalTo(middleBtn.snp.right).offset(5)
        }
        
        let rightBtn = UIButton()
        rightBtn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        rightBtn.extUseAutoLayout()
        rightBtn.extSetImages([UIImage.init(named: "uncollection")!,UIImage.init(named: "collection")!], controlStates: [UIControlState.normal,UIControlState.selected])
        rightBtn.tag = 1002
        rightBtn.extSetAddTarget(self, #selector(clickNavBtn))
        navCustomView.setRightModule([rightBtn], rightSize: (17, 17))
        self.rightBtn = rightBtn
        reloadVC()
    }
    
    //点击底部按钮
    @objc func clickBottomBtn(_ btn : UIButton){
//        let testVc = EXMarketDetailHolzontalVc.instanceFromStoryboard(name: "Market")
//        testVc.coinMapEntity = self.entity
//        self.navigationController?.pushViewController(testVc, animated: true)
        return
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (i) in
            guard let mySelf = self else{return}
            let array = PublicInfoManager.sharedInstance.allCoinMapInfo
            if array.count > 0{
                mySelf.wsRequestData()
            }
            }.disposed(by: disposeBag)
    }
    
    func wsRequestData(){
        ws_historyDeal.connectSever(NetDefine.wss_host_url)//历史交易
        ws_klineHistory.connectSever(NetDefine.wss_host_url)//请求历史K线
        ws_DepthNow.connectSever(NetDefine.wss_host_url)//深度
        ws_PriceNow.connectSever(NetDefine.wss_host_url)//24小时
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disconnectws()
    }
    
    //注销ws
    func disconnectws(){
        ws_historyDeal.disconnect()
        ws_DepthNow.disconnect()
        ws_klineHistory.disconnect()
        ws_klineNow.disconnect()
        ws_PriceNow.disconnect()
        ws_nowDeal.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadVC(){
        middleBtn?.extSetTitle(entity.name, 18, UIColor.ThemeLabel.colorLite, UIControlState.normal)
        rightBtn?.isSelected = XUserDefault.whetherCollectionCoinMap(entity.name)
        transactionDetailsHeadV.kLineDetailsV.reloadView(false)//更新
        transactionDetailsHeadV.kLineDepthView.noDataLabel.isHidden = true
        disconnectws()
        //历史k线
        transactionDetailsHeadV.kLineDetailsV.reloadKLineView([])
        //24小时行情
        transactionDetailsHeadV.transactionHeadV.entity = TransactionHeadEntity()
        transactionDetailsHeadV.transactionHeadV.setView()
        //深度
        transactionDetailsHeadV.kLineDepthView.depthDatas.removeAll()
        transactionDetailsHeadV.kLineDepthView.depthView.reloadData()
        //交易
        tableViewRowDatas.removeAll()
        tableView.reloadData()
        wsRequestData()

    }
    
    //点击导航栏按钮
    @objc func clickNavBtn(_ btn : UIButton){
        switch btn.tag {
        case 1001://点击搜索
            break
        case 1002://收藏
            btn.isSelected = !btn.isSelected
            if btn.isSelected{
                XUserDefault.collectionCoinMap(entity.name)
            }else{
                XUserDefault.cancelCollectionCoinMap(entity.name)
            }
        default:
            break
        }
    }
    

}

extension TransactionDetailsVC : DSWebSocketDelegate{
    
    //链接成功
    func websocketDidConnect(socket: XWebSocketManager) {
        if socket.key == "ws_klineHistory"{//历史k线
            wsHistoryKLineData()
        }else if socket.key == "ws_klineNow"{//实时k线
            wsNowKLineData()
        }else if socket.key == "ws_PriceNow"{//24小时行情
            wsNowPriceData()
        }else if socket.key == "ws_DepthNow"{//深度
            wsDepthLineData()
        }else if socket.key == "ws_historyDeal"{//历史交易
            wsHistoryDealData()
        }else if socket.key == "ws_nowDeal"{//实时交易
            wsNowDealData()
        }
    }
    
    //接收数据
    func websocketDidReceiveData(socket: XWebSocketManager, data: Data) {
        let uncompress = NSData.uncompressZippedData(data)
        if uncompress == nil{
            return
        }
        do{
            let json = try JSONSerialization.jsonObject(with: uncompress!, options: JSONSerialization.ReadingOptions.allowFragments)
            if let dict = json as? [String : Any]{
                if socket.key == "ws_DepthNow"{//深度
                }
                if dict.keys.contains("ping"){
                    let jsonData = try JSONSerialization.data(withJSONObject: ["pong" : dict["ping"]], options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
                    socket.sendBrandStr(string: jsonStr!)
                }else{
                    if socket.key == "ws_klineHistory"{//历史k线
                        handleHistoryLine(dict)
                    }else if socket.key == "ws_klineNow"{//实时k线
                        handleNowKLine(dict)
                    }else if socket.key == "ws_PriceNow"{//24小时行情
                        handleNowPrice(dict)
                    }else if socket.key == "ws_DepthNow"{//深度
                        handleDepthLine(dict)
                    }else if socket.key == "ws_historyDeal"{//历史交易
                        handleHistoryDeal(dict)
                    }else if socket.key == "ws_nowDeal"{//实时交易
                        handleNowDeal(dict)
                    }
                }
            }
        }catch _ {
            
        }
    }
    
    //请求当前24小时行情
    func wsNowPriceData(){
        let channel = "market_\(entity.symbol)_ticker"
        let cb_id = "mainCell\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_PriceNow.sendBrandStr(string: jsonStr)
    }
    
    //处理当前24小时行情
    func handleNowPrice(_ dict : [String : Any]){
        if let channel = dict["channel"] as? String , channel == "market_\(entity.symbol)_ticker"{
            if let tick = dict["tick"] as? [String : Any]{
                let entity = TransactionHeadEntity()
                entity.precision = self.precision
                entity.setEntityWithDict(tick)
                let array = self.entity.name.components(separatedBy: "/")
                if array.count > 1{
                    if let close = tick["close"]{
                        let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(array[1])
                        if let rmb = NSString.init(string: String(describing: close)).multiplyingBy1(t.1, decimals: t.2){
                            transactionDetailsHeadV.transactionHeadV.moneyLabel.text = "≈\(t.0)" + rmb
                        }
                    }
                    
                }
                transactionDetailsHeadV.transactionHeadV.entity = entity
                transactionDetailsHeadV.transactionHeadV.setView()
            }
        }
    }
    
    //请求历史k线
    func wsHistoryKLineData(){
        let channel = "market_\(entity.symbol)_kline_\(kcandleType)"
        let cb_id = "Kline\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "req" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_klineHistory.sendBrandStr(string: jsonStr)
    }
    
    //处理历史k线
    func handleHistoryLine(_ dict : [String : Any]){
        if let data = dict["data"] as? [[String : Any]]{
            var array : [KlineChartData] = []
            for item in data{
                let entity = KlineChartData()
                entity.setEntityWithDict(item)
                array.append(entity)
            }
            transactionDetailsHeadV.kLineDetailsV.reloadKLineView(array)
        }
        ws_klineNow.disconnect()
        ws_klineNow.connectSever(NetDefine.wss_host_url)
        wsNowKLineData()
    }
    
    //请求最新的k线
    func wsNowKLineData(){
        let channel = "market_\(entity.symbol)_kline_\(kcandleType)"
        let cb_id = "KlineNow\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_klineNow.sendBrandStr(string: jsonStr)
    }
    
    //处理实时k线
    func handleNowKLine(_ dict : [String : Any]){
        if let tick = dict["tick"] as? [String : Any]{
            let array = transactionDetailsHeadV.kLineDetailsV.kLineView.kLineDatas
            if array.count > 0{
                if let ts = tick["id"] as? Int , (array.last)?.time == ts{
                    return
                }
            }
            let entity = KlineChartData()
            entity.setEntityWithDict(tick)
            transactionDetailsHeadV.kLineDetailsV.appendKLineView(entity)
        }
    }
    
    //请求深度图
    func wsDepthLineData(){
        let channel = "market_\(entity.symbol)_depth_step0"
        let cb_id = "KlineDepth\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id , "asks" : "150" , "bids" : "150"]])
        ws_DepthNow.sendBrandStr(string: jsonStr)
    }
    
    //处理深度图
    func handleDepthLine(_ dict : [String : Any]){
        let doubleArray = transactionDetailsHeadV.kLineDepthView.getDataByFile(dict)
        asksAlllength = "0"
        buysAlllength = "0"
        reloadDepthTableViewRowDatas()
        let asks = doubleArray.0
        let buys = doubleArray.1
        let asksN = asks.count >= 20 ? 20 : asks.count
        let buysN = buys.count >= 20 ? 20 : buys.count
        let pricedecimals = Int(entity.price) ?? 8
        let voldecimals = Int(entity.volume) ?? 8
//            entity.depthArray.count > 0 ? entity.depthArray[0] : 8
        for i in 0..<asksN{
            if asks[i].count > 1{
                depthTableViewRowDatas[i].asks = NSString.init(string:  "\(asks[i][0])").decimalString(pricedecimals)
                depthTableViewRowDatas[i].asksNum = NSString.init(string:  "\(asks[i][1])").decimalString(voldecimals)
                asksAlllength = NSString.init(string: asksAlllength).adding(depthTableViewRowDatas[i].asksNum, decimals: voldecimals)
                depthTableViewRowDatas[i].askslength = asksAlllength
            }
        }
        for i in 0..<buysN{
            if buys[i].count > 1{
                depthTableViewRowDatas[i].buys = NSString.init(string:  "\(buys[i][0])").decimalString(pricedecimals)
                depthTableViewRowDatas[i].buysNum = NSString.init(string:  "\(buys[i][1])").decimalString(voldecimals)
                buysAlllength = NSString.init(string: buysAlllength).adding(depthTableViewRowDatas[i].buysNum, decimals: voldecimals)
                depthTableViewRowDatas[i].buyslength = buysAlllength
            }
        }
        self.tableView.reloadData()
    }
    
    //请求历史成交
    func wsHistoryDealData(){
        let channel = "market_\(entity.symbol)_trade_ticker"
        let cb_id = "KlineDownHistory\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "req" , "params" : ["channel" : channel , "cb_id" : cb_id , "top" : "20"]])
        ws_historyDeal.sendBrandStr(string: jsonStr)
        
    }
    
    //处理历史成交
    func handleHistoryDeal(_ dict : [String : Any]){
        if let data = dict["data"] as? [[String : Any]]{
            var arr : [TransacionEntity] = []
            for item in data{
                let entity = TransacionEntity()
                entity.coinMapEntity = self.entity
                entity.precision = self.precision
                entity.setEntityWithDict(item)
                arr.append(entity)
            }
            tableViewRowDatas = arr
            tableView.reloadData()
            ws_nowDeal.disconnect()
            ws_nowDeal.connectSever(NetDefine.wss_host_url)
        }
    }
    
    //请求实时交易
    func wsNowDealData(){
        let channel = "market_\(entity.symbol)_trade_ticker"
        let cb_id = "KlineDown\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_nowDeal.sendBrandStr(string: jsonStr)
    }
    
    //处理实时交易
    func handleNowDeal(_ dict : [String : Any]){
        if let tick = dict["tick"] as? [String : Any]{
            if let data = tick["data"] as? [[String : Any]]{
                if data.count > 0{
                    for i in data{
                        let entity = TransacionEntity()
                        entity.coinMapEntity = self.entity
                        entity.setEntityWithDict(i)
                        tableViewRowDatas.insert(entity, at: 0)
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //点击第几档
    func setKCandleTypeWithTag(_ tag : Int){
        if tag <= PublicInfoEntity.sharedInstance.klineScale.count,tag >= 0{
            
            self.kcandleType = PublicInfoEntity.sharedInstance.klineScale[tag-1]
        }else{
            self.kcandleType = "30min"
        }
    }
    
}

extension TransactionDetailsVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if type == .deal{
            let view = TransactionDetailsV()
            view.setView(entity.marketName, sell: entity.coinListEntity.name)
            return view
        }else{
            let view = TransactionDepthTV()
            view.setView(entity.coinListEntity.name, marketCoin: entity.marketName)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .deal{
            let cell : TransactionDetailsTC = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailsTC") as! TransactionDetailsTC
            if indexPath.row < tableViewRowDatas.count{
                cell.setCellWithEntity(tableViewRowDatas[indexPath.row])
            }
            return cell
        }else{
            let cell : TransactionDepthTC = tableView.dequeueReusableCell(withIdentifier: "TransactionDepthTC") as! TransactionDepthTC
            if indexPath.row < depthTableViewRowDatas.count{
                cell.setCell(depthTableViewRowDatas[indexPath.row],index : indexPath.row,asksAlllength:asksAlllength , buysAlllength : buysAlllength)
            }
            return cell
        }
    }
}


