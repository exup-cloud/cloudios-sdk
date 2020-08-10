//
//  EXKlineWsVm.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift



class EXKlineWsVm: NSObject {
    var accountType:KLineAccountType = .coin
    var entity = CoinMapEntity()
    static let keyLine = "Line"
    var depthMaxAmount: Float = 0          //最大深度
    var depthDatas: [CHKDepthChartItem] = [CHKDepthChartItem]()
    var hasFinishAllHistory:Bool = false
    var hasOrder:Bool = false
    var historyCount:Int = 0
    var originHistoryModel :EXKlineModel = EXKlineModel()
    
    var latestPriceTS = ""
    static let wsKeyPrice = "ws_PriceNow"
    static let wsKeyNow = "ws_klineNow"
    static let wsKeyHistory = "ws_klineHistory"
    static let wsKeyDepthNow = "ws_DepthNow"
    static let wsHistroyOrder = "ws_historyDeal"
    static let wsNowOrder = "ws_nowDeal"

    var kcandleType = KlineScaleDefaultKey {
        didSet {
            if kcandleType == EXKlineWsVm.keyLine {
                kcandleType = "1min"
            }
        }
    }//深度
    
    //第二个参数为是否翻页
    let kLineHistroyDatas : PublishSubject<([KLineChartItem],Bool)> = PublishSubject.init()
    let kLineNowDatas : PublishSubject<KLineChartItem> = PublishSubject.init()
    let tickPriceData : PublishSubject<TickItem> = PublishSubject.init()
    let depthData : PublishSubject<([CHKDepthChartItem],Float)> = PublishSubject.init()
    
    let orderHistoryData : PublishSubject<[TransacionEntity]> = PublishSubject.init()
    let orderNowData : PublishSubject<[TransacionEntity]> = PublishSubject.init()

    let candleScale:Variable<String?> = Variable(nil)
    let disposebag = DisposeBag()

    func observeScale() {
        candleScale.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] scale in
                if let changedScale = scale {
                    self?.kcandleType = changedScale
                    self?.disconnectAll()
                    self?.reconncet()
                }
            }).disposed(by: disposebag)
    }
    
    
    //历史k线
    lazy var ws_klineHistory : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_klineHistory"
        return manager
    }()
    
    //实时k线
    lazy var ws_klineNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_klineNow"
        return manager
    }()
    
    //实时价格
    lazy var ws_PriceNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_PriceNow"
        manager.connectSever(self.getServer())
        return manager
    }()
    
    //深度图
    lazy var ws_DepthNow : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_DepthNow"
        manager.connectSever(self.getServer())
        return manager
    }()
    
    //历史成交
    lazy var ws_historyDeal : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_historyDeal"
        manager.connectSever(self.getServer())
        return manager
    }()
    
    //实时成交
    lazy var ws_nowDeal : XWebSocketManager = {
        let manager = XWebSocketManager()
        manager.webSocketDelegate = self
        manager.key = "ws_nowDeal"
        manager.connectSever(self.getServer())
        return manager
    }()
    
    
    func reconncet() {
        self.connecKlineWs()//启动历史k线
        self.connectDepth()
        self.connectprice()
        self.connectHistoryOrder()
    }
    
    func getServer() -> String {
//        let server = accountType == .coin ? EXNetworkDoctor.sharedManager.getKlineWs() : EXNetworkDoctor.sharedManager.getContractWs()
        var server = EXNetworkDoctor.sharedManager.getKlineWs()
        if accountType == .coin || accountType == .lever {
            server = EXNetworkDoctor.sharedManager.getKlineWs()
        }else if accountType == .contract {
            server = EXNetworkDoctor.sharedManager.getContractWs()
        }
        
//        var server = NetDefine.wss_host_url
//        if accountType == .coin || accountType == .lever{
//            server = NetDefine.wss_host_url
//        }else if accountType == .contract{
//            server = NetDefine.wss_host_contract
//        }
        return server
    }
    
    func connectDepth() {
        ws_DepthNow.connectSever(self.getServer())//请求sshendu
    }
    
    func connectHistoryOrder() {
        
        ws_historyDeal.connectSever(self.getServer())//历史交易
    }

    func connecKlineWs() {
        ws_klineHistory.connectSever(self.getServer())//请求历史K线
    }
    
    func connecKlineNow() {
        ws_klineNow.connectSever(self.getServer())//请求实时K线
    }
    
    func connectprice(){
        ws_PriceNow.connectSever(self.getServer())//价格
    }
    
    func disconnectKlineWs() {
        
    }
    
    func disconnectAll(){
        self.hasFinishAllHistory = false
        self.hasOrder = false
        self.historyCount = 0
        self.originHistoryModel.data.removeAll()
        
        ws_historyDeal.disconnect()
        ws_DepthNow.disconnect()
        ws_klineHistory.disconnect()
        ws_klineNow.disconnect()
        ws_PriceNow.disconnect()
        ws_nowDeal.disconnect()
    }
}

