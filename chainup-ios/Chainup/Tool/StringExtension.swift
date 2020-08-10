//
//  NSStringExtension.swift
//  SDJG
//
//  Created by wangzewu on 16/5/31.
//  Modify  by 王俊 on 17/6/5. swift3.0
//  Copyright © 2016年 sunland. All rights reserved.
//

import Foundation
import UIKit

/*
 "👌🏿".isSingleEmoji // true
 "🙎🏼‍♂️".isSingleEmoji // true
 "👨‍👩‍👧‍👧".isSingleEmoji // true
 "👨‍👩‍👧‍👧".containsOnlyEmoji // true
 "Hello 👨‍👩‍👧‍👧".containsOnlyEmoji // false
 "Hello 👨‍👩‍👧‍👧".containsEmoji // true
 "👫 Héllo 👨‍👩‍👧‍👧".emojiString // "👫👨‍👩‍👧‍👧"
 "👨‍👩‍👧‍👧".glyphCount // 1
 "👨‍👩‍👧‍👧".characters.count // 4
 
 "👫 Héllœ 👨‍👩‍👧‍👧".emojiScalars // [128107, 128104, 8205, 128105, 8205, 128103, 8205, 128103]
 "👫 Héllœ 👨‍👩‍👧‍👧".emojis // ["👫", "👨‍👩‍👧‍👧"]
 
 "👫👨‍👩‍👧‍👧👨‍👨‍👦".isSingleEmoji // false
 "👫👨‍👩‍👧‍👧👨‍👨‍👦".containsOnlyEmoji // true
 "👫👨‍👩‍👧‍👧👨‍👨‍👦".glyphCount // 3
 "👫👨‍👩‍👧‍👧👨‍👨‍👦".characters.count // 8
 */

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

