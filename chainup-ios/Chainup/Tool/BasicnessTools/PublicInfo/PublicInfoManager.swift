//
//  PublicInfoManager.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/25.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit


class PublicInfoManager: NSObject {
    
    let publicEntity = PublicInfoEntity.sharedInstance
    
    //所有币对信息
    var allCoinMapInfo : [CoinMapEntity] = []

    //所有汇率
    var allCoinExchangeRate : [String : [String : Any]] = [:]
    
    //MARK:单例
    public static var sharedInstance : PublicInfoManager{
        struct Static {
            static let instance : PublicInfoManager = PublicInfoManager()
        }
        return Static.instance
    }
}

extension PublicInfoManager{
    
    //获取所有支持的语言列表
    func getLanaguageList() -> LanguageEnity{
        return PublicInfoManager.sharedInstance.publicEntity.lan
    }
    
    //获取所有的市场名字
    func getHomeCoin() -> [String]{
        return publicEntity.marketSort
    }
    
    //根据币种名字查找市场名字
    func getMarket(_ str : String) -> String{
        let arr = str.components(separatedBy: "/")
        if arr.count > 1{
            return arr[1]
        }
        return str
    }
    
    func getCoinMapLeft(_ coinMap:String) -> String {
           let arr = coinMap.components(separatedBy: "/")
           if arr.count > 1 {
               return arr[0]
           }
           return coinMap
       }
    
    //获取市场标签，减半、etf等
    func getCoinMarketTag(_ symbol:String) -> String {
        let followCoinAry = getAllFollowCoinList()
        for item in followCoinAry{
           if item.name == symbol{
            return (item.coinTag)
           }
        }
        let array = getAllCoinEntiy()
        for item in array{
            if item.name == symbol{
                return (item.coinTag)
            }
        }
        return ""
    }
    
    //获取所有币种信息
    func getAllCoinList() -> [CoinListEntity]{
        return publicEntity.coinList
    }
    
    //根据币种名字获取tokenBase信息
    func getTokenBaseInfo(_ name:String) -> String{
        var temp = ""
        for entity in publicEntity.coinList {
            if name == entity.name{
                temp = entity.tokenBase
            }
        }
        return temp
    }
    
    //获取默认otc币种
    func getDefaultOTCCoinEntity()->CoinListEntity {
        let coinList = self.getAllOTCCoinList()
        if coinList.count > 0 {
            var tempEntity : CoinListEntity?
            for entity in coinList {
                if entity.name.uppercased() == publicEntity.otc_default_coin.uppercased() {
                    tempEntity = entity
                    break
                }
            }
            if let defaultCoinEntity = tempEntity {
                return defaultCoinEntity
            }else {
                let first = coinList[0]
                return first
            }
        }
        return CoinListEntity()
    }
    
    //获取所有OTC币种信息
    func getAllOTCCoinList() -> [CoinListEntity]{
        var coinArray:[CoinListEntity] = []
        for entity in publicEntity.coinList{
            if "\(entity.otcOpen)" == "1"{
                coinArray.append(entity)
            }
        }
        return coinArray
    }

    //获取所有BiBao币种信息
    func getAllBiBaoCoinList() -> [CoinListEntity]{
        
        var coinArray:[CoinListEntity] = []
        for entity in publicEntity.coinList{
            if "\(entity.depositOpen)" == "1"{
                coinArray.append(entity)
            }
        }
        
        
        return coinArray
    }
    //获取所有所有的币种信息
    func getAllCoinEntiy() -> [CoinListEntity]{
        return publicEntity.coinList
    }
    
    //根据币种信息获取所有币对信息
    func getCoinMapInfoWithCoin(_ coin : String) -> MarketEntity{
        var entity = MarketEntity()
        for item in publicEntity.market{
            if item.key == coin{
                entity = item
                break
            }
        }
        return entity
    }
    
