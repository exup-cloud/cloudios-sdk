//
//  EXHomeEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
class HomeEntity: SuperEntity {
    
    var cmsAppAdvertList : [CmsAppAdvertEntity] = []//h5和app轮播图
    
    var noticeInfoList : [NoticeInfoEntity] = []//公告列表
    
    var risingListIsOpen = ""//涨幅榜开关，1：开启，0：关闭
    
    var fallingListIsOpen = ""//跌幅榜开关，1：开启，0：关闭
    
    var dealListIsOpen = ""//成交榜开关，1：开启，0：关闭
    
    var switchArray : [String] = []
    
    var homeFunctionEntityList : [HomeFunctionEntity] = []//首页展示位
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        
        if let array = dict["cmsAppAdvertList"] as? [[String : Any]]{
            var arr : [CmsAppAdvertEntity] = []
            for dic in array{
                let entity = CmsAppAdvertEntity()
                entity.setEntityWithDict(dic)
                arr.append(entity)
                arr.sort { (entity1, entity2) -> Bool in
                    if let str = NSString.init(string: entity1.sort).subtracting(entity2.sort, decimals: 0) , str.contains("-"){
                        return true
                    }
                    return false
                }
            }
            cmsAppAdvertList = arr
        }
        
        if let array = dict["noticeInfoList"] as? [[String : Any]]{
            var arr : [NoticeInfoEntity] = []
            for dic in array{
                let entity = NoticeInfoEntity()
                entity.setEntityWithDict(dic)
                arr.append(entity)
            }
            noticeInfoList = arr
        }
        
        if let array = dict["cmsAppDataList"] as? [[String : Any]]{
            var arr : [HomeFunctionEntity] = []
            for dic in array{
                let entity = HomeFunctionEntity()
                entity.setEntityWithDict(dic)
                arr.append(entity)
            }
            homeFunctionEntityList = arr
        }
        
        switchArray.removeAll()
        
        risingListIsOpen = dictContains("risingListIsOpen")
        if risingListIsOpen == "1"{
            switchArray.append("rasing")
        }
        
        fallingListIsOpen = dictContains("fallingListIsOpen")
        if fallingListIsOpen == "1"{
            switchArray.append("falling")
        }
        
        dealListIsOpen = dictContains("dealListIsOpen")
        if dealListIsOpen == "1"{
            switchArray.append("deal")
        }
        
    }
    
}

class NoticeInfoEntity : SuperEntity{//公告
    
    var id = ""
    
    var title = ""
    
    var content = ""
    
    var ctime = ""
    
    var mtime = ""
    
    var stime = ""
    
    var lang = ""
    
    var httpUrl = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        id = dictContains("id")
        title = dictContains("title")
        content = dictContains("content")
        ctime = dictContains("ctime")
        mtime = dictContains("mtime")
        stime = dictContains("stime")
        lang = dictContains("lang")
        httpUrl = dictContains("httpUrl")
    }
    
}

class CmsAppAdvertEntity : SuperEntity {//轮播图
    
    var id = ""
    
    var title = ""
    
    var imageUrl = ""
    
    var httpUrl = ""
    
    var sort = ""
    
    var lang = ""
    
    var nativeUrl = ""//本地url
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        
        id = dictContains("id")
        
        title = dictContains("title")
        
        imageUrl = dictContains("imageUrl")
        
        httpUrl = dictContains("httpUrl")
        
        sort = dictContains("sort")
        
        lang = dictContains("lang")
        
        nativeUrl = dictContains("nativeUrl")
    }
    
}


class HomeRecommendedEntity : HomeListEntity{//首页推荐
    
