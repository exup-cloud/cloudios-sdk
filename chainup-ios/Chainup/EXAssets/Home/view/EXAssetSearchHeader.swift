//
//  EXAssetSearchHeader.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/29.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAssetSearchHeader: NibBaseView {
    @IBOutlet var checkBox: EXCheckBox!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var searchIcon: UIImageView!
    
    override func onCreate() {
        let searchTitle = "assets_action_search".localized()
        let checkTitle = "assets_action_privacy".localized()
        let contentWidth = checkTitle.textSizeWithFont(UIFont.ThemeFont.SecondaryRegular, width:CGFloat.greatestFiniteMagnitude).width
        searchIcon.image = UIImage.themeImageNamed(imageName: "search")
        
        searchBar.setPlaceHolderAtt(searchTitle)
        checkBox.text(content: checkTitle)
        checkBox.checkLabel.textColor = UIColor.ThemeLabel.colorMedium
        checkBox.checkLabel.font = UIFont.ThemeFont.SecondaryRegular
        checkBox.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(contentWidth + 25)
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon.snp.right).offset(8)
            make.right.equalTo(checkBox.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
    }

}
