//
//  EXLeverageAssetListCell.swift
//  Chainup
//
//  Created by ljw on 2019/11/4.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverageAssetListCell: UITableViewCell {
    @IBOutlet weak var topTitleLab: UILabel!//BTC/USDT
    @IBOutlet weak var symbolLab: UILabel!//币种
    @IBOutlet weak var availableLab: UILabel!//可用
    @IBOutlet weak var borrowLab: UILabel!//已借
    @IBOutlet weak var topSymbolLab: UILabel!
    @IBOutlet weak var topAvailableLab: UILabel!
    @IBOutlet weak var topBorrowLab: UILabel!
    @IBOutlet weak var bottomSymbolLab: UILabel!
    @IBOutlet weak var bottomAvaiableLab: UILabel!
    @IBOutlet weak var bottomBorrowLab: UILabel!
    @IBOutlet weak var convertLab: UILabel!
    var totalBalanceSymbol = "BTC"
    
    var currentModel = EXLeverageCoinMapItem()
    
    @IBOutlet weak var line: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        self.selectionStyle = UITableViewCellSelectionStyle.none
        topTitleLab.extSetTextColor(UIColor.ThemeLabel.colorHighlight, fontSize: 16, textAlignment: NSTextAlignment.left, isBold: true, numberOfLines: 1)
        symbolLab.extSetText("common_text_coinsymbol".localized(), textColor: UIColor.ThemeLabel.colorDark, fontSize: 12, textAlignment: NSTextAlignment.left)
        availableLab.extSetText("assets_text_available".localized(), textColor: symbolLab.textColor, fontSize: symbolLab.font.pointSize, textAlignment: NSTextAlignment.left)
        borrowLab.extSetText("leverage_have_borrowed".localized(), textColor: symbolLab.textColor, fontSize: symbolLab.font.pointSize, textAlignment: NSTextAlignment.right)
        topSymbolLab.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 14, textAlignment: NSTextAlignment.left, isBold: false, numberOfLines: 1)
        
        
        bottomSymbolLab.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 14, textAlignment: NSTextAlignment.left, isBold: false, numberOfLines: 1)
        
        
        topAvailableLab.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 14, textAlignment: NSTextAlignment.left, isBold: false, numberOfLines: 1)
        topAvailableLab.font = self.themeHNMediumFont(size: 14)
        
        bottomAvaiableLab.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 14, textAlignment: NSTextAlignment.left, isBold: false, numberOfLines: 1)
        bottomAvaiableLab.font = topAvailableLab.font
        
        topBorrowLab.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 14, textAlignment: NSTextAlignment.right, isBold: false, numberOfLines: 1)
        topBorrowLab.font = topAvailableLab.font
        
        bottomBorrowLab.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 14, textAlignment: NSTextAlignment.right, isBold: false, numberOfLines: 1)
        bottomBorrowLab.font = topAvailableLab.font
        convertLab.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 14, textAlignment: NSTextAlignment.left, isBold: false, numberOfLines: 1)
        
        
        line.backgroundColor = UIColor.ThemeView.seperator
    }
    func setModel(model : EXLeverageCoinMapItem) {
        currentModel = model
        let privacy = XUserDefault.assetPrivacyIsOn()
        topTitleLab.text = model.name.aliasCoinMapName()
        topSymbolLab.text = model.baseCoin.aliasName()
        topAvailableLab.text = !privacy ? model.baseNormalBalance.formatAmount(model.baseCoin,isLeverage: true) : String.privacyString()
        topBorrowLab.text = !privacy ? model.baseBorrowBalance.formatAmount(model.baseCoin,isLeverage: true) : String.privacyString()
        
        bottomSymbolLab.text = model.quoteCoin.aliasName()
        bottomAvaiableLab.text = !privacy ? model.quoteNormalBalance.formatAmount(model.quoteCoin,isLeverage: true) : String.privacyString()
        bottomBorrowLab.text = !privacy ? model.quoteBorrowBalance.formatAmount(model.quoteCoin,isLeverage: true) : String.privacyString()
        
        convertLab.text = !privacy ? getCaculatePrice() : String.privacyString()
    }
    func getCaculatePrice()->String {
        //btc的汇率
        let currency = PublicInfoManager.sharedInstance.getCoinExchangeRate(totalBalanceSymbol)
        let unit = currency.0
        let rate = currency.1
        let decimal = currency.2
        let balance = self.currentModel.symbolBalance as NSString
        if let rst =  balance.multiplying(by: rate, decimals: decimal) {
            return "assets_text_equivalence".localized()  + unit + rst
        }else {
            return "assets_text_equivalence".localized()  + unit + "0"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
