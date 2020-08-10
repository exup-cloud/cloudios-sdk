//
//  PublicInfo.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/24.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import YYWebImage

class EXCurrencyModel:EXBaseModel {
    var lang_coin = "USD"//法币简称
    var lang_logo = "$"//法币符号
    var coin_precision = "4"//币币法币精度
    var coin_fiat_precision = "2"//场外法币精度
}

class PublicInfo: NSObject {
    
    var subject = BehaviorSubject.init(value: 0)

    //MARK:单例
    public static var sharedInstance : PublicInfo{
        struct Static {
            static let instance : PublicInfo = PublicInfo()
        }
        return Static.instance
    }
    
}

extension PublicInfo{
    
    func getData(){
        let url = NetManager.sharedInstance.url(EXNetworkDoctor.sharedManager.getAppAPIHost(), model: NetDefine.common, action: NetDefine.public_info)
        let param = NetManager.sharedInstance.handleParamter()
        NetManager.sharedInstance.sendRequest(url, parameters: param, isShowLoading : false,success: { (result, response, nil) in
            guard let result = result as? [String : Any] else{return}
            guard let data = result["data"] as? [String : Any] else{return}
            PublicInfoEntity.sharedInstance.setEntityWithDict(data)
            self.subject.onNext(1)
        }) { (state , error , nil) in
            
        }
    }
    
}

class PublicInfoEntity : SuperEntity{
    
    //MARK:单例
    public static var sharedInstance : PublicInfoEntity{
        struct Static {
            static let instance : PublicInfoEntity = PublicInfoEntity()
        }
        return Static.instance
    }
    
    var verificationType = "" // 1阿里 2 极验
    var country_code = ""
    
    var nc_appkey = ""
    
    var marketSort : [String] = []//币种
    
    var footer_style = ""
    
    var klineColor : KLineColorEntity = KLineColorEntity()
    
    var otcOpen = ""
    
    var lan = LanguageEnity()//语言
    
    var default_country_code = ""//后台默认地区码 例如 +86
    
    var default_country_code_real = ""//后台默认国家码 例如 156
    
    var smsOptCode : [DefaultPublicEntity] = []
    
    var mobileOpen = ""
    
    var wsUrl = ""
    
    var app_logo_list = AppLogoList()
    
    var app_logo_list_new = AppLogoListNew()
    
    var app_klinelogo_model = AppKlineLogoImgModel()
    
    var otcUrl = ""
    
    var market : [MarketEntity] = []//每个市场下的币对
    
    var maket_index = ""
    var popWindow_txt = ""
    var protocol_url  = ""
    
    
    var nc_lang = ""
    
    var coinList : [CoinListEntity] = []//币种列表
    
    var followCoinList : [CoinListEntity] = []//从币列表
    
    var followCoinDict : [String : [CoinListEntity]] = [:]//从币列表字典
    
    var emailOptCode : [DefaultPublicEntity] = []
    
    var rate : [RateEntity] = []//汇率
    
    var contractOpen = "0"
    var isNewContract = ""
    
    var tmpDict : [String : Any] = [:]
    
    var haveOTC = "0"

    var haveBiBao = "0"

    var klineScale : [String] = []
    
    var bank_name_equal_auth = "0"
    
    var tagType = "0"
    
    var symbol_profile  = "0"
    //4.0新加
    var otc_default_coin = "" //场外默认交易币种
    var app_help_center = "" //配置帮助中心,如果字段为空，则使用默认帮助中心
    var app_upload_img_type = "0"//使用哪种方法上传图片：app_upload_img_type: 0使用旧上传图片，1使用token方式上传图片
    var coinsymbol_introduce_names : [String] = [] //存在简介的币种列表
    var update_safe_withdraw = UpdateSafeWithdraw()
    var online_service_url = ""//在线客服地址
    
