//
//  BusinessTools.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/2.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import Alamofire

class BusinessTools: NSObject {

    static var count = 0
    
    //MARK:模态弹出登录页面
    class func modalLoginVC(_ source : String = "" ){

        if count == 1{
            return
        }else if count == 0{
            count = 1
            XHUDManager.sharedInstance.loading()
        }
        
        let loginVC = EXLoginAndRegistVC()
        
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        let nav = NavController()
        let quickToken = XUserDefault.getVauleForKey(key: XUserDefault.quickToken) as! String

        nav.modalPresentationStyle = .fullScreen
        nav.isNavigationBarHidden = true
        if source == "",quickToken != ""{
            let entity = UserInfoEntity.sharedInstance()
            
             if XUserDefault.getFaceIdOrTouchIdPassword() != "" {
                
                FingerPrintVerify.fingerIsSupportCallBack { (type) in
                                 
                    if type == "1" || type == "2"{

                        let login = EXReLoginVC()
                        nav.viewControllers = [login]
                        appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                        
                    }else{
                        nav.viewControllers = [loginVC]
                        appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                    }
                    
                    dismissLoginNet()
                }
            }
            
            //如果设置了手势密码
           else if XUserDefault.getGesturesPassword() != nil || entity.gesturePwd != ""{
            
                
            
                var params : [String : Any] = [:]
                params["uid"] = entity.uid

                if let pwd = XUserDefault.getGesturesPassword(){
                    params["gesturePwd"] = pwd

                }

                if  entity.gesturePwd.ch_length > 1{
                    params["gesturePwd"] = entity.gesturePwd
                    
                }

            let param = NetManager.sharedInstance.handleParamter(params)
                
            let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.gesturePwd_is_same, action: "")
                    NetManager.sharedInstance.sendRequest(url,parameters : param, success: { (result, response, entity) in
                        if let result = result as? [String : Any]{
                       
                            guard let data = result["data"] as? [String:Any] else {return}
                        
                            if let isPass = data["isPass"] as? Int{
                                if Int(isPass) == 1{
                                    let vc = GestureValidationVC()
                                    vc.type = GestureValidationType.login
                                    nav.viewControllers = [vc]
                                    appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                                }else{
                                    nav.viewControllers = [loginVC]
                                    appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                                }
                            }
                            
                        }
                        dismissLoginNet()

                    }, fail: { (state, error, any) in
                        nav.viewControllers = [loginVC]
                        appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                        dismissLoginNet()
                    })
                
               
            }
            
