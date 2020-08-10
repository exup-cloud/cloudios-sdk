//
//  EXTextFieldStyle.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXTextFieldStyle: NSObject {
    
    let disposebg = DisposeBag()
    static let `style` = EXTextFieldStyle()
    open class var commonStyle: EXTextFieldStyle {
        return style
    }
    
    func bindHighlight(textField:UITextField,effectView:UIView,isBorder:Bool = false) {

        textField.rx.controlEvent(UIControlEvents.editingDidBegin)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: true, effectView: effectView, borderHighlight: isBorder)
            }).disposed(by: disposebg)
        textField.rx.controlEvent(UIControlEvents.editingDidEnd)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: false, effectView: effectView, borderHighlight: isBorder)
            }).disposed(by: disposebg)
    }
    
    func showHilights(on:Bool,effectView:UIView,borderHighlight:Bool) {
        if borderHighlight {
            effectView.layer.borderColor = on ? UIColor.ThemeView.highlight.cgColor : UIColor.ThemeView.border.cgColor
        }else {
            effectView.backgroundColor = on ? UIColor.ThemeView.highlight : UIColor.ThemeTextField.seperator
        }
    }

}
