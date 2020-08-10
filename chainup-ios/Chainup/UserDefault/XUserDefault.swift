//
//  UserDefault.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/16.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class XUserDefault: NSObject {

    //设置并同步
    class func setValueForKey(_ value : Any? , key : String){
        if value == nil || value is NSNull{//容错
            return
        }
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //获取，如没有返回空字符串
    class func getVauleForKey(key : String) -> Any{
        return UserDefaults.standard.object(forKey: key) ?? ""
    }
    
    //移除
    class func removeKey(key : String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}

//define
extension XUserDefault{
    
    static let token = "token"//登录token
    static let quickToken = "quickToken" //快捷登录
    static let XUUID = "XUUID"//设备id
    
    static let gesturesPassword = "gesturesPassword"//手势密码
    static let faceIdOrTouchIdPassword = "faceIdOrTouchIdPassword"//手势密码

    static let countryCode = "countryCode"//国家编号
    
    static let onGesturesPassword = "onGesturesPassword"//是否开启手势密码
    
    static let onGooglePassword = "onGooglePassword"//是否开启谷歌登录
    
    static let collectionCoinMap = "collectionCoinMap"//收藏的币对
    
    static let collectionCoinMaySymbols = "collectionCoinMaySymbols" //收藏币对symbol
    
    static let mobileNumber = "mobileNumber"//手机号码
    
    
    
    static let userInfo = "userInfo"//个人信息
    
    static let publicInfo = "publicInfo"//初始化信息接口
    
    static let loginTime = "loginTime"//登录时间

    static let isNextRemind = "isNextRemind"//下次提醒
    
    static let searchArray = "searchArray"//最近查看的币对数组
    
    static let assets = "assets"//是否开启资产
    static let hideZeroAssets = "hideZeroAssets"//是否开启资产隐藏0资产
    
    static let updateVersion = "updateVersion"//存储接口版本

    static let etfInformation = "etfInformation"//eft免责说明
    
    static let swapComfirmAlert = "swapComfirmAlert"//合约二次确认框
    
    static let homeCustomConfig = "homeCustomConfig"//首页自定义配置
}

extension XUserDefault{
    
    //下次提醒
    class func getIsNextRemind()-> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.isNextRemind) as? String, str != ""{
            return str
        }
        return ""
    }
    
    class func setNextRemind(){

        XUserDefault.setValueForKey("isNextRemind", key: XUserDefault.isNextRemind)

    }


    //获取token
    class func getToken()-> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.token) as? String, str != ""{
            return str
        }
        return nil
    }
    
    class func isOffLine()-> Bool {
        return self.getToken() == nil
    }
    
    //获取手势密码
    class func getGesturesPassword() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.gesturesPassword) as? String ,str != "" ||
                UserInfoEntity.sharedInstance().gesturePwd.ch_length > 0{
            
            if str.ch_length > 0{
                
                return str
            }
           
            return  UserInfoEntity.sharedInstance().gesturePwd
        }
        return nil
    }
    //设置手势密码
    class func setGesturesPassword(_ gpw : String){
        XUserDefault.setValueForKey(gpw, key: XUserDefault.gesturesPassword)
    }
    
    
    //获取faceIdOrTouchId密码
    class func getFaceIdOrTouchIdPassword() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.faceIdOrTouchIdPassword) as? String , str != ""{
            
            return str

        }
        return ""
    }
    //设置faceIdOrTouchId密码
    class func setFaceIdOrTouchId(_ gpw : String){
        XUserDefault.setValueForKey(gpw, key: XUserDefault.faceIdOrTouchIdPassword)
    }
   
    //获取是否开启谷歌验证
    class func getOnGooglePassword() -> String?{
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.onGooglePassword) as? String, str != ""{
            return str
        }
        return nil
    }
    
    
    //获取收藏的币对
    class func getCollectionCoinMap() -> [String] {
        if let array = XUserDefault.getVauleForKey(key: XUserDefault.collectionCoinMap) as? [String]{
            return array
        }
        return []
    }
    
    //收藏币对
    class func collectionCoinMap(_ name : String){
        var array = getCollectionCoinMap()
        if array.contains(name) == false{
            array.append(name)
            EXAlert.showSuccess(msg: "kline_tip_addCollectionSuccess".localized())
            XUserDefault.setValueForKey(array, key: XUserDefault.collectionCoinMap)
        }
    }
    
    //取消收藏
    class func cancelCollectionCoinMap(_ name : String){
        var array = getCollectionCoinMap()
        if array.contains(name){
            if let index = array.index(of: name) , array.count > index{
                array.remove(at: index)
                EXAlert.showSuccess(msg: "kline_tip_removeCollectionSuccess".localized())
            }
        }
        XUserDefault.setValueForKey(array, key: XUserDefault.collectionCoinMap)
    }
    
    //判断是否收藏
    class func whetherCollectionCoinMap(_ name : String) -> Bool{
        let array = getCollectionCoinMap()
        if array.contains(name){
            return true
        }
        return false
    }
    
    //设置登录时间
    class func setLoginTime(){
        let date = Date.init()
        let time = Int(date.timeIntervalSince1970)
        XUserDefault.setValueForKey(time, key: XUserDefault.loginTime)
    }
    
    //判断是否超过7天 true超过 false未超过
    class func getLoginTime() -> Bool{
//        if let time = XUserDefault.getVauleForKey(key: XUserDefault.loginTime) as? Int{
//            let date = Date.init()
//            let nowTime = Int(date.timeIntervalSince1970)
//            if nowTime - time >= 604800{//如果大于7天返回true 604800
//                return true
//            }else{//如果不大于返回false
//                return false
//            }
//        }
//        return true
        return false
    }
    
    //设置最近查看
    class func setSearchArray(_ name : String){
        var array = getSearchArray()
        if array.contains(name){
            if let index = array.index(of: name) , array.count > index{
                array.remove(at: index)
            }
        }
        array.insert(name, at: 0)
        if array.count > 5{
            array = Array(array[0..<5])
        }
        XUserDefault.setValueForKey(array, key: XUserDefault.searchArray)
    }
    
    //获取最近查看
    class func getSearchArray() -> [String]{
        if let array = XUserDefault.getVauleForKey(key: XUserDefault.searchArray) as? [String]{
            return array
        }
        return []
    }
    
    //清除最近查看
    class func removeSearchArray(){
        XUserDefault.setValueForKey([], key: XUserDefault.searchArray)
    }
    
    //开启关闭资产
    class func switchAssets(_ bool : Bool){
        if bool == true{//开启
            XUserDefault.setValueForKey("1", key: XUserDefault.assets)
        }else{//关闭
            XUserDefault.setValueForKey("0", key: XUserDefault.assets)
        }
    }
    
    //查询资产状态
    class func assetPrivacyIsOn () -> Bool{
        if let a = XUserDefault.getVauleForKey(key: XUserDefault.assets) as? String , a == "1"{
            return true
        }else{
            return false
        }
    }
    
    //开启关闭资产
    class func switchZeroAssets(_ bool : Bool){
        if bool == true{//开启
            XUserDefault.setValueForKey("1", key: XUserDefault.hideZeroAssets)
        }else{//关闭
            XUserDefault.setValueForKey("0", key: XUserDefault.hideZeroAssets)
        }
    }
    
    //查询资产状态
    class func zeroAssetsSetting () -> Bool{
        if let a = XUserDefault.getVauleForKey(key: XUserDefault.hideZeroAssets) as? String , a == "1"{
            return true
        }else{
            return false
        }
    }
    
    //设置接口版本
    class func setUpdateVersion(_ version : String) -> Bool{
        if let v = XUserDefault.getVauleForKey(key: XUserDefault.updateVersion) as? String{
            if v == version{
                return false
            }else{
                XUserDefault.setValueForKey(version, key: XUserDefault.updateVersion)
                return true
            }
        }
        return true
    }
    
    class func getHomeCustomConfig() -> String{
        guard let jsonConfig =  XUserDefault.getVauleForKey(key: XUserDefault.homeCustomConfig) as? String else {return ""}
        return jsonConfig
    }
    
    //设置etf免责
    class func setEtfInformation(){
        XUserDefault.setValueForKey("1", key: XUserDefault.etfInformation)
    }
    
    //获取etf免责
    class func getEtfInformation() -> Bool{
        if let a = XUserDefault.getVauleForKey(key: XUserDefault.etfInformation) as? String , a == "1"{
            return true
        }else{
            return false
        }
    }
    
    //设置是否合约二次确认框
    class func setComfirmSwapAlert(_ status : Bool){
        if status == true {
            XUserDefault.setValueForKey("1", key: XUserDefault.swapComfirmAlert)
        } else {
            XUserDefault.setValueForKey("0", key: XUserDefault.swapComfirmAlert)
        }
    }
    
    //获取是否合约二次确认框
    class func getOnComfirmSwapAlert() -> Bool {
        if let str = XUserDefault.getVauleForKey(key: XUserDefault.swapComfirmAlert) as? String {
            if str == "" {
                setComfirmSwapAlert(true)
                return true
            } else if str == "1" {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
