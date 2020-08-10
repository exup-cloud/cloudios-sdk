//
//  SLInputLimitDelegate.swift
//  Chainup
//
//  Created by xiaoming on 2020/7/13.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLInputLimitDelegate: NSObject{
    
    var limetValue:Int = 2
    var maxLength:Int = 9
    var decail:String = ""{
        
        didSet {
            resizeLimitValue(px_unit: decail)
        }
    }
    
    func resizeLimitValue(px_unit:String?) {
        
        if px_unit != nil {
            
            if px_unit!.contains("."){
                let pointRange = (px_unit! as NSString).range(of: ".")
                
                let subSting = (px_unit! as NSString).substring(from: pointRange.location)
                self.limetValue = subSting.ch_length - 2
                if limetValue <= 0 {
                    
                    limetValue = 1
                }
                return
            }
            limetValue = 0
            
        }
    }
    
    
}

extension SLInputLimitDelegate:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = textField.text as NSString?
        let newString = nsString? .replacingCharacters(in: range, with: string)
        
        if let newStr = newString {
            //超长处理，其他往下走逻辑
            if newStr.count > maxLength {
                return false
            }
        }
        
        let scanner = Scanner(string: string)
        let numbers : NSCharacterSet
        let pointRange = (textField.text! as NSString).range(of: ".")
        
        if (pointRange.length > 0) && pointRange.length < range.location || pointRange.location > range.location + range.length {
            numbers = NSCharacterSet(charactersIn: "0123456789.")
        }else{
            numbers = NSCharacterSet(charactersIn: "0123456789.")
        }
        
        if textField.text == "" && string == "." {
            return false
        }
        
        let tempStr = textField.text!.appending(string)
        
        let strlen = tempStr.count
        
        if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
            if string == "." {
                return false
            }
            
            if strlen > 0 && (strlen - pointRange.location) > self.limetValue + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return false
            }
        }
        
        let zeroRange = (textField.text! as NSString).range(of: "0")
        if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
            if !(string == "0") && !(string == ".") && textField.text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text = string
                return false
            }else {
                if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if string == "0" {
                        return false
                    }
                }
            }
        }
        //        let buffer : NSString!
        if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
            return false
        }
        
        return true
        
    }
    
}
