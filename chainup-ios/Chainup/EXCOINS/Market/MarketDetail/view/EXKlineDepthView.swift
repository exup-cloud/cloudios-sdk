//
//  EXKlineDepthView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/19.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXKlineDepthView: NibBaseView {
    
    var thresholdPrice = 0.15//价格阙值
    
    var depthDatas: [CHKDepthChartItem] = [CHKDepthChartItem]()
    var maxAmount: Float = 0          //最大深度
    
    var precision = "0.01"//精度
    
    var pricevalue = "0"//最新价
    
    var entity = CoinMapEntity()
    
    @IBOutlet var leftLabel: DepthViewTitleLabel!
    @IBOutlet var rightLabel: DepthViewTitleLabel!
    
    @IBOutlet var depthView: CHDepthChartView!
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.MinimumRegular
        label.layoutIfNeeded()
        return label
    }()
    
    override func onCreate() {
        depthView.style = EXKLineDepthStyle.depthStyle()
        depthView.yAxis.referenceStyle = .none
        
        leftLabel.minimumRegular()
        rightLabel.minimumRegular()
        
        leftLabel.textColor = UIColor.ThemeLabel.colorMedium
        rightLabel.textColor = UIColor.ThemeLabel.colorMedium
        leftLabel.text = "contract_text_buyMarket".localized()
        rightLabel.text = "contract_text_sellMarket".localized()
        leftLabel.fillcolor = UIColor.ThemekLine.up
        rightLabel.fillcolor =  UIColor.ThemekLine.down
        leftLabel.textAlignment = .right
        rightLabel.textAlignment = .right
        
        self.addSubview(priceLabel)
        self.bringSubview(toFront: priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(18)
        }

    }
    
    func updatedepthData(models:[CHKDepthChartItem],maxAmount:Float , price : String , entity : CoinMapEntity) {
        self.maxAmount = maxAmount
//        self.depthDatas = models
        self.entity = entity
        self.precision = BasicParameter.strToPrecision(entity.price)
        self.depthDatas = dealDepthDatas(models ,price: price)
        self.depthView.reloadData()
    }
    
    //处理深度列表
    func dealDepthDatas(_ depthDatas : [CHKDepthChartItem] , price : String) -> [CHKDepthChartItem]{
        let tmpDepthDatas = depthDatas
        var bidDepthDatas : [CHKDepthChartItem] = []//买
        var askDepthDatas : [CHKDepthChartItem] = []//卖
        
        for bidItem in tmpDepthDatas{
            if bidItem.type == .bid{
                bidDepthDatas.append(bidItem)
            }
        }
        for askItem in tmpDepthDatas{
            if askItem.type == .ask{
                askDepthDatas.append(askItem)
            }
        }
        
        let priceValue = dealPrice(bidDepthDatas, askDepthDatas: askDepthDatas, price: price)
//        let priceValue = price
        priceLabel.text = (priceValue as NSString).decimalString1(Int(self.entity.price) ?? 4)
        self.pricevalue = priceValue
        
        let standardValues = PublicInfoEntity.sharedInstance.defaultThreshold
//            dealStandardValues(bidDepthDatas, askDepthDatas: askDepthDatas, price: priceValue)
        
        let datas = dealBidsAndAsks(bidDepthDatas, asks: askDepthDatas ,standardValues : standardValues , price: priceValue)
        
        bidDepthDatas = datas.0
        if bidDepthDatas.count > 0{//中间填充买价格
            if let poor = NSString.init(string: "\(bidDepthDatas.last!.value)").subtracting(priceValue, decimals: 10) , poor.contains("-"){
                let item = CHKDepthChartItem()
                item.type = .bid
                item.amount = 0
                item.value = CGFloat(BasicParameter.handleDouble(priceValue))
                bidDepthDatas.append(item)
            }
        }
        
        askDepthDatas = datas.1
        if askDepthDatas.count > 0{//中间填充卖价格
            if let poor = NSString.init(string: priceValue).subtracting("\(askDepthDatas.first!.value)", decimals: 10) , poor.contains("-"){
                let item = CHKDepthChartItem()
                item.amount = 0
                item.value = CGFloat(BasicParameter.handleDouble(priceValue))
                item.type = .ask
                askDepthDatas.insert(item, at: 0)
            }
        }
        
        self.maxAmount = self.getMax(arr1: bidDepthDatas, arr2: askDepthDatas)
        return bidDepthDatas + askDepthDatas
    }
    
    //获取x轴刻度，默认为400
    func getCalibration(_ num : String = "100" , bidDepthDatas : [CHKDepthChartItem] , askDepthDatas : [CHKDepthChartItem]) -> String{
        if askDepthDatas.count == 0 || bidDepthDatas.count == 0{
            return "0"
        }
        var calibration = precision
        if let poor = NSString.init(string:"\(askDepthDatas.last!.value)").subtracting("\(bidDepthDatas.first!.value)", decimals: 10){
            if let tmpCalibration = (poor as NSString).dividing(by: precision, decimals: 10){
                if let p = (tmpCalibration as NSString).subtracting(num, decimals: 10) , p.contains("-"){
                    calibration = precision
                }else{
                    if let div = (poor as NSString).dividing(by:num, decimals: 10){
                        calibration = div
                    }
                }
            }
        }
        return calibration
    }
    
    //获取新的数组
    func addCHKDepthChartItem(bidDepthDatas : [CHKDepthChartItem] , askDepthDatas : [CHKDepthChartItem],bidsValue : String , asksValue : String) ->([CHKDepthChartItem],[CHKDepthChartItem]) {
        var tmpBidDepthDatas = bidDepthDatas
        var tmpAskDepthDatas = askDepthDatas
        
        var bidDatas : [CHKDepthChartItem] = []
        var askDatas : [CHKDepthChartItem] = []
        //获取刻度
        let calibration = BasicParameter.handleDouble(getCalibration(bidDepthDatas: tmpBidDepthDatas, askDepthDatas: tmpAskDepthDatas))
        if calibration == 0{
            return ([],[])
        }
        
        //中间的值
        let askTmpprice = BasicParameter.handleDouble(pricevalue)
        let bidTmpprice = BasicParameter.handleDouble(pricevalue)
        
        //处理卖
        var asksValue = BasicParameter.handleDouble(asksValue)
        while askTmpprice <= asksValue{
            var amount : CGFloat = 0
            if tmpAskDepthDatas.count > 0{
                var removeArr : [CHKDepthChartItem] = []
                for item in tmpAskDepthDatas{
                    if Double(item.value) >= asksValue{
                        amount = amount + item.amount
                        removeArr.append(item)
                    }
                }
                tmpAskDepthDatas.ch_removeObjectsInArray(removeArr)
            }
            
            let item = CHKDepthChartItem()
            item.type = .ask
            item.amount = amount
            item.value = CGFloat(asksValue)
            askDatas.insert(item, at: 0)
            asksValue = asksValue - calibration
        }
        
        //处理残渣
        if tmpAskDepthDatas.count > 0{
            var removeArr : [CHKDepthChartItem] = []
            var amount : CGFloat = 0
            for item in tmpAskDepthDatas{
                amount = amount + item.amount
                removeArr.append(item)
            }
            tmpAskDepthDatas.ch_removeObjectsInArray(removeArr)
            let item = CHKDepthChartItem()
            item.type = .ask
            item.amount = amount
            item.value = CGFloat(askTmpprice)
            askDatas.insert(item, at: 0)
        }
        
        //处理买
        var bidsValue = BasicParameter.handleDouble(bidsValue)
        while bidTmpprice >= bidsValue{
            var amount : CGFloat = 0
            if tmpBidDepthDatas.count > 0{
                var removeArr : [CHKDepthChartItem] = []
                for item in tmpBidDepthDatas{
                    if Double(item.value) <= bidsValue{
                        amount = amount + item.amount
                        removeArr.append(item)
                    }
                }
                tmpBidDepthDatas.ch_removeObjectsInArray(removeArr)
            }
            
            let item = CHKDepthChartItem()
            item.type = .bid
            item.amount = amount
            item.value = CGFloat(bidsValue)
            bidDatas.append(item)
            bidsValue = bidsValue + calibration
        }
        
        //处理残渣
        if tmpBidDepthDatas.count > 0{
            var removeArr : [CHKDepthChartItem] = []
            var amount : CGFloat = 0
            for item in tmpBidDepthDatas{
                amount = amount + item.amount
                removeArr.append(item)
            }
            tmpBidDepthDatas.ch_removeObjectsInArray(removeArr)
            let item = CHKDepthChartItem()
            item.type = .bid
            item.amount = amount
            item.value = CGFloat(bidTmpprice)
            bidDatas.append(item)
        }
        
        return (bidDatas,askDatas)
    }
    
    //处理最新成交价
    func dealPrice(_ bidDepthDatas : [CHKDepthChartItem] , askDepthDatas : [CHKDepthChartItem] , price : String) -> String{
        var priceValue = price
        //买单最大值
        var bidMax = "0"
        if bidDepthDatas.count > 0{
            bidMax = "\(bidDepthDatas.last!.value)"
        }
        //卖单最小值
        var askMin = "0"
        if askDepthDatas.count > 0{
            askMin = "\(askDepthDatas.first!.value)"
        }
        if askMin == "0" && bidMax == "0"{
            return priceValue
        }
        
        //如果最新成交价在买1和卖1中间 则返回最新成交价
        if (bidMax as NSString).ob_compare(price) == .orderedAscending && (askMin as NSString).ob_compare(price) == .orderedDescending{
            return priceValue
        }else if bidMax == "0"{//
            if (askMin as NSString).ob_compare(price) == .orderedDescending{
                return priceValue
            }else{
                return askMin
            }
        }else if askMin == "0"{//
            if (bidMax as NSString).ob_compare(price) == .orderedAscending{
                return priceValue
            }else{
                return bidMax
            }
        }else{//如果不在则买1+卖1除以2 算出最新成交价
            priceValue = ((bidMax as NSString).adding(askMin, decimals: 10) as NSString).dividing(by: "2", decimals: 10)
        }
        return priceValue
    }
    
    //处理买和卖的值
    func dealBidsAndAsks(_ bids : [CHKDepthChartItem] , asks : [CHKDepthChartItem] ,standardValues : String , price : String) -> ([CHKDepthChartItem],[CHKDepthChartItem]){
        var tmpBids : [CHKDepthChartItem] = []
        var tmpAsks : [CHKDepthChartItem] = []
        let tmpthreshold1 = ("1" as NSString).subtracting(standardValues, decimals: 10) // 1-阙值
        let tmpthreshold2 = ("1" as NSString).adding(standardValues, decimals: 10)//1+阙值
        let bidsValue = NSString.init(string: price).multiplying(by: tmpthreshold1 , decimals: 10) as NSString//买最小
        let asksValue = NSString.init(string: price).multiplying(by: tmpthreshold2, decimals: 10) as NSString//卖最大
//        NSLog("\(bidsValue ,     asksValue)")
        for item in bids{
            //作比较
//            let value = NSString.init(string: price).multiplying(by: tmpthreshold1 , decimals: 8) as NSString
            if let poor = Double(bidsValue.subtracting("\(item.value)", decimals: 10)) , poor <= 0{
                if let poor = Double(price.subtracting("\(item.value)", decimals: 10)) , poor >= 0{
                    tmpBids.append(item)
                }
            }
        }
        for item in asks{
            //作比较
//            let value = NSString.init(string: price).multiplying(by: tmpthreshold2, decimals: 8) as NSString
            if let poor = Double(asksValue.subtracting("\(item.value)", decimals: 10)) , poor >= 0{
                if let poor = Double(price.subtracting("\(item.value)", decimals: 10)) , poor <= 0{
                    tmpAsks.append(item)
                }
            }
        }
        
        if tmpBids.count > tmpAsks.count{
            let count = tmpBids.count - tmpAsks.count
            if tmpAsks.count > 0{
                for _ in 0..<count{
                    let item = CHKDepthChartItem()
                    item.value = tmpAsks.last!.value
                    item.type = .ask
                    item.amount = 0
                    tmpAsks.append(item)
                }
            }else{
                for _ in 0..<count{
                    let item = CHKDepthChartItem()
                    item.type = .ask
                    tmpAsks.append(item)
                }
            }
        }else if tmpAsks.count > tmpBids.count{
            let count = tmpAsks.count - tmpBids.count
            if tmpBids.count > 0{
                for _ in 0..<count{
                    let item = CHKDepthChartItem()
                    item.value = tmpBids[0].value
                    item.amount = 0
                    tmpBids.insert(item, at: 0)
                }
            }else{
                for _ in 0..<count{
                    let item = CHKDepthChartItem()
                    tmpBids.insert(item, at: 0)
                }
            }
        }
        
//        var datas =
//        datas.0 = tmpBids
//        datas.1 = tmpAsks
        //两边添加实体
        //如果有买单，则填充一个买单的值
        if tmpBids.count > 0{
            if let bidvalue = Double(bidsValue as String){
                let bidsItem = CHKDepthChartItem()
                bidsItem.value = CGFloat(bidvalue)
                bidsItem.amount = 0
                tmpBids.insert(bidsItem, at: 0)
            }
        }
        
        //如果有卖单，则填充一个卖单的值
        if tmpAsks.count > 0{
            if let askvalue = Double(asksValue as String){
                let asksItem = CHKDepthChartItem()
                asksItem.value = CGFloat(askvalue)
                asksItem.amount = 0
                asksItem.type = .ask
                tmpAsks.append(asksItem)
            }
        }

        return addCHKDepthChartItem(bidDepthDatas: tmpBids, askDepthDatas: tmpAsks , bidsValue : bidsValue as String , asksValue : asksValue as String)
//            (tmpBids,tmpAsks)
    }
    
    //返回的是阙值
    func dealStandardValues(_ bidDepthDatas : [CHKDepthChartItem] , askDepthDatas : [CHKDepthChartItem] , price : String) -> String{
        
        if bidDepthDatas.count == 0 || askDepthDatas.count == 0{
            
        }else{
            //买单最小值
            let bidPrice = "\(bidDepthDatas[0].value)"
            //买单阙值
            let bidthreshold = calculateThreshold(bidPrice, minuend: price , divminuend: price)
            
            //卖单最大值
            let askPrice =  "\(askDepthDatas.last!.value)"
            //卖单阙值
            let askthreshold = calculateThreshold(price, minuend: askPrice, divminuend: price)
            
            //如果阙值都为0 则取标准阙值
            if (bidthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedSame && (askthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedSame{
                return "\(thresholdPrice)"
                //如果买单的阙值 大于 标准阙值 同时 卖单的阙值 大于 标准阙值 则使用最小的阙值
                //公式：a > 15% && b > 15% 则使用 a b中小的
            }else if (bidthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedDescending && (askthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedDescending{
                if (bidthreshold as NSString).ob_compare("\(askthreshold)") == .orderedDescending{
                    return askthreshold
                }else{
                    return bidthreshold
                }
                //如果买单的阙值 小于 标准阙值 同时 卖单的阙值 小于 标准阙值 则使用最大的阙值
                //公式：a < 15% && b < 15% 则使用 a b中大的
            }else if (bidthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedAscending && (askthreshold as NSString).ob_compare("\(thresholdPrice)") == .orderedAscending{
                if (bidthreshold as NSString).ob_compare("\(askthreshold)") == .orderedAscending{
                    return askthreshold
                }else{
                    return bidthreshold
                }
            }else{//其他情况使用标准阙值
                return "\(thresholdPrice)"
            }
        }
        return "\(thresholdPrice)"
    }
    
    //计算阙值 reduction 减数  minuend 被减数
    //公式 (minuend - reduction) / divminuend
    func calculateThreshold(_ reduction : String , minuend : String , divminuend : String) -> String{
        //计算差
        if let poor = (minuend as NSString).subtracting(reduction, decimals: 10){
            if let threshold = (poor as NSString).dividing(by: divminuend, decimals: 10){
                //如果值大于1 则强制使用0.99
                if let p = (threshold as NSString).replacingOccurrences(of: "-", with: "").subtracting("1", decimals: 10) , p.contains("-"){
                    return threshold.replacingOccurrences(of: "-", with: "")
                }else{
                    return "0.99"
                }
            }
        }
        return "\(thresholdPrice)"
    }
    
    //获取最大值
    func getMax(arr1 : [CHKDepthChartItem] , arr2 : [CHKDepthChartItem]) -> Float{
        var max : Float = 0
        
        var max1 : CGFloat = 0
        for item in arr1{
            max1 = max1 + item.amount
        }
        
        var max2 : CGFloat = 0
        for item in arr2{
            max2 = max2 + item.amount
        }
        
        max = max1 > max2 ? Float(max1) : Float(max2)
        
        return max
    }
    
    
}

extension EXKlineDepthView : CHKDepthChartDelegate{
    /// 价格的小数位
    func depthChartOfDecimal(chart: CHDepthChartView) -> Int {
        return Int(self.entity.price) ?? 4
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
        
        //计算一个显示5个辅助线的友好效果
        var step = self.maxAmount * 1.1 / 5
        
//        var j = 0
//        while step / 10 > 1 {
//            j += 1
//            step = step / 10
//        }
//
//        //幂运算
//        var pow: Int = 1
//        if j > 0 {
//            for _ in 1...j {
//                pow = pow * 10
//            }
//        }
        
//        step = Float(lroundf(step) * pow)
        return Double(step)
    }
    
    func depthChart(chart: CHDepthChartView, labelOnYAxisForValue value: CGFloat) -> String {
        if value == 0 {
            return ""
        }
        let strValue = BasicParameter.dealVolumFormate("\(value)")
//            value.ch_toString(maxF: 1)
        return strValue
    }
    
}

class DepthViewTitleLabel :UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 0.0
    private let squareWidth:CGFloat = 6
    
    var fillcolor = UIColor.clear{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(rect: CGRect(x: 0, y:(self.height - squareWidth)/2, width: squareWidth, height: squareWidth))
        self.fillcolor.setFill()
        path.fill()
        super.drawText(in: rect)
    }
    
    override func drawText(in rect: CGRect) {
        let labelInset = UIEdgeInsetsMake(0, leftInset, 0, 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, labelInset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

