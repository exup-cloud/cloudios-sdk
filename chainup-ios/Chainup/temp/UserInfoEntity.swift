//
//  UserInfoEntity.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/10.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

/**
 * 认证类型
 *  认证状态 0、审核中，1、通过，2、未通过  3未认证
 */
enum UserAuthLevel:String {
    case pending = "0"
    case pass = "1"
    case reject = "2"
    case newbie = "3"
}

class UserInfoEntity: SuperEntity {
    
    static var entity : UserInfoEntity?
    
    public class func sharedInstance() -> UserInfoEntity{
        if entity == nil{
            let e = UserInfoEntity()
            
            entity = e
        }
        return entity!
    }
//
//    //MARK:单例
//    public static var sharedInstance : UserInfoEntity{
//        struct Static {
//            static let instance : UserInfoEntity = UserInfoEntity()
//        }
//        return Static.instance
//    }
    static var userSymbolsVm = UserSymbolsVM()
    
    var feeCoinRate = ""
    
    var uid = ""
    
    var myMarket = ""
    
    var mobileNumber = ""
    
    var isOpenMobileCheck = "0"//开没开起手机验证 0 未开
    
    var accountStatus = ""
    
    var inviteCode = ""//邀请码
    
    var authLevel = ""// 认证状态 0、审核中，1、通过，2、未通过  3、未认证
    
    var countryCode = ""//国家码
    
    var inviteUrl = ""//推荐邀请
    
    var useFeeCoinOpen = ""
    
    var nickName = ""
    
    var googleStatus = "0"//开没开起google验证 0 未开
    
    var notPassReason = ""
    var isCapitalPwordSet = "0"//是否设置资金密码
    var lastLoginTime = ""
    
    var feeCoin = ""
    
    var lastLoginIp = ""
    
    var userAccount = ""
    
    var email = ""//如果有就是邮箱登录
    
    var token = ""
    
    var gesturePwd : String = ""
    
    var tmpDict : [String : Any] = [:]
    
    var creditGrade = "0"//信用度
    
    var realName = ""//信用度
    
    var otcCompanyInfo : [String : Any] = [:]
    var otcCompanyInfoModel = OtcCompanyInfoEntity()
    var userCompanyInfo : [String : Any] = [:]
    var userCompanyInfoModel = UserCompanyInfoEntity()
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.otcCompanyInfoModel = OtcCompanyInfoEntity.mj_object(withKeyValues: otcCompanyInfo)
        self.userCompanyInfoModel = UserCompanyInfoEntity.mj_object(withKeyValues: userCompanyInfo)
    }
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["uid":"id"]
    }

    func dealEntity(){
        UserInfoEntity.setTmpDict()
        
        XUserDefault.setGesturesPassword(gesturePwd)
        
        if lastLoginTime == ""{
            lastLoginTime = LanguageTools.getString(key: "temp_none")
        }else{
            lastLoginTime = DateTools.strToTimeString(lastLoginTime)
        }
        
        if lastLoginIp == ""{
            lastLoginIp = LanguageTools.getString(key: "temp_none")
        }
        
        token = String(describing:XUserDefault.getVauleForKey(key: XUserDefault.token))
        
        creditGrade = NSString.init(string: "1").subtracting(creditGrade, decimals: 2)
        creditGrade = NSString.init(string: creditGrade).multiplying(by: "100", decimals: 0)
    }
    
    class func setTmpDict(){
        if let data = UserInfoEntity.sharedInstance().mj_JSONData(){
            XUserDefault.setValueForKey(data, key: XUserDefault.userInfo)
        }
    }
    
    func reloadTmpDict(_ key : String , value : String){
        if let value = dict[key]{
            UserInfoEntity.sharedInstance().tmpDict[key] = value
            UserInfoEntity.setTmpDict()
        }
    }
    
    class func getTmpDict(){
        if let data = XUserDefault.getVauleForKey(key: XUserDefault.userInfo) as? Data{
            if let en = UserInfoEntity.mj_object(withKeyValues: data){
                UserInfoEntity.entity = en
                UserInfoEntity.sharedInstance().token = ""
            }
        }
    }
    
    func otcBasicCheckPass()->Bool {
        //强制Google认证
        if PublicInfoManager.sharedInstance.isRequireGoogle() {
            if self.nickName.count > 0,
                self.authLevel == UserAuthLevel.pass.rawValue {
                if self.googleStatus == "1"{
                    return true
                }else {
                    return false
                }
            }else {
                return  false
            }
        }else {
            if self.nickName.count > 0,
                self.authLevel == UserAuthLevel.pass.rawValue {
                if self.googleStatus == "1" ||
                    self.isOpenMobileCheck == "1" {
                    return true
                }else {
                    return false
                }
            }else {
                return  false
            }
        }
    }
    
    func hasNickName() ->Bool {
        return self.nickName.count > 0
    }
    
    func didBindPhone() ->Bool {
        return self.isOpenMobileCheck == "1"
    }
    
    func didBindGoolge() ->Bool {
        return self.googleStatus == "1"
    }
    
    func didBindMail() ->Bool {
        return self.email.count > 0
    }
    
    func didpassRealName() -> Bool {
        return self.authLevel ==  UserAuthLevel.pass.rawValue
    }
    
    func didSetPayPwd()->Bool {
        return self.isCapitalPwordSet == "1"
    }
    
    func otcSafetyCheckPass()->Bool {
        if self.isCapitalPwordSet == "1" {
            return true
        }else {
            return false
        }
    }
    
    //清空
    public class func removeAllData(){
        UserInfoEntity.entity = nil
    }
    
    
    func canEditOtcRealName() -> Bool {
        if XUserDefault.isOffLine() {
            return false
        }
        
        if self.userCompanyInfoModel.status == "1" || self.userCompanyInfoModel.status == "3" {
            return true
        }
        return false
    }
}

