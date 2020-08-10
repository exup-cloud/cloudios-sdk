//
//  EXNaviSearchBar.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXNaviSearchBar: NibBaseView {
    
    @IBOutlet var searchIcon: UIButton!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var cancelBtn: UIButton!
    
    override func onCreate() {
        searchField.setPlaceHolderAtt("charge_action_searchcoin".localized())
        searchField.setPlaceHolderAtt("charge_action_searchcoin".localized(), color: UIColor.ThemeLabel.colorDark, font: 14)
        searchField.textColor = UIColor.ThemeLabel.colorLite
        searchIcon.setImage(UIImage.themeImageNamed(imageName: "search"), for: .normal)
        cancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        cancelBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
    }

}
