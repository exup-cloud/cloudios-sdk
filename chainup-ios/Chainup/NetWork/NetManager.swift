//
//  NetManager.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import Alamofire

//网络请求状态
public enum NetRequestResultState : String {
    
    case Success = "Success"//请求正确 例如200
    case NetFailure  = "NetFailure"   //网络失败 例如 连接超时 没有网络
    case ServerFailure = "ServerFailure" // 服务器失败 例如404 500
    case SendRequestFailure = "SendRequestFailure" // 发起请求失败 将要请求失败
}

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}

public class NetManager: NSObject {
    
    var managerArray = NSMutableArray.init()
    
    //MARK:单例
    @objc public static var sharedInstance : NetManager{
        struct Static {
            static let instance : NetManager = NetManager()
        }
        return Static.instance
    }
    
    //MARK:发送请求
    public func sendRequest(_ urlString : String ,httpheaders : HTTPHeaders = [:] , parameters : [String : Any], mothed : HTTPMethod = .post ,encoding : ParameterEncoding = JSONEncoding.default,isShowLoading : Bool = true ,outTime : Int = 10, requestEntity : Any? = nil, success : @escaping ((_ result : Any, _ response : DataResponse<Any>? , _ requestEntity : Any?) -> Void) , fail : @escaping ((_ state : NetRequestResultState, _ error: Error?, _ requestEntity:  Any?) -> Void)){
        
        let config = URLSessionConfiguration.default
        
        let delegate = SessionDelegate.init()
        
        let manager = SessionManager.init(configuration: config, delegate: delegate, serverTrustPolicyManager: nil)
        
        managerArray.add(manager)//防止提前释放
        
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(outTime)
        var httphead = httpheaders
        if httpheaders.keys.count == 0{
            httphead = getHeaderParams()
        }
        
        var tmpEncoding = encoding
        if mothed == .get{
            tmpEncoding = URLEncoding.httpBody
        }
        
        if isShowLoading {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if self.managerArray.contains(manager){
                    XHUDManager.sharedInstance.loading()
                }
            }
        }

        renzheng {
            manager.request(urlString, method: mothed, parameters: parameters, encoding: tmpEncoding, headers: httphead).validate().responseJSON {[weak self] (response) in
                guard let mySelf = self else{return}
                if isShowLoading {
                    XHUDManager.sharedInstance.dismissWithDelay {
                        mySelf.handleResponse(response, requestEntity: requestEntity, isShowLoading: isShowLoading ,success: success, fail: fail)
                    }
                } else {
                    XHUDManager.sharedInstance.dismissWithDelay {
                        mySelf.handleResponse(response, requestEntity: requestEntity, isShowLoading: isShowLoading ,success: success, fail: fail)
                    }
                }
                mySelf.managerArray.remove(manager)//移除返回的请求管理
            }
        }

    }
    //4.5.9_changehost 删除了认证的相关代码
    func renzheng(_ requestUrl : @escaping (()->())){
        requestUrl()
    }
    
    //获取客户端证书相关信息
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "client", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "xxxxxxxxxxx"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                print("\(identityPointer)  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(trustPointer)  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
    
    //MARK:发送请求
    public func sendRequestGet(_ urlString : String ,httpheaders : HTTPHeaders = [:] , parameters : [String : Any], mothed : HTTPMethod = .get ,encoding : ParameterEncoding = JSONEncoding.default,isShowLoading : Bool = true ,outTime : Int = 10, requestEntity : Any? = nil, success : @escaping ((_ result : Any, _ response : DataResponse<Any>? , _ requestEntity : Any?) -> Void) , fail : @escaping ((_ state : NetRequestResultState, _ error: Error?, _ requestEntity:  Any?) -> Void)){
        
        let config = URLSessionConfiguration.default
        
        let delegate = SessionDelegate.init()
        
        let manager = SessionManager.init(configuration: config, delegate: delegate, serverTrustPolicyManager: nil)
        
        managerArray.add(manager)//防止提前释放
        
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(outTime)
        var httphead = httpheaders
        if httpheaders.keys.count == 0{
            httphead = getHeaderParams()
        }
        
        var tmpEncoding = encoding
        if mothed == .get{
            tmpEncoding = URLEncoding.httpBody
        }
        
        if isShowLoading {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if self.managerArray.contains(manager){
                    XHUDManager.sharedInstance.loading()
                }
            }
        }

        renzheng {
            manager.request(urlString, method: mothed, parameters: parameters, encoding: tmpEncoding, headers: httphead).validate().responseJSON {[weak self] (response) in
                guard let mySelf = self else{return}
                if isShowLoading {
                    XHUDManager.sharedInstance.dismissWithDelay {
                        mySelf.handleResponse(response, requestEntity: requestEntity, isShowLoading: isShowLoading ,success: success, fail: fail)
                    }
                }else{
                    XHUDManager.sharedInstance.dismissWithDelay {
                        mySelf.handleResponse(response, requestEntity: requestEntity, isShowLoading: isShowLoading ,success: success, fail: fail)
                    }
                }
                mySelf.managerArray.remove(manager)//移除返回的请求管理

            }
        }

    }
}




