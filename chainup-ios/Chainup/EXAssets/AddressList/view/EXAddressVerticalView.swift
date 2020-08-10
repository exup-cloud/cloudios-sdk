//
//  EXAddressVerticalView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAddressVerticalView: NibBaseView {
    
    @IBOutlet var addressContainer: UIStackView!
    @IBOutlet var remarkLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var checkIcon: UIImageView!
    
    override func onCreate() {
        remarkLabel.font = UIFont.ThemeFont.HeadMedium
        remarkLabel.textColor = UIColor.ThemeLabel.colorLite
        tagLabel.font = UIFont.ThemeFont.SecondaryRegular
        tagLabel.textColor = UIColor.ThemeLabel.colorMedium
        addressLabel.font = self.themeHNFont(size: 14)
        addressLabel.textColor = UIColor.ThemeLabel.colorMedium
        checkIcon.image = UIImage.themeImageNamed(imageName: "personal_selected")
    }
    
    func hideTagLabel() {
        addressContainer.removeArrangedSubview(tagLabel)
        tagLabel.removeFromSuperview()
    }
    
    func showCheck(_ isChecked:Bool ){
        checkIcon.isHidden = !isChecked
    }
    
    func getHeight(_ addressItem:AddressItem) ->CGFloat {
        var height:CGFloat = 20//remark height
        
        if let _ = addressItem.address.range(of: "_") {
            let addressAry = addressItem.address.components(separatedBy: "_")
            if addressAry.count == 2 {
                let address = addressAry[0]
                let tag = addressAry[1]
                height += address.textSizeWithFont(UIFont.ThemeFont.BodyRegular, width: SCREEN_WIDTH - 30).height
                height += tag.textSizeWithFont(UIFont.ThemeFont.BodyRegular, width: SCREEN_WIDTH - 30).height
                height += 10 // gap
            }
        }else {
            let address = addressItem.address
            height += address.textSizeWithFont(UIFont.ThemeFont.BodyRegular, width: SCREEN_WIDTH - 30).height
            height += 10
        }
        return height + 30 //上下margin
    }
}
