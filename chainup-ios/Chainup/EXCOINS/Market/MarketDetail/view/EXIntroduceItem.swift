//
//  EXIntroduceItem.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXIntroduceItem: NibBaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func onCreate() {
        titleLabel.font = UIFont.ThemeFont.BodyRegular
        contentLabel.font = UIFont.ThemeFont.BodyRegular
        titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        contentLabel.textColor = UIColor.ThemeLabel.colorLite
    }
    
    func bind(title:String,value:String ){
        titleLabel.text = title
        if value.count > 0 {
            contentLabel.text = value
        }else {
            contentLabel.text = "--"
        }
    }
}
