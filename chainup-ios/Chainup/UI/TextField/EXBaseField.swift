//
//  EXBaseField.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


enum DecimalType {
    case cny //法币精度
    case coin //币种精度
}


class EXBaseField: NibBaseView {
    var decimalType:DecimalType = .coin
    var symbol:String = ""
    var decimal:String = ""
    var maxLenth:Int = 32 //默认最长32
    var forceInputLenth:Bool = false
    var rxhasError = BehaviorRelay<Bool>(value: false)
    var hasError:Bool {
        get {
            return rxhasError.value
        }
        set {
            rxhasError.accept(newValue)
        }
    }
    
    typealias TxtFieldDidBeginBlock = () -> ()
    typealias TxtFieldDidEndBlock = () -> ()
    typealias TxtFieldValueChanged = (String) -> ()
    var textfieldDidBeginBlock : TxtFieldDidBeginBlock?
    var textfieldDidEndBlock : TxtFieldDidEndBlock?
    var textfieldValueChangeBlock : TxtFieldValueChanged?
    
    func setPlaceHolder(placeHolder:String , font : CGFloat) {}
    func setText(text:String) {}
    func setTitle(title:String) {}
    
//    func showError(){}
//    func hideError(){}
//    
    
    override func onCreate() {
        self.rxhasError.asObservable()
        .subscribe(onNext: { [weak self] error in
            guard let `self` = self else { return }
            if error {
//                self.showError()
            }
        }).disposed(by: self.disposeBag)
    }
    
    
    func hideError(_ textField:UITextField) {
        if let placeHolder = textField.placeholder {
            textField.setPlaceHolderAtt(placeHolder)
        }
    }
//
//    func showError(_ textField:UITextField? = nil , _ effectView:UIView? = nil, _ isBorder:Bool = false) {
//        guard let txtField = textField else {return}
//        guard let effectsView = effectView else {return}
//        if isBorder {
//            effectsView.layer.borderColor = UIColor.ThemeState.fail.cgColor
//        }else {
//            effectsView.backgroundColor = UIColor.ThemeState.fail
//        }
//        if let placeHolder = txtField.placeholder {
//            txtField.setPlaceHolderAtt(placeHolder,color:UIColor.ThemeState.fail)
//        }
//    }
}

extension EXBaseField : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.keyboardType == .numberPad ||
            textField.keyboardType == .decimalPad {
            let nsString = textField.text as NSString?
            let newString = nsString? .replacingCharacters(in: range, with: string)
            
            if let newStr = newString {
                //超长处理，其他往下走逻辑
                if newStr.count > maxLenth {
                    return false
                }
            }
            
            if textField.keyboardType == .numberPad{
                if BusinessTools.number(newString ?? ""){
                    return true
                }else{
                    EXAlert.showFail(msg: "userinfo_tip_inputPhone".localized())
                    return false
                }
            }
            
            if string.isEmpty {
                return true
            }else {
                //如果都没指定,都不管
                if symbol.isEmpty && decimal.isEmpty {
                    return true
                }else {
                    //无论法币精度还是币种精度,点开头都return false
                    let regex = "^[0][0-9]+$"
                    let regexDot = "^[.]+$"
                    let predicate0 = NSPredicate(format: "SELF MATCHES %@", regex)
                    let predicateDot = NSPredicate(format: "SELF MATCHES %@", regexDot)
                    let isZeroPrefix = predicate0.evaluate(with: newString)
                    let isDotPrefix = predicateDot.evaluate(with: newString)
                    if  isDotPrefix || isZeroPrefix {
                        return false
                    }else {
                        var decimalPrecision = 8
                        if decimalType == .coin {
                            if decimal.count > 0 {
                                let decimal = Int(self.decimal)
                                if let symbolDecimal = decimal,symbolDecimal > 0 {
                                    decimalPrecision = symbolDecimal
                                }
                            }else {
                                if let precision = PublicInfoManager.sharedInstance.getCoinEntity(self.symbol)?.showPrecision {
                                    let decimal = Int(precision)
                                    if let symbolDecimal = decimal,symbolDecimal > 0 {
                                        decimalPrecision = symbolDecimal
                                    }
                                }
                            }
                        }else {
                            if decimal.count > 0 {
                                decimalPrecision = Int(decimal) ?? 8
                            }else {
                                decimalPrecision = PublicInfoManager.sharedInstance.getRatePrecision()
                            }
                            
                        }
                        let regex = "^([0-9]*)?(\\.)?([0-9]{0,\(decimalPrecision)})?$"
                        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                        return predicate.evaluate(with: newString)
                    }
                }
            }
        }else {
            if forceInputLenth {
                let nsString = textField.text as NSString?
                let newString = nsString? .replacingCharacters(in: range, with: string)
                
                if let newStr = newString {
                    //超长处理，其他往下走逻辑
                    if newStr.count > maxLenth {
                        return false
                    }
                }
                return true
            }
            return true
        }
    }
}
