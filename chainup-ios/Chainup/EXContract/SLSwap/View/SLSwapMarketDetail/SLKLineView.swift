//
//  SLKLineView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/9.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLKLineView: UIView {
    
    var kLineDataArray: [CHChartItem] = []
    
    /// 价格精度
    var px_unit: Int = 0
    var qty_unit: Int = 0
    
    
    private var chartXAxisPrevDay = ""
    private var kLineDatas: [KLineChartItem] = []
    private let infoView = EXKLineSelectedInfoView()
    
    typealias KLineViewTapBlock = () -> ()
    var didTapklineCallback: KLineViewTapBlock?
        
    var kLineChartView: CHKLineChartView = {
        let view = CHKLineChartView()
        view.isInnerYAxis = true
        view.style = EXKlineStyle.normalStyle()
        view.setSection(hidden: true, byKey:"assistant")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([kLineChartView])
        
        self.initLayout()
        
        self.kLineChartView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.kLineChartView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 更新主图指标
    func updateMasterAlgorithm(to: MasterAlgorithmType) {
        switch to {
            case .none:
                break
            case .MA:
                kLineChartView.setSerie(hidden: false, by: "MA", inSection: 0)
                kLineChartView.setSerie(hidden: true, by: "BOLL", inSection: 0)
                break
            case .BOLL:
                kLineChartView.setSerie(hidden: true, by: "MA", inSection: 0)
                kLineChartView.setSerie(hidden: false, by: "BOLL", inSection: 0)
                break
            case .Hides:
                kLineChartView.setSerie(hidden: true, by: "MA", inSection: 0)
                kLineChartView.setSerie(hidden: true, by: "BOLL", inSection: 0)
                break
        }
        kLineChartView.reloadData()
    }
    
    /// 更新副图指标
    func updateAssistantAlgorithm(to: AssistantAlgorithmType) {
        if to != .none {
            if to == .Hides {
                kLineChartView.setSection(hidden: true, byKey:"assistant")
            } else {
                kLineChartView.setSection(hidden: false, byKey:"assistant")
                kLineChartView.setSerie(hidden: true, by: CHSeriesKey.macd, inSection: 2)
                kLineChartView.setSerie(hidden: true, by: CHSeriesKey.kdj, inSection: 2)
                kLineChartView.setSerie(hidden: true, by: CHSeriesKey.rsi, inSection: 2)
                kLineChartView.setSerie(hidden: true, by: CHSeriesKey.wr, inSection: 2)

                if to == .MACD {
                    kLineChartView.setSerie(hidden: false, by: CHSeriesKey.macd, inSection: 2)
                } else if to == .KDJ {
                    kLineChartView.setSerie(hidden: false, by: CHSeriesKey.kdj, inSection: 2)
                } else if to == .RSI {
                    kLineChartView.setSerie(hidden: false, by: CHSeriesKey.rsi, inSection: 2)
                } else if to == .WR {
                    kLineChartView.setSerie(hidden: false, by: CHSeriesKey.wr, inSection: 2)
                }
            }
            self.kLineChartView.reloadData()
        }
    }
    
    func chartSerieSwitchToLineMode(on: Bool) {
        kLineChartView.setSerie(hidden: !on, by: "Timeline", inSection: 0)
        kLineChartView.setSerie(hidden: on, by: "Candle", inSection: 0)
        kLineChartView.setSerie(hidden: on, by: "MA", inSection: 0)
        kLineChartView.setSerie(hidden: on, by: "KDJ", inSection: 0)
        kLineChartView.setSerie(hidden: !on, by: "volume", inSection: 0)
        kLineChartView.reloadData()
    }
}


// MARK: - Update Data
extension SLKLineView {
    func reloadData(data: [CHChartItem]) {
        self.kLineDataArray = data
        
        self.kLineChartView.reloadData(toPosition: CHChartViewScrollPosition.end, resetData: true)
    }
    
    func appendData(data: [CHChartItem]) {
        let lastestTime = self.kLineDataArray.last?.time ?? 0
        for item in data {
            if item.time > lastestTime {
                if self.kLineDataArray.count > 0 {
                    self.kLineDataArray.append(item)
                    self.kLineChartView.reloadData(toPosition: .none, resetData: false)
                }
            } else if item.time == lastestTime {
                self.kLineDataArray.removeLast()
                self.kLineDataArray.append(item)
                self.kLineChartView.reloadData()
            }
        }
    }
}

// MARK: - CHKLineChartDelegate

extension SLKLineView: CHKLineChartDelegate {
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return self.kLineDataArray.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        if let item = self.kLineDataArray[safe: index] {
            return item
        } else {
            return CHChartItem()
        }
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section: CHSection) -> String {
        let strValue = value.ch_toString(maxF: self.px_unit)
        return strValue
    }
    
    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        self.didTapklineCallback?()
        infoView.removeFromSuperview()
        chart .addSubview(infoView)
        infoView.updateItems(item: item,priceDecimal: String(self.px_unit),volumeDecimal: String(self.qty_unit))
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
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        return self.px_unit
    }
    
    func kLineChartScrolled() {
        infoView.removeFromSuperview()
    }
    
    func kLineChartPinched() {
        infoView.removeFromSuperview()
    }

    func hideSelection() {
        infoView.removeFromSuperview()
        kLineChartView.showSelection = false
        kLineChartView.sightView?.isHidden = true
    }
}