    //根据币种名字获取币种的所有信息
    func getCoinEntity(_ coin : String) -> CoinListEntity?{
        let array = getAllCoinEntiy()
        for item in array{
            if item.name == coin{
                return item
            }
        }
        return nil
    }
    
    //根据名字获取币种是否需要展示标签栏
    func coinNeedTag(_ coinName:String) -> Bool {
        let followCoinAry = getAllFollowCoinList()
        for item in followCoinAry{
           if item.name == coinName{
               return (item.tagtype == "1" || item.tagtype == "2")
           }
        }
        let array = getAllCoinEntiy()
        for item in array{
            if item.name == coinName{
                return (item.tagtype == "1" || item.tagtype == "2")
            }
        }
        return false
    }
    
    func isCoinForceWithdrawTag(_ coinName:String) -> Bool{
        let followCoinAry = getAllFollowCoinList()
        for item in followCoinAry{
            if item.name == coinName{
                return  item.tagtype == "2"
            }
        }
        
        let array = getAllCoinEntiy()
        for item in array{
            if item.name == coinName{
                return item.tagtype == "2"
            }
        }
        return false
    }
    
    //根据币种拿精度
    func coinPrecision(_ coinName: String) -> Int{
        let entity = self.getCoinEntity(coinName)

        let tmp = entity?.showPrecision
        if let strPrecision = tmp {
            if let precision = Int(strPrecision) {
                return precision
            }
        }
        return 8 //默认币种精度为8
    }
    
    //根据币对名字搜索币种的精度,默认2
    func getCoinPrecision(_ coinMap : String) -> Int{
        var precision = 2
        let array = coinMap.components(separatedBy: "/")
        if array.count > 1{
            if let coinEntity = PublicInfoManager.sharedInstance.getCoinEntity(array[0]) , let i = Int(coinEntity.showPrecision) {
                precision = i
            }
        }
        return precision
    }
    
    //根据币对名字获取币对信息
    func getCoinMapInfo(_ name : String) -> CoinMapEntity{
        let array = getAllCoinMapInfo()
        var entity = CoinMapEntity()
        for item in array{
            if name == item.name{
                entity = item
                break
            }
        }
        return entity
    }
    
    func getCoinMapInfoWithSymbol(_ symbol:String) -> CoinMapEntity {
        
        let array = getAllCoinMapInfo()
        var entity = CoinMapEntity()
        
        for item in array {
            if symbol == item.symbol && item.name != "" {
                
                entity = item
                break
            }
        }
        return entity
    }
    
    //获取所有的币对信息
    func getAllCoinMapInfo() -> [CoinMapEntity]{
        var array : [CoinMapEntity] = []
        for item in publicEntity.market{
            for entity in item.coinMapEntity{
                array.append(entity)
            }
        }
        allCoinMapInfo = array
        return array
    }
    
    //根据币对的买 设置币对里的币种信息
    func setCoinListEntityofCoinMapEntity(){
        let coinMapArray = getAllCoinMapInfo()//所有币对
        let coinArray = publicEntity.coinList//所有币种
        for i in coinMapArray{
            for j in coinArray{
                let name = i.name
                let arr = name.components(separatedBy: "/")
                if arr.count > 1{
                    if arr[0] == j.name{
                        i.coinListEntity = j
                        break
                    }
                }
            }
        }
    }
    
    //获取收藏的所有币种
    func getCollectionCoinMapList(_ names : [String]) -> [CoinMapEntity]{
        var array : [CoinMapEntity] = []
        for name in names{
            let entity = getCoinMapInfo(name)
            if entity.name != ""{
                array.append(entity)
            }
//            else{
//                //如果未发现则取消收藏
//                XUserDefault.cancelCollectionCoinMap(name)
//            }
        }
        return array
    }
    
    //搜索内的币对列表
    func getSearchCoinMapList(_ names : String) -> [CoinMapEntity]{
        var array : [CoinMapEntity] = []
        for item in allCoinMapInfo{
            if item.name.aliasCoinMapName().lowercased().contains(names.lowercased()){
                array.append(item)
            }
        }
        return array
    }
    
