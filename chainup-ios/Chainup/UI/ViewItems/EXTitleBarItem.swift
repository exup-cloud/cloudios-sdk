//
//  EXTitleBarItem.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXTitleBarItem: NibBaseView {
    
    @IBOutlet var btnItem: EXFlatBtn!
    @IBOutlet var indicator: UIView!
    @IBOutlet var indicatorHeight: NSLayoutConstraint!
    @IBOutlet var indicatorWidth: NSLayoutConstraint!
    var selectedColor:UIColor = UIColor.ThemeLabel.colorHighlight
    var normalColor:UIColor = UIColor.clear
    
    var isSelected:Bool = false {
        didSet {
            btnItem.isSelected = isSelected
            if isSelected {
                indicator.backgroundColor = selectedColor
            }else {
                indicator.backgroundColor = normalColor
            }
        }
    }
    
    override func onCreate() {
        btnItem.clearColors()
    }
    
    func setFont(_ font:UIFont) {
        btnItem.titleLabel?.font = font
    }
    
    func setTitle(_ title:String) {
        btnItem.setTitle(title, for: .normal)
    }
    
    func setTitleColor(_ color:UIColor,state:UIControlState) {
        btnItem.setTitleColor(color, for:state)
    }

}
