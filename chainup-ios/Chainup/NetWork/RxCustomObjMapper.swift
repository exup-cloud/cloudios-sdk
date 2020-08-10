//
//  RxCustomObjMapper.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/21.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result
import Moya
import MJExtension

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
     func MJObjectMap<T>(_ type: T.Type,_ handleErr:Bool = true) -> Single<T> {
        return flatMap { response in
            #if DEBUG
            print("=======================================\n")
            print("请求：",response.request?.url ?? "None")
            let body = response.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
            print("参数：",body)
            print("\n=======================================")
            #endif
            if handleErr == true{
                if let code = response.response?.statusCode{
                    switch code{
                    case NSURLErrorTimedOut , 408:
                        EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_networkTimeout"))
                        throw CustomNetworkError.ParseJSONError
                    case 403:
                        EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    case 404:
                        EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    case NSURLErrorCannotConnectToHost , NSURLErrorNetworkConnectionLost , NSURLErrorNotConnectedToInternet:
                        EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                        throw CustomNetworkError.ParseJSONError
                    default:
                        if let code = response.response?.statusCode , code >= 500 ,code < 600{
                            EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                            throw CustomNetworkError.ParseJSONError
                        }
                    }
                }
            }
            
            guard let json = try response.mapJSON() as? [String: Any] else {
                throw CustomNetworkError.ParseJSONError
            }
            #if DEBUG
            print("response：%@",(json as NSDictionary).mj_JSONString())
            print("\n=======================================")
            #endif

            var strCode:String = "0"//默认成功
            if let code = json["code"] as? String {
                strCode = code
            }else if let code = json["code"] as? Int {
                strCode = "\(code)"
            }else {
                throw CustomNetworkError.ParseJSONError
            }
            
            if strCode == "0" {
                
                guard let data = json["data"] else {
                    throw  CustomNetworkError.ParseJSONError
                }
                
                if let result = data as? [[String: Any]] {
                    //这个用CommonAryModel.self 接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["dictAry":result]) as! T
                    return Single.just(obj)
                }
                else if let result = data as? [String: Any] {
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues: result) as! T
                    return Single.just(obj)
                }
                else if let result = data as? String {
                    //这个用CommonStringModel接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["msg":result]) as! T
                    return Single.just(obj)
                }
                    //有些服务端返回0,data为null
                else if let _ = data as? NSNull {
                    //这个用CommonStringModel接.
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["msg":""]) as! T
                    return Single.just(obj)
                }else {
                    //还有返回int/double,全都当他是成功的
                    let obj = (type as! NSObject.Type).mj_object(withKeyValues:["msg":""]) as! T
                    return Single.just(obj)
                }
            }else {
                
                if strCode == "10002" || strCode == "10021" || strCode == "3" {//3是合约
                    XUserDefault.removeKey(key: XUserDefault.token)
                    BusinessTools.logoutNet()
                    BusinessTools.modalLoginVC()
                    throw CustomNetworkError.ExpireTokenError
                }else {
                    let codeInt = Int(strCode)
                    if let code = codeInt,let msg = json["msg"] as? String {
                        let error = NSError(domain: "CustomNetworkError", code: code, userInfo:  [NSLocalizedDescriptionKey: msg])
                        if handleErr {
                            EXAlert.showFail(msg: error.localizedDescription + "(\(strCode))")
                        }
                        throw error
                    }else {
                        throw CustomNetworkError.ParseJSONError
                    }
                }
            }
        }
    }
}

enum CustomNetworkError: String {
    case ParseJSONError = "Network Error"//解析错误
    case ExpireTokenError = "ExpireTokenError"//token
}

extension CustomNetworkError: Swift.Error {
    
}