extension String{
    func StringToFloat()->(CGFloat){
        let string = self
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    //是否包含emoji，新版推荐使用containsEmoji
    public func isContainsEmoji(_ text:String?) -> Bool {
        guard text != nil else{
            return false
        }
        
        let string = text! as NSString
        var returnValue: Bool = false
        
        string.enumerateSubstrings(in: NSMakeRange(0, (string as NSString).length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { (substring, substringRange, enclosingRange, stop) -> () in
            
            let objCString:NSString = NSString(string:substring!)
            let hs: unichar = objCString.character(at: 0)
            if 0xd800 <= hs && hs <= 0xdbff
            {
                if objCString.length > 1
                {
                    let ls: unichar = objCString.character(at: 1)
                    let step1: Int = Int((hs - 0xd800) * 0x400)
                    let step2: Int = Int(ls - 0xdc00)
                    let uc: Int = Int(step1 + step2 + 0x10000)
                    
                    if 0x1d000 <= uc && uc <= 0x1f77f
                    {
                        returnValue = true
                    }
                }
            }
            else if objCString.length > 1
            {
                let ls: unichar = objCString.character(at: 1)
                if ls == 0x20e3
                {
                    returnValue = true
                }
            }
            else
            {
                if 0x2100 <= hs && hs <= 0x27ff
                {
                    returnValue = true
                }
                else if 0x2b05 <= hs && hs <= 0x2b07
                {
                    returnValue = true
                }
                else if 0x2934 <= hs && hs <= 0x2935
                {
                    returnValue = true
                }
                else if 0x3297 <= hs && hs <= 0x3299
                {
                    returnValue = true
                }
                else if hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50
                {
                    returnValue = true
                }
            }
        }
        
        return returnValue;
    }
    
    //http%3A%2F%2F172.16.13.30%3A8999%2Findex.html%3Fuid%3D705981%23exam
    //: // # ? 都会转义
    public func wk_URLEncodedString3() -> String{
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted)
        if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return escapedString
        }
        return ""
    }
    
    //返回传入字符串的数  英文算0.5个 例a为0.5 ab为1 汉字算1个 字符同理
    public func convert(toInt:String) -> Int {
        var number = 0
        for character in toInt {
            let characterString = String(character)
            let characterBytes = characterString.cString(using: .utf8)
            if characterBytes?.count == 2 {
                number += 1
            }else if characterBytes?.count == 4 {
                number += 2
            }
        }
        return (number+1)/2
    }
    
    
    
    //MARK: URL添加请求参数 url地址 请求参数 是否追加时间戳
    public func appendRequestParam(_ params :[String:String] , isAppendRandowm : Bool = false) -> String{
        
        //新的URL
        var newUrl = ""
        
        //拼接请求参数
        var paramStr = ""
        params.keys.forEach { (key :String) in
            paramStr = paramStr.appending("&\(key)=\(params[key] == nil ? "" : params[key]! )")
        }
        if paramStr.count > 0{
            paramStr = String(paramStr.suffix(from: paramStr.index(paramStr.startIndex, offsetBy: 1)))
        }
        
        //如果是合法的URL
        if let url = NSURL(string: self){
            
            if let scheme = url.scheme {
                newUrl = newUrl.appending(scheme + "://")
            }
            
            if let host = url.host {
                newUrl = newUrl.appending(host)
            }
            
            if let port = url.port {
                newUrl = newUrl.appending(":\(port)")
            }
            
            if let path = url.path {
                newUrl = newUrl.appending(path)
            }
            
            var joinStr = "?"
            if let query = url.query ,  query != "" {
                newUrl = newUrl.appending(joinStr + query)
                joinStr = "&"
            }
            
            if paramStr.count > 0 {
                newUrl = newUrl.appending(joinStr + paramStr + "\(isAppendRandowm ? "&random=\(arc4random()%10)" : "")")
            }
            
            if let fragment = url.fragment {
                newUrl = newUrl.appending("#"+fragment)
            }
        }
        
        return newUrl
    }
    
    //判断字符高度，需传入字符大小和宽度
    //返回的是宽度和高度
    public  func textSizeWithFont(_ font: UIFont, width:CGFloat,option : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        
        var textSize:CGSize!
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        if size.equalTo(CGSize.zero) {
            
            let attributes = [NSAttributedStringKey.font:font]
            
            textSize = self.size(withAttributes: attributes)
            
        } else {
            
            let attributes = [NSAttributedStringKey.font:font]
            
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            
            textSize = stringRect.size
        }
        return textSize
    }
    
    public func textHeightSizeWithFont(_ font: UIFont, height:CGFloat,option : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        
        var textSize:CGSize!
        
        let size = CGSize(width: 10000, height: height)
        
        if size.equalTo(CGSize.zero) {
            
            let attributes = [NSAttributedStringKey.font:font]
            
            textSize = self.size(withAttributes: attributes)
            
        } else {
            
            let attributes = [NSAttributedStringKey.font:font]
            
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            
            textSize = stringRect.size
        }
        return textSize
    }
    
    /**
     string字符串截取
    */
    public  func extStringSub(_ range : NSRange)->String{
    
        let beforeStr = NSString.init(string: self)
        
        let afterStr = beforeStr.substring(with: range)

        return afterStr as String
    }
    
    /**
     正则查找 形如name=value value部分
     
     - returns: value
     */
    public func regexStringUrlValueOfParam(paramName p :String) -> String {
        let reg = "(?<="+p+"\\=)[^&]+"
    
        let decodeStrUrl = self.removingPercentEncoding!
        let range =  decodeStrUrl.range(of: reg, options: String.CompareOptions.regularExpression, range: nil, locale: nil)
        if range  != nil {
            return String(decodeStrUrl[range!])
        }
        return ""
    }
    /**
     判断字符串是否为纯数字
     
     - returns: value
     */
    public func isNumber() -> Bool{
        if self.count == 0{
            return false
        }else{
            let reg = "[0-9]*"
            let predicate = NSPredicate.init(format: "SELF MATCHES %@", reg)
            let result = predicate.evaluate(with: self)
            return result
        }
    }
    
    /// 字符串截取(可数的闭区间)例子：
    /// let str = "hello word"
    /// let tmpStr = hp[0 ... 5] tmpStr = hello
    /// - Parameter r: 字符串范围
    public subscript (r: CountableClosedRange<Int>) -> String{
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            var endIndex:String.Index?
            if r.upperBound > self.count{
                endIndex = self.index(self.startIndex, offsetBy: self.count)
            }else{
                endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            }
            return String(self[startIndex..<endIndex!])
        }
    }
    
