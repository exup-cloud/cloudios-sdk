//
//  ContractCurrentEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractCurrentList : EXBaseModel{
    
    var orderList : [ContractCurrentEntity] = []
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.orderList = ContractCurrentEntity.mj_objectArray(withKeyValuesArray: self.orderList).copy() as! [ContractCurrentEntity]
    }
    
}

class ContractCurrentEntity: EXBaseModel {
    var orderPriceValue = ""
    var pricePrecision = ""
    var symbol = ""
    var ctimeStr = ""
    var ctime = ""
    var side = ""
    var settleTime = ""
    var orderId = ""
    var avgPrice = ""//成交均价
    var multiplier = ""
    var contractType = ""
    var leverageLevel = ""
    var type = ""
    var baseSymbol = ""
    var volume = ""
    var valuePrecision = ""
    var dealVolume = ""
    var price = ""
    var action = ""
    
    var quoteSymbol = ""
    var undealVolume = ""
    var contractId = ""
    {
        didSet{
            contractModel = ContractPublicInfoManager.manager.getContractWithContractId(contractId)
        }
    }
    
    var contractModel = ContractContentModel()
    var contractName = ""
    var status = ""
    {
        didSet{
            switch status{
            case "0":
                status_str = "contract_text_orderWaitInHandicap".localized()
            case "1":
                status_str = "contract_text_orderNewOrder".localized()
            case "2":
                status_str = "contract_text_orderComplete".localized()
            case "3":
                status_str = "contract_text_orderPartSuccess".localized()
            case "4":
                status_str = "contract_text_orderCancel".localized()
            case "5":
                status_str = "contract_text_orderWaitCancel".localized()
            case "6":
                status_str = "contract_text_orderError".localized()
            case "7":
                status_str = "contract_text_orderPartCancel".localized()
            default:
                status_str = ""
            }
        }
    }
    
    var status_str = ""
    
    var statusText = ""
    
    func priceDecimal() ->Int{
        if let precision = Int(contractModel.pricePrecision){
            return precision
        }
        return 8
    }
    
    func getSideStatus() -> String{
        var status = ""
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
            if side == "BUY"{
                if action == "OPEN"{//做多
                    status = "contract_action_long".localized()
                }else{//平多
                    status = "contract_flat_long".localized()
                }
            }else{
                if action == "OPEN"{//做空
                    status = "contract_action_short".localized()
                }else{//平空
                    status = "contract_flat_short".localized()
                }
            }
        }else{
            if side == "BUY"{
                status = "contract_text_long".localized()
            }else{
                status = "contract_text_short".localized()
            }
        }
        return status
    }
    
    func valueDecimal() ->Int {
        let tmpPrecision = Int(valuePrecision)
        if let precision = tmpPrecision {
            return precision
        }
        return 8
    }
    
    //成交价格
    func fmsPrice() -> String{
        let precision = self.priceDecimal()
        if !price.isEmpty {
            let nsRate = price as NSString
            let fmtRate = nsRate.decimalString1(precision)
            if let rate = fmtRate {
                return "\(rate)"
            }
        }
        return "\(price)"
    }
    
    //处理成交均价
    func fmsAvgPrice() -> String{
        let precision = self.priceDecimal()
        if !avgPrice.isEmpty {
            let nsRate = avgPrice as NSString
            let fmtRate = nsRate.decimalString1(precision)
            if let rate = fmtRate {
                return "\(rate)"
            }
        }
        return "\(avgPrice)"
    }
    
    //价值
    func fmsOrderPriceValue() -> String{
        let precision = ContractPublicInfoManager.manager.getBtcPrecision()
        if !orderPriceValue.isEmpty {
            let nsRate = orderPriceValue as NSString
            let fmtRate = nsRate.decimalString1(precision)
            if let rate = fmtRate {
                return "\(rate)"
            }
        }
        return "\(orderPriceValue)"
    }
    
    //处理时间戳
    func fmsctime() -> String{
        let t = DateTools.strToTimeString(ctime)
        return t
    }
    
}