    var amplitudeColor = UIColor.ThemeLabel.colorMedium
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        if let rose = Float(rose){
            if rose == 0{
                backColor = UIColor.ThemeLabel.colorMedium
                amplitudeColor = UIColor.ThemeView.bg
            }else if rose < 0{
                backColor = UIColor.ThemekLine.down.withAlphaComponent(0.2)
                amplitudeColor =  UIColor.ThemekLine.down
            }else{
                backColor = UIColor.ThemekLine.up.withAlphaComponent(0.2)
                amplitudeColor = UIColor.ThemekLine.up
            }
        }
    }
    
}

class HomeListEntity : CoinDetailsEntity{//首页各种榜
    
    var symbol = "--"
    
    var price = "--"
    
    var coinName = "USDT"//币种名字
    
    var dealVolume = "--"//成交量
    
    var volume = "--"
    
    var nameAttrWidth:CGFloat = 0
    
    var symbolWidth:CGFloat = 0
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        self.dict = dict
        symbol = dictContains("symbol")
        let entity = PublicInfoManager.sharedInstance.getCoinMapWithSymbol(symbol)
        name = entity.name
        if let i = Int(entity.price){//默认精度
            precision = i
        }
        super.setEntityWithDict(dict)
        if let rose = Float(rose){
            if rose == 0{
                backColor = UIColor.ThemeLabel.colorMedium
                color = UIColor.ThemeLabel.colorMedium
            }
        }
        
        volume = dictContains("volume")
        if volume != ""{
            volume = (volume as NSString).decimalString1(2)
            volume = BasicParameter.dealDataFormate(volume)
            name = symbol
        }
        
        if coinName != ""{
            price = PublicInfoManager.sharedInstance.getOTCCoinExchangeRate(coinName).1
            dealVolume = BasicParameter.dealDataFormate(dealVolume)
            if dealVolume == ""{
                dealVolume = "--"
            }
        }
        
        rose = dictContains("rose")
        
        if rose.contains("-"){
            rose = rose.replacingOccurrences(of: "-", with: "")
            rose = NSString.init(string: rose).multiplying(by: "100", decimals: 2)
            rose = self.dealRose(rose)
            rose = "-" + rose
            if let r = Int(rose) , r == 0{
                rose = rose.replacingOccurrences(of: "-", with: "")
            }
        }else{
            rose = NSString.init(string: rose).multiplying(by: "100", decimals: 2)
            rose = self.dealRose(rose)
        }
        
        if let rose1 = Float(self.rose){
            if rose1 == 0{
                rose = "0.00" + "%"
                backColor = UIColor.ThemekLine.up
                color = UIColor.ThemeLabel.colorMedium
            }else if rose1 < 0{
                rose =  rose + "%"
                backColor = UIColor.ThemekLine.down
                color = UIColor.ThemekLine.down
            }else{
                rose = "+" + rose + "%"
                backColor = UIColor.ThemekLine.up
                color = UIColor.ThemekLine.up
            }
            self.rose1 = rose1
        }
        if dictContains("rose") == ""{
            rose = "--"
        }
        nameAttrWidth = nameAttr().boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14), options: .usesLineFragmentOrigin, context: nil).width + 36 
        symbolWidth = symbol.aliasName().textSizeWithFont(UIFont.ThemeFont.HeadBold, width: .greatestFiniteMagnitude).width + 36
    }
    
    //处理rose
    func dealRose(_ rose : String) -> String{
        var rose1 = rose
        if rose1.count > 6 , rose1.contains("."){
            rose1 = rose1.extStringSub(NSRange.init(location: 0, length: rose1.count - 1))
            if rose1.last == "."{
                rose1 = rose1.extStringSub(NSRange.init(location: 0, length: rose1.count - 1))
            }
            return dealRose(rose1)
        }
        return rose1
    }
    
}

class HomeAssetsEntity : EXBaseModel {
    var name = ""
    
    var assetSymbol = ""
    
