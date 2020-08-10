//
//  AppDelegate.swift
//  AppProject
//
//  Created by zewu wang on 2018/7/31.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManager
import FirebaseCore
import FirebaseAnalytics
import RxSwift
import RxCocoa


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController : UINavigationController?
    var loadSwapSDK = false
    let reachability = Reachability.forInternetConnection()
    var reStart = false
    var reloadSwapSDKTime = 0.0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        EXNetworkDoctor.sharedManager.configNetWork()
        ProgressHUDManager.setMinimumDismissTimeInterval(2)//设置提示框最少展示时间
        
        let IQ = IQKeyboardManager.shared()
        IQ.isEnabled = true       //控制整个功能是否启用
        IQ.shouldResignOnTouchOutside = true      //控制点击背景是否收起键盘
        IQ.shouldToolbarUsesTextFieldTintColor = false       //控制键盘上的工具条文字颜色是否用户自定义
        IQ.isEnableAutoToolbar = true      //控制是否显示键盘上的工具条
        
        self.loadTheme()
      
        UIApplication.shared.statusBarStyle = .lightContent//状态栏设置成白色
        UITextField.appearance().tintColor = UIColor.ThemeView.highlight
        //初始化语言
        LanguageTools.shareInstance.initUserLanguage()

        //初始化个人信息
        UserInfoEntity.getTmpDict()
        
        //初始化大数据
        PublicInfoEntity.sharedInstance.getTmpDict()
        
        // 初始化 合约 sdk
        initSwapSDK()
        
        //创建视图070306
        self.window = initWindow()
    
        // 实时获取汇率
        AppDelegateData().getRate()
        
        //获取公告数据
        PublicInfo.sharedInstance.getData()


        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"),
            object: reachability
        )
        reachability?.startNotifier()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if isContractOpen() {
            SLContractSocketManager.shared().srWebSocketClose()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        BusinessTools.checkVersion()
        // 重新打开app重新建立合约websocket连接
        if isContractOpen() {
            
            if reStart == true {
                SLContractSocketManager.shared().srWebSocketOpen(withURLString: EXNetworkDoctor.sharedManager.getContractWs())
            }
            reStart = true
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // 每次终止app进程需要清理一次token
//        XUserDefault.removeKey(key: XUserDefault.token)
        EXThemeManager.saveLastTheme()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print(url.scheme ?? "333333")
        dealGameJump(urlStr: url.absoluteString)
        return true
    }

    
}



extension AppDelegate {
    
    public func isContractOpen() ->Bool {
        let open = PublicInfoEntity.sharedInstance.contractOpen == "1"
        let newContract = PublicInfoEntity.sharedInstance.isNewContract != "0"
        return open && newContract
    }
    
