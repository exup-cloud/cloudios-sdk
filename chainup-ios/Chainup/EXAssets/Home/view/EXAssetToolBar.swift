//
//  EXAssetToolBar.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAssetToolBar: NibBaseView {
    @IBOutlet var containerView: UIStackView!
    var iconBtnsContainer:[EXTopIconBtn] = []
    var toolbarItems:[EXAssetToolBarItem] = []
    
    typealias ToolBarActionCallback = (EXAssetToolBarAction) -> ()
    var onToolBarSelected:ToolBarActionCallback?
    
    
    func bindToolBarItems(_ items:[EXAssetToolBarItem]) {
        if iconBtnsContainer.count > 0 {
            self.containerView.removeAllArrangedSubviews()
            self.iconBtnsContainer.removeAll()
        }
        self.toolbarItems = items

        for (idx,item) in items.enumerated() {
            let iconBtn = EXTopIconBtn()
            iconBtn.onTapGesture = {[weak self] in
                self?.itemDidSelect(idx)
            }
            iconBtn.titleLabel.text = item.title
            iconBtn.topIcon.image = UIImage.themeImageNamed(imageName:item.iconImageName)
            self.containerView.addArrangedSubview(iconBtn)
            iconBtnsContainer.append(iconBtn)
        }
    }
    
    func itemDidSelect(_ idx:Int) {
        let item = self.toolbarItems[idx]
        self.onToolBarSelected?(item.action)
    }
    
    
}
