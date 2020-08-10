//
//  EXCoinBorrowRecordSectionHeaderView.swift
//  Chainup
//
//  Created by ljw on 2019/11/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinBorrowRecordSectionHeaderView: UIView,NibLoadable {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var historyBtn: UIButton!
   
    @IBOutlet weak var line: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.ThemeView.bg
        titleLab.extSetText("leverage_current_apply".localized(), textColor: UIColor.ThemeLabel.colorLite, fontSize: 16)
        titleLab.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
        historyBtn.extSetTitle("leverage_history".localized(), 14, UIColor.ThemeLabel.colorMedium, UIControlState.normal)
         var img = UIImage.themeImageNamed(imageName: "fiat_order")
        img = img.yy_imageByResize(to: CGSize.init(width: 12, height: 12.8), contentMode: UIViewContentMode.center) ?? UIImage.init()
        
        historyBtn.setImage(img, for: UIControlState.normal)
        line.backgroundColor = UIColor.ThemeView.seperator
    }
}
