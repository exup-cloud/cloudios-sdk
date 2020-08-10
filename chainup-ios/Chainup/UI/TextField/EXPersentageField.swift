//
//  EXPersentageField.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

//百分比的输入框,25%/50%/75%/100%.处理最多输入，处理小数点1个

/*
 self.textfieldValueChangeBlock?(value)
 self.textfieldDidBeginBlock?()
 self.textfieldDidEndBlock?()
 */

import UIKit
import RxSwift

class EXPersentageField: EXBaseField {
    
    @IBOutlet var input: UITextField!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var stepStacks: UIStackView!
    @IBOutlet var steps: [UIButton]!
    @IBOutlet var topView: EXPersentageTopView!
    @IBOutlet var bottomView: EXPersentageBottomView!
    let style = EXTextFieldStyle.commonStyle

    var color = UIColor.ThemekLine.up
    
    var maxValue:String = ""
//    var decimal:String = ""
    
    let disposebg = DisposeBag()
    
    fileprivate lazy var presenter : EXTextFieldPresenter = {
        return EXTextFieldPresenter.init(presenter: self)
    }()

    override func onCreate() {
        super.onCreate()
        self.handleHighlight()
        self.presenter.configWithTextField(input: input)
    }
    
    override func setPlaceHolder(placeHolder: String,font : CGFloat = 14) {
        input.setPlaceHolderAtt(placeHolder, color: UIColor.ThemeLabel.colorDark, font: font)
    }
    
    override func setText(text: String) {
        input.text = text
    }
    
    private func handleHighlight(){
        input.rx.controlEvent(UIControlEvents.editingDidBegin)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: true)
            }).disposed(by: disposebg)
        input.rx.controlEvent(UIControlEvents.editingDidEnd)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: false)
            }).disposed(by: disposebg)
        input.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext:{[weak self] _ in
                self?.emptyPersentage()
            }).disposed(by: disposebg)
    }
    
    func emptyPersentage() {
        for btn in steps {
            btn.backgroundColor = UIColor.clear
            btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        }
        bottomView.selectIdx = -1
    }
    
    func showHilights(on:Bool) {
        topView.highlightMode = on
    }
    
    func getPersent(_ byTag:Int) -> String? {
        let arr = ["0.25","0.5","0.75","1"]
        if arr.count > byTag {
            return arr[byTag]
        }else {
            return nil
        }
    }
    
    @IBAction func onTapStep(_ sender: UIButton) {
        
        if self.maxValue.count > 0,self.decimal.count > 0 {
            let nsMaxValue = maxValue as NSString
            let coindecimal = Int(self.decimal)
            if let precision = coindecimal {
                if let persent = self.getPersent(sender.tag) {
                    let rst = nsMaxValue.multiplying(by: persent, decimals: precision)
                    if let caculate = rst {
                        input.text = caculate
                        input.sendActions(for: .valueChanged)
                    }
                }
            }
        }
     
        bottomView.selectIdx = sender.tag
        for btn in steps {
            if btn == sender {
                btn.backgroundColor = color.withAlphaComponent(0.15)
                btn.setTitleColor(color, for: .normal)
            }else {
                btn.backgroundColor = UIColor.clear
                btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
            }
        }
    }
}

extension EXPersentageField :ExTextFieldProtocol {
    
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

//extension EXPersentageField : EXTextFieldConfigurable {
//    
//    var baseField: UITextField {
//        return self.input
//    }
//    
//    var baseHighlight: UIView {
//        return UIView()
//    }
//}

