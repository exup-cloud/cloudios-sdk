//
//  EXPing.swift
//  Chainup
//
//  Created by chainup on 2020/6/16.
//  Copyright © 2020 ChainUP. All rights reserved.
//

import UIKit
import Alamofire
import Starscream

let defaultTimeout: TimeInterval = 2.0

struct EXPingEntity {
    
    var host:String? = nil
    var urlString:String? = nil
    var sendDate:Date? = nil
    var receiveDate:Date? = nil
    var wsConnectDate:Date? = nil
    func rtt() -> String {
        
        guard let sendDate = self.sendDate,let receiveDate = self.receiveDate, receiveDate.compare(sendDate) == .orderedDescending else {
            return "--"
        }
        return String(format: "%.0fms",receiveDate.timeIntervalSince(sendDate) * 1000)
    }
    func wsRtt() -> String {
        
        guard let sendDate = self.sendDate,let connectDate = self.wsConnectDate, connectDate.compare(sendDate) == .orderedDescending else {
            return "--"
        }
        return String(format: "%.0fms",connectDate.timeIntervalSince(sendDate) * 1000)
    }
}

protocol EXPingDelegate {
    func ping(_ ping:EXPing, didReceive entity:EXPingEntity)
    func ping(_ ping:EXPing, didFail entity:EXPingEntity)
    
}

class EXPing {
    
    let address:String
    var delegate:EXPingDelegate? = nil
    var pingEntity = EXPingEntity()
    var socket : WebSocket? = nil
    init(host:String,address:String,wsAddress:String) {
        
        self.address = address
        pingEntity.host = host
        pingEntity.urlString = address
        if let url = URL(string: wsAddress) {
            socket = WebSocket(url:url)
            socket?.delegate = self
        }
    }
    func stop() {
        socket?.disconnect()
        socket = nil
    }
    func startPinging() {
        
        pingEntity.sendDate = Date()
        
        let _ = domainSpeedTestApi.rx.request(.health(host: pingEntity.host ?? "")).subscribe(onSuccess: { (_) in
            self.pingEntity.receiveDate = Date()
            self.delegate?.ping(self, didReceive: self.pingEntity)
        }) { (_) in
            
            self.delegate?.ping(self, didFail: self.pingEntity)
        }
        
        socket?.connect()
        
    }
}

extension EXPing:WebSocketDelegate {
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.delegate?.ping(self, didFail: self.pingEntity)
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        self.pingEntity.wsConnectDate = Date()
        self.delegate?.ping(self, didReceive: self.pingEntity)
    }
}