    //搜索内的币种列表
    func getSearchCoinList(_ names : String) -> [CoinListEntity]{
        var array : [CoinListEntity] = []
        for item in getAllCoinList(){
            if item.name.lowercased().contains(names.lowercased()){
                array.append(item)
            }
        }
        return array
    }
    
    //获取去交易的实体 顺序USDT BTC ETH
    func getDealEntity(_ name : String) -> CoinMapEntity{
        if name == "USDT"{
            var str = name
            str = "BTC/USDT"
            let entity = getCoinMapInfo(str)
            return entity
        }
        var entity = CoinMapEntity()
        var array : [CoinMapEntity] = []
        for item in allCoinMapInfo{
            let temp = item.name.components(separatedBy: "/")
            if temp.count > 1{

                if temp[0] == name{
                    array.append(item)

                }
            }
           
        }
        for str in ["BTC","USDT","ETH"]{
            for item in array{
                let temp = item.name.components(separatedBy: "/")
                if temp.count > 1{
                    if temp[1].contains(str){
                        entity = item
                        break
                    }
                }
               
            }
            if entity.name != ""{
                break
            }
        }
        if entity.name == "" , array.count > 0{
            entity = array[0]
        }
        return entity
    }
    
    //设置汇率
    func setAllCoinExchangeRate(_ dict : [String : Any]){
        publicEntity.dict["rate"] = dict
        getAllCoinExchangeRate()
    }
    
    //获取所有汇率 ko_KR en_US zh_CN
    func getAllCoinExchangeRate(){
        if let rate = publicEntity.dict["rate"] as? [String : [String : Any]]{
            allCoinExchangeRate = rate
        }
    }
    
    //获取币种的汇率 ,找不到的拿usdt 0符号 1汇率 2位数
    func getCoinExchangeRate(_ name : String) -> (String,String,Int){
        var t : (String , String,Int) = ("","",2)
        if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate[BasicParameter.phoneLanguage],let r = rate[name.uppercased()]{
            if let lang_logo = rate["lang_logo"] as? String{
                t.0 = lang_logo
            }
            
            t.1 = "\(r)"
            t.2 = getRatePrecision()
//            if let coin_precision = rate["coin_precision"] as? Int{
//                t.2 = coin_precision
//            }

        }else if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate["en_US"],let r = rate[name.uppercased()]{
            if let lang_logo = rate["lang_logo"] as? String{
                t.0 = lang_logo
            }
            t.1 = "\(r)"
            t.2 = getRatePrecision()
        }else{
            t.1 = "0"
        }

        return t
    }
    
    //获取法币精度
    func getRatePrecision() -> Int{
        var t = 2
        if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate[BasicParameter.phoneLanguage]{
            if let coin_precision = rate["coin_precision"]{
                if let tmpCoin_precision = Int("\(coin_precision)"){
                    t = tmpCoin_precision
                }
            }
        }else if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate["en_US"]{
            if let coin_precision = rate["coin_precision"]{
                if let tmpCoin_precision = Int("\(coin_precision)"){
                    t = tmpCoin_precision
                }
            }
        }
        return t
    }
    
    //传入CNY、USD等法币符号，返回法币的精度
    func getCurrencyModel(_ fromCurrecyUnit:String) -> EXCurrencyModel{
        let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate
        var currencys:[EXCurrencyModel] = []
        for (_,value) in rate {
            if let model = EXCurrencyModel.mj_object(withKeyValues: value, context: nil) {
                currencys .append(model)
            }
        }
        for model in currencys {
            if model.lang_coin == fromCurrecyUnit {
                return model
            }
        }
        return EXCurrencyModel()
    }
    
