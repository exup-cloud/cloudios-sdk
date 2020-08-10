//
//  SLKLineDepthView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// k 线图中的深度图
class SLKLineDepthView: UIView {
    
    private var depthModel: BTDepthModel?
    
    /// 价格阙值
    var thresholdPrice = 0.15
    
    /// 深度数据
    var depthDatas: [CHKDepthChartItem] = [CHKDepthChartItem]()
    
    /// 最大深度
    var maxAmount: Double = 0
    
    /// 精度
    var precision = "0.01"
    
    /// 最新价
    var pricevalue = "0"
    
    private lazy var titleView: UIStackView = UIStackView()
    
    /// 买盘
    private lazy var buyLabel: DepthViewTitleLabel = DepthViewTitleLabel(text: "contract_text_buyMarket".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    
    /// 卖盘
    private lazy var sellLabel: DepthViewTitleLabel = DepthViewTitleLabel(text: "contract_text_sellMarket".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    
    /// 深度图
    private lazy var depthView: CHDepthChartView = {
        let view = CHDepthChartView()
        view.delegate = self
        view.style = EXKLineDepthStyle.depthStyle()
        view.yAxis.referenceStyle = .none
        return view
    }()
    
    /// 中间价格
    private lazy var priceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buyLabel.fillcolor = UIColor.ThemekLine.up
        sellLabel.fillcolor =  UIColor.ThemekLine.down
        
        titleView.addSubViews([buyLabel, sellLabel])
        
        self.addSubViews([depthView, priceLabel, titleView])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        titleView.snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        buyLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        sellLabel.snp.makeConstraints { (make) in
           make.right.centerY.equalToSuperview()
        }
        depthView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleView.snp_bottom).offset(2)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(18)
        }
    }
}


// MARK: - Update Data

extension SLKLineDepthView {
    func updateView(depthModel: BTDepthModel, lastestPrice: String) {
        self.depthModel = depthModel
        self.handleDepthData(lastestPrice: lastestPrice)
        self.depthView.reloadData()
    }
    
    private func handleDepthData(lastestPrice: String) {
        guard let _depthModel = self.depthModel else {
            return
        }
        let count = min(_depthModel.buys.count, _depthModel.sells.count)
        var sumBuysVol: Double = 0
        var sumSellsVol: Double = 0
        var bidDepthDatas: [CHKDepthChartItem] = [] // 买
        var askDepthDatas: [CHKDepthChartItem] = [] // 卖
        for i in 0..<count {
            let buyItem = CHKDepthChartItem()
            let sellItem = CHKDepthChartItem()
            let buyModel = _depthModel.buys[i]
            let sellModel = _depthModel.sells[i]
            buyItem.type = .bid
            buyItem.value = CGFloat(BasicParameter.handleDouble(buyModel.px))
            buyItem.amount = CGFloat(BasicParameter.handleDouble(buyModel.qty))
            sellItem.type = .ask
            sellItem.value = CGFloat(BasicParameter.handleDouble(sellModel.px))
            sellItem.amount = CGFloat(BasicParameter.handleDouble(sellModel.qty))
            
            sumBuysVol += BasicParameter.handleDouble(buyModel.qty)
            sumSellsVol += BasicParameter.handleDouble(sellModel.qty)
            
            bidDepthDatas.append(buyItem)
            askDepthDatas.append(sellItem)
        }
        
        let rbidDepthDatas = bidDepthDatas.reversed() as [CHKDepthChartItem]
        
        self.pricevalue = self.dealPrice(rbidDepthDatas, askDepthDatas, lastestPrice: lastestPrice)
        self.priceLabel.text = self.pricevalue
        self.depthDatas = rbidDepthDatas + askDepthDatas
        self.maxAmount = max(sumBuysVol, sumSellsVol)
    }
    
    /// 处理最新成交价
    private func dealPrice(_ bidDepthDatas: [CHKDepthChartItem], _ askDepthDatas: [CHKDepthChartItem], lastestPrice: String) -> String {
        var priceValue = lastestPrice
        // 买单最大值
        var bidMax = "0"
        if bidDepthDatas.count > 0 {
            bidMax = "\(bidDepthDatas.last!.value)"
        }
        // 卖单最小值
        var askMin = "0"
        if askDepthDatas.count > 0 {
            askMin = "\(askDepthDatas.first!.value)"
        }
        if askMin == "0" && bidMax == "0" {
            return priceValue
        }
        
        // 如果最新成交价在买1和卖1中间 则返回最新成交价
        if (bidMax as NSString).ob_compare(lastestPrice) == .orderedAscending && (askMin as NSString).ob_compare(lastestPrice) == .orderedDescending {
            return priceValue
        } else if bidMax == "0"{//
            if (askMin as NSString).ob_compare(lastestPrice) == .orderedDescending {
                return priceValue
            } else {
                return askMin
            }
        } else if askMin == "0" {//
            if (bidMax as NSString).ob_compare(lastestPrice) == .orderedAscending {
                return priceValue
            } else {
                return bidMax
            }
        } else {//如果不在则买1+卖1除以2 算出最新成交价
            priceValue = ((bidMax as NSString).adding(askMin, decimals: 10) as NSString).dividing(by: "2", decimals: 10)
        }
        return priceValue
    }
}


// MARK: - CHKDepthChartDelegate
extension SLKLineDepthView: CHKDepthChartDelegate {
    /// 价格的小数位
    func depthChartOfDecimal(chart: CHDepthChartView) -> Int {
        return 2
    }
    
    /// 量的小数位
    func depthChartOfVolDecimal(chart: CHDepthChartView) -> Int {
        return 6
    }
    
    /// 图表的总条数
    /// 总数 = 买方 + 卖方
    /// - Parameter chart:
    /// - Returns:
    func numberOfPointsInDepthChart(chart: CHDepthChartView) -> Int {
        return self.depthDatas.count
    }
    
    /// 每个点显示的数值项
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    /// - Returns:
    func depthChart(chart: CHDepthChartView, valueForPointAtIndex index: Int) -> CHKDepthChartItem {
        return self.depthDatas[index]
    }
    
    /// y轴以基底值建立
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func baseValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        return 0
    }
    
    /// y轴以基底值建立后，每次段的增量
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func incrementValueForYAxisInDepthChart(in depthChart: CHDepthChartView) -> Double {
        // 计算一个显示5个辅助线的友好效果
        let step = self.maxAmount * 1.1 / 5
        return Double(step)
    }
    
    /**
     获取图表Y轴的显示的内容
    
    - parameter chart:
    - parameter value:     计算得出的y值
    
    - returns:
    */
    func depthChart(chart: CHDepthChartView, labelOnYAxisForValue value: CGFloat) -> String {
        if value == 0 {
            return ""
        }
        let strValue = BasicParameter.dealVolumFormate("\(value)")
        return strValue
    }
}
