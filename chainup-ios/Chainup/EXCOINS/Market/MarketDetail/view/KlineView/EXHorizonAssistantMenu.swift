//
//  EXHorizonAssistantMenu.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit


class EXHorizonAssistantMenu: NibBaseView {
    
    @IBOutlet var menus: [CMLocalizedButton]!
    var currentType:AssistantAlgorithmType = .Hides
    typealias AssistantAlogithmChangeBlock = (AssistantAlgorithmType) -> ()
    var assistantAlgorithmCallback : AssistantAlogithmChangeBlock?
    @IBOutlet var hideBtn: CMLocalizedButton!
    
    override func onCreate() {
        self.loadBtnStyle()
        self.selectOn(type: currentType)
        hideBtn.setImage(UIImage.themeImageNamed(imageName: "visible_highlight"), for: .normal)
        hideBtn.setImage(UIImage.themeImageNamed(imageName: "hide_lightcolor"), for: .selected)

    }
    
    func loadBtnStyle() {
        for (idx,btn) in menus.enumerated() {
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
    
    func selectOn(type:AssistantAlgorithmType) {
        currentType = type
        for(idx,btn) in menus.enumerated() {
            if idx == type.rawValue {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.ThemeFont.SecondaryBold
            }else {
                btn.isSelected = false
                btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
            }
        }
    }
    
    @IBAction func didSelectAlgorithm(_ sender: UIButton) {
        let type = AssistantAlgorithmType.init(rawValue: sender.tag)
        if let selectedType = type, selectedType != currentType {
            self.selectOn(type: selectedType)
            currentType = selectedType
            self.assistantAlgorithmCallback?(selectedType)
        }
    }
}
