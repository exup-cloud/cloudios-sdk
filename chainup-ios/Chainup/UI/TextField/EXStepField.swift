//
//  EXStepField.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

/*
 self.textfieldValueChangeBlock?(value)
 self.textfieldDidBeginBlock?()
 self.textfieldDidEndBlock?()
 */

//百分比的输入框,25%/50%/75%/100%.处理最多输入，处理小数点1个，负数处理

import UIKit
import RxSwift

class EXStepField: EXBaseField {
    //传decimal，二选一
//    var decimal:String = "0" {
//        didSet {
//            print(decimal)
//        }
//    }
    @IBOutlet var input: UITextField!
    @IBOutlet var baseLine: UIView!
    let disposebg = DisposeBag()
    let style = EXTextFieldStyle.commonStyle
    @IBOutlet var minusBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    var inputText = ""
    
    fileprivate lazy var presenter : EXTextFieldPresenter = {
        return EXTextFieldPresenter.init(presenter: self)
    }()
    
    override func onCreate() {
        super.onCreate()
        self.layer.cornerRadius = 1.5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.ThemeView.border.cgColor
        minusBtn.setImage(UIImage.themeImageNamed(imageName: "exchange_reduction"), for: .normal)
        plusBtn.setImage(UIImage.themeImageNamed(imageName: "exchange_increase"), for: .normal)

        style.bindHighlight(textField: input, effectView: self,isBorder: true)
        self.presenter.configWithTextField(input: input)
    }
    
    override func setPlaceHolder(placeHolder: String , font : CGFloat = 14) {
        input.setPlaceHolderAtt(placeHolder, color: UIColor.ThemeLabel.colorDark, font: font)
    }
    
    override func setText(text: String) {
        input.text = text
        inputText = text
    }

    @IBAction func stepBack(_ sender: Any) {
        if let coinDecimal = Int(self.decimal) {
            
            let number = NSDecimalNumber.init(value: 1).multiplying(byPowerOf10: Int16(coinDecimal))
            let base = "1" as NSString
            let step = base.dividing(by: number.stringValue, decimals: coinDecimal)
            
            if inputText.isEmpty {
                let nsZero = "0" as NSString
                let nsRst = nsZero.subtracting(step, decimals: coinDecimal)
                if let rst = nsRst {
                    let result = rst as NSString
                    if result.isBig("0") {
                        input.text = rst
                    }else {
                        input.text = "0"
                    }
                    input.sendActions(for: .valueChanged)
                }

            }else {
                let nsZero =  inputText as NSString
                let nsRst = nsZero.subtracting(step, decimals: coinDecimal)
                if let rst = nsRst {
                    let result = rst as NSString
                    if result.isBig("0") {
                        input.text = rst
                    }else {
                        input.text = "0"
                    }
                    input.sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    @IBAction func stepForward(_ sender: Any) {
        if let coinDecimal = Int(decimal) {
            
            let number = NSDecimalNumber.init(value: 1).multiplying(byPowerOf10: Int16(coinDecimal))
            let base = "1" as NSString
            let step = base.dividing(by: number.stringValue, decimals: coinDecimal)
            
            if inputText.isEmpty {
                let nsZero = "0" as NSString
                let nsRst = nsZero.adding(step, decimals: coinDecimal)
                if let rst = nsRst {
                    let result = rst as NSString
                    if result.isBig("0") {
                        input.text = rst
                    }else {
                        input.text = "0"
                    }
                    input.sendActions(for: .valueChanged)
                }
                
            }else {
                let nsZero =  inputText as NSString
                let nsRst = nsZero.adding(step, decimals: coinDecimal)
                if let rst = nsRst {
                    let result = rst as NSString
                    if result.isBig("0") {
                        input.text = rst
                    }else {
                        input.text = "0"
                    }
                    input.sendActions(for: .valueChanged)
                }
            }
        }
    }
}

extension EXStepField :ExTextFieldProtocol {
    
    func textValueChanged(value: String) {
        inputText = value
        self.textfieldValueChangeBlock?(value)
    }
    
    func inputDidBeginEditing() {
        self.hideError(input)
        self.textfieldDidBeginBlock?()
    }
    
    func inputDidEndEditing() {
        self.textfieldDidEndBlock?()
    }
}

extension EXStepField : EXTextFieldConfigurable {
    
    var baseField: UITextField {
        return self.input
    }
    
    var baseHighlight: UIView {
        return self.baseLine
    }
}
