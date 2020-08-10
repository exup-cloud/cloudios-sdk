//
//  EXActionSheetButtonItem.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXActionSheetButtonItem: NibBaseView {
    
    @IBOutlet var actionBtn: EXButton!
    
    override func onCreate() {
        self.configure()
    }
    
    func configure() {
        self.actionBtn.clearColors()
        self.actionBtn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        self.actionBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .highlighted)
        self.actionBtn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
    }
}