    var assetsCount = ""
    {
        didSet{
            //如果后台返回的是空字符串 也改成 0
            if assetsCount == ""{
                assetsCount = "0"
            }
            let decimal = PublicInfoManager.sharedInstance.coinPrecision(assetSymbol)
            let btc = NSString.init(string: assetsCount).decimalString(decimal)
            assetsCount = btc ?? "0"
            self.assetsAtt = assetsAtt.add(string: assetsCount, attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite , NSAttributedStringKey.font : UIFont.init().themeHNMediumFont(size: 16)]).add(string: " " + assetSymbol, attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium , NSAttributedStringKey.font : UIFont.init().themeHNMediumFont(size: 12)])
            
            let rate = PublicInfoManager.sharedInstance.getCoinExchangeRate(assetSymbol)
            self.rmb = "≈" + rate.0 + NSString.init(string: assetsCount).multiplying(by: rate.1, decimals: rate.2)
        }
    }
    
    var assetsAtt = NSMutableAttributedString.init()
    
    var rmb = ""
    
    var bool = false
}

class HomeGOTO : NSObject{
    
    var coinMap = ""
    
    weak var vc : UIViewController?
    
    //0.webView 1.coinmap_market 行情 2.coinmap_trading 币对交易页 3.coinmap_details 币对详情页 4.otc_buy 场外交易-购买 5.otc_sell 场外交易-出售 6.order_record 订单记录 7.account_transfer 账户划转 8.otc_account 资产-场外账户 9.coin_account 资产-币币账户 10.safe_set 安全设置 11.safe_money 安全设置-资金密码 12.personal_information 个人资料 13.personal_invitation 个人资料-邀请码 14.collection_way 收款方式 15.real_name 实名认证
    func gotoVC(_ vc : UIViewController? = nil , tnativeUrl : String , httpUrl : String){
        var nativeUrl = tnativeUrl
        if vc == nil{
            return
        }
        self.vc = vc
        
        if nativeUrl == ""{
            let charSet = CharacterSet.alphanumerics
            if let encodingURL = httpUrl.addingPercentEncoding(withAllowedCharacters: charSet) {
                EXNavigationHandler.sharedHandler.commonJumpCommand("web", encodingURL)
            }
        }else{
            let arr = nativeUrl.components(separatedBy: "?")
            if arr.count > 1{
                nativeUrl = arr[0]
                coinMap = arr[1]
            }else if arr.count > 0{
                nativeUrl = arr[0]
            }
            EXNavigationHandler.sharedHandler.commonJumpCommand(nativeUrl,coinMap)
        }
    }
}

class EXHomeAssetModel: EXBaseModel {
    
    var assetSymbol = "BTC"
    
    var totalBalance = ""
    {
        didSet{
            //如果后台返回的是空字符串 也改成 0
            if totalBalance == ""{
                totalBalance = "0"
            }
            let decimal = PublicInfoManager.sharedInstance.coinPrecision(assetSymbol)
            let btc = NSString.init(string: totalBalance).decimalString(decimal)
            totalBalance = btc ?? "0"
            self.assetsAtt = assetsAtt.add(string: totalBalance, attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorLite , NSAttributedStringKey.font : UIFont.init().themeHNMediumFont(size: 16)]).add(string: " " + assetSymbol, attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium , NSAttributedStringKey.font : UIFont.init().themeHNMediumFont(size: 12)])
            
            let rate = PublicInfoManager.sharedInstance.getCoinExchangeRate(assetSymbol)
            self.rmb = "≈" + rate.0 + NSString.init(string: totalBalance).multiplying(by: rate.1, decimals: rate.2)
        }
    }
    
    var assetsAtt = NSMutableAttributedString.init()
    
    var rmb = ""
    
    func updateTotalBalanceWithCoBalance(cobalance:String) {
        
        let decimal = PublicInfoManager.sharedInstance.coinPrecision(assetSymbol)
        let btc = NSString.init(string: totalBalance).adding(cobalance, decimals: decimal)
        self.assetsAtt = NSMutableAttributedString.init()
        self.totalBalance = btc ?? "0"
    }
    
    
}