    var red_packet_open = "0"//红包按钮 0关 1开
    var is_enforce_google_auth = ""//google 安全等级,开 0关,1开.默认开,客户端先上
    
    var interfaceSwitch = "0"//实名认证 人脸开关 0关 1开
    var has_trade_limit_open = "0"//  1开 0 关,1获取该币对交易限制文案接口
    
    var limitCountryList : [String] = []//屏蔽的国家
    var app_personal_title : [AppPersonalTitleEntity] = []//自定义tabbar title
    var app_personal_icon : AppPersonalIconEntity = AppPersonalIconEntity()//自定义tabbar icon

    var fiat_trade_open = "0"//b2c开关 0关闭 1开启
    
    var custom_config = ""
    
    // sl
    var online_swap_guide = "https://bikiuser.zendesk.com/hc/zh-cn/sections/360007889891" // 合约指南
    var online_swap_ADL = "https://bikiuser.zendesk.com/hc/zh-cn/articles/360039490271" // 自动减仓
    var online_swap_Close = "https://bikiuser.zendesk.com/hc/zh-cn/sections/360007889891" // 强制平仓
    
    var lever_open = ""//杠杆的总开关
    
    var open_order_collect = "0"//币币订单历史搜索的开关
        
    var protocol_url_list : [String : Any] = [:]//获取杠杆协议列表
    
    var defaultThreshold = ""
    
    var locales:[String:String] = [:]

    var sharingPage = ""//下载二维码
    
    var companyId = ""
    var co_agent_noticeUrl = ""
    
    var appPushSwitch = ""
    
    var coCouponSwitchStatus = "0"
    var coCouponSwitch_url = ""
    
    var kycLimitConfigModel = KycLimitConfigModel()
    var userRegist : [String : Any] = [:]//用户配置的注册列表
    var fundRate:String = ""
        
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        setTmpDict()
        
        if let array = dict["limitCountryList"] as? [String]{
            limitCountryList = array
        }
        
        if let user_reg_type = dict["user_reg_type"] as? String{
            if let usr = user_reg_type.mj_JSONObject() as? [String : Any]{
                userRegist = usr
            }
        }
        
        sharingPage = dictContains("sharingPage")
        co_agent_noticeUrl = dictContains("co_agent_noticeUrl")
        appPushSwitch = dictContains("appPushSwitch", defaultStr: "0")
        
        if let titles = dict["app_personal_title"] as? [String : Any]{
            var array : [AppPersonalTitleEntity] = []
            for key in titles.keys{
                if let item = titles[key] as? [String : Any]{
                    let entity = AppPersonalTitleEntity()
                    entity.key = key
                    entity.setEntityWithDict(item)
                    array.append(entity)
                }
            }
            self.app_personal_title = array
        }
        
        if let iconDict = dict["app_personal_icon"] as? [String : Any]{
            app_personal_icon.setEntityWithDict(iconDict)
        }
        
        if let kycLimitConfig = dict["kycLimitConfig"] as? [String : Any]{
            kycLimitConfigModel.setEntityWithDict(kycLimitConfig)
        }
        
        if let protocol_url_list = dict["protocol_url_list"] as? [String : Any]{
            self.protocol_url_list = protocol_url_list
        }
        
        defaultThreshold = dictContains("defaultThreshold",defaultStr: "0.1")
        
        if let local = dict["locales"] as? [String : String]{
            self.locales = local
        }
        
        open_order_collect = dictContains("open_order_collect")//币币历史委托如果打开就用
        
        online_service_url = dictContains("online_service_url")//在线客服地址

        interfaceSwitch = dictContains("interfaceSwitch")
        
        companyId = dictContains("companyId")
        
        custom_config = dictContains("custom_config")
        
        fundRate = dictContains("fundRate")

        if let market = dict["market"] as? [String : Any]{
            var array : [MarketEntity] = []
            for key in market.keys{
                if let item = market[key] as? [String : Any]{
                    let marketEntity = MarketEntity()
                    marketEntity.key = key
                    marketEntity.setEntityWithDict(item)
                    array.append(marketEntity)
                }
            }
            self.market = array
        }
        