    /// 字符串截取(可数的开区间)例子：
    /// let str = "hello word"
    /// let tmpStr = hp[0 ..< 5] tmpStr = hello
    /// - Parameter r: 字符串范围
    public subscript (r: CountableRange<Int>) -> String{
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            var endIndex:String.Index?
            if r.upperBound > self.count{
                endIndex = self.index(self.startIndex, offsetBy: self.count)
            }else{
                endIndex = self.index(self.startIndex, offsetBy: r.upperBound-1)
            }
            return String(self[startIndex..<endIndex!])
        }
    }
    
    /// 字符串替换(可数的闭区间)
    /// 用法str.sd_replaceSubrange(r: 0..<5, with: "hahahah")
    /// - Parameters:
    ///   - r: range(可数的闭区间)
    ///   - with: 备用替换的String
    public mutating func sd_replaceSubrange(r: CountableClosedRange<Int>,with:String){
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        var endIndex:String.Index?
        if r.upperBound > self.count{
            endIndex = self.index(self.startIndex, offsetBy: self.count)
        }else{
            endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        }
//        self.replaceSubrange(Range<String.Index>(startIndex..<endIndex!), with: with)
    }
}

extension String{
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    //覆盖
    mutating func coverStringWithString(_ str : String ,startIndex : Int = 0 , endindex : Int){
        if self.count > endindex && startIndex < endindex{
            let index = endindex - startIndex
            var tmpstr = ""
            for _ in 0..<index{
                tmpstr = tmpstr + str
            }
            if let range = Range.init(NSRange.init(location: startIndex, length: index), in: self){
                self.replaceSubrange(range, with: tmpstr)
            }
        }else if self.count > startIndex && startIndex < endindex{
            let index = self.count - startIndex
            var tmpstr = ""
            for _ in 0..<index{
                tmpstr = tmpstr + str
            }
            if let range = Range.init(NSRange.init(location: startIndex, length: index), in: self){
                self.replaceSubrange(range, with: tmpstr)
            }
        }
    }
    
}

//regular Expression
extension String {
    
    //判断是否符合交易密码规则，数字+字母，大于等于8位小于等于20
    func isValidTransactionpPwd() -> Bool {
        return isValidRegex(regex: "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
    }
    
    //判断是否符合输入金额、币种数量规则。decimal==0只能输入整数。其余，按decimal规则输入。
    //不能连续输入00，开头不能输入小数点，小数点也只能输入1个
    func isValidInputAmount(decimal:Int = 18) -> Bool {
        if decimal == 0 {
            //只能输入整数
            return isValidRegex(regex: "^\\+?[1-9][0-9]*$")
        }else {
            //通用输入，默认小数点后可输入18位
            let regex = "^[0][0-9]+$"
            let regexDot = "^[.]+$"
            let predicate0 = NSPredicate(format: "SELF MATCHES %@", regex)
            let predicateDot = NSPredicate(format: "SELF MATCHES %@", regexDot)
            
            let isZeroPrefix = predicate0.evaluate(with: self)
            let isDotPrefix = predicateDot.evaluate(with: self)
            
            if  isZeroPrefix || isDotPrefix {
                return false
            }
            
            return isValidRegex(regex: "^([0-9]*)?(\\.)?([0-9]{0,\(decimal)})?$")
        }
    }
    
    private func isValidRegex(regex: String) -> Bool {
        let regex = regex
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let valid = predicate.evaluate(with: self)
        return valid
    }
    
    static func placeholderAttributeString(placeholder:String,fontSize:Int = 12,color:UIColor = UIColor.ThemeLabel.colorLite) -> NSAttributedString {

        let attributedString = NSMutableAttributedString.init(string: placeholder,
                                                              attributes:[NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                                                                          NSAttributedStringKey.foregroundColor: color])
        return attributedString
    }
    
}

enum EXCurrencyUnitFormat {
    case coinFormat
    case fiatFormat
}

extension String {
    
    func localized() -> String{
        return LanguageTools.getString(key: self)
    }
    
    func copyToPasteBoard() {
        UIPasteboard.general.string = self
    }
    
    static func privacyString() -> String{
        return "*****"
    }
    
    //小额限制，展示最小btc的资产配置
    static func limitSatoshi() -> String {
        return "0.0001"
    }
    
    func getCaculatePrice(forSymbol:String,withUnit:Bool = false)->String {
        let currency = PublicInfoManager.sharedInstance.getCoinExchangeRate(forSymbol)
        let unit = currency.0
        let rate = currency.1
        let decimal = currency.2
        let balance = self as NSString
        if let rst =  balance.multiplying(by: rate, decimals: decimal) {
            if withUnit {
                return "≈" + unit + rst
            }else {
                return rst
            }
        }else {
            if withUnit {
                return "≈" + unit + "0"
            }else {
                return "0"
            }
        }
    }
    
