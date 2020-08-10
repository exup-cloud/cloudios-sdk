//
//  ContractWsVm.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContractWsVm: NSObject {
    
    var wsDepthChannel:String = ""
    var ws24HourChannel:String = ""
    fileprivate let wsDepthKey = "manager.wsDepthKey"
    fileprivate let ws24HourPriceKey = "manager.ws24HourPriceKey"
    
    let closePriceSubject : PublishSubject<PriceTick> = PublishSubject.init()
    let buysSubject : PublishSubject<([String],[String],String)> = PublishSubject.init()
    let sellsSubject : PublishSubject<([String],[String],String)> = PublishSubject.init()

    var lstep = "0"//深度
    var priceDecimal :Int = 8
    var contractSymbol:String = "" {
        didSet {
            wsDepthChannel = "market_\(contractSymbol.lowercased())_depth_step\(lstep)"
            ws24HourChannel = "market_\(contractSymbol.lowercased())_ticker"
        }
    }
    
    
    //成交挂单
    lazy var contractWsManager : XWebSocketManager = {
        let ws = XWebSocketManager()
        ws.key = wsDepthKey
        ws.webSocketDelegate = self
        return ws
    }()
    
    //成交价
    lazy var contractPriceManager : XWebSocketManager = {
        let ws = XWebSocketManager()
        ws.key = ws24HourPriceKey
        ws.webSocketDelegate = self

        return ws
    }()
    
}

extension ContractWsVm :DSWebSocketDelegate {
    
    func wsRequestData(){
        let server = EXNetworkDoctor.sharedManager.getContractWs()
        contractWsManager.connectSever(server)//五档
        contractPriceManager.connectSever(server)//成交价
    }
    
    func disconnectws(){
        contractWsManager.disconnect()
        contractPriceManager.disconnect()
    }
    
    func websocketDidConnect(socket: XWebSocketManager) {
        if socket.key == wsDepthKey {//五档
            wsBuySellFiveData()
        }else if socket.key == ws24HourPriceKey {//成交价
            requestClinchDealData()
        }
    }
    
    //请求五档数据
    func wsBuySellFiveData(){
        let cb_id = ""
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : wsDepthChannel , "cb_id" : cb_id , "asks" : "150" , "bids" : "150"]])
        contractWsManager.sendBrandStr(string: jsonStr)
    }
    
    //请求成交
    func requestClinchDealData(){
        let cb_id = ""
        let jsonStr = JSONSerialization.jsonDataFromDictToString(["event" : "sub" , "params" : ["channel" : ws24HourChannel , "cb_id" : cb_id]])
        contractPriceManager.sendBrandStr(string: jsonStr)
    }
    
    func websocketDidReceiveData(socket: XWebSocketManager, data: Data) {
        let uncompress = NSData.uncompressZippedData(data)
        if uncompress == nil{
            return
        }
        do{
            let json = try JSONSerialization.jsonObject(with: uncompress!, options: JSONSerialization.ReadingOptions.allowFragments)
            if let dict = json as? [String : Any]{
                if dict.keys.contains("ping"){
                    let jsonData = try JSONSerialization.data(withJSONObject: ["pong" : dict["ping"]], options: JSONSerialization.WritingOptions.prettyPrinted)
                    let jsonStr = String.init(data: jsonData, encoding: String.Encoding.utf8)
                    socket.sendBrandStr(string: jsonStr!)
                }else{
                    if socket.key == wsDepthKey {//请求五档数据
                        dealBuySellFiveData(dict)
                    }else if socket.key == ws24HourPriceKey {//成交价
                        handleClinchDealData(dict)
                    }
                }
            }
        }catch _ {
            
        }
    }
    
    //处理成交
    func handleClinchDealData(_ dict : [String : Any]){
        let contract24Model = ContractWs24HourModel.mj_object(withKeyValues: dict)
        guard let ct24Model = contract24Model else {
            return
        }
        if ct24Model.channel == ws24HourChannel {
            if let ticket = ct24Model.tick {
//                if !ticket.close.isEmpty {
                    closePriceSubject.onNext(ticket)
//                }
            }
        }
    }
    
    //处理五档数据
    func dealBuySellFiveData(_ dict : [String : Any]){
        let model = ContractWsDepthModel.mj_object(withKeyValues: dict)
        guard let depthModel = model else {
            return
        }
        if let ticket = depthModel.tick {
            if ticket.asks.count > 0 {
                var asksArray : [Double] = []
                for item in ticket.asks {
                    if item.count > 1 {
                        if let t = item[1] as? Double{
                            asksArray.append(t)
                        }
                    }
                }
                if let asksSum = asksArray.max(){
                    var priceAry = [String]()
                    var volumeAry = [String]()
                    if ticket.asks.count >= 10{
                        for i in 0..<10{
                            if ticket.asks[i].count > 1{
                                priceAry.append(self.getFmtedPrice(price: "\( ticket.asks[i][0])"))
                                volumeAry.append("\(ticket.asks[i][1])")
                            }
                        }
                    }else{
                        for i in 0..<ticket.asks.count{
                            if ticket.asks[i].count > 1{
                                priceAry.append(self.getFmtedPrice(price: "\( ticket.asks[i][0])"))
                                volumeAry.append("\(ticket.asks[i][1])")
                            }
                        }
                    }
                    sellsSubject.onNext((priceAry,volumeAry,"\(asksSum)"))
                }
            }else {
                sellsSubject.onNext(([],[],""))
            }
            if ticket.buys.count > 0 {
                var buysArray : [Double] = []
                for item in ticket.buys{
                    if item.count > 1{
                        if let t = item[1] as? Double{
                            buysArray.append(t)
                        }
                    }
                }
                if let buysSum = buysArray.max(){
                    var priceAry = [String]()
                    var volumeAry = [String]()
                    if ticket.buys.count >= 10{
                        for i in 0..<10{
                            if ticket.buys[i].count > 1{
                                priceAry.append(self.getFmtedPrice(price: "\(ticket.buys[i][0])"))
                                
                                volumeAry.append("\(ticket.buys[i][1])")
                            }
                        }
                    }else{
                        for i in 0..<ticket.buys.count{
                            if ticket.buys[i].count > 1{
                                priceAry.append(self.getFmtedPrice(price: "\(ticket.buys[i][0])"))
                                volumeAry.append("\(ticket.buys[i][1])")
                            }
                        }
                    }
                    buysSubject.onNext((priceAry,volumeAry,"\(buysSum)"))
                }
            }else {
                buysSubject.onNext(([],[],""))
            }
        }
    }
    
    func getFmtedPrice(price:String) ->String{
        let nsPrice = price.decimalNumberWithDouble() as NSString
        return nsPrice.decimalString1(priceDecimal)
    }
}