        //如果有场外和合约，需要先与上一次本地存储的数据进行比较
        if PublicInfoEntity.sharedInstance.haveOTC != dictContains("otcOpen") || PublicInfoEntity.sharedInstance.contractOpen != dictContains("contractOpen") || PublicInfoEntity.sharedInstance.lever_open != dictContains("lever_open") || PublicInfoEntity.sharedInstance.fiat_trade_open != dictContains("fiat_trade_open") ||
            PublicInfoEntity.sharedInstance.isNewContract != dictContains("isNewContract"){
            contractOpen = dictContains("contractOpen")
            haveOTC = dictContains("otcOpen")
            lever_open = dictContains("lever_open")
            fiat_trade_open = dictContains("fiat_trade_open")
            isNewContract = dictContains("isNewContract")
            
            let window = UIApplication.shared.keyWindow
            let nav = AppDelegate().initNavBarV()
            window?.rootViewController = nav
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if  appDelegate.isContractOpen() {
            appDelegate.initSwapSDK()
        }
        
        //只有打开了老合约 才会请求老合约
        if contractOpen == "1",isNewContract == "0" {
            ContractPublicInfoManager.manager.requestContractPublicInfo()
        }
        
        //只有打开了otc 才会请求otc
      
        has_trade_limit_open = dictContains("has_trade_limit_open")
        red_packet_open = dictContains("red_packet_open")
        is_enforce_google_auth =  dictContains("is_enforce_google_auth", defaultStr:"0")
        otc_default_coin = dictContains("otc_default_coin")
//        app_upload_img_type = dictContains("app_upload_img_type")
        symbol_profile = dictContains("symbol_profile")

        haveBiBao = dictContains("depositOpen")
        verificationType = dictContains("verificationType")
        country_code = dictContains("country_code")
        //
        nc_appkey = dictContains("nc_appkey")
        if let array = dict["klineScale"] as? [String]{
            var arr : [String] = []
            arr.append("1min")
            arr = arr + array
            klineScale = arr
        }else{
            klineScale =  ["1min","1min", "5min", "15min", "30min", "60min", "1day", "1week", "1month"]
        }
        if let array = dict["marketSort"] as? [String]{
            marketSort = array
        }
        if let array = dict["coinsymbol_introduce_names"] as? [String]{
            coinsymbol_introduce_names = array
        }
        bank_name_equal_auth = dictContains("bank_name_equal_auth")

        tagType = dictContains("tagType")
        
        default_country_code = dictContains("default_country_code")
        default_country_code_real = dictContains("default_country_code_real")
        
        footer_style = dictContains("footer_style")
        
        if let tmpklineColor = dict["klineColor"] as? [String : Any]{
            klineColor.setEntityWithDict(tmpklineColor)
        }
        
        otcOpen = dictContains("otcOpen")
        popWindow_txt = dictContains("popWindow_txt")
        protocol_url = dictContains("protocol_url")
        if let lanl = dict["lan"] as? [String : Any]{
            lan.setEntityWithDict(lanl)
        }
        
        mobileOpen = dictContains("mobileOpen")
        
        wsUrl = dictContains("wsUrl")
        
        if let app_logo_list = dict["app_logo_list"] as? [String : Any]{
            self.app_logo_list.setEntityWithDict(app_logo_list)
        }
        
        if let app_logo_list_new = dict["app_logo_list_new"] as? [String : Any]{
            self.app_logo_list_new.setEntityWithDict(app_logo_list_new)
        }
        
        if let kline_background_logo_img =  dict["kline_background_logo_img"] as? [String : Any]{
            self.app_klinelogo_model.setEntityWithDict(kline_background_logo_img)
        }
        
        if let update_safe_withdraw = dict["update_safe_withdraw"] as? [String : Any]{
            self.update_safe_withdraw.setEntityWithDict(update_safe_withdraw)
        }
        
        otcUrl = dictContains("otcUrl")
        
        maket_index = dictContains("maket_index")
        
        nc_lang = dictContains("nc_lang")
        
        if let rate = dict["rate"] as? [String : Any]{
            var array : [RateEntity] = []
            for key in rate.keys{
                if let item = rate[key] as? [String : Any]{
                    let rateEntity = RateEntity()
                    rateEntity.key = key
                    rateEntity.setEntityWithDict(item)
                    array.append(rateEntity)
                }
            }
            self.rate = array
        }
        
        if let coinList = dict["coinList"] as? [String : Any]{
            var array : [CoinListEntity] = []
            for key in coinList.keys{
                if let item = coinList[key] as? [String : Any]{
                    let entity = CoinListEntity()
                    entity.setEntityWithDict(item)
                    array.append(entity)
                }
            }
            array.sort { (entity1, entity2) -> Bool in
                return entity2.sort > entity1.sort
            }
            self.coinList = array
        }
        
        if let followCoinList = dict["followCoinList"] as? [String : Any]{
            var array : [CoinListEntity] = []
            for key in followCoinList.keys{
                if let item = followCoinList[key] as? [String : Any]{
                    for key in item.keys{
                        if let dic = item[key] as? [String : Any]{
                            let entity = CoinListEntity()
                            entity.setEntityWithDict(dic)
                            array.append(entity)
                        }
                    }
                }
            }
            array.sort { (entity1, entity2) -> Bool in
                return entity2.sort > entity1.sort
            }
            self.followCoinList = array
        }
        
        if let followCoinList = dict["followCoinList"] as? [String : Any]{
            var dict : [String : [CoinListEntity]] = [:]
            for key in followCoinList.keys{
                var array : [CoinListEntity] = []
                if let item = followCoinList[key] as? [String : Any]{
                    for key in item.keys{
                        if let dic = item[key] as? [String : Any]{
                            let entity = CoinListEntity()
                            entity.setEntityWithDict(dic)
                            array.append(entity)
                        }
                    }
                }
                array.sort { (entity1, entity2) -> Bool in
                    return entity2.sort > entity1.sort
                }
                dict[key] = array
            }
            self.followCoinDict = dict
        }
        
        if let emailOptCode = dict["emailOptCode"] as? [String : Any]{
            var array : [DefaultPublicEntity] = []
            for key in emailOptCode.keys{
                if let value = emailOptCode[key]{
                    let entity = DefaultPublicEntity()
                    entity.setEntityWithDict([key : value])
                    array.append(entity)
                }
            }
            self.emailOptCode = array
        }
        
        app_help_center = dictContains("app_help_center")
        
        if let coCouponSwitch = dict["coCouponSwitch"] as? [String:String] {
            if let status = coCouponSwitch["status"] {
                coCouponSwitchStatus = status
            }
            if let url = coCouponSwitch["url"] {
                coCouponSwitch_url = url
            }
        }
        
        //设置币对中的币种信息
        DispatchQueue.main.async {
            LanguageTools.shareInstance.tryDownloadCurrentLan()
            PublicInfoManager.sharedInstance.setCoinListEntityofCoinMapEntity()
        }
        
        PublicInfoManager.sharedInstance.getAllCoinMapInfo()
        PublicInfoManager.sharedInstance.getAllCoinExchangeRate()
    }
    
