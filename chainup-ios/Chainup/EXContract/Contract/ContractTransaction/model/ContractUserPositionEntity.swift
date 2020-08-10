//
//  ContractUserPositionEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractUserPositionModels : EXBaseModel{
    
    var positions : [ContractUserPositionEntity] = []
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.positions = ContractUserPositionEntity.mj_objectArray(withKeyValuesArray: self.positions).copy() as! [ContractUserPositionEntity]
    }
    
}

class ContractUserPositionEntity: EXBaseModel {
    
    var contractId = "" //合约id
    {
        didSet{
            contractContentModel = ContractPublicInfoManager.manager.getContractWithContractId(contractId)
        }
    }
    
    var id = ""//仓位id
    
    var contractContentModel = ContractContentModel()//合约实体id
    
    var contractName = "" // 合约名称
    
    var volume = "" //持有数量
    
    var priceValue = "" //仓位价值
    
    var avgPrice = "" //开仓价格
    
    var indexPrice   = "" //标记价格
    
    var liquidationPrice = "" //预期强平价格
    
    var assignedMargin = "" //保证金（仓位保证金+未盈）无效，使用unrealisedAmountIndex+holdAmount计算保证金。
    var copType = "" //（1：全仓  2：逐仓）
    
    var holdAmount = ""
    
    var unrealisedAmountMarket = "" //市价未实现盈亏
    
    var unrealisedAmountIndex = "" //标记价未实现盈亏（左侧持仓信息取此未盈）
    
    var unrealisedRateMarket = "" //市价未实现盈亏回报率
    
    var unrealisedRateIndex = "" //标记价未实现盈亏回报率（左侧持仓信息取此回报率）
    
    var realisedAmountCurr = "" //当前已实现盈亏
    
    var realisedAmountHistory = "" // 累计已实现盈亏 app端取这个字段展示”已实现盈亏“
    {
        didSet{
            realisedAmountHistory = NSString.init(string: realisedAmountHistory).decimalString(18)
        }
    }
    var leverageLevel = "" //杠杆倍数
    
    var usedMargin = "" //已分配保证金
    
    var canUseMargin = "" //可用保证金
    
    var accountType = "" //此用户此合约合约保证金账号type
    
    var pricePrecision = "" //合约价格精度（价格精度根据这个截取）
    
    var minMargin = "" // 默认追加保证金最小值
    
    var positionCount = "" //仓位数量
    
    var orderCount = "" // 活动订单数量
    
    var side = "" //   BUY SELL 仓位方向
    {
        didSet{
            side_color = side == "BUY" ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        }
    }
    
    var side_color = UIColor.ThemekLine.up
    
    var baseSymbol  = "" //  基准货币
    var valuePrecision = "" //   价值根据这个截取
    var bond = "" //   保证金币种（所有钱单位）
    var symbol = "" //   币对（页面显示把下划线之前都截掉）
    {
        didSet{
            let arr = symbol.components(separatedBy: "_")
            if arr.count > 1{
                symbol = arr[1]
            }
        }
    }
    var quoteSymbol = ""
    
    func priceDecimal() ->Int {
        if let precision = Int(contractContentModel.pricePrecision) {
            return precision
        }
        return 8
    }
    
    func valueDecimal() ->Int? {
        let tmpPrecision = Int(valuePrecision)
        if let precision = tmpPrecision {
            return precision
        }
        return nil
    }
    
    func fmtAvgPrice() ->String {
        let precision = self.priceDecimal()
        if !avgPrice.isEmpty {
            let nsAvg = avgPrice as NSString
            return nsAvg.decimalString1(precision)
        }
        return avgPrice
    }
    
    func fmtIndexPrice() ->String {
        let precision = self.priceDecimal()
        if !indexPrice.isEmpty {
            let nsIdx = indexPrice as NSString
            return nsIdx.decimalString1(precision)
        }
        return indexPrice
    }
    
    func fmtLiqPrice() ->String {
        let precision = self.priceDecimal()
        if !liquidationPrice.isEmpty {
            let nsLiq = liquidationPrice as NSString
            return nsLiq.decimalString1(precision)
        }
        return liquidationPrice
    }
    
    func fmtPriceValue() -> String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !priceValue.isEmpty {
            let nsValue = priceValue as NSString
            return nsValue.decimalString1(precision)
        }
        return priceValue
    }
    
    func fmtCanUsedMargin() ->String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !canUseMargin.isEmpty {
            let nsMargin = canUseMargin as NSString
            return nsMargin.decimalString1(precision)
        }
        return canUseMargin
    }
    
    func fmtUsedMargin() ->String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !usedMargin.isEmpty {
            let nsMargin = usedMargin as NSString
            return nsMargin.decimalString1(precision)
        }
        return usedMargin
    }

    func fmtMargin() -> String{
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !unrealisedAmountIndex.isEmpty {
            let nsMargin = unrealisedAmountIndex as NSString
            let rst = nsMargin.adding(holdAmount, decimals: precision)
            if let realRst = rst {
                return realRst
            }
        }
        return unrealisedAmountIndex
    }
    
    func fmtUnrealisedAmountIndex() ->String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !unrealisedAmountIndex.isEmpty {
            let nsMargin = unrealisedAmountIndex as NSString
            if nsMargin.hasPrefix("-") {
                let newStr = nsMargin.substring(from: 1) as NSString
                return "-\(newStr.decimalString1(precision) ?? "")"
            }
            return "+" + nsMargin.decimalString1(precision)
        }
        return unrealisedAmountIndex
    }
    
    func fmtUnrealisedAmountMarket() ->String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !unrealisedAmountMarket.isEmpty {
            let nsMargin = unrealisedAmountMarket as NSString
            if nsMargin.hasPrefix("-") {
                let newStr = nsMargin.substring(from: 1) as NSString
                return "-\(newStr.decimalString1(precision) ?? "")"
            }
            return "+" + nsMargin.decimalString1(precision)
        }
        return unrealisedAmountMarket
    }
    
    func fmtRealisedAmountIndex() ->String {
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !realisedAmountHistory.isEmpty {
            let nsMargin = realisedAmountHistory as NSString
            if nsMargin.hasPrefix("-") {
                let newStr = nsMargin.substring(from: 1) as NSString
                return "-\(newStr.decimalString1(precision) ?? "")"
            }
            return "+" + nsMargin.decimalString1(precision)
        }
        return realisedAmountHistory
    }
    
    func fmtUnrealisedRateMarket() -> String {
        if !unrealisedRateMarket.isEmpty {
            let nsRate = unrealisedRateMarket as NSString
            let fmtRate = nsRate.decimalString1(2)
            if let rate = fmtRate {
                return "\(rate)%"
            }
        }
        return "\(unrealisedRateMarket)"
    }
    
    func fmtUnrealisedRateIndex() -> String {
        if !unrealisedRateIndex.isEmpty {
            let nsRate = unrealisedRateIndex as NSString
            let fmtRate = nsRate.decimalString1(2)
            if let rate = fmtRate {
                return "\(rate)%"
            }
        }
        return "\(unrealisedRateIndex)"
    }
    
}