            else{
                nav.viewControllers = [loginVC]
                appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                dismissLoginNet()
            }
        }
        else{
            nav.viewControllers = [loginVC]
            appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
            dismissLoginNet()
        }
        
    }
    
    class func dismissLoginNet(){
        count = 0
        XHUDManager.sharedInstance.dismissWithDelay {
        }
    }
    
    //被踢
    class func logoutNet(){
        guard let nav = BusinessTools.getRootNavBar()else{
            return
        }
        if let tabbar = BusinessTools.getRootTabbar(){
            if XUserDefault.getToken() == nil{
                let vc = tabbar.getCurrentTabbarVC()
                if vc is EXAssetBaseVc{
                    tabbar.selectIndex(0 , showLogin:false)
                }
                if vc is ContractVC{
                    (vc as! ContractVC).reloadView()
                }
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK:模态弹出注册页面
    class func modalRegistVC(){
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        let login = EXLoginAndRegistVC()
        login.changeView(EXLoginType.regist)
        let nav = NavController()
        nav.viewControllers = [login]
        nav.isNavigationBarHidden = true
        appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    //MARK:获取rootTabbar
    class func getRootTabbar() -> TabbarController?{
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        if let tabbarController = appDelegate.window??.rootViewController?.childViewControllers[0] as? TabbarController{
            return tabbarController
        }
        return nil
    }
    
    //MARK:获取rootNavBar
    class func getRootNavBar() -> NavController?{
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        if let navController = appDelegate.window??.rootViewController as? NavController{
            return navController
        }
        return nil
    }
    
    //获取publicInfo接口
    func getPublicInfo(){
        let timer = Timer.init(timeInterval: 60, repeats: true) { (timer1) in
            if DateTools.getPublicInfo() == true{
                PublicInfo.sharedInstance.getData()
            }
        }
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    //MARK:检测版本 type 0 不提示当前为最新版本 1 提示当前为最新版本
    class func checkVersion(_ type : String = "0"){
        
        let time = DateTools.getNowTimeInterval()
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.getVersion, action: "") + "?time=\(time)"
        NetManager.sharedInstance.sendRequest(url, parameters: [:],mothed:HTTPMethod.get, isShowLoading : false,success: { (result, response, nil) in
            
            if let dict = result as? [String:Any]{
                if let data = dict["data"] as? [String:Any]{
                    
                    //                    print(data)
                    let force = data["force"] as? Int//强制升级标识
                    
                    let zan = UserDefaults.standard.object(forKey: "zanbugengxin") as? String//暂不升级标识
                    
                    let info = Bundle.main.infoDictionary
                    let build  = data["build"] as? Int//后台配置id
                    
                    var app:Int = 0//appid
                    if info?.keys.contains("exChainupBundleVersion") == true{
                        if let app_version = info!["exChainupBundleVersion"] as? String {
                            if let a = Int(app_version){
                                app =  a
                            }
                        }
                    }

                    //提示框
                    let alert = EXNormalAlert()
                    
                    //当前不是最新版本
                    if let b = build , b - app > 0{
                        var title = ""
                        var content = ""
                        if let title1 = data["title"] as? String{
                            title = title1
                        }
                        if let content1 = data["content"] as? String{
                            content = content1
                        }
                        if force == 1{//强制更新
                            
                            alert.configSigleAlert(title: title, message: content, sigleBtnTitle: LanguageTools.getString(key: "common_action_upgrade"))
                            alert.alertCallback = {tag in
                                if let u = data["downloadUrl"] as? String{
                                    if let url = URL.init(string: u){
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }
                            }
                        }else{//非强制更新
                            if zan == "1" && type == "0"{//已经点过了
                                return
                            }else{//还没有点过
                                alert.configAlert(title: title, message: content, passiveBtnTitle: LanguageTools.getString(key: "common_action_cancelUpgrade"), positiveBtnTitle: LanguageTools.getString(key: "common_action_upgrade"))
                                alert.alertCallback = {tag in
                                    if tag == 1{//
                                        UserDefaults.standard.set("1", forKey: "zanbugengxin")
                                        UserDefaults.standard.synchronize()
                                    }else if tag == 0{
                                        if let u = data["downloadUrl"] as? String{
                                            if let url = URL.init(string: u){
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else{//当前是最新版本
                        if type == "1"{//提示用户当前为最新版本
                            alert.configSigleAlert(title: LanguageTools.getString(key: "common_tip_isNewVersion"), message: "", sigleBtnTitle: LanguageTools.getString(key: "common_text_btnConfirm"))
                        }else if type == "0"{
                            return
                        }
                    }
                    
                    //展示
                    EXAlert.showAlert(alertView: alert)
                    
                }
            }
        }, fail: { (state , error,nil) in
            
        })
        
        
    }
    
    // 判断长度大于8位后再接着判断是否同时包含数字和字符
    class func numberAndCharacter(_ str : String) -> Bool{
        var tmpresult = false

        var regex: NSRegularExpression = NSRegularExpression.init()

        let linkPattern: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z~!@#$%^&*()]{8,20}$"
        
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            ProgressHUDManager.showFailWithStatus("正则表达式有问题")
        }
        
        //遍历目标字符串
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) { (result, flags, stop) in
            if result == nil {
                return
            } else {
                tmpresult = true
                return
            }
        }
        return tmpresult
    }
    
    // 判断是否为纯数字
    class func number(_ str : String) -> Bool{
        var tmpresult = false
        
        var regex: NSRegularExpression = NSRegularExpression.init()
        
        let linkPattern: String = "^\\d{0,}$"
        
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            ProgressHUDManager.showFailWithStatus("正则表达式有问题")
        }
        
        //遍历目标字符串
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) { (result, flags, stop) in
            if result == nil {
                return
            } else {
                tmpresult = true
                return
            }
        }
        return tmpresult
    }
    
    // 判断是否为邮箱
    class func isEmail(_ str : String) -> Bool{
        var tmpresult = false
        if str.count < 5 || str.count > 100{
            return tmpresult
        }
        
        var regex: NSRegularExpression = NSRegularExpression.init()
        
        let linkPattern: String = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            ProgressHUDManager.showFailWithStatus("正则表达式有问题")
        }
        
        //遍历目标字符串
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) { (result, flags, stop) in
            if result == nil {
                return
            } else {
                tmpresult = true
                return
            }
        }
        return tmpresult
    }
    
    class func presentNav(_ vc : UIViewController){
        let nav = NavController()
        nav.isNavigationBarHidden = true
        nav.viewControllers = [vc]
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    //重启app
    class func reloadWindow(){
        let window = UIApplication.shared.keyWindow
        let nav = AppDelegate().initNavBarV()
        window?.makeKeyAndVisible()
        window?.rootViewController = nav
    }
    
    class func unLoginPopBack(){
        
    }
}