    func setTmpDict(){
        for key in dict.keys{
            if let value = dict[key]{
                PublicInfoEntity.sharedInstance.tmpDict[key] = value
            }
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: PublicInfoEntity.sharedInstance.tmpDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            XUserDefault.setValueForKey(data, key: XUserDefault.publicInfo)
        }catch _ {
            
        }
    }
    
    func getTmpDict(){
        if let data = XUserDefault.getVauleForKey(key: XUserDefault.publicInfo) as? Data{
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let dict = json as? [String : Any] , dict.keys.count > 0{
                    if let otcOpen = dict["otcOpen"] as? String{
                        PublicInfoEntity.sharedInstance.haveOTC = otcOpen
                    }
                    PublicInfoEntity.sharedInstance.setEntityWithDict(dict)
                }
            }catch _ {
                
            }
        }
    }
    
}

class KycLimitConfigModel : SuperEntity{
    
    var deposite_kyc_open = ""//充值
    var withdraw_kyc_open = ""//提现
    var exchange_trade_kyc_open = ""//币币交易
    var lever_trade_kyc_open = ""//杠杆交易
    var contract_transfer_kyc_open = ""//合约划转
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        deposite_kyc_open = dictContains("deposite_kyc_open")
        withdraw_kyc_open = dictContains("withdraw_kyc_open")
        exchange_trade_kyc_open = dictContains("exchange_trade_kyc_open")
        lever_trade_kyc_open = dictContains("lever_trade_kyc_open")
        contract_transfer_kyc_open = dictContains("contract_transfer_kyc_open")
    }

}

