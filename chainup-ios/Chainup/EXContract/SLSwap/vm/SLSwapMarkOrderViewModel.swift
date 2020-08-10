//
//  SLSwapMarkOrderViewModel.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapMarkOrderViewModel: NSObject {
    typealias MakerOrderAssetChangeBlock = () -> ()
    var makerOrderAssetChangeBlock:MakerOrderAssetChangeBlock?
    
    typealias MakerOrderUnitChangeBlock = () -> ()
    var makerOrderUnitChangeBlock:MakerOrderUnitChangeBlock?
    /// 合约数据模型
    var itemModel : BTItemModel? {
        didSet {
            if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil { // 未登录状态
                
            } else { // 登录状态
                if itemModel != nil {
                    asset = SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: itemModel!.contractInfo.margin_coin)
                }
            }
            priceUnit = itemModel?.contractInfo?.quote_coin ?? ""
            costUnit = itemModel?.contractInfo?.margin_coin ?? ""
            if leverage_type == .unKnow {
                leverage_type = .pursueType
                leverage = (itemModel?.contractInfo?.default_leverage) ?? "10"
                leverageTypeStr = "contract_Fixed_position".localized()
            }
        }
    }
    
    /// 以币为单位
    var isCoin : Bool {
        return BTStoreData.storeBool(forKey: BT_UNIT_VOL)
    }
    
    /// 价格单位
    var priceUnit = ""
    
    /// 成本单位
    var costUnit = ""
    
    /// 数量单位
    var volumeUnit : String? {
        if isCoin == false {
            return "contract_text_volumeUnit".localized()
        }
        return itemModel?.contractInfo?.base_coin ?? "-"
    }
    
    /// 当前杠杆
    var leverage : String //= ""
    {
        set {
            BTStoreData.setStoreObjectAndKey(newValue, key: "BTLeveageData"+String(itemModel?.instrument_id ?? 0))
        }
        get {
            if leverageArr.count <= 0 {
                return ""
            }
            let data = BTStoreData.storeObject(forKey: "BTLeveageData"+String(itemModel?.instrument_id ?? 0))
            if data == nil {
                BTStoreData.setStoreObjectAndKey("10", key: "BTLeveageData"+String(itemModel?.instrument_id ?? 0))
                return "10"
            }
            guard ((data as? String) != nil) else {
                BTStoreData.setStoreObjectAndKey("10", key: "BTLeveageData"+String(itemModel?.instrument_id ?? 0))
                return "10"
            }
            return data as! String
        }
    }
    
    var leverageTypeStr : String //= "contract_Fixed_position".localized()
    {
        set {
            if newValue.ch_length > 0 {
                BTStoreData.setStoreObjectAndKey(newValue, key: "BTLeveageType"+String(itemModel?.instrument_id ?? 0))
            }
        }
        get {
            if leverageArr.count <= 0 {
                return ""
            }
            let data = BTStoreData.storeObject(forKey: "BTLeveageType"+String(itemModel?.instrument_id ?? 0))
            if data == nil {
                BTStoreData.setStoreObjectAndKey("contract_Fixed_position".localized(), key: "BTLeveageType"+String(itemModel?.instrument_id ?? 0))
                return "contract_Fixed_position".localized()
            }
            guard ((data as? String) != nil) else {
                BTStoreData.setStoreObjectAndKey("contract_Fixed_position".localized(), key: "BTLeveageType"+String(itemModel?.instrument_id ?? 0))
                return "contract_Fixed_position".localized()
            }
            return data as! String
        }
    }
    
    var leverageArr : [String] {
        if itemModel?.contractInfo != nil {
            var arr = itemModel!.contractInfo.leverageArr
            arr?.insert(itemModel!.contractInfo.leverageArr[0], at: 0)
            return arr!
        }
        return []
    }
    
    /// 资产
    var asset : BTItemCoinModel? {
        didSet {
            self.makerOrderAssetChangeBlock?()
        }
    }
    
    /// 杠杆类型
    var leverage_type : BTPositionOpenType {
        set {
        }
        get {
            let data = BTStoreData.storeObject(forKey: "BTLeveageType"+String(itemModel?.instrument_id ?? 0))
            if data == nil {
                return BTPositionOpenType.unKnow
            }
            guard let dataStr = data as? String else {
                return BTPositionOpenType.unKnow
            }
            if dataStr == "contract_Fixed_position".localized() {
                return BTPositionOpenType.pursueType
            } else if dataStr == "contract_Cross_position".localized() {
                return BTPositionOpenType.allType
            } else {
                return BTPositionOpenType.unKnow
            }
        }
    } //= BTPositionOpenType.unKnow
    
    /// 开多订单
    var orderLongModel : BTContractOrderModel?
    /// 开空订单
    var orderShortModel : BTContractOrderModel?
    
    /// 平空仓订单
    var orderCloseShortModel : BTContractOrderModel?
    /// 平多仓订单
    var orderCloseMoreModel : BTContractOrderModel?
    
    /// 买单深度
    var buyDepthOrder : [SLOrderBookModel]? {
        get {
            return SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(10) ?? []
        }
    }
    
    /// 卖单深度
    var sellDepthOrder : [SLOrderBookModel]? {
        get {
            return SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(0) ?? []
        }
    }
    
    /// 持多仓
    var buyPosition : BTPositionModel? {
        get {
            return SLFormula.getUserPosition(with: itemModel!, contractWay: .buy_OpenLong)
        }
    }
    /// 持空仓
    var sellPosition : BTPositionModel? {
        get {
            return SLFormula.getUserPosition(with: itemModel!, contractWay: .sell_OpenShort)
        }
    }
    
    /// 可开多
    var canOpenMore = "0"
    /// 可开空
    var canOpenShort = "0"
    
    /// 可平空
    var canCloseShort : String {
        get {
            var canClose = sellPosition?.cur_qty.bigSub(sellPosition?.freeze_qty) ?? "0"
            if isCoin {
                canClose = SLFormula.ticket(toCoin: canClose, price: sellPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return canClose
        }
    }
    /// 可平多
    var canCloseMore : String {
        get {
            var canClose = buyPosition?.cur_qty.bigSub(buyPosition?.freeze_qty) ?? "0"
            if isCoin {
                canClose = SLFormula.ticket(toCoin: canClose, price: buyPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return canClose
        }
    }
    
    var holdMoreNum : String {
        get {
            var hold = buyPosition?.cur_qty ?? "0"
            if isCoin {
                hold = SLFormula.ticket(toCoin: hold, price: buyPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return hold
        }
    }
    
    var holdShortNum : String {
        get {
            var hold = sellPosition?.cur_qty ?? "0"
            if isCoin {
                hold = SLFormula.ticket(toCoin: hold, price: sellPosition?.markPrice ?? "0", contract: itemModel!.contractInfo)
            }
            return hold
        }
    }
    
    /// 可用
    var canUseAmount = "0"
    
// MARK: - 生成开仓单
    func loadOpenOrder(px: String?,
                       qty: String?,
                       perform_px : String?,
                       contractType: SLSwapMarketOrderViewShowType,
                       priceType: SLSwapMarketOrderPriceType,
                       planPriceType: SLSwapPlanOrderPriceType,
                       timeForce: Int) {
        orderLongModel = caculateOpenOrder(side: .buy_OpenLong,
                                           px: px ?? itemModel?.last_px ?? "0",
                                                qty: qty ?? "0",
                                                perform_px: perform_px ?? "0",
                                                contractType: contractType,
                                                priceType: priceType,
                                                planPriceType: planPriceType,
                                                timeForce:timeForce)
        orderShortModel = caculateOpenOrder(side: .sell_OpenShort,
                                                 px: px ?? itemModel?.last_px ?? "0",
                                                 qty: qty ?? "0",
                                                 perform_px: perform_px ?? "0",
                                                 contractType: contractType,
                                                 priceType: priceType,
                                                 planPriceType: planPriceType,
                                                 timeForce:timeForce)
    }
    func caculateOpenOrder(side : BTContractOrderWay,
                           px: String,
                           qty: String,
                           perform_px : String,
                           contractType: SLSwapMarketOrderViewShowType,
                           priceType: SLSwapMarketOrderPriceType,
                           planPriceType: SLSwapPlanOrderPriceType,
                           timeForce: Int) -> BTContractOrderModel {
        let order = BTContractOrderModel()
        var openOrder : BTContractsOpenModel?
        order.takeFeeRatio = itemModel!.contractInfo.taker_fee_ratio;
        order.instrument_id = itemModel!.instrument_id;
        order.leverage = leverage;
        order.index_px = itemModel!.index_px;
        order.position_type = leverage_type;
        if isCoin {
            if contractType == .planOrder && planPriceType == .limitPlan {
                order.qty = SLFormula.coin(toTicket: qty, price: perform_px, contract: itemModel!.contractInfo).toString(0)
            } else {
                order.qty = SLFormula.coin(toTicket: qty, price: px, contract: itemModel!.contractInfo).toString(0)
            }
        } else {
            order.qty = qty;
        }
        order.side = side;
        if contractType == .normalOrder { // 普通单
            if priceType == .limitPrice { // 限价单
                order.category = .normal
                if px.lessThanOrEqual(BTZERO) {
                    order.px = itemModel!.fair_px
                } else {
                    order.px = px
                }
            } else if (priceType == .marketPrice) { // 市价单
                order.category = .market
                order.px = itemModel!.last_px;
            } else if (priceType == .buyOnePrice) { // 买一单
                order.category = .normal
                if (buyDepthOrder?.count ?? 0 > 0) {
                    let orderM = buyDepthOrder!.first!
                    order.px = orderM.px
                }
            } else if (priceType == .sellOnePrice) { // 卖一单
                order.category = BTContractOrderCategory.normal
                if (sellDepthOrder?.count ?? 0 > 0) {
                    let orderM = sellDepthOrder!.first!
                    order.px = orderM.px
                }
            }
            openOrder = BTContractsOpenModel.init(orderModel: order, contractInfo: itemModel!.contractInfo, assets: asset)
        } else if contractType == .highOrder {
            if priceType == .limitPrice { // 限价单
                if px.lessThanOrEqual(BTZERO) {
                    order.px = itemModel!.fair_px
                } else {
                    order.px = px
                }
            } else if (priceType == .buyOnePrice) { // 买一单
                if (buyDepthOrder?.count ?? 0 > 0) {
                    let orderM = buyDepthOrder!.first!
                    order.px = orderM.px
                }
            } else if (priceType == .sellOnePrice) { // 卖一单
                if (sellDepthOrder?.count ?? 0 > 0) {
                    let orderM = sellDepthOrder!.first!
                    order.px = orderM.px
                }
            }
            if timeForce == 1 {
                order.category = .passive
            } else if timeForce == 2 {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: timeForce)
            } else if timeForce == 3 {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: timeForce)
            }
            openOrder = BTContractsOpenModel.init(orderModel: order, contractInfo: itemModel!.contractInfo, assets: asset)
        } else if contractType == .planOrder { // 计划单
            order.px = px
            if planPriceType == .limitPlan {
                order.category = .normal;
                order.exec_px = perform_px;
            } else if planPriceType == .marketPlan {
                order.category = .market
                order.exec_px = px
            }
            let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
            if idx == 0 { // "最新价格"
                order.trigger_type = .tradePriceType
                if (order.px.lessThan(itemModel!.last_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.last_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else if idx == 1 { // "合理价格"
                order.trigger_type = .markPriceType
                if (order.px.lessThan(itemModel!.fair_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.fair_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else { // "指数价格"
                order.trigger_type = .indexPriceType
                if (order.px.lessThan(itemModel!.index_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.index_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            }
            
            let idx2 = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            if idx2 == 0 {
                order.cycle = NSNumber(value: NSString(string: "1".bigMul("24")).floatValue)
            } else {
                order.cycle = NSNumber(value: NSString(string: "7".bigMul("24")).floatValue)
            }
            openOrder = BTContractsOpenModel.init(orderModel: order, contractInfo: itemModel!.contractInfo, assets: asset)
        }
        
        // 如果资产
        if (asset?.coin_code == itemModel!.contractInfo.margin_coin) {
            canUseAmount = self.asset?.contract_avail.toSmallValue(withContract:itemModel!.instrument_id) ?? "0"
        }
        
        if openOrder != nil {
            if side == .buy_OpenLong {
                var longNum = openOrder?.maxOpenLong ?? "0"
                if isCoin {
                    if contractType == .planOrder {
                        if order.exec_px.greaterThan(BT_ZERO) {
                            longNum = SLFormula.ticket(toCoin: longNum, price: order.exec_px, contract: itemModel!.contractInfo)
                        } else {
                            longNum = SLFormula.ticket(toCoin: longNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    } else {
                        if order.px != nil && order.px.greaterThan(BT_ZERO) {
                            longNum = SLFormula.ticket(toCoin: longNum, price: order.px, contract: itemModel!.contractInfo)
                        } else {
                            longNum = SLFormula.ticket(toCoin: longNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    }
                    longNum = longNum.toSmallValue(withContract: itemModel!.instrument_id)
                } else {
                    longNum = longNum.toString(0)
                }
                canOpenMore = longNum
            } else if side == .sell_OpenShort {
                var shortNum = openOrder?.maxOpenShort ?? "0"
                if isCoin {
                    if contractType == .planOrder {
                        if order.exec_px.greaterThan(BT_ZERO) {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: order.exec_px, contract: itemModel!.contractInfo)
                        } else {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    } else {
                        if order.px != nil && order.px.greaterThan(BT_ZERO) {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price:  order.px, contract: itemModel!.contractInfo)
                        } else {
                            shortNum = SLFormula.ticket(toCoin: shortNum, price: itemModel!.fair_px, contract: itemModel!.contractInfo)
                        }
                    }
                    shortNum = shortNum.toSmallValue(withContract: itemModel!.instrument_id)
                } else {
                    shortNum = shortNum.toString(0)
                }
                canOpenShort = shortNum
            }
            order.avai = openOrder!.orderAvai
            order.freezAssets = openOrder!.freezAssets
            order.balanceAssets = asset?.contract_avail
        }
        return order
    }

// MARK:- 生成平仓单
    func loadCloseOrder(px: String?,
                        qty: String?,
                        perform_px : String?,
                        contractType: SLSwapMarketOrderViewShowType,
                        priceType: SLSwapMarketOrderPriceType,
                        planPriceType: SLSwapPlanOrderPriceType,
                        timeForce: Int){
        // 平空仓单
        orderCloseShortModel = carculteCloseOrder(side: .buy_CloseShort,
                                                  px: px ?? "0",
                                                  qty: qty ?? "0",
                                                  perform_px: perform_px ?? "0",
                                                  contractType: contractType,
                                                  priceType: priceType,
                                                  planPriceType: planPriceType,
                                                  timeForce: timeForce)
        orderCloseShortModel?.pid = self.sellPosition?.pid ?? 0
        // 平多仓单
        orderCloseMoreModel = carculteCloseOrder(side: .sell_CloseLong,
                                                  px: px ?? "0",
                                                  qty: qty ?? "0",
                                                  perform_px: perform_px ?? "0",
                                                  contractType: contractType,
                                                  priceType: priceType,
                                                  planPriceType: planPriceType,
                                                  timeForce: timeForce)
        orderCloseMoreModel?.pid = self.buyPosition?.pid ?? 0
        
    }
    func carculteCloseOrder(side : BTContractOrderWay,
                            px: String,
                            qty: String,
                            perform_px : String,
                            contractType: SLSwapMarketOrderViewShowType,
                            priceType: SLSwapMarketOrderPriceType,
                            planPriceType: SLSwapPlanOrderPriceType,
                            timeForce: Int) -> BTContractOrderModel {
        let order = BTContractOrderModel()
        order.takeFeeRatio = itemModel!.contractInfo.taker_fee_ratio;
        order.instrument_id = itemModel!.instrument_id;
        order.leverage = leverage;
        order.index_px = itemModel!.index_px;
        order.position_type = leverage_type;
        if isCoin {
            if contractType == .planOrder && planPriceType == .limitPlan {
                order.qty = SLFormula.coin(toTicket: qty, price: perform_px, contract: itemModel!.contractInfo).toString(0)
            } else {
                order.qty = SLFormula.coin(toTicket: qty, price: px, contract: itemModel!.contractInfo).toString(0)
            }
        } else {
            order.qty = qty;
        }
        order.side = side;
        if contractType == .normalOrder { // 普通委托
            if priceType == .limitPrice { // 普通限价
                order.category = .normal
                if px.lessThanOrEqual(BTZERO) {
                    order.px = itemModel!.fair_px
                } else {
                    order.px = px
                }
            } else if priceType == .marketPrice { // 普通市价
                order.category = .market
                order.px = itemModel!.last_px;
            } else if (priceType == .buyOnePrice) { // 买一单
                order.category = .normal
                if (buyDepthOrder?.count ?? 0 > 0) {
                    let orderM = buyDepthOrder!.first!
                    order.px = orderM.px
                }
            } else if (priceType == .sellOnePrice) { // 卖一单
                order.category = BTContractOrderCategory.normal
                if (sellDepthOrder?.count ?? 0 > 0) {
                    let orderM = sellDepthOrder!.first!
                    order.px = orderM.px
                }
            }
        } else if contractType == .highOrder {
            if priceType == .limitPrice { // 普通限价
                if px.lessThanOrEqual(BTZERO) {
                    order.px = itemModel!.fair_px
                } else {
                    order.px = px
                }
            } else if (priceType == .buyOnePrice) { // 买一单
                if (buyDepthOrder?.count ?? 0 > 0) {
                    let orderM = buyDepthOrder!.first!
                    order.px = orderM.px
                }
            } else if (priceType == .sellOnePrice) { // 卖一单
                if (sellDepthOrder?.count ?? 0 > 0) {
                    let orderM = sellDepthOrder!.first!
                    order.px = orderM.px
                }
            }
            if timeForce == 1 {
                order.category = .passive
            } else if timeForce == 2 {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: timeForce)
            } else if timeForce == 3 {
                order.category = .normal
                order.time_in_force = NSNumber.init(value: timeForce)
            }
        } else if contractType == .planOrder { // 计划委托
            order.px = px
            if planPriceType == .limitPlan {
                order.category = .normal
                order.exec_px = perform_px
            } else if planPriceType == .marketPlan {
                order.category = .market
                order.exec_px = itemModel!.last_px
            }
            let idx = BTStoreData.storeObject(forKey: ST_TIGGER_PRICE) as? Int ?? 0
            if idx == 0 { // "最新价格"
                order.trigger_type = .tradePriceType
                if (order.px.lessThan(itemModel!.last_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.last_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else if idx == 1 { // "合理价格"
                order.trigger_type = .markPriceType
                if (order.px.lessThan(itemModel!.fair_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.fair_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            } else { // "指数价格"
                order.trigger_type = .indexPriceType
                if (order.px.lessThan(itemModel!.index_px)) { // 计划价格低于当前价格
                    order.trend = .down;
                } else if (order.px.greaterThan(itemModel!.index_px)) {
                    order.trend = .up;
                } else {
                    order.trend = .up;
                }
            }
            
            let idx2 = BTStoreData.storeObject(forKey: ST_DATE_CYCLE) as? Int ?? 0
            if idx2 == 0 {
                order.cycle = NSNumber(value: NSString(string: "1".bigMul("24")).floatValue)
            } else {
                order.cycle = NSNumber(value: NSString(string: "7".bigMul("24")).floatValue)
            }
        }
        // 如果资产
        if (asset?.coin_code == itemModel!.contractInfo.margin_coin) {
            canUseAmount = self.asset?.contract_avail.toSmallValue(withContract:itemModel!.instrument_id) ?? "0"
        }
        return order
    }
}
