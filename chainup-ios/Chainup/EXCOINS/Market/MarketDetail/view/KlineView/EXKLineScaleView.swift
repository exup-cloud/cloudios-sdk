//
//  EXKLineScaleView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXKLineScaleView: NibBaseView {

    @IBOutlet var bgBtn: UIButton!
    @IBOutlet var scaleBtn: EXButton!
    @IBOutlet var identifer: UIView!
    var identiferKey:String = ""
    
    override func onCreate() {
        scaleBtn.titleLabel?.minimumRegular()
        scaleBtn.clearColors()
        scaleBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        scaleBtn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        identifer.backgroundColor = UIColor.ThemeView.highlight
    }
    
    func setTitle(title :String ) {
        scaleBtn.setTitle(title, for: .normal)
    }
    
    func setSelected(isSelect:Bool) {
        scaleBtn.isSelected = isSelect
        identifer.isHidden = !isSelect
    }
    
}