class UpdateSafeWithdraw : SuperEntity{
    
    var is_open = ""
    
    var hour = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        is_open = dictContains("is_open")
        hour = dictContains("hour")
    }
    
}

class AppLogoList : SuperEntity{
    
    var startup_logo = ""
    
    var login_logo = ""
    
    var user_center_logo = ""
    
    var market_logo = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        startup_logo = dictContains("startup_logo")
        
        login_logo = dictContains("login_logo")
        
        user_center_logo = dictContains("user_center_logo")
        
        market_logo = dictContains("market_logo")
    }
    
}

class AppLogoListNew : SuperEntity{
    
    var logo_black = ""
    
    var logo_white = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        logo_black = dictContains("logo_black")
        logo_white = dictContains("logo_white")
    }
    
}

class AppKlineLogoImgModel : SuperEntity{
    var app_img = ""
    var app_img_night = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        app_img = dictContains("app_img")
        app_img_night = dictContains("app_img_night")
    }
}

//汇率
class RateEntity : SuperEntity{
    
    var defaultEntity : [DefaultPublicEntity] = []
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        for key in dict.keys{
            if let value = dict[key]{
                let entity = DefaultPublicEntity()
                entity.setEntityWithDict([key : value])
                defaultEntity.append(entity)
            }
        }
    }
}

class KLineColorEntity : SuperEntity{
    var up = ""//
    
    var down = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        up = dictContains("up")
        down = dictContains("down")
    }
}

//默认实体：针对key 不固定 value只有一个的情况
class DefaultPublicEntity : SuperEntity{
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        if dict.keys.count > 0{
            key = dict.keys.first ?? ""
            value = dictContains(key)
        }
    }
}

//币种信息
class CoinListEntity : SuperEntity{
    var showPrecision = "0"
    
    var otcOpen = ""
    var depositOpen = ""
    var icon = ""
    
    var name = ""
    
    var sort = 0
    var tokenBase = ""
    
    var tagtype = ""//0不填 1可不填 2必填
    
    var showName = ""//别名
    
    var isOvercharge = "0"//是否为加价币对
    
    var isOverchargeMsg : [String : Any] = [:]
    
    var mainChainType = ""//币种主从配置 0默认  1主币  2从币
    
    var mainChainSymbol = ""//主币币种
    