    //获取币种的汇率 ,找不到的拿usdt 0符号 1汇率 2位数
    func getOTCCoinExchangeRate(_ name : String) -> (String,String,Int){
        var t : (String , String,Int) = ("","",2)
        if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate[BasicParameter.phoneLanguage],let r = rate[name.uppercased()]{
            
            if let lang_logo = rate["lang_coin"] as? String{
                t.0 = lang_logo
            }

            
            t.1 = "\(r)"
            t.2 = getRatePrecision()

            
        }else if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate["en_US"],let r = rate[name.uppercased()]{
            if let lang_logo = rate["lang_coin"] as? String{
                t.0 = lang_logo
            }
            t.1 = "\(r)"
            t.2 = getRatePrecision()

        }else{
            t.1 = "0"
        }
        
        return t
    }
    
    //获取法币单位 CNY USD等
    func getRateLangCoin() -> String{
        if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate[BasicParameter.phoneLanguage]{
            if let lang_logo = rate["lang_coin"] as? String{
                return lang_logo
            }
        }else if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate["en_US"]{
            if let lang_logo = rate["lang_coin"] as? String{
                return lang_logo
            }
        }
        return ""
    }
    
    //根据symbol获取币对信息
    func getCoinMapWithSymbol(_ symbol : String) -> CoinMapEntity{
        var entity = CoinMapEntity()
        for coinMapEntity in getAllCoinMapInfo(){
            if coinMapEntity.name.replacingOccurrences(of: "/", with: "").lowercased() == symbol{
                entity = coinMapEntity
            }
        }
        return entity
    }
    
    func getUploadImgType() -> ExUploadImgType {
        if self.publicEntity.app_upload_img_type == "0" {
            return .direct
        }else if self.publicEntity.app_upload_img_type == "1" {
            return .oss
        }else {
            return .direct
        }
    }
    
    func getSupportAccounts() ->[EXAccountType] {
        var accountTypes:[EXAccountType] = [.coin]
        if PublicInfoManager.sharedInstance.getFiatTradeOpen() {
            accountTypes.append(.b2c)
        }
        
        if PublicInfoManager.sharedInstance.getLeverOpen() == true {
            accountTypes.append(.leverage)
        }
        
        if self.publicEntity.otcOpen == "1" {
            accountTypes.append(.otc)
        }
        
        if self.publicEntity.contractOpen == "1" {
            accountTypes.append(.contract)
        }
      
        return accountTypes
    }
    
    func isSupportOTC() -> Bool {
        return self.publicEntity.otcOpen == "1"
    }
    
    func isSupportContract() -> Bool {
        return self.publicEntity.contractOpen == "1"
    }
    
    func hasMultiAccounts() -> Bool {
//        return  (self.isSupportOTC() &&  self.isSupportContract() && PublicInfoManager.sharedInstance.getLeverOpen() == true)
        return getSupportAccounts().count > 2
    }
    
    func isCoinIntroduceSupport(_ coinSymbol:String) -> Bool {
        if self.publicEntity.symbol_profile == "1" {
            return self.publicEntity.coinsymbol_introduce_names.contains(coinSymbol)
        }
        return false
    }
    
    func dealChannel(_ channel : String) -> String{
        let arr1 = channel.components(separatedBy: "_")
        if arr1.count > 1{
            let channel1 = arr1[1]
            let arr2 = channel1.components(separatedBy: "_")
            if arr2.count > 0 {
                return arr2[0]
            }
        }
        return channel
    }
    
    func isRequireGoogle() -> Bool  {
        if self.publicEntity.is_enforce_google_auth == "1" {
            return true
        }
        return false
    }
    
    //根据别名获取币对实体
    func getCoinMapWithAliaName(_ name : String) -> CoinMapEntity{
        var coinmapEntity = CoinMapEntity()
        for entity in PublicInfoManager.sharedInstance.getAllCoinMapInfo(){
            if entity.showName.replacingOccurrences(of: "/", with: "").lowercased() == name{
                coinmapEntity = entity
                break
            }
        }
        return coinmapEntity
    }
    