    /// 初始化合约SDK
    public func initSwapSDK() {

        if BasicParameter.getNetStatus() == "NONE" {
            return
        }
        
        if loadSwapSDK == true  {
            return
        }
        self.loadSwapSDK = true
        // 当websocket链接成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contractWebSocketDidOpenNotification),
                                               name: NSNotification.Name(rawValue: ContractWebSocketDidOpenNote),
                                               object: nil)
        // 监听登录成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(swapSDKLoadPlatForm),
                                               name: NSNotification.Name(rawValue: "EXLoginSuccess"),
                                               object: nil)
        // 添加退出登录通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshLogout),
                                               name: NSNotification.Name(rawValue: "Logout_notification_name"),
                                               object: nil)
        // 用户合约资产刷新通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshSwapAsset),
                                               name: NSNotification.Name(rawValue: BTFutureProperty_Notification),
                                               object: nil)
        // 合约SDK初始化成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(swapInfoReloaded),
                                               name: NSNotification.Name(rawValue: BTLoadContractsInfo_Notification),
                                               object: nil)
        /// 初始化合约SDK
        reLoadSwapSDK()
    }
    
    func reLoadSwapSDK() {
        /// 初始化合约SDK
        let headers = NetManager.sharedInstance.getHeaderParams()
        let config = SLPrivateConfig.shared()!
        config.base_host = EXNetworkDoctor.sharedManager.getContractAPIHost()
        config.host_Header = "EX"
        config.private_KEY = "lMYQry09AeIt6PNO"
        config.headers = headers
        SLSDK.sharedInstance()?.sl_start(withAppID: "chainup", launchOption: config, callBack: {[weak self] (result :Any?, error :Error?) in
            if error != nil {
                if ((self?.reloadSwapSDKTime ?? 129 ) > 128) {
                    // 您的网络状况不是很好，请检查网络后重试
                    return;
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self?.reloadSwapSDKTime ?? 0)) {
                    if SLPublicSwapInfo.sharedInstance()?.hasSwapInfo == false {
                        self?.reLoadSwapSDK()
                    }
                }
                // 重新初始化时间2的指数级增长
                if (self?.reloadSwapSDKTime == 0) {
                    self?.reloadSwapSDKTime = 2;
                } else {
                    self?.reloadSwapSDKTime *= 2;
                }
                return
            }
        })
    }
    
    
    @objc func swapInfoReloaded(notification: NSNotification) {
        /// 获取合约列表
        SLSDK.sl_loadFutureMarketData {[weak self] (result, error) in
            if result != nil {
                self?.swapSDKLoadPlatForm()
                if SLContractSocketManager.shared().isConnected == false {
                    SLContractSocketManager.shared().srWebSocketOpen(withURLString: EXNetworkDoctor.sharedManager.getContractWs())
                }
            }
        }
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if let reachability = notification.object as? Reachability{
            if reachability.currentReachabilityStatus().rawValue != 0{
                initSwapSDK()
            }
        }
    }
    
    @objc func refreshSwapAsset(notification: NSNotification) {
        var swapBalance = "0"
        if let coinArray = SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() {
            let allBTC = PublicInfoManager.sharedInstance.convertAssetsToBTC(coinArray: coinArray)
            swapBalance = allBTC
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SLSwapBalanceRefresh"), object: swapBalance)
    }
    
    @objc func swapSDKLoadPlatForm() {
        let token = XUserDefault.getToken()
        if token != nil {
            let account = BTAccount()
            account.token = token
            account.uid = UserInfoEntity.sharedInstance().uid
            account.headers = NetManager.sharedInstance.getHeaderParams()
            SLPlatformSDK.sharedInstance()?.sl_start(withAccountInfo: account)
            // 登录成功后监听私有信息
            SLSocketDataManager.sharedInstance().sl_subscribeContractUnicastData()
            // 请求用户的所有仓位(计算账户权益需要暂时这么写)
            BTContractTool.getUserPositionWithcoinCode(nil, contractID: 0, status: .holdSystem, offset: 0, size: 0, success: { (positions) in
                print("")
            }) { (error) in
                print(error as Any)
            }
        }
    }
    
    @objc func refreshLogout() {
        SLPlatformSDK.sharedInstance()?.sl_logout()
        // 退出登录后取消订阅私有信息
        SLSocketDataManager.sharedInstance().sl_unSubscribeContractUnicastData()
    }
    
    /// ws链接成功
    @objc func contractWebSocketDidOpenNotification(notification: NSNotification) {
        // 订阅 ticker ,订阅深度 如果登录之后订阅资产
        // 订阅 ticker 
        let tickerArr = SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_UNKOWN) ?? []
        var symbolArr : [NSNumber] = []
        for itemModel in tickerArr {
            symbolArr.append(NSNumber.init(value: itemModel.instrument_id))
        }
        SLSocketDataManager.sharedInstance().sl_subscribeContractTickerData(symbolArr)
        // 如果登录
        let token = XUserDefault.getToken()
        if token != nil && SLPlatformSDK.sharedInstance()?.activeAccount != nil { // 如果已经登录订阅私有资产信息
            SLSocketDataManager.sharedInstance().sl_subscribeContractUnicastData()
        }
    }
    //游戏APP跳转过来授权
    //比如：NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"gameJump://gameId=%@&gameName=%@&gameScheme=%@&gameToken=%@",@"123",@"游戏",@"app1",@"232323"]];
    //gameId:游戏id(后台接口用),gameScheme:游戏APP唯一标识，gameToken：token(后台接口用),gameName游戏名称
    func dealGameJump(urlStr : String) {
        if urlStr.hasPrefix("gameJump://") {
            let str = urlStr.replacingOccurrences(of: "gameJump://", with: "")
            let paraArr = str.components(separatedBy: "&")
            var paraDic : [String : String] = [:]
            for item in paraArr {
                let keyArr = item.components(separatedBy: "=")
                if keyArr.count == 2{
                    let key = keyArr[0]
                    let value = keyArr[1]
                    paraDic[key] = value
                }
            }
            //存储游戏传过来的参数
            EXGameJumpManager.shareInstance.paraDic = paraDic
            print(paraDic)
            //如果未登陆，则登录再显示授权页面
            if XUserDefault.getToken() == nil{
                BusinessTools.modalLoginVC()
            }else {
                EXGameJumpManager.shareInstance.presentAuthorVc()
                
            }
        }else {
            EXGameJumpManager.shareInstance.paraDic = nil
        }
    }
}

