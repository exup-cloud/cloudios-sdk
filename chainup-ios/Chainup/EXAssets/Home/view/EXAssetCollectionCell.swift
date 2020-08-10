//
//  EXAssetCollectionCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAssetCollectionCell: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var caculatePriceLabel: UILabel!

    @IBOutlet var bgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.ThemeBtn.normal
        caculatePriceLabel.textColor = UIColor.ThemeBtn.normal
        balanceLabel.textColor = UIColor.ThemeLabel.white
        balanceLabel.font = self.themeHNBoldFont(size: 24)
        caculatePriceLabel.font =  self.themeHNFont(size:12)
    }
    
    func bindAssetModel(_ assetModel:EXCommonAssetModel) {
        
        let privacy = XUserDefault.assetPrivacyIsOn()
        if assetModel.totalBalanceSymbol.count > 0 {
            nameLabel.text = assetModel.title + " (\(assetModel.totalBalanceSymbol))"
        }else {
            nameLabel.text = assetModel.title
        }
        bgImage.image = UIImage.themeImageNamed(imageName: assetModel.bgIcon)
        balanceLabel.text = !privacy ? assetModel.totalBalance.formatAmount(assetModel.totalBalanceSymbol,isLeverage:assetModel.assetType == .leverage) : String.privacyString()
        caculatePriceLabel.text = !privacy ? assetModel.getCaculatePrice() : String.privacyString()
    }
}