extension EXKlineWsVm : DSWebSocketDelegate {
    
    func websocketDidConnect(socket: XWebSocketManager) {
        if socket.key == EXKlineWsVm.wsKeyHistory {//历史k线
            wsHistoryKLineData()
        }else if socket.key == EXKlineWsVm.wsKeyNow{//实时k线
            wsNowKLineData()
        }else if socket.key == EXKlineWsVm.wsKeyPrice {//价格
            wsNowPriceData()
        }else if socket.key == EXKlineWsVm.wsKeyDepthNow {
            wsDepthNowDate()
        }else if socket.key == EXKlineWsVm.wsHistroyOrder {
            wsHistoryDealData()
        }else if socket.key == EXKlineWsVm.wsNowOrder {
            wsNowDealData()
        }
    }
    
    //请求历史k线
    func wsHistoryKLineData(){
        let channel = "market_\(entity.symbol)_kline_\(kcandleType)"
        let cb_id = "Kline\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "req" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_klineHistory.sendBrandStr(string: jsonStr)
    }
    
    //上一页ws数据
    func wsHistoryKLinePre() {
        let channel = "market_\(entity.symbol)_kline_\(kcandleType)"
        let cb_id = "Kline\(entity.symbol)"
        let preItem = self.originHistoryModel.data[0]
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "req" , "params" : ["channel" : channel , "cb_id" : cb_id, "endIdx":preItem.id , "pageSize":300]])
        ws_klineHistory.sendBrandStr(string: jsonStr)
    }
    
    //请求最新的k线
    func wsNowKLineData(){
        let channel = "market_\(entity.symbol)_kline_\(kcandleType)"
        let cb_id = "KlineNow\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_klineNow.sendBrandStr(string: jsonStr)
    }
    
    //请求当前24小时行情
    func wsNowPriceData(){
        let channel = "market_\(entity.symbol)_ticker"
        let cb_id = "mainCell\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_PriceNow.sendBrandStr(string: jsonStr)
    }
    
    func wsDepthNowDate() {
        let channel = "market_\(entity.symbol)_depth_step0"
        let cb_id = "KlineDepth\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id , "asks" : "150" , "bids" : "150"]])
        ws_DepthNow.sendBrandStr(string: jsonStr)
    }
    
    //请求历史成交
    func wsHistoryDealData(){
        let channel = "market_\(entity.symbol)_trade_ticker"
        let cb_id = "KlineDownHistory\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "req" , "params" : ["channel" : channel , "cb_id" : cb_id , "top" : "20"]])
        ws_historyDeal.sendBrandStr(string: jsonStr)
        
    }
    //请求实时交易
    func wsNowDealData(){
        let channel = "market_\(entity.symbol)_trade_ticker"
        let cb_id = "KlineDown\(entity.symbol)"
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : channel , "cb_id" : cb_id]])
        ws_nowDeal.sendBrandStr(string: jsonStr)
    }
    
    //处理历史成交
    func handleHistoryDeal(_ dict : [String : Any]){
        if hasOrder {
            return
        }
        if let data = dict["data"] as? [[String : Any]]{
            var arr : [TransacionEntity] = []
            for item in data{
                let entity = TransacionEntity()
                entity.coinMapEntity = self.entity
//                entity.precision = self.precision
                entity.setEntityWithDict(item)
                arr.append(entity)
            }
            orderHistoryData.onNext(arr)
            ws_nowDeal.disconnect()
            ws_nowDeal.connectSever(self.getServer())
        }else {
            orderHistoryData.onNext([])
        }
        hasOrder = true
    }
    
    //处理实时交易
    func handleNowDeal(_ dict : [String : Any]){
        if let tick = dict["tick"] as? [String : Any]{
            if let data = tick["data"] as? [[String : Any]]{
                var arr : [TransacionEntity] = []

                if data.count > 0{
                    for i in data{
                        let entity = TransacionEntity()
                        entity.coinMapEntity = self.entity
                        entity.setEntityWithDict(i)
                        arr.append(entity)
//                        tableViewRowDatas.insert(entity, at: 0)
//                        tableView.reloadData()
                    }
                }
                orderNowData.onNext(arr)
            }
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
                    
                    if socket.key == EXKlineWsVm.wsKeyHistory ||
                        socket.key == EXKlineWsVm.wsKeyNow {
                        guard let klineModel = EXKlineModel.mj_object(withKeyValues: dict) else {
                            return
                        }
                        if socket.key == EXKlineWsVm.wsKeyHistory {//历史k线
                            handleHistoryLine(model:klineModel)
                        }else if socket.key == EXKlineWsVm.wsKeyNow {//实时k线
                            handleNowKline(model: klineModel)
                        }
                    }else if socket.key ==  EXKlineWsVm.wsKeyPrice {//24小时行情
                        guard let tickModel = EXKlineTictModel.mj_object(withKeyValues: dict), let currentTs = tickModel.ts, (currentTs as NSString).isBig(latestPriceTS) else {

                            print("currentTs =====  is Small latestPriceTS  ")
                            return
                        }
                        
                        print("currentTs ===== \(currentTs) is Great latestPriceTS =====\(latestPriceTS) curerntTs is Big latestPriceTS \(currentTs.isBig(latestPriceTS))")
                        latestPriceTS = currentTs as String
                        handleNowPrice(model: tickModel)
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
    
    func handleHistoryLine(model:EXKlineModel) {
        if model.data.count == 0 {
            return
        }
        //所有历史都已经加载完成
        if hasFinishAllHistory {
            return
        }
        // 抛出历史data model.data
        if originHistoryModel.data.count == 0 {
            originHistoryModel = model
            kLineHistroyDatas.onNext((model.data,false))
            connecKlineNow()
        }else {
            //第一次历史数据都不够指定的300,不需要再往前翻页了
            if originHistoryModel.data.count < 300 {
                hasFinishAllHistory = true
                return
            }
            let firstId = model.data[0].id
            let originFid = originHistoryModel.data[0].id
            //返回值和现有值id一致,不再添加处理
            if firstId >= originFid {
                return
            }
            if historyCount == 1 {
                hasFinishAllHistory = true
                return
            }
            originHistoryModel.data.insert(contentsOf: model.data, at: 0)
            kLineHistroyDatas.onNext((originHistoryModel.data,true))
            historyCount += 1
        }
    }
    
    func handleNowKline(model:EXKlineModel) {
        // 抛出当前kline数据
        kLineNowDatas.onNext(model.tick)
    }
    
    //处理当前24小时行情
    func handleNowPrice(model: EXKlineTictModel) {
        if let tickItem = model.tick {
            if let precision = Int(entity.price){
                tickItem.precision = precision
            }
            tickPriceData.onNext(tickItem)
        }
    }
    
    func handleDepthLine(_ dict : [String : Any]) {
        let model = ContractWsDepthModel.mj_object(withKeyValues: dict)
        guard let depthModel = model else {
            return
        }
        if let ticket = depthModel.tick {
            self.depthMaxAmount = 0
            depthDatas.removeAll()
            var asksArray : [[Double]] = []
            var bidsArray : [[Double]] = []
            
            if ticket.asks.count > 0 {
                for arr in ticket.asks{
                    if arr.count > 1{
                        asksArray.append([BasicParameter.handleDouble(arr[0]),BasicParameter.handleDouble(arr[1])])
                    }
                }
            }
            if ticket.buys.count > 0 {
                for arr in ticket.buys {
                    if arr.count > 1{
                        bidsArray.append([BasicParameter.handleDouble(arr[0]),BasicParameter.handleDouble(arr[1])])
                    }
                }
            }
            if asksArray.count > 0{
                self.decodeDatasToAppend(datas: asksArray, type: .ask)
            }
            
            if bidsArray.count > 0{
                self.decodeDatasToAppend(datas: bidsArray.reversed(), type: .bid)
            }
            
            self.depthData.onNext((self.depthDatas, self.depthMaxAmount))
        }
    }
    
    /// 解析数据
    func decodeDatasToAppend(datas: [[Double]], type: CHKDepthChartItemType) {
        var total: Float = 0
        if datas.count > 0 {
            for data in datas {
                let item = CHKDepthChartItem()
                item.value = CGFloat(data[0])
                item.amount = CGFloat(data[1])
                item.type = type
                
                self.depthDatas.append(item)
                
                total += Float(item.amount)
            }
        }
        
        if total > self.depthMaxAmount {
            self.depthMaxAmount = total
        }
    }

}

