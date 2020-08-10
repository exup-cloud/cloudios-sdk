//
//  EXHorizontalMainMenu.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHorizontalMainMenu: NibBaseView {
    
    @IBOutlet var menuBtns: [CMLocalizedButton]!
    var currentType:MasterAlgorithmType = .MA
    typealias MasterAlogithmChangeBlock = (MasterAlgorithmType) -> ()
    var masterAlgorithmCallback : MasterAlogithmChangeBlock?
    @IBOutlet var hideBtn: CMLocalizedButton!
    
    override func onCreate() {
        self.loadBtnStyle()
        hideBtn.setImage(UIImage.themeImageNamed(imageName: "visible_highlight"), for: .normal)
        hideBtn.setImage(UIImage.themeImageNamed(imageName: "hide_lightcolor"), for: .selected)
    }
    
    func loadBtnStyle() {
        for (idx,btn) in menuBtns.enumerated() {
            if idx == 0 {
                btn.titleLabel?.minimumRegular()
            }else {
                btn.titleLabel?.secondaryRegular()
            }
            if idx == 0 {
                btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
                btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .selected)
            }else {
                btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
                btn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
            }
        }
    }
    
    func selectOn(type:MasterAlgorithmType) {
        currentType = type  
        for(idx,btn) in menuBtns.enumerated() {
            if idx == type.rawValue {
                btn.titleLabel?.font = UIFont.ThemeFont.SecondaryBold
                btn.isSelected = true
            }else {
                btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
                btn.isSelected = false
            }
        }
    }
    
    @IBAction func didSelectAlgorithm(_ sender: UIButton) {
        let type = MasterAlgorithmType.init(rawValue: sender.tag)
        if let selectedType = type, selectedType != currentType {
            self.selectOn(type: selectedType)
            currentType = selectedType
            self.masterAlgorithmCallback?(selectedType)
        }
    }
    

}