extension UserInfoEntity{
    
    
    func loginSuccess(_ token : String , quickToken : String = "", account : String = "", loginPwd : String = ""){
        XUserDefault.setLoginTime()//登录成功，存储登录时间
        
         //登录成功获取远端的列表
        
        if let temp = XUserDefault.getVauleForKey(key: XUserDefault.mobileNumber) as? String{//如果不是相同账号，则把指纹和面部识别删除
            if account != temp{
                XUserDefault.setFaceIdOrTouchId("")
            }
        }
        if account != ""{
            XUserDefault.setValueForKey(account , key: XUserDefault.mobileNumber)//登录成功，保存登录账号
        }
        
        if quickToken != "" {
            XUserDefault.setValueForKey(quickToken, key: XUserDefault.quickToken) //登录成功，保存快捷登录token
        }
        XUserDefault.setValueForKey(token, key: XUserDefault.token)//二次登录成功后才会存储token
        UserInfoEntity.removeAllData()//清理之前的个人信息
        UserInfoEntity.userSymbolsVm.syncUserSysmbols()//登录成功同步收藏
        NotificationCenter.default.post(name: Notification.Name(rawValue: "EXLoginSuccess"), object: nil)
    }
    
    func getUserInfo(_ complete : @escaping (()->())){
        _ = appApi.rx.request(.userInfo()).MJObjectMap(UserInfoEntity.self).subscribe(onSuccess: { (entity) in
            UserInfoEntity.entity = entity
            UserInfoEntity.sharedInstance().dealEntity()
            complete()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "EXGetUserInfoSuccess"), object: nil)
        }) { (error) in
            NSLog("\(error)")
        }
    }
    
}

class OtcCompanyInfoEntity : EXBaseModel{
    var status = ""//场外商户状态，0：未开启，1：开启普通商户，2：开启超级商户
    var applyStatus = ""//用户场外商户申请状态，0：未申请，1：申请中，2：拒绝，3：通过
    var applyComment = ""//用户场外商户申请失败原因
    var otcCompanyMarginNum = ""//账户金额
}

class UserCompanyInfoEntity : EXBaseModel{
    var marginCoinSymbol = ""//保证金币种
    var docAddr = ""//文档地址
    var normalCompanyMarginNum = ""//普通商户保证金数量
    var superCompanyMarginNum = ""//超级商户保证金数量
    var status = ""//用户场外商户状态， 0：未认证，1：普通商户，2：普通商户释放，3：超级商户，4：超级商户释放
    var normalTradeLimit = ""//普通交易最大值，默认100000\
    var otcCompanyApplyEmail = ""//申请商户邮箱地址
}
