//
//  EXNavigationHandler.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import URLNavigator

//0.webView 1.coinmap_market 行情 2.coinmap_trading 币对交易页 3.coinmap_details 币对详情页 4.otc_buy 场外交易-购买 5.otc_sell 场外交易-出售 6.order_record 订单记录 7.account_transfer 账户划转 8.otc_account 资产-场外账户 9.coin_account 资产-币币账户 10.safe_set 安全设置 11.safe_money 安全设置-资金密码 12.personal_information 个人资料 13.personal_invitation 个人资料-邀请码 14.collection_way 收款方式 15.real_name 实名认证

enum EXRouterActionKey:String {
    case MarketPage = "coinmap_market"
    case TransactionPage = "coinmap_trading"
    case TransactionDetail = "coinmap_details"
    case OTCBuy = "otc_buy"
    case OTCSell = "otc_sell"
    //未登录下不能跳转到下面页面
    case OTCOrder = "order_record"
    case Transfer = "account_transfer"
    case AssetOTC = "otc_account"
    case AssetCoin = "coin_account"
    case SafeSetting = "safe_set"
    case SafeMoney = "safe_money"
    case PersonalInfo = "personal_information"
    case Invitation = "personal_invitation"
    case OTCPayment = "collection_way"
    case AuthRealName = "real_name"
    case CommonWeb = "web"
    case BindGoogle = "bindGoogle"
    case BindPhone = "bindPhone"
    case SetUp = "setUp"
    case KYCSuccessful = "KYCSuccessful"
    case RealNameOne = "RealNameOne"
    case MarketETF = "market_etf"
    case ContractTransaction = "contract_transaction"
    case ContractFollowOrder = "contract_follow_order"
    case ContractAgent = "config_contract_agent_key"
    case Personal = "personal"
    case ContractRecord = "contract_record"

}

class EXNavigationHandler: NSObject {
    static let `handler` = EXNavigationHandler()
    private var navigator: NavigatorType?

    open class var sharedHandler: EXNavigationHandler {
        let navigator = Navigator()
        EXNavigator.initialize(navigator: navigator)
        handler.navigator = navigator
        return handler
    }
    
    //hiexCommand://trade?coinPair=xxx&action=xxx
    func commandTradingCoin(_ symbol:String,_ action:String) {
        let command =  "hiexCommand://trade?" + "symbol=\(symbol)&action=\(action)&tradeType=exchange"
        self.navigator?.open(command)
    }
    
    //hiexCommand://trade?coinSymbol=xxx&action=xxx
    func commandToOTC(_ symbol:String,_ action:String) {
        let command =  "hiexCommand://trade?" + "symbol=\(symbol)&action=\(action)&tradeType=otc"
        self.navigator?.open(command)
    }
    
    //hiexCommand://trade?coinSymbol=xxx&action=xxx
    func commandToContract(_ contractId:String,_ action:String) {
        let command =  "hiexCommand://trade?" + "contractId=\(contractId)&action=\(action)&tradeType=contract"
        self.navigator?.open(command)
    }
    
    //hiexCommand://trade?action=xxx
    func commandToAsset(_ action:String) {
        let command =  "hiexCommand://trade?" + "action=\(action)&tradeType=asset"
        self.navigator?.open(command)
    }

    func commonJumpCommand(_ action:String,_ extra:String = "") {
        let command =  "hiexCommand://commonJump?" + "action=\(action)&extra=\(extra)"
        self.navigator?.open(command)
    }
}

enum EXNavigator {
    static func initialize(navigator: NavigatorType) {
        //处理命令
        navigator.handle("hiexCommand://trade") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
//            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            EXNavigationExcute.handleCommandTrade(url)
            return true
        }
        
        //处理首页的跳转命令
        navigator.handle("hiexCommand://commonJump") { (url, values, context) -> Bool in
            EXNavigationExcute.handleCommonCommandJump(url)
            return true
        }
        
        
        navigator.register("hiexIndoorJump://indoorvc") { (url, values, context) -> UIViewController? in
            let vcname = url.queryParameters["name"]
            if let name = vcname {
                if name == "EXGoogleBindingVC" {
                    return EXGoogleBindingVC()
                }else {
                    return nil
                }
            }else {
                return nil
            }
        }
    }
}


class EXNavigationExcute: NSObject {
    