    func getCoinEntityWithAliasName(_ name :String) -> CoinListEntity {
        let all = getAllCoinList()
        let follow = getAllFollowCoinList()
        for item in all {
            if item.showName.lowercased() == name.lowercased() {
                return item
            }
        }
        
        for item in follow {
            if item.showName.lowercased() == name.lowercased() {
                return item
            }
        }
        return CoinListEntity()
    }
    
    //获取自定义title
    func getAppTitles() -> AppPersonalTitleEntity{
        var entity = AppPersonalTitleEntity()
        for item in PublicInfoEntity.sharedInstance.app_personal_title{
            if item.key == BasicParameter.getPhoneLanguage(){
                entity = item
            }
        }
        return entity
    }
    
    //获取法币开关
    func getFiatTradeOpen() -> Bool{
        return PublicInfoEntity.sharedInstance.fiat_trade_open == "1"
    }

    //获取杠杆开关
    func getLeverOpen() -> Bool{
        return PublicInfoEntity.sharedInstance.lever_open == "1" && PublicInfoManager.sharedInstance.getAllLeverArray().count > 0
    }
    
    func getFundRate() -> String {
        let rate = PublicInfoEntity.sharedInstance.fundRate
        return rate
    }
    
    //获取所有支持杠杆的币对
    func getAllLeverArray() -> [CoinMapEntity]{
        var arr = [CoinMapEntity]()
        for item in getAllCoinMapInfo(){
            if item.isOpenLever == "1"{
                arr.append(item)
            }
        }
        arr = arr.sorted(by: { (entity1, entity2) -> Bool in
            return entity1.doubleSort < entity2.doubleSort
        })
        return arr
    }
    
    //获取杠杆默认币种 如果有btcusdt用 没有取第一个
    func getDefaultLeverCoin() -> CoinMapEntity{
        let arr = getAllLeverArray()
        if arr.count > 0{
            for item in arr{
                if item.symbol == "btcusdt"{
                    return item
                }
            }
            return arr[0]
        }
        return CoinMapEntity()
    }
    
    //获取所有杠杆币对的市场
    func getAllLeverMarketArray() -> [String]{
        let arr = getAllLeverArray()
        var market : [String] = []
        for item in arr{
            if market.contains(item.marketName) == false{
                market.append(item.marketName)
            }
        }
        return market
    }
    

    //获取所有从币币种信息
    func getAllFollowCoinList() -> [CoinListEntity]{
        return publicEntity.followCoinList
    }
    
    //获取所有从币币种字典
    func getAllFollowCoinDict() -> [String:[CoinListEntity]]{
        return publicEntity.followCoinDict
    }
    
    //根据主币名字获取从币字典里的数组
    func getFollowCoinList(_ mainCoinSymbol : String) -> [CoinListEntity]{
        var arr : [CoinListEntity] = []
        let dict = getAllFollowCoinDict()
        for key in dict.keys{
            if key.lowercased() == mainCoinSymbol.lowercased(){
                arr = dict[key] ?? []
            }
        }
        return arr
    }
    
    //根据从币名字获取从币的信息
    func getFollowCoin(_ coinName : String) -> CoinListEntity{
        var entity = CoinListEntity()
        for item in getAllFollowCoinList(){
            if item.name.lowercased() == coinName.lowercased(){
                entity = item
            }
        }
        return entity
    }
    //根据语言获取杠杆协议url
    func getLeverProtocolUrl() -> String{
        var url = ""
        if let u = publicEntity.protocol_url_list[BasicParameter.getPhoneLanguage()] as? String{
            url = u
        }
        return url
    }
    
    //获取所有的ETF币对
    func getAllETFCoinMap() -> [CoinMapEntity]{
        var arr : [CoinMapEntity] = []
        for entity in getAllCoinMapInfo(){
            if entity.etfOpen == "1"{
                arr.append(entity)
            }
        }
        return arr
    }
    
