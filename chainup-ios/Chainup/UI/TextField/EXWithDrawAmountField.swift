//
//  EXWithDrawAmountField.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/14.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXWithDrawAmountField: EXBaseField {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var input: UITextField!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var leftSymbolLabel: UILabel!
    @IBOutlet var rightSendAllLabel: UILabel!
    @IBOutlet var baseLine: UIView!
    @IBOutlet weak var verticalLine: UIView!
    var amount:String = ""
    
    let style = EXTextFieldStyle.commonStyle
    fileprivate lazy var presenter : EXTextFieldPresenter = {
        return EXTextFieldPresenter.init(presenter: self)
    }()
    
    
    override func onCreate() {
        super.onCreate()
        input.keyboardType = UIKeyboardType.decimalPad
        style.bindHighlight(textField: input, effectView: baseLine)
        presenter.configWithTextField(input: input)
    }
    
    override func setPlaceHolder(placeHolder: String , font : CGFloat = 14) {
        input.setPlaceHolderAtt(placeHolder, color: UIColor.ThemeLabel.colorDark, font: font)
    }
    
    override func setText(text: String) {
        input.text = text
        input.sendActions(for: .valueChanged)
    }
    
    override func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func changeThemeColor(isRed : Bool) {
        if isRed {
            self.baseLine.backgroundColor = UIColor.ThemeState.fail
            self.amountLabel.textColor = UIColor.ThemeState.fail
        }else {
            self.baseLine.backgroundColor = UIColor.ThemeView.seperator
            self.amountLabel.textColor = UIColor.ThemeLabel.colorMedium
        }
        if let placeHolder = self.input.placeholder {
            self.input.setPlaceHolderAtt(placeHolder,color:isRed ? UIColor.ThemeState.fail : UIColor.ThemeLabel.colorDark)
        }
    }
    func setAmount(amount:String,title:String,isLeverage:Bool=false) {
        if isLeverage {
            self.amount = amount.formatAmountUseDecimal("8")
        }else {
             self.amount = amount.formatAmount(self.symbol)
        }
        amountLabel.text = title + self.amount + self.symbol.aliasName()
    }
    func setLeverageAmount(amount:String,title:String) {//只有借贷的时候用
        self.amount = amount.formatAmountUseDecimal("3")
        amountLabel.text = title + self.amount + self.symbol.aliasName()
    }
    func setOTCAmount(amount:String,title:String) {
        self.amount = amount.formatAmount(self.symbol)
        amountLabel.text = title + self.amount + self.symbol.aliasName()
    }
    @IBAction func sendAll(_ sender: Any) {
        let nsAmount = self.amount as NSString
        if nsAmount.isBig("0") {
            setText(text: self.amount)
        }
    }
    
}

extension EXWithDrawAmountField : ExTextFieldProtocol {
    
    func textValueChanged(value: String) {
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

extension EXWithDrawAmountField : EXTextFieldConfigurable {
    
    var baseField: UITextField {
        return self.input
    }
    
    var baseHighlight: UIView {
        return self.baseLine
    }
}