    static func handleCommonCommandJump(_ cmd:URLConvertible) {
        guard let action = cmd.queryParameters["action"] else { return }
        guard let topVc = AppService.topViewController() else { return }
        if action == EXRouterActionKey.CommonWeb.rawValue {
            guard let webUrl = cmd.queryParameters["extra"] else { return }
            let web = WebVC()
            web.loadUrl(webUrl)
            topVc.navigationController?.pushViewController(web, animated: true)
        }else if action == EXRouterActionKey.MarketPage.rawValue {
            
        }else if action == EXRouterActionKey.TransactionPage.rawValue {
            
          
           
        }else if action == EXRouterActionKey.TransactionDetail.rawValue {
            
            guard let coinPair = cmd.queryParameters["extra"] else { return }
            let entity = PublicInfoManager.sharedInstance.getCoinMapWithSymbol(coinPair)
            if entity.name == ""{
                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "common_tip_hasNoCoinPair"))
                return
            }
 
        }else if action == EXRouterActionKey.OTCBuy.rawValue {
          
        
        }else if action == EXRouterActionKey.OTCSell.rawValue {
            

        }else if action == EXRouterActionKey.ContractTransaction.rawValue {
            if let tabbar = BusinessTools.getRootTabbar(){
                let topVc = AppService.topViewController()
                topVc?.popBack(false, true)
                let index = tabbar.getVCIndex(SLSwapVc())
                tabbar.selectIndex(index)
            }
        }else if action == EXRouterActionKey.MarketETF.rawValue {
       
        }else if action == EXRouterActionKey.ContractAgent.rawValue {

        }else if action == EXRouterActionKey.Personal.rawValue {
            //face++是弹出来的,关掉再进入
            if let pvc = topVc.presentingViewController {
                pvc.dismiss(animated: false) {
                    if let topVc = AppService.topViewController() {
                        let meVC = EXMEVC()
                        topVc.navigationController?.pushViewController(meVC, animated: true)
                    }
                }
            }else {
                let meVC = EXMEVC()
                topVc.navigationController?.pushViewController(meVC, animated: true)
            }

        }else {
            //如果未登陆，则不跳转
            if XUserDefault.getToken() == nil{
                BusinessTools.modalLoginVC()
                return
            }
            
            if action == EXRouterActionKey.OTCOrder.rawValue {
//                let otclist = EXOTCHistoryListVc.instanceFromStoryboard(name: StoryBoardNameOTC)
//                topVc.navigationController?.pushViewController(otclist, animated: true)
            }else if action == EXRouterActionKey.Transfer.rawValue {
                let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                transfer.transferFlow = .exchangeToOther
                topVc.navigationController?.pushViewController(transfer, animated: true)
            }else if action == EXRouterActionKey.AssetOTC.rawValue {
                if let tabbar = BusinessTools.getRootTabbar(){
                    let index = tabbar.getVCIndex(EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset))
                    if index == 0 {
                        let topVc = AppService.topViewController()
                        let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                        asset.assetType = .otc
                        topVc?.navigationController?.pushViewController(asset, animated: true)
                    }else {
                        tabbar.selectIndex(index)
                        let topVc = AppService.topViewController()
                        if let vc = topVc as? EXTradeCmdProtocal {
                            vc.excuteCmd(symbol: "", action: "otc")
                        }
                    }
                }
            }else if action == EXRouterActionKey.AssetCoin.rawValue {
                if let tabbar = BusinessTools.getRootTabbar(){
                    let index = tabbar.getVCIndex(EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset))
                    if index == 0 {
                        let topVc = AppService.topViewController()
                        let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                        asset.assetType = .coin
                        topVc?.navigationController?.pushViewController(asset, animated: true)
                    }else {
                        tabbar.selectIndex(index)
                        let topVc = AppService.topViewController()
                        if let vc = topVc as? EXTradeCmdProtocal {
                            vc.excuteCmd(symbol: "", action: "coin")
                        }
                    }
                }
            }else if action == EXRouterActionKey.SafeSetting.rawValue {
                let safevc = EXSecurityCenterVC()
                topVc.navigationController?.pushViewController(safevc, animated: true)
            }else if action == EXRouterActionKey.SafeMoney.rawValue {
                let otcpwd = EXChangeOTCPWVC()
                topVc.navigationController?.pushViewController(otcpwd, animated: true)
            }else if action == EXRouterActionKey.PersonalInfo.rawValue {
                let userInfo = EXMyInfoVC()
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.OTCPayment.rawValue {
//                let userInfo = EXOTCAvailablePaymentVc.instanceFromStoryboard(name:StoryBoardNameAsset)
//                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.AuthRealName.rawValue {
                let user = UserInfoEntity.sharedInstance()
                if user.authLevel == UserAuthLevel.pending.rawValue {
                    let realName = EXRealNameThreeVC()
                    topVc.navigationController?.pushViewController(realName, animated: true)
                }else {
                    let realName = EXRealNameCertificationChooseVC()
                    topVc.navigationController?.pushViewController(realName, animated: true)
                }
            }else if action == EXRouterActionKey.Invitation.rawValue{
                let userInfo = EXInviteVC()
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.BindGoogle.rawValue{
                let userInfo = EXGoogleBindingVC()
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.BindPhone.rawValue{
                let userInfo = EXMoblieBindingVC()
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.SetUp.rawValue{
//                if EXOTCSafetyCheckVm.manager.checkOTCBasicRequire(topVc) {
//                    let listVc = EXOTCSupportPaymentMethodVc.instanceFromStoryboard(name: StoryBoardNameAsset)
//                    topVc.navigationController?.pushViewController(listVc, animated: true)
//                }
            }else if action == EXRouterActionKey.KYCSuccessful.rawValue{
                let userInfo = EXRealNameThreeVC()
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.RealNameOne.rawValue{
                let userInfo = EXRealNameOneVC()
                userInfo.mainView.regionEntity = RegionManager.sharedInstance.regionEntity
                topVc.navigationController?.pushViewController(userInfo, animated: true)
            }else if action == EXRouterActionKey.ContractFollowOrder.rawValue {
//                let followVC = GDFollowListVC()
//                topVc.navigationController?.pushViewController(followVC, animated: true)
            }else if action == EXRouterActionKey.ContractRecord.rawValue {
                let assetsRecordVC = SLAssetsRecordVC()
                assetsRecordVC.isBouns = true
                topVc.navigationController?.pushViewController(assetsRecordVC, animated: true)
            }
        }
    }
    
    
    static func handleCommandTrade(_ cmd:URLConvertible) {
        guard let tradeType = cmd.queryParameters["tradeType"] else { return }

        if tradeType == "exchange" {
            //处理命令
            guard let coinPair = cmd.queryParameters["symbol"] else { return }
            guard let action = cmd.queryParameters["action"] else { return }
            if let tabbar = BusinessTools.getRootTabbar(){
                
            }
        }else if tradeType == "otc" {
            guard let coinName = cmd.queryParameters["symbol"] else { return }
            guard let action = cmd.queryParameters["action"] else { return }
//            guard let tradeType = cmd.queryParameters["tradeType"] else { return }
//            if let tabbar = BusinessTools.getRootTabbar(){
//                let index = tabbar.getVCIndex(EXOTCHomeContainerVc.instanceFromStoryboard(name:StoryBoardNameOTC))
//                tabbar.selectIndex(index)
//                let topVc = AppService.topViewController()
//                if let vc = topVc as? EXTradeCmdProtocal {
//                    vc.excuteCmd(symbol: coinName, action: action)
//                }
//            }
        }else if tradeType == "contract" {
            guard let contractId = cmd.queryParameters["contractId"] else { return }
            guard let action = cmd.queryParameters["action"] else { return }
            if let tabbar = BusinessTools.getRootTabbar(){
                let index = tabbar.getVCIndex(SLSwapVc())
                tabbar.selectIndex(index)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    let topVc = AppService.topViewController()
                    if let vc = topVc as? EXTradeCmdProtocal {
                        vc.excuteCmd(symbol: contractId, action: action)
                    }
                }
            }
        }else if tradeType == "asset" {
            guard let action = cmd.queryParameters["action"] else { return }
            if let tabbar = BusinessTools.getRootTabbar(){
                let index = tabbar.getVCIndex(EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset))
                if index == 0 {
                    let topVc = AppService.topViewController()
                    let asset = EXAssetsContainerVc.instanceFromStoryboard(name: StoryBoardNameAsset)

                    var assetType:EXAccountType = .coin
                    if action == "otc" {
                        assetType = .otc
                    }else if action == "contract" {
                        assetType = .contract
                    }else if action == "leverage"{
                        assetType = .leverage
                    }
                    asset.assetType = assetType
                    topVc?.navigationController?.pushViewController(asset, animated: true)
                }else {
                    tabbar.selectIndex(index)
                    let topVc = AppService.topViewController()
                    if let vc = topVc as? EXTradeCmdProtocal {
                        vc.excuteCmd(symbol: "", action: action)
                    }
                }
            }
        }
    }
}
