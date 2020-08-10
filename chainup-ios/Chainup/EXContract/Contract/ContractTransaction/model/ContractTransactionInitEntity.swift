//
//  ContractTransactionInitEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractTransactionInitEntity: EXBaseModel {

//    var pricePrecision = "4" //   价格精度
    var contractId = "" //  合约id
    var buyOrderCost = "" //买入成本
    var sellOrderCost  = "" //卖出成本
    var buyOrderPriceValue = "" //买入委托价值
    var sellOrderPriceValue = "" //卖出委托价值（实际用来开仓的委托价值）
    var orderPriceValue   = "" //  委托价值（等于 买入委托价值，因为原来用的这个字段，所以放着不动）
    var canUseBalance   = "" //  可用余额
//    var maxLeverageLevel  = "" //   默认杠杆倍数
//    var maxOrderVolume   = "" //  仓位最大限制（整数）
//    var minOrderVolume  = "" //   仓位最小限制
//    var quoteSymbol   = "" //  计价货币
//    var symbol   = "" //  币对
    var liquidationBuyPrice = "" //    做多开仓强平价（市价委托计算用）
    var liquidationSellPrice  = "" //   做空开仓强平价
//    var leverTypes = "" //杠杆显示（1,3,5,10,15,20,100）
    var price  = "" //   价格
    var volume  = "" //   数量
    var level = "" //    杠杆倍数(目前使用此杠杆倍数来显示 显示级别 传入level>持仓level>合约配置最大level)
//    var baseSymbol = ""//基础货币

    var contractConfig = ContractConfigModel()
    
}

class ContractConfigModel : EXBaseModel{
    var baseSymbol = ""//基础货币
    var beginTime = ""
    var bond = ""
    var buyLimitRate = ""
    var contractName = ""
    var contractType = ""
    var ctime = ""
    var feeRateMaker = ""
    var feeRateTaker = ""
    var holdRate = ""
    var id = ""
    var leverTypes = ""//杠杆显示（1,3,5,10,15,20,100）
    var maxLeverageLevel = ""//   默认杠杆倍数
    var maxOrderVolume = ""//  仓位最大限制（整数）
    var minMargin = ""
    var minOrderVolume = ""//   仓位最小限制
    var mtime = ""
    var multiplier = ""
    var pricePrecision = "4"//   价格精度
    var quoteSymbol = ""//  计价货币
    var sellLimitRate = ""
    var settleFeeRate = ""
    var settleTime = ""
    var settlementPrice = ""
    var signType = ""
    var status = ""
    var symbol = ""
}

class ContractTransactionTagPrice : EXBaseModel {
    
    var indexPrice = ""//指数价格
    
    var tagPrice = ""//标记价格
    
}

class ContactTransactionLiquidationRate : EXBaseModel{
    
    var contractId = ""//合约id
    
    var liquidationRate = ""//减仓排名
    {
        didSet{
            let step = liquidationRate.dividing(by: "20", decimals: 2) as NSString
            liquidationRate_num = Int(ceilf(step.floatValue))
        }
    }
    
    var liquidationRate_num = 0
    
}

class ContractTransactionWSEntity : NSObject{
    
    var price = "--"
    
    var volum = "--"
    
    var max = "0"
    
    var side = "1"//1买 2卖
    
    func lenght() -> CGFloat{
        var lenght : CGFloat = 0
        if max != "0" , volum != "--"{
            if let l = NSString.init(string: volum).dividing(by: max, decimals: 8) {
                lenght = CGFloat(Float(l) ?? 0) * SCREEN_WIDTH * (1 - proportion1)
            }
        }
        return lenght
    }
    
}
