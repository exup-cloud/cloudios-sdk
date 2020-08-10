//
//  EXKlineStyle.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXKlineStyle: NSObject {
    //实现一个最基本的样式，开发者可以自由扩展配置样式
    static func normalStyle() -> CHKLineChartStyle {
        let style = CHKLineChartStyle()
        style.isInnerYAxis = true //k线是否在label内
        style.labelFont = UIFont.systemFont(ofSize: 10)
        style.lineColor = UIColor(white: 0.2, alpha: 1)
        style.textColor = UIColor.ThemeLabel.colorMedium
        style.selectedBGColor = UIColor.ThemekLine.tagbg
        style.selectedTextColor = UIColor.ThemeLabel.colorLite
        style.padding = UIEdgeInsets(top: 38, left: 0, bottom:0, right: 0)
        style.backgroundColor = UIColor.clear//背景色
        style.showYAxisLabel = .right
        //配置图表处理算法
        style.algorithms = [
            CHChartAlgorithm.timeline,
            CHChartAlgorithm.sar(4, 0.02, 0.2), //默认周期4，最小加速0.02，最大加速0.2
            CHChartAlgorithm.ma(5),
            CHChartAlgorithm.ma(10),
            CHChartAlgorithm.ma(20),        //计算BOLL，必须先计算到同周期的MA
            CHChartAlgorithm.ma(30),
            CHChartAlgorithm.ema(5),
            CHChartAlgorithm.ema(10),
            CHChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            CHChartAlgorithm.ema(30),
            CHChartAlgorithm.boll(20, 2),
            CHChartAlgorithm.macd(12, 26, 9),
            CHChartAlgorithm.kdj(9, 3, 3),
            CHChartAlgorithm.rsi(14),
            CHChartAlgorithm.macd(12, 26, 9),
            CHChartAlgorithm.wr(14)
        ]
        style.sections = [priceSection(style: style),volumeSection(style: style),trendSection(style: style)]
        return style
    }
    
    static func up() ->(UIColor,Bool) {
        let up = UIColor.ThemekLine.up
        //是否是实心图
        return (up,true)
    }
    
    static func down() ->(UIColor,Bool) {
        let down = UIColor.ThemekLine.down
        //是否是实心图
        return (down,true)
    }
    
    static func priceSection(style:CHKLineChartStyle)->CHSection {
        
        let priceSection = CHSection()
        priceSection.padding = UIEdgeInsetsMake(5, 0, 5, 5)
        priceSection.backgroundColor = style.backgroundColor
        priceSection.titleShowOutSide = true
        priceSection.valueType = .master
        priceSection.key = "master"
        priceSection.hidden = false
        priceSection.ratios = 3 //占比
        priceSection.xAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        priceSection.yAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        /// 时分线
        //
        if EXHomeViewModel.homepageStyle() == .king {
            priceSection.logo = "com.chainup.exchange.DAKINGS"
        }else {
            if EXThemeManager.isNight() {
                priceSection.logo =  PublicInfoEntity.sharedInstance.app_klinelogo_model.app_img_night
            }else {
                priceSection.logo = PublicInfoEntity.sharedInstance.app_klinelogo_model.app_img
            }
        }

        let timelineSeries = CHSeries.getTimelinePrice(
            color: UIColor.ThemeView.highlight,
            section: priceSection,
            showGuide: true,
            ultimateValueStyle:.none,
            lineWidth: 1)
    
        timelineSeries.hidden = true
        
        /// 蜡烛线
        let priceSeries = CHSeries.getCandlePrice(
            upStyle: up(),
            downStyle: down(),
            titleColor: UIColor(white: 0.8, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .arrow(UIColor(white: 0.8, alpha: 1)))
        
        priceSeries.showTitle = true
        
        priceSeries.chartModels.first?.ultimateValueStyle = .arrow(UIColor.ThemeLabel.colorLite)
        
        
        let priceMASeries = CHSeries.getPriceMA(
            isEMA: false,
            num: [5,10,30],
            colors: [
                UIColor.ThemekLine.yellow,
                UIColor.ThemekLine.green,
                UIColor.ThemekLine.purple,
                ],
            section: priceSection)
        priceMASeries.hidden = false
        
        let priceEMASeries = CHSeries.getPriceMA(
            isEMA: true,
            num: [5,10,30],
            colors: [
                UIColor.ch_hex(0xDDDDDD),
                UIColor.ThemekLine.yellow,
                UIColor.ThemekLine.green,
                ],
            section: priceSection)
        
        priceEMASeries.hidden = true
        
        let priceBOLLSeries = CHSeries.getBOLL(
            UIColor.ThemekLine.yellow,
            ubc: UIColor.ThemekLine.green,
            lbc: UIColor.ThemekLine.purple,
            section: priceSection)
        
        priceBOLLSeries.hidden = true
        
        let priceSARSeries = CHSeries.getSAR(
            upStyle: up(),
            downStyle: down(),
            titleColor: UIColor.ch_hex(0xDDDDDD),
            section: priceSection)
        
        priceSARSeries.hidden = true
        
        priceSection.series = [
            timelineSeries,
            priceSeries,
            priceMASeries,
            priceEMASeries,
            priceBOLLSeries,
            priceSARSeries
        ]
        return priceSection
    }
    
    static func volumeSection(style:CHKLineChartStyle)-> CHSection {
        let volumeSection = CHSection()
        volumeSection.backgroundColor = style.backgroundColor
        volumeSection.valueType = .assistant
        volumeSection.key = "volume"
        volumeSection.hidden = false
        volumeSection.ratios = 1
        volumeSection.yAxis.tickInterval = 1
        volumeSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 5)
        let volumeSeries = CHSeries.getDefaultVolume(upStyle: up(), downStyle: down(), section: volumeSection)
        volumeSection.xAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        volumeSection.yAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        
        let volumeMASeries = CHSeries.getVolumeMA(
            isEMA: false,
            num: [5,10],
            colors: [
                UIColor.ch_hex(0xDDDDDD),
                UIColor.ThemekLine.yellow,
                UIColor.ThemekLine.green,
                ],
            section: volumeSection)
        
        let volumeEMASeries = CHSeries.getVolumeMA(
            isEMA: true,
            num: [5,10],
            colors: [
                UIColor.ch_hex(0xDDDDDD),
                UIColor.ThemekLine.yellow,
                UIColor.ThemekLine.green,
                ],
            section: volumeSection)
        
        volumeEMASeries.hidden = true
        volumeSection.series = [volumeSeries, volumeMASeries, volumeEMASeries]
        return volumeSection
    }
    
    static func trendSection(style:CHKLineChartStyle)-> CHSection{
        
        let trendSection = CHSection()
        trendSection.backgroundColor = style.backgroundColor
        trendSection.valueType = .assistant
        trendSection.key = "assistant"
        trendSection.hidden = false
        trendSection.ratios = 1
        trendSection.paging = false
        trendSection.yAxis.tickInterval = 1
        trendSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        trendSection.xAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        trendSection.yAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        
        let kdjSeries = CHSeries.getKDJ(
            UIColor.ch_hex(0xDDDDDD),
            dc: UIColor.ThemekLine.yellow,
            jc: UIColor.ThemekLine.green,
            section: trendSection)
        kdjSeries.title = "KDJ(9,3,3)"
        
        let macdSeries = CHSeries.getMACD(
            UIColor.ch_hex(0xDDDDDD),
            deac: UIColor.ThemekLine.yellow,
            barc: UIColor.ThemekLine.green,
            upStyle: up(), downStyle: down(),
            section: trendSection)
        macdSeries.title = "MACD(12,26,9)"
        macdSeries.symmetrical = true
        
        let rsiSeries = CHSeries.getRSI(num: [14], colors: [UIColor.ThemekLine.yellow], section: trendSection)
        rsiSeries.symmetrical = true
        
        let wrSeries = CHSeries.getWR(num: [14], colors: [UIColor.ThemekLine.yellow], section: trendSection)
        wrSeries.title = "WR(14)"

        trendSection.series = [
            kdjSeries,
            macdSeries,
            rsiSeries,
            wrSeries]
        return trendSection
    }
    
}