    var mainChainName = ""
    var coinTag = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        otcOpen = dictContains("otcOpen")
        depositOpen = dictContains("depositOpen")
        icon = dictContains("icon")
        icon = icon.replacingOccurrences(of: "https://", with: "http://")
        name = dictContains("name")
        showName = dictContains("showName") == "" ? name : dictContains("showName")
        tokenBase = dictContains("tokenBase")
        if dict.keys.contains("sort") , let s = dict["sort"] as? Int{
            sort = s
        }
        showPrecision = dictContains("showPrecision")
        tagtype = dictContains("tagType")
        isOvercharge = dictContains("isOvercharge",defaultStr : "0")
        if let dic = dict["isOverchargeMsg"] as? [String : Any]{
            isOverchargeMsg = dic
        }
        mainChainType = dictContains("mainChainType")
        mainChainSymbol = dictContains("mainChainSymbol")
        mainChainName = dictContains("mainChainName")
        coinTag = dictContains("coinTag")
    }
    
    //获取模式说明
    func getOverchargeMsg() -> String{
        var str = ""
        if let s = self.isOverchargeMsg[BasicParameter.getPhoneLanguage()] as? String{
            str = s
        }
        return str
    }
    
}

class LanguageEnity : SuperEntity{
    
    var defLan = ""
    
    var lanList : [LanguageListEntity] = []
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        defLan = dictContains("defLan")
        if let lanl = dict["lanList"] as? [[String : Any]]{
            
            var temp:[LanguageListEntity] = []
            
            for item in lanl{
                let entity = LanguageListEntity()
                entity.setEntityWithDict(item)
                temp.append(entity)
            }
            lanList = temp
        }
    }
    
}

class LanguageListEntity : SuperEntity{
    var name = ""
    var selected = false
    var id = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        name = dictContains("name")
        if let ids = dict["id"] as? String{
            
            id = ids.replacingOccurrences(of: "_", with: "-")
        }
    }
}

class MarketEntity : SuperEntity {
    
    var coinMapEntity : [CoinMapEntity] = []
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        for key in dict.keys{
            if let item = dict[key] as? [String : Any]{
                let coinMapEntity = CoinMapEntity()
                coinMapEntity.setEntityWithDict(item)
                self.coinMapEntity.append(coinMapEntity)
                self.coinMapEntity.sort { (entity1, entity2) -> Bool in
                    if NSString.init(string: entity1.sort).subtracting(entity2.sort, decimals: 1).contains("-") {
                        return true
                    }
                    return false
                }
            }
        }
    }
}

//币对
class CoinMapEntity: SuperEntity{
    var volume = ""//卖的数量精度
    
    var symbol = ""
    
    var name = ""//币对名字
    
    var limitPriceMin = ""//最低价格
    
    var marketSellMin = ""//最少价格
    
    var sort = ""
    
    var doubleSort : Double = 1000
    
    var price = ""//买的价格精度
    
    var marketBuyMin = ""
    
    var limitVolumeMin = ""
    
    var depth = ""
    
    var depthArray : [Int] = []
    
    var coinListEntity = CoinListEntity()
    
    var marketEntity = CoinListEntity()
    
    var coinName = ""//基础货币名字
    
    var marketName = ""//市场名字
    
    var newcoinFlag = "0"//0主区 1创新区 2观察区 3减半区
    
    var coinDetailsEntity = CoinDetailsEntity()//ws实时
    
    var isShow = "1"//是否列表展示 1是 0否
    
    var showName = ""//别名
    
    var multiple = ""//杠杆默认倍数
    
    var isOpenLever = ""//杠杆开关，0关闭，1开启
    
    var etfOpen = ""//是否为etf市场币对 0不是 1是
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        volume = dictContains("volume")
        
        multiple = dictContains("multiple")
        
        isOpenLever = dictContains("isOpenLever")
        
        name = dictContains("name")
        showName = dictContains("showName") == "" ? name : dictContains("showName")
        
        symbol = dictContains("symbol")
        
        limitPriceMin = dictContains("limitPriceMin")
        
        marketSellMin = dictContains("marketSellMin")
        
        sort = dictContains("sort")
        if let double = Double(sort){
            doubleSort = double
        }
        
        price = dictContains("price")
        
        marketBuyMin = dictContains("marketBuyMin")
        
