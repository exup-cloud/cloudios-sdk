//
//  EXWithDrawAddressField.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXWithDrawAddressField: EXBaseField {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scanBtn: UIButton!
    @IBOutlet var addressBtn: UIButton!
    @IBOutlet var seperatorLine: UIView!
    @IBOutlet var baseLine: UIView!
    
    @IBOutlet var input: UITextField!
    let style = EXTextFieldStyle.commonStyle
    
    fileprivate lazy var presenter : EXTextFieldPresenter = {
        return EXTextFieldPresenter.init(presenter: self)
    }()

    override func onCreate() {
        super.onCreate()
        style.bindHighlight(textField: input, effectView: baseLine)
        presenter.configWithTextField(input: input)
        scanBtn.setImage(UIImage.themeImageNamed(imageName: "assets_scanit"), for: .normal)
        addressBtn.setImage(UIImage.themeImageNamed(imageName: "assets_withdrawaladdress"), for: .normal)
    }
    
//    override func showError(_ textField: UITextField? = nil, _ effectView: UIView? = nil, _ isBorder: Bool = false) {
//        super.showError(input, baseLine)
//    }
    
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
    
    func onlyScan() {
        addressBtn.isHidden = true
        seperatorLine.isHidden = true 
    }
}

extension EXWithDrawAddressField : ExTextFieldProtocol {
    
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

extension EXWithDrawAddressField : EXTextFieldConfigurable {
    
    var baseField: UITextField {
        return self.input
    }
    
    var baseHighlight: UIView {
        return self.baseLine
    }
}
