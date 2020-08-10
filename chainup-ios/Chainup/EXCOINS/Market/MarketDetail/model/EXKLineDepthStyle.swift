//
//  EXKLineDepthStyle.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXKLineDepthStyle: NSObject {
    
    static func depthStyle()->CHKLineChartStyle {
        let style = CHKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor(white: 0.7, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.ThemeView.bg
        //文字颜色
        style.textColor = UIColor.ThemeLabel.colorMedium
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 8, left: 0, bottom: 21, right: 0)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //Y轴显示在右边
        style.showYAxisLabel = .right
        //边界宽度
        style.borderWidth = (0, 0, 0.5, 0)
        
        style.bidChartOnDirection = .left
        style.showXAxisLabel = true 
        style.enableTap = false
        //买方深度图层的颜色 UIColor(hex:0xAD6569) UIColor(hex:0x469777)
        style.bidColor = (UIColor.ThemekLine.up,UIColor.ThemekLine.up15, 1)
        //买方深度图层的颜色
        style.askColor = (UIColor.ThemekLine.down, UIColor.ThemekLine.down15, 1)
        
        return style
    }
}