        limitVolumeMin = dictContains("limitVolumeMin")
        
        newcoinFlag = dictContains("newcoinFlag")
        
        depth = dictContains("depth")
        truncationDepth(depth)
        
        isShow = dictContains("isShow",defaultStr:"1")
        
        let array = self.name.components(separatedBy: "/")
        if array.count > 0{
            coinName = array[0]
            coinListEntity = PublicInfoManager.sharedInstance.getCoinEntity(coinName) ?? CoinListEntity()
        }
        if array.count > 1{
            marketName = array[1]
            marketEntity = PublicInfoManager.sharedInstance.getCoinEntity(marketName) ?? CoinListEntity()
        }
        
        etfOpen = dictContains("etfOpen")
        
    }
    
    //截断
    func truncationDepth(_ depth : String){
        let array = depth.components(separatedBy: ",")
        for item in array{
            let s = item.replacingOccurrences(of: ".", with: "")
            depthArray.append(s.count - 1)
        }
    }
}

class AppPersonalTitleEntity : SuperEntity{
        
    var assets = ""//资产
    
    var contract = ""//合约
    
    var fiat = ""//otc
    
    var exchange = ""//币币交易
    
    var home = ""//首页
    
    var quotes = ""//行情
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        assets = dictContains("assets")
        contract = dictContains("contract")
        fiat = dictContains("fiat")
        exchange = dictContains("exchange")
        home = dictContains("home")
        quotes = dictContains("quotes")
    }
    
}

class AppPersonalIconEntity : SuperEntity{
    
    var tabbar_home_default_night = ""
    
    
    var tabbar_fiat_default_daytime = ""

    
    var tabbar_home_default_daytime = ""

    
    var tabbar_home_selected = ""

    
    var tabbar_contract_default_daytime = ""

    
    var tabbar_assets_default_night = ""

    
    var tabbar_contract_selected = ""

    
    var tabbar_assets_default_daytime = ""

    
    var tabbar_fiat_default_night = ""

    
    var tabbar_quotes_selected = ""

    
    var tabbar_fiat_selected = ""

    
    var tabbar_exchange_default_night = ""

    
    var tabbar_exchange_default_daytime = ""

    
    var tabbar_quotes_default_night = ""

    
    var tabbar_exchange_selected = ""

    
    var tabbar_quotes_default_daytime = ""

    
    var tabbar_contract_default_night = ""

    
    var tabbar_assets_selected = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        tabbar_home_default_night = dictContains("tabbar_home_default_night")
        tabbar_home_default_daytime = dictContains("tabbar_home_default_daytime")
        tabbar_home_selected = dictContains("tabbar_home_selected")

        tabbar_assets_default_night = dictContains("tabbar_assets_default_night")
        tabbar_assets_selected = dictContains("tabbar_assets_selected")
        tabbar_assets_default_daytime = dictContains("tabbar_assets_default_daytime")

        tabbar_fiat_default_night = dictContains("tabbar_fiat_default_night")
        tabbar_fiat_selected = dictContains("tabbar_fiat_selected")
        tabbar_fiat_default_daytime = dictContains("tabbar_fiat_default_daytime")

        tabbar_exchange_default_night = dictContains("tabbar_exchange_default_night")
        tabbar_exchange_default_daytime = dictContains("tabbar_exchange_default_daytime")
        tabbar_exchange_selected = dictContains("tabbar_exchange_selected")

        tabbar_quotes_default_night = dictContains("tabbar_quotes_default_night")
        tabbar_quotes_default_daytime = dictContains("tabbar_quotes_default_daytime")
        tabbar_quotes_selected = dictContains("tabbar_quotes_selected")

        tabbar_contract_default_night = dictContains("tabbar_contract_default_night")
        tabbar_contract_default_daytime = dictContains("tabbar_contract_default_daytime")
        tabbar_contract_selected = dictContains("tabbar_contract_selected")

    }
    
}
