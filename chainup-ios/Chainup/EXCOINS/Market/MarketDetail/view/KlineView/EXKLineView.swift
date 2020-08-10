//
//  EXKLineView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SwiftEventBus

class EXKLineView: NibBaseView {
    var chartXAxisPrevDay = ""
    var kLineDatas : [KLineChartItem] = []
    let infoView = EXKLineSelectedInfoView()
    
    var priceDecimal:String = "8"
    var volumeDecimal:String = "8"
    
    typealias KLineViewTapBlock = () -> ()
    var didTapklineCallback : KLineViewTapBlock?
    
    @IBOutlet var chartsView: CHKLineChartView!
    var zoomed:Bool = false
    
    override func onCreate() {
        config()
    }
    
    func config() {
        chartsView.isInnerYAxis = true 
        chartsView.style = EXKlineStyle.normalStyle()
        chartsView.delegate = self
        chartsView.setSection(hidden: true, byKey:"assistant")
    }
    
    func updateMasterAlgorithm(to:MasterAlgorithmType) {
        switch to {
            case .none:
                break
            case .MA:
                chartsView.setSerie(hidden: false, by: "MA", inSection: 0)
                chartsView.setSerie(hidden: true, by: "BOLL", inSection: 0)
                break
            case .BOLL:
                chartsView.setSerie(hidden: true, by: "MA", inSection: 0)
                chartsView.setSerie(hidden: false, by: "BOLL", inSection: 0)
                break
            case .Hides:
                chartsView.setSerie(hidden: true, by: "MA", inSection: 0)
                chartsView.setSerie(hidden: true, by: "BOLL", inSection: 0)
                break
        }
        chartsView.reloadData()
    }
    
    func updateAssistantAlgorithm(to:AssistantAlgorithmType) {
        if to != .none {
            if to == .Hides {
                chartsView.setSection(hidden: true, byKey:"assistant")
            }else {
                chartsView.setSection(hidden: false, byKey:"assistant")
                chartsView.setSerie(hidden: true, by: CHSeriesKey.macd, inSection: 2)
                chartsView.setSerie(hidden: true, by: CHSeriesKey.kdj, inSection: 2)
                chartsView.setSerie(hidden: true, by: CHSeriesKey.rsi, inSection: 2)
                chartsView.setSerie(hidden: true, by: CHSeriesKey.wr, inSection: 2)

                if to == .MACD {
                    chartsView.setSerie(hidden: false, by: CHSeriesKey.macd, inSection: 2)
                }else if to == .KDJ {
                    chartsView.setSerie(hidden: false, by: CHSeriesKey.kdj, inSection: 2)
                }else if to == .RSI {
                    chartsView.setSerie(hidden: false, by: CHSeriesKey.rsi, inSection: 2)
                }else if to == .WR {
                    chartsView.setSerie(hidden: false, by: CHSeriesKey.wr, inSection: 2)
                }
            }
            self.chartsView.reloadData()
        }
    }
    
    
    func reloadData(data:[KLineChartItem]) {
        self.kLineDatas = data
        
//        self.chartsView.reloadData(toPosition: .end, resetData: false)

        self.chartsView.reloadData(toPosition: CHChartViewScrollPosition.end, resetData: true)
//        if zoomed == false {
//            self.chartsView.zoomChart(by: 20, enlarge: true)
//            zoomed = true
//        }

    }
    
    func reloadPreData(data:[KLineChartItem]) {
        self.kLineDatas = data
        self.chartsView.reloadPreData()
    }
    

    func appendData(data:KLineChartItem) {
        if let lastModel = self.kLineDatas.last {
            if lastModel.id == data.id {
                self.kLineDatas.removeLast()
                self.kLineDatas.append(data)
                chartsView.reloadData()
            }else {
                if  data.id > lastModel.id {
                    self.kLineDatas.append(data)
                    chartsView.reloadData(toPosition: .none, resetData: false)
                }
            }
        }else {
            self.kLineDatas .append(data)
            chartsView.reloadData(toPosition: .none, resetData: false)
        }
    }
    
    func chartSerieSwitchToLineMode(on:Bool) {
        chartsView.setSerie(hidden: !on, by: "Timeline", inSection: 0)
        chartsView.setSerie(hidden: on, by: "Candle", inSection: 0)
        chartsView.setSerie(hidden: on, by: "MA", inSection: 0)
        chartsView.setSerie(hidden: on, by: "KDJ", inSection: 0)
        chartsView.setSerie(hidden: !on, by: "volume", inSection: 0)
        chartsView.reloadData()
    }
    
}

extension EXKLineView : CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return kLineDatas.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let data = self.kLineDatas[index]
        let item = CHChartItem()
        item.time = data.time
        item.openPrice = CGFloat(data.open)
        item.highPrice = CGFloat(data.high)
        item.lowPrice = CGFloat(data.low)
        item.closePrice = CGFloat(data.close)
        item.vol = CGFloat(data.vol)
        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section: CHSection) -> String {
        var strValue = ""
        if section.key == "volume" {
            if value / 1000 > 1 {
                strValue = (value / 1000).ch_toString(maxF: section.decimal).formatAmountUseDecimal(volumeDecimal) + "K"
            } else {
                strValue = value.ch_toString(maxF: section.decimal).formatAmountUseDecimal(volumeDecimal)
            }
        } else {
            strValue = value.ch_toString(maxF: section.decimal).formatAmountUseDecimal(priceDecimal)
        }
        return strValue
    }
    
    /// 自定义X轴坐标值显示内容
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        let data = self.kLineDatas[index]
        let timestamp = data.time
        let dayText = Date.ch_getTimeByStamp(timestamp, format: "MM-dd")
        let timeText = Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
        var text = ""
        //跨日，显示日期
        if dayText != self.chartXAxisPrevDay && index > 0 {
            text = dayText
        } else {
            text = timeText
        }
        self.chartXAxisPrevDay = dayText
        return text
    }
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        return 8
    }
    

    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        self.didTapklineCallback?()
        infoView.removeFromSuperview()
        chart .addSubview(infoView)
        infoView.updateItems(item: item,priceDecimal: priceDecimal,volumeDecimal: volumeDecimal)
        let topOffset = chart.style.padding.top
        let halfIdx = (chart.rangeTo + chart.rangeFrom) / 2
        chart.style.showYAxisLabel = index > halfIdx ? .right : .left
        
        if index > halfIdx {
            infoView.snp.makeConstraints { (make) in
                make.left.equalTo(5)
                make.top.equalTo(topOffset)
                make.width.equalTo(120)
                make.height.equalTo(107)
            }
        }else {
            infoView.snp.makeConstraints { (make) in
                make.right.equalTo(-5)
                make.top.equalTo(topOffset)
                make.width.equalTo(120)
                make.height.equalTo(107)
            }
        }
    }
    
    func kLineChartScrolled() {
        infoView.removeFromSuperview()
    }
    
    func kLineChartPinched() {
        infoView.removeFromSuperview()
    }

    func hideSelection() {
        infoView.removeFromSuperview()
        chartsView.showSelection = false
        chartsView.sightView?.isHidden = true
    }
    
    func kLinePrePage() {
        SwiftEventBus.post(EXEventBusConst.onKlinePrePageTrigger)
    }
    
}
