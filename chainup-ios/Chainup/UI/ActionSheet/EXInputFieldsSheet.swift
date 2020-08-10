//
//  EXInputFieldsSheet.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXInputFieldsSheet :NibBaseView {
    
    var rxField:UITextField?
    typealias SheetBtnCallback = (String) -> ()
    var sheetTapCallback : SheetBtnCallback?
    
    private var model:EXInputSheetModel?
    
    var modelKey:String?
    var modelValue:String?
    
    @IBOutlet var container: UIView!
    
    override func onCreate() {
        
    }
    
    func configItemModel(model:EXInputSheetModel) {
        for item in self.container.subviews {
            item.removeFromSuperview()
        }
        self.model = model
        self.modelKey = model.key
        if model.inputText.count > 0 {
            self.modelValue = model.inputText
        }
        switch model.type {
            case .input:
                let input = EXTextField()
                input.enableTitleModel = model.enableTitleMode
                input.input.keyboardType = model.keyboard
                input.enablePrivacyModel = model.enablePrivacy
                input.setText(text: model.inputText)
                input.enableTitleModel = model.title.count > 0
                input.setTitle(title: model.title)
                input.setPlaceHolder(placeHolder: model.inputPlaceHoloder)
                container.addSubview(input)
                input.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                input.textfieldValueChangeBlock = {[weak self] text in
                    self?.valueChanged(text: text)
                }
                input.setExtraText(model.unit)
                self.rxField = input.input
                break
            case .sms:
                let smsCount = EXCountField()
                smsCount.setText(text: model.inputText)
                smsCount.enableTitleModel = model.title.count > 0
                smsCount.setTitle(title: model.title)
                smsCount.input.keyboardType = model.keyboard
                smsCount.setPlaceHolder(placeHolder: model.inputPlaceHoloder)
                container.addSubview(smsCount)
                smsCount.resendCallback = {[weak self] in
                    self?.sheetTapCallback?(model.key)
                }
                smsCount.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                smsCount.textfieldValueChangeBlock = {[weak self] text in
                    self?.valueChanged(text: text)
                }
                self.rxField = smsCount.input
                break
            case .paste:
                let input = EXPasteField()
                input.showTitle = model.title.count > 0
                input.input.keyboardType = model.keyboard
                input.setText(text: model.inputText)
                input.setTitle(title: model.title)
                input.setPlaceHolder(placeHolder: model.inputPlaceHoloder)
                container.addSubview(input)
                input.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                input.textfieldValueChangeBlock = {[weak self] text in
                    self?.valueChanged(text: text)
                }
                self.rxField = input.input
                break
        }
    }
    
    func valueChanged(text:String) {
        if let model = self.model {
            self.modelKey = model.key
            self.modelValue = text
        }
    }
}
