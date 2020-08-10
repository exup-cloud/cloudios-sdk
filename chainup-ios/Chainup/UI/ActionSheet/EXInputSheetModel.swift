//
//  EXInputSheetModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum SheetFieldItemlStyle {
    case input // 纯输入框
    case sms // 发验证码的
    case paste //黏贴功能
}

class EXInputSheetModel: NSObject {
    typealias ClickBlock = () -> ()//点击block
    var clickBlock : ClickBlock?
    var title:String = ""//输入框的title,没有不写
    var inputText:String = ""//输入框的内容
    var inputPlaceHoloder:String = ""//输入框的placeholder
    var type:SheetFieldItemlStyle = .input
    var keyboard:UIKeyboardType = UIKeyboardType.default
    var key:String = ""
    var enablePrivacy:Bool = false
    var enableTitleMode:Bool = false
    var unit = ""
    
    class func setModel(withTitle:String = "",
                        key:String,
                        inputText:String = "",
                        placeHolder:String = "",
                        type:SheetFieldItemlStyle = .input,
                        privacyMode:Bool = false,
                        keyBoard:UIKeyboardType = .default,
                        unit:String = "") -> EXInputSheetModel{
        let model = EXInputSheetModel.init()
        if withTitle.isEmpty {
            model.enableTitleMode = false
        }else {
            model.enableTitleMode = true
        }
        model.key = key
        model.title = withTitle
        model.inputText = inputText
        model.inputPlaceHoloder = placeHolder
        model.type = type
        model.enablePrivacy = privacyMode
        model.keyboard = keyBoard
        model.unit = unit
        return model
    }
}
