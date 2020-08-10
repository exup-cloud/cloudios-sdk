//
//  XWebSocketManager.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/30.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import Starscream

@objc public protocol DSWebSocketDelegate: NSObjectProtocol{
    /**websocket 连接成功*/
    @objc optional func websocketDidConnect(socket: XWebSocketManager)
    /**websocket 连接失败*/
    @objc  optional  func websocketDidDisconnect(socket: XWebSocketManager, error: Error?)
    /**websocket 接受文字信息*/
    @objc  optional func websocketDidReceiveMessage(socket: XWebSocketManager, text: String)
    /**websocket 接受二进制信息*/
    @objc optional  func  websocketDidReceiveData(socket: XWebSocketManager, data: Data)
}

public class XWebSocketManager: NSObject ,WebSocketDelegate {
    
    var reConnectTime = 0//重连时间
    
    var heartBeat : Timer?//
    
    var index : Int?
    
    var socket:WebSocket?
    
    var url = ""
    
    var key = ""

    weak var webSocketDelegate: DSWebSocketDelegate?
    
    public static var sharedInstance : XWebSocketManager{
        struct Static {
            static let instance : XWebSocketManager = XWebSocketManager()
        }
        return Static.instance
    }
    
    public func websocketDidConnect(socket: WebSocketClient) {
//        NSLog("链接成功")
        webSocketDelegate?.websocketDidConnect?(socket: self)
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        NSLog("链接失败\n%@",url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.webSocketDelegate?.websocketDidDisconnect?(socket: self, error: error)
            //失败重连
            self.disconnect()
            self.connectSever(self.url)
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        NSLog("接收到消息")
        webSocketDelegate?.websocketDidReceiveMessage?(socket: self, text: text)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        NSLog("data数据")
        webSocketDelegate?.websocketDidReceiveData?(socket: self, data: data)
    }
    
    //MARK:- 链接服务器
    public func connectSever(_ urlStr : String){
        if socket == nil{
            if let url = URL.init(string:urlStr){
                self.url = urlStr
                socket = WebSocket(url: url)
                socket?.delegate = self
                socket?.connect()
            }
        }
    }
    
    //MARK:- 关闭消息
    public func disconnect(){
        if socket != nil{
            socket?.disconnect()
            socket = nil
        }
    }
    
    //发送文字消息
    public func sendBrandStr(string:String){
        socket?.write(string: string)
    }
    
    public func sendBrandStr(string:String , func1 : @escaping (() -> ())){
        socket?.write(string: string, completion: {
            func1()
        })
    }
    
    //初始化心跳
    public func initHeartBeat(){
        DispatchQueue.main.async {
            self.destoryHeartBeat()
            //心跳设置为3分钟，NAT超时一般为5分
            self.heartBeat = Timer.scheduledTimer(withTimeInterval: TimeInterval.init(60), repeats: true, block: {[weak self] (timer) in
                guard let mySelf = self else{return}
                //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
                mySelf.sendBrandStr(string: "{message:HeartBeat}")
            })
            RunLoop.current.add(self.heartBeat!, forMode: RunLoopMode.commonModes)
        }
    }
    
    //销毁心跳
    public func destoryHeartBeat(){
        DispatchQueue.main.async {
            if self.heartBeat != nil{
                self.heartBeat?.invalidate()
                self.heartBeat = nil
            }
        }
    }
    
    //重连机制
    public func reConnect(){
        self.disconnect()
        //超过一分钟就不在重连了 所以重连五次
        if reConnectTime > 64{
            return
        }
        //重连时间2的指数级增长
        if (reConnectTime == 0) {
            reConnectTime = 2;
        }else{
            reConnectTime = reConnectTime * 2;
        }
    }
    
    //pingpong
    public func ping(){
        self.socket?.write(ping: Data())
    }
    
    
}
