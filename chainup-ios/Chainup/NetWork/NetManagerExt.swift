//
//  NetManagerExt.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import Alamofire

extension NetManager{
    
    //MARK:地址拼接
    public func url(_ host : String,model : String , action : String) -> String{
        return host + model + action
    }
    
    //MARK:处理入参，返回字典
    public func handleParamter(_ param : [String : Any] = [:])-> [String : Any]{
        var temParam = param
        temParam["time"] = DateTools.getNowTimeInterval()
        temParam["sign"] = dealSign(temParam)
        return temParam
    }
    
    //MARK:处理签名
    func dealSign(_ param : [String : Any]) -> String{
        var sign = ""
        let keys = param.keys.sorted()
        for key in keys{
            sign = sign + key + String(describing: param[key]!)
        }
        sign = sign + "jiaoyisuo@2017"
        sign = AppService.md5(sign)
        return sign
    }
    
    //MAR:处理入参，返回data
    public func handleParameterForData(_ param : [String : Any] = [:]) -> Data{
        var data = Data()
        do{
            data = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())
        }catch _ {
            
        }
        return data
    }
    
    //MARK:获取header的参数
    @objc public func getHeaderParams() -> HTTPHeaders{
        var headParam : [String : String] = [:]
        let deviceId = BasicParameter.getUUID()//uid
        let deviceVersion = BasicParameter.getDeviceVersion()//设备version
        let deviceModel_CU = BasicParameter.getPhoneModel()//设备型号
        let devicePhoneOS = BasicParameter.getPhoneOS()//版本型号
        let deviceLanguage = BasicParameter.getPhoneLanguage()//语言
        let deviceNetwork = BasicParameter.getNetStatus()//网络状态
        let app_Version = BasicParameter.getAppVersion()//app version
        if let token = XUserDefault.getVauleForKey(key: XUserDefault.token) as? String{//用户token
            headParam["exchange-token"] = token
            headParam["ex_token"] = token
        }else{
            headParam["exchange-token"] = ""
            headParam["ex_token"] = ""
        }
        
        let info = Bundle.main.infoDictionary
        if info?.keys.contains("exChainupBundleVersion") == true{
            if let app_version = info!["exChainupBundleVersion"] as? String {
                headParam["exChainupBundleVersion"] = app_version
            }
        }

        headParam["Build-CU"] = app_Version
        headParam["Mobile-Model-C"] = deviceModel_CU
        headParam["SysVersion-CU"] = deviceVersion
        headParam["SysSDK-CU"] = deviceVersion
        headParam["Channel-CU"] = BasicParameter.getChannel()
        headParam["Mobile-Model-C"] = deviceModel_CU
        headParam["Platform-CU"] = devicePhoneOS
        headParam["UUID-CU"] = deviceId
        headParam["Network-CU"] = deviceNetwork
        headParam["exchange-client"] = "app"
        headParam["exchange-language"] = deviceLanguage
        headParam["lan"] = deviceLanguage
        //新加
        headParam["appAcceptLanguage"] = deviceLanguage
        headParam["appChannel"] = BasicParameter.getChannel()
        headParam["appNetwork"] = deviceNetwork
        headParam["timezone"] = TimeZone.current.identifier
        headParam["osName"] = devicePhoneOS
        headParam["os"] = devicePhoneOS
        headParam["osVersion"] = deviceVersion
        headParam["platform"] = devicePhoneOS
        headParam["device"] = deviceId
        headParam["clientType"] = "ios"
        headParam["language"] = BasicParameter.phoneLanguage
        headParam["DEVICE-ID"] = deviceId
        return headParam
    }
    
    //MARK:处理返回参数
    public func handleResponse(_ response : DataResponse<Any> , requestEntity : Any? = nil ,isShowLoading : Bool ,success : @escaping ((_ result : Any, _ response : DataResponse<Any>? , _ requestEntity : Any?) -> Void) , fail : @escaping ((_ state : NetRequestResultState, _ error: Error?, _ requestEntity:  Any?) -> Void)){
        response.result.ifSuccess {
            if let result = response.result.value as? [String : Any] , let code = result["code"]{
                switch "\(code)"{
                case "0":
                    success(response.result.value ?? [:],response,requestEntity)
                case "10002" , "10021" , "3"://3是合约
                    fail(NetRequestResultState.NetFailure , NSError(), requestEntity)
                    XUserDefault.removeKey(key: XUserDefault.token)
//                    UserInfoEntity.removeAllData()
                    BusinessTools.logoutNet()
                    BusinessTools.modalLoginVC()
//                    if let msg = result["msg"] as? String{
//                        ProgressHUDManager.showFailWithStatus(msg)
//                    }
                case "10089"://注册token超时
                    if let msg = result["msg"] as? String{
                            ProgressHUDManager.showFailWithStatus(msg)
                    }
                    fail(NetRequestResultState.NetFailure , NSError.init(domain: "1", code: 10089, userInfo: nil), requestEntity)
                case "104008"://快捷登录超时
                    if let msg = result["msg"] as? String{
                        ProgressHUDManager.showFailWithStatus(msg)
                    }
                    fail(NetRequestResultState.NetFailure , NSError.init(domain: "1", code: 104008, userInfo: nil), requestEntity)
                default:
                    if let msg = result["msg"] as? String{
                        ProgressHUDManager.showFailWithStatus(msg + "(\(code))")
                    }
                    var code1 = 10001
                    if let c = Int("\(code)"){
                        code1 = c
                    }
                    fail(NetRequestResultState.NetFailure , NSError.init(domain: "1", code: code1, userInfo: nil), requestEntity)
//                    success(response.result.value ?? [:],response,requestEntity)
                    break
                }
            }
//            #if DEBUG
            
//            success(response.result.value,response,requestEntity)
//            #endif
        }
        response.result.ifFailure {
            var error = NSError()
            if let e = response.result.error {
                error = e as NSError
            }
            
            fail(NetRequestResultState.NetFailure , error as Error, requestEntity)
            
            if isShowLoading == false{//如果不要求展示，则不展示
                return
            }
            
            if error.code == -1009{
                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_networkDisconnect"))
            }else{
                if let code = response.response?.statusCode{
                    switch code{
                    case NSURLErrorTimedOut , 408:
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "long_time"))
                    case 403:
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                    case 404:
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                    case NSURLErrorCannotConnectToHost , NSURLErrorNetworkConnectionLost , NSURLErrorNotConnectedToInternet:
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                    default:
                        if let code = response.response?.statusCode , code >= 500 ,code < 600{
                            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_networkDisconnect") + "\n\(code)")
                            break
                        }
                        
                    }
//                    return
                }
//                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "no_net"))
            }
            
        }
    }
    
}
