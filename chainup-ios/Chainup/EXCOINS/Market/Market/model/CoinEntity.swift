//
//  CoinEntity.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/6.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class CoinEntity: SuperEntity {

    var name = LanguageTools.getString(key: "market_text_customZone")
    
    var showLine = false
    
}


class CoinDetailsEntity : SuperEntity{
    
    var subject : BehaviorSubject<String> = BehaviorSubject.init(value: "")
    
    var name = ""
    
    var amount = "--"//成交量
    var close = "--"
    var high = "--"
    var low = "--"
    var open = "--"
    var rose = "--"
    var vol = "--"
    var precision = 2
    var volprecision = 2
    var rose1 : Float = -100
    
    var color = UIColor.ThemeLabel.colorMedium
    
    var rmb = ""
    
    var backColor = UIColor.ThemekLine.up
    
    var doubleClose : Double = 0
    
    var nameWidth : CGFloat = 0
    var nameAttrStr: NSMutableAttributedString = NSMutableAttributedString.init(string: "")
    
    var marketTag:String = ""
    var marketTagWidth:CGFloat = 0
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        amount = NSString.init(string: dictContains("amount")).decimalString(volprecision)
        if dictContains("amount") == ""{
            amount = "--"
        }
        close = NSString.init(string: dictContains("close")).decimalString1(precision)
        if dictContains("close") == ""{
            close = "--"
        }
        doubleClose = Double(close) ?? 0
        
        high = NSString.init(string: dictContains("high")).decimalString(precision)
        if dictContains("high") == ""{
            high = "--"
        }
        low = NSString.init(string: dictContains("low")).decimalString(precision)
        if dictContains("low") == ""{
            low = "--"
        }
        open = NSString.init(string: dictContains("open")).decimalString(precision)
        if dictContains("open") == ""{
            open = "--"
        }
        rose = dictContains("rose")
        if rose.contains("-"){
            rose = rose.replacingOccurrences(of: "-", with: "")
            rose = "-" + NSString.init(string: rose).multiplying(by: "100", decimals: 2)
            if let r = Int(rose) , r == 0{
                rose = rose.replacingOccurrences(of: "-", with: "")
            }
        }else{
            rose = NSString.init(string: dictContains("rose")).multiplying(by: "100", decimals: 2)
        }
        if let rose1 = Float(self.rose){
            if rose1 == 0{
                rose = "0.00" + "%"
                backColor = UIColor.ThemekLine.up
                color = UIColor.ThemeLabel.colorMedium
            }else if rose1 < 0{
                rose = rose + "%"
                backColor = UIColor.ThemekLine.down
                color = UIColor.ThemekLine.down
            }else{
                rose = "+" + rose + "%"
                backColor = UIColor.ThemekLine.up
                color = UIColor.ThemekLine.up
            }
            self.rose1 = rose1
        }
        if dictContains("rose") == ""{
            rose = "--"
        }
        vol = NSString.init(string: dictContains("vol")).decimalString(volprecision)
        vol = BasicParameter.dealDataFormate(vol)
        if dictContains("vol") == ""{
            vol = "--"
        }
        
        let array = name.components(separatedBy: "/")
        if array.count > 1{
            let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(array[1])
            if let rmb = NSString.init(string: close).multiplyingBy1(t.1, decimals: t.2,holdZero: true){
                self.rmb = "≈\(t.0)" + rmb
            }
        }
        nameAttrStr = String.getCoinMapAttr(name.aliasCoinMapName(),leftFont:UIFont().themeHNBoldFont(size: 16))
        let symbol = PublicInfoManager.sharedInstance.getCoinMapLeft(name)
        marketTag = PublicInfoManager.sharedInstance.getCoinMarketTag(symbol)
        marketTagWidth = EXTagView.getTagWidth(tag: marketTag,font:UIFont.ThemeFont.TagRegular,padding:2)
        nameWidth = nameAttrStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14), options: .usesLineFragmentOrigin, context: nil).width
//        let tagWidth = tagView.commonTagWidth(titleStr: entity.marketTag)

//        subject.onNext(name)
    }
    
    //先留着这个方法,不影响其他地方
    func nameAttr() -> NSMutableAttributedString{
        let array = name.aliasCoinMapName().components(separatedBy: "/")
        let att = NSMutableAttributedString.init(string:"")
        if array.count >= 2 {
            att.append(NSAttributedString.init(string: array[0], attributes: [NSAttributedStringKey.font : UIFont().themeHNBoldFont(size: 16)]))
            att.append(NSAttributedString.init(string: array[1], attributes: [NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular]))
        }else {
            att.append(NSAttributedString.init(string: name.aliasCoinMapName(), attributes: [NSAttributedStringKey.font :  UIFont.ThemeFont.SecondaryRegular]))
        }
        return att
    }
    
    
}

class EXNoReadEntity : EXBaseModel{
    var noReadMsgCount = "0"//未读数
}