    func formatCurrencyMoney(_ symbol:String,holdZero:Bool = true, format:EXCurrencyUnitFormat = .coinFormat) ->String {
        if self.isEmpty {
            return ""
        }
        //币币法币精度
        if format == .coinFormat {
            let currencyModel = PublicInfoManager.sharedInstance.getCurrencyModel(symbol)
            let precion = Int(currencyModel.coin_precision)
        
            let nsAmount = self as NSString
            if holdZero {
                let rst = nsAmount.decimalString1(precion ?? 4)
                if let rightRst = rst {
                    return rightRst
                }
                return self
            }else {
                let rst = nsAmount.decimalString(precion ?? 4)
                if let rightRst = rst {
                    return rightRst
                }
                return self
            }
        }
        //法币法币精度，取法币独立配置
        else if format == .fiatFormat {
            let currencyModel = PublicInfoManager.sharedInstance.getCurrencyModel(symbol)
            let precion = Int(currencyModel.coin_fiat_precision)
        
            let nsAmount = self as NSString
            if holdZero {
                let rst = nsAmount.decimalString1(precion ?? 4)
                if let rightRst = rst {
                    return rightRst
                }
                return self
            }else {
                let rst = nsAmount.decimalString(precion ?? 4)
                if let rightRst = rst {
                    return rightRst
                }
                return self
            }
        }else  {
            //format挂了，直接return
            return self
        }
    }
    
    func formatAmount(_ forSymbol:String, holdZero:Bool = true,isLeverage : Bool = false) -> String {
        if self.isEmpty {
            return ""
        }
       
        var decimal = PublicInfoManager.sharedInstance.coinPrecision(forSymbol)
        if isLeverage {
            decimal = 8
        }
        let nsAmount = self as NSString
        if holdZero {
            let rst = nsAmount.decimalString1(decimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }else {
            let rst = nsAmount.decimalString(decimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }
    }
    
    func formatAmountUseDecimal(_ decimal:String, holdZero:Bool = true) -> String {
        
        if self.isEmpty {
            return ""
        }
        
        if self == "--" {
            return self
        }
        
        if decimal.isEmpty {
            return self
        }
        
        guard let numberDecimal = Int(decimal) else {return self}
        let nsAmount = self as NSString
        if holdZero {
            let rst = nsAmount.decimalString1(numberDecimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }else {
            let rst = nsAmount.decimalString(numberDecimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }
    }
    
    func fmtTimeStr(_ fmt:String = "yyyy-MM-dd HH:mm:ss") -> String {
        var time = TimeInterval.init(0)
        if self.count >= 13{
            if let t = TimeInterval.init(self.prefix(10)){
                time = t
            }
        }else{
            if let t = TimeInterval.init(self){
                time = t
            }
        }
        return DateTools.dateToString(time ,dateFormat:fmt)
    }
    
    //用symbol直接调用获取alias
    func aliasName() -> String {
        if self.isEmpty {
            return self
        }
        if let coinModel = PublicInfoManager.sharedInstance.getCoinEntity(self) {
            //TODO: showname
            if coinModel.name.isEmpty {
                return self
            }
            //TODO: return showname
            return coinModel.showName
        }
        return self
    }
    
    //用name直接调用获取alias
    func aliasCoinMapName() -> String{
        if self.isEmpty {
            return self
        }
        let coinMapModel = PublicInfoManager.sharedInstance.getCoinMapInfo(self)
        if coinMapModel.name.isEmpty{
            return self
        }else{
            return coinMapModel.showName
        }
    }
    
    func decimalNumberWithDouble() -> String{
        if let conversionValue = Double(self){
            let decimalNumberWithDouble = String(conversionValue)
            let decNumber = NSDecimalNumber.init(string: decimalNumberWithDouble as String)
            return "\(decNumber)"
        }
        return self
    }
    
    func hostStr() -> String {
        if let url = URL.init(string: self),let host = url.host {
            var paths = host.components(separatedBy: ".")
            if paths.count == 3 {
                paths.remove(at: 0)
            }
            let domain = paths.joined(separator: ".")
            return domain
        }
        return self
    }
}

extension String {
    func getHeightlineH(width: CGFloat, font: CGFloat, lineH: CGFloat) -> CGFloat {
         
         let paraph = NSMutableParagraphStyle()
         paraph.lineSpacing = lineH
         //样式属性集合
         let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: font),
                           NSAttributedStringKey.paragraphStyle: paraph]
         let rect = self.boundingRect(with: CGSize(width: width, height: 9999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
         return rect.size.height + 1
     }
}

