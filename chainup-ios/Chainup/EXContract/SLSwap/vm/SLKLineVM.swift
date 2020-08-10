//
//  SLKLineVM.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/9.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// k 线数据
class SLKLineVM: NSObject {
    
    var reciveKLineSocketData: (([CHChartItem]) -> ())?
    
    var lineDataDict : [String : [BTItemModel]] = [:]
    
    /// 当前 k 线数据对应的类型
    var currentKLineDataType: SLFrequencyType = .FREQUENCY_TYPE_15M
    
    private var currentInstrumentID: Int64 = 0
    
    private var lastestTimestamp = NSNumber(value: 0)
    
    override init() {
        super.init()
        self.addKLineSocketNotify()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.unsubscribeKLineScoketData(contract_id: self.currentInstrumentID)
    }
    
    /// 请求 k 线数据
    /// - Parameters:
    ///   - scaleKey: 时间刻度
    ///   - contract_id: 合约 ID
    ///   - complete: 回调
    func requestKLineData(scaleKey: String, contract_id: Int64, complete: @escaping ([CHChartItem]?) -> Void,fullcomplete: @escaping ([CHChartItem]?) -> Void) {
        let kLineDataType = self.convertScaleKey(scaleKey)
        self.requestKLineData(scaleKey:scaleKey ,kLineDataType: kLineDataType, contract_id: contract_id, complete: complete,fullComplete: fullcomplete)
    }
    
    /// 请求 k 线数据
    func requestKLineData(scaleKey: String,kLineDataType: SLFrequencyType, contract_id: Int64, complete: @escaping ([CHChartItem]?) -> Void,fullComplete: @escaping ([CHChartItem]?) -> Void) {
        let handleKLineData: (([BTItemModel]?) -> Void) = {[weak self] itemModelArray in
            guard let mySelf = self else { return}
            guard let _itemModelArray = itemModelArray else {
                complete(nil)
                return
            }
            var itemArr: [CHChartItem] = []
            for model in _itemModelArray {
                let item = CHChartItem()
                item.time = Int(model.timestamp.int32Value)
                
                item.openPrice = CGFloat(BasicParameter.handleDouble(model.open ?? "0"))
                item.highPrice = CGFloat(BasicParameter.handleDouble(model.high ?? "0"))
                item.lowPrice = CGFloat(BasicParameter.handleDouble(model.low ?? "0"))
                item.closePrice = CGFloat(BasicParameter.handleDouble(model.close ?? "0"))
                item.vol = CGFloat(BasicParameter.handleDouble(model.last_qty ?? "0"))
                itemArr.append(item)
            }
            // 记录最新的数据时间
            mySelf.lastestTimestamp = _itemModelArray.first?.timestamp ?? NSNumber(value: 0)
            complete(itemArr)
        }
        let fullHandleKLineData: (([BTItemModel]?) -> Void) = {[weak self] itemModelArray in
            guard let mySelf = self else { return}
            guard let _itemModelArray = itemModelArray else {
                fullComplete(nil)
                return
            }
            var itemArr: [CHChartItem] = []
            for model in _itemModelArray {
                let item = CHChartItem()
                item.time = Int(model.timestamp.int32Value)
                
                item.openPrice = CGFloat(BasicParameter.handleDouble(model.open ?? "0"))
                item.highPrice = CGFloat(BasicParameter.handleDouble(model.high ?? "0"))
                item.lowPrice = CGFloat(BasicParameter.handleDouble(model.low ?? "0"))
                item.closePrice = CGFloat(BasicParameter.handleDouble(model.close ?? "0"))
                item.vol = CGFloat(BasicParameter.handleDouble(model.last_qty ?? "0"))
                itemArr.append(item)
            }
            // 记录最新的数据时间
            mySelf.lastestTimestamp = _itemModelArray.first?.timestamp ?? NSNumber(value: 0)
            fullComplete(itemArr)
        }
        
        BTDrawLineManager.share()?.loadData(withCoin: "",
                                            contractID: contract_id,
                                            type: .LINE_TYPE_FUTURES,
                                            frequencyType: kLineDataType,
                                            previewDataBlock: { (itemModelArray) in
                                                handleKLineData(itemModelArray)
                                                
        },
                                            middleDataBlock: { (itemModelArray) in
                                                
        },
                                            fullDataBlock: { (itemModelArray) in
                                                fullHandleKLineData(itemModelArray)
                                                
        }, failure: { (error) in
            complete(nil)
        })
    }
    
    
    private func convertScaleKey(_ scaleKey: String) -> SLFrequencyType {
        var kLineDataType = SLFrequencyType.FREQUENCY_TYPE_15M
        switch scaleKey {
            case "Line":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_M
            case "1min":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_1M
            case "5min":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_5M
            case "15min":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_15M
            case "30min":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_30M
            case "60min":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_1H
            case "4h":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_4H
            case "1day":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_1D
            case "1week":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_1W
            case "1month":
                kLineDataType = SLFrequencyType.FREQUENCY_TYPE_1MO
            default:
                break
        }
        return kLineDataType
    }
    
    
    // MARK: - Socket
    
    func addKLineSocketNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKLineScoketData), name: NSNotification.Name(rawValue: SLSocketDataUpdate_QuoteBin_Notification), object: nil)
    }
    
    func subscribKLineSocketData(contract_id: Int64, scaleKey: String) {
        let kLineDataType = self.convertScaleKey(scaleKey)
        self.currentKLineDataType = kLineDataType
        self.currentInstrumentID = contract_id
        SLSocketDataManager.sharedInstance().sl_subscribeQuoteBinData(withContractID: contract_id, stockLineDataType: kLineDataType)
    }
    
    func unsubscribeKLineScoketData(contract_id: Int64) {
        SLSocketDataManager.sharedInstance().sl_unsubscribeQuoteBinData(withContractID: contract_id, stockLineDataType: self.currentKLineDataType)
    }
    
    @objc func handleKLineScoketData(notify: NSNotification) {
        guard let userInfo = notify.userInfo else {
            return
        }
        guard let itemModelArray = userInfo["data"] as? Array<BTItemModel> else {
            return
        }
        guard let kLineType = userInfo["kLineDataType"] as? NSNumber else {
            return
        }
        let kLineDataType = kLineType.intValue
        
        // 分时 和 1 分钟 返回的都是 SLFrequencyTypeOneMinute
        if (kLineDataType != self.currentKLineDataType.rawValue) {
            if (kLineDataType == SLFrequencyType.FREQUENCY_TYPE_1M.rawValue && self.currentKLineDataType == SLFrequencyType.FREQUENCY_TYPE_M) {
                
            } else {
                return
            }
        }
        
        var itemArr: [CHChartItem] = []
        for model in itemModelArray {
            if (model.timestamp.int64Value >= self.lastestTimestamp.int64Value) {
                let item = CHChartItem()
                item.time = Int(model.timestamp.int32Value)
                item.openPrice = CGFloat(BasicParameter.handleDouble(model.open))
                item.highPrice = CGFloat(BasicParameter.handleDouble(model.high))
                item.lowPrice = CGFloat(BasicParameter.handleDouble(model.low))
                item.closePrice = CGFloat(BasicParameter.handleDouble(model.close))
                item.vol = CGFloat(BasicParameter.handleDouble(model.last_qty))
                itemArr.append(item)
            }
        }
        self.reciveKLineSocketData?(itemArr)
    }
}