    func isNewContracct() -> Bool {
        return publicEntity.isNewContract != "0"
    }
    
    func companyId() -> String {
        return publicEntity.companyId
    }
    
    func coAgentUrl() -> String {
        return publicEntity.co_agent_noticeUrl
    }
    
    func customConfig() -> String {
        return publicEntity.custom_config
    }
    
    //是否开启kyc的认证
    func getKycConfigModel(_ str : String) -> Bool{
        switch str {
        case "1"://充值
            return publicEntity.kycLimitConfigModel.deposite_kyc_open == "1"
        case "2"://提现
            return publicEntity.kycLimitConfigModel.withdraw_kyc_open == "1"
        case "3"://币币交易
            return publicEntity.kycLimitConfigModel.exchange_trade_kyc_open == "1"
        case "4"://杠杆交易
            return publicEntity.kycLimitConfigModel.lever_trade_kyc_open == "1"
        case "5"://合约划转
            return publicEntity.kycLimitConfigModel.contract_transfer_kyc_open == "1"
        default:
            return false
        }
        return false
    }
    
}

extension PublicInfoManager {
    /// 获取 币种-USD 的汇率
    /// - Parameter name: 币种名称, 返回元组 0: 汇率  1: 精确位数
    func sl_getCoinExchangeRate(_ name : String) -> (String, Int) {
        var t: (String, Int) = ("", 2)
        if let rate = PublicInfoManager.sharedInstance.allCoinExchangeRate["en_US"], let r = rate[name.uppercased()] {
            t.0 = "\(r)"
            t.1 = getRatePrecision()
        } else {
            t.0 = "0"
        }
        return t
    }
    
    /// 把所有币种都转换为 法币 总资产
    func convertAssetsToUSD(coinArray: [BTItemCoinModel]) -> String {
        var allUSD = "0"
        for coinModel in coinArray {
            var isContinue = false
            for item  in SLPublicSwapInfo.sharedInstance()!.getTickersWithArea(.CONTRACT_BLOCK_SIMULATION) ?? [] {
                if coinModel.coin_code == item.contractInfo.margin_coin {
                    isContinue = true
                    break
                }
            }
            if isContinue == true {
                continue
            }
            let rate = PublicInfoManager.sharedInstance.getCoinExchangeRate(coinModel.coin_code)
            let property = SLMinePerprotyModel()
            property.conversionContractAssetsWithitemModel(coinModel)
            let allVol = (property.avail_funds ?? "0").adding((property.block_funds ?? "0"), decimals: 8).adding(property.profitOrLoss ?? "0", decimals: 8).adding((property.holdDeposit ?? "0"), decimals: 8) as NSString // 可用+冻结+未实现盈亏+仓位保证金
            let usd = allVol.multiplyingBy1(rate.1, decimals: rate.2)
            allUSD = (allUSD as NSString).adding(usd, decimals: rate.2)
        }
        return allUSD
    }
    
    /// 把所有币种都转换为 BTC 总资产
    func convertAssetsToBTC(coinArray: [BTItemCoinModel]) -> String {
        // 先转换为法币
        let usd = self.convertAssetsToUSD(coinArray: coinArray)
        let btcRate = PublicInfoManager.sharedInstance.getCoinExchangeRate("BTC")
        let btc = (usd as NSString).dividing(by: btcRate.1, decimals: 8) ?? "0"
        return btc
    }
    
    //获取注册的配置项
    func getRegistTypes() -> [String]{
        var arr : [String] = []
        let lan = BasicParameter.getPhoneLanguage()
        for key in publicEntity.userRegist.keys{
            if key == lan{
                if let arr1 = publicEntity.userRegist[key] as? [Any]{
                    for item in arr1{
                        arr.append("\(item)")
                    }
                    break
                }
            }
        }
        return arr
    }
    
}

