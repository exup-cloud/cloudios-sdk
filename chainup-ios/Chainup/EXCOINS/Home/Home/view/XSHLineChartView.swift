//
//  XSHLineChartView.swift
//  XSHLineChart
//
//  Created by 宋莹 on 2019/6/28.
//  Copyright © 2019 Abner. All rights reserved.
//

import UIKit

class XSHLineChartView: UIView {
    
    var granLayer = CAGradientLayer()//渐变色
    
    var maskLayer = CAShapeLayer()//填充色
    
    var shapeLayer = CAShapeLayer()//折线

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initLayer()
        addLayer()
    }
    
    func initLayer(){
        granLayer = {//渐变色
            let tempGranLayer = CAGradientLayer()
            tempGranLayer.colors = [UIColor.ThemeView.highlight.cgColor,UIColor.ThemeView.bg.cgColor]
            tempGranLayer.startPoint = CGPoint(x: 0, y: 0)
            tempGranLayer.endPoint = CGPoint(x: 0, y: 1)
            tempGranLayer.locations = [0.0,1.0]
            tempGranLayer.frame = bounds
            return tempGranLayer
        }()
        maskLayer = {//填充色
            let tempMask = CAShapeLayer()
            tempMask.fillColor = UIColor.ThemeView.highlight.withAlphaComponent(0.5).cgColor
            tempMask.frame = granLayer.bounds
            return tempMask
        }()
        shapeLayer = {//折线
            let tempLayer = CAShapeLayer()
            tempLayer.strokeColor = UIColor.ThemeView.highlight.cgColor
            tempLayer.lineWidth = 0.5
            tempLayer.fillColor = UIColor.clear.cgColor
            tempLayer.frame = bounds
            return tempLayer
        }()
    }
    
    func addLayer(){
        layer.addSublayer(granLayer)
        granLayer.mask = maskLayer
        layer.addSublayer(shapeLayer)
    }
    
    func setLayerFrame(){
        granLayer.frame = bounds
        shapeLayer.frame = bounds
        maskLayer.frame = granLayer.bounds
    }
    
    func setColor(_ color : UIColor){
        granLayer.colors = [color.cgColor , UIColor.ThemeView.bg.cgColor]
        maskLayer.fillColor = color.withAlphaComponent(0.5).cgColor
        shapeLayer.strokeColor = color.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
}

/** 计算绘图 */
extension XSHLineChartView{
    func creatLineChart(XDatasArr:[CGFloat],YDatasArr:[CGFloat]) {
        //1 移除旧视图
        self.layer.sublayers?.forEach({ (sublayer) in
            sublayer.removeFromSuperlayer()
        })
        
        //添加新视图
        initLayer()
        addLayer()
        
        //2 计算
        var minY : CGFloat = CGFloat(MAXFLOAT)
        var maxY : CGFloat = 0
        for i in 0...YDatasArr.count-1 {
            if minY >= YDatasArr[i]{
                minY = YDatasArr[i]
            }
            if maxY <= YDatasArr[i]{
                maxY = YDatasArr[i]
            }
        }
        let YMaxHeight = maxY - minY
        if  YMaxHeight <= 0{return}
        let XMargin:CGFloat = self.frame.size.width/CGFloat(XDatasArr.count - 1)
        let YMargin:CGFloat = self.frame.size.height/YMaxHeight
        
        //3 画线
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint(x: 0, y: (maxY - YDatasArr[0])*YMargin))
        for i in 0...XDatasArr.count-1 {
            let addPoint = CGPoint(x: CGFloat(i)*XMargin, y: (maxY - YDatasArr[i])*YMargin)
            bezierPath.addLine(to: addPoint)
        }
        self.shapeLayer.path = bezierPath.cgPath
        
        //4 填色
        bezierPath.addLine(to: CGPoint(x: CGFloat(XDatasArr.count-1)*XMargin, y: self.frame.size.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        self.maskLayer.path = bezierPath.cgPath
        
        
        
    }
}
