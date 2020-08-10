//
//  EXHorizontalTopLeft.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHorizontalTopLeft: NibBaseView {

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var rmbLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    
    override func onCreate() {
        symbolLabel.font = self.themeHNBoldFont(size: 16)
        priceLabel.font =  self.themeHNBoldFont(size: 16)
        rmbLabel.textColor = UIColor.ThemeLabel.colorMedium
        rmbLabel.font = self.themeHNFont(size: 12)
        changeLabel.font = self.themeHNFont(size: 12)
        self.backgroundColor = UIColor.ThemeNav.bg
    }
    
    func updatePrices(item:TickItem,title:String) {
        symbolLabel.text = title
        let color =  item.riseorfail ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        priceLabel.text = item.close
        priceLabel.textColor = color
        changeLabel.textColor = color
        changeLabel.text = item.rose + "%"
        let array = title.components(separatedBy: "/")
        if array.count == 2 {
            
            let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(array[1])
            if let rmb = NSString.init(string: String(describing: item.close)).multiplyingBy1(t.1, decimals: t.2){
                rmbLabel.text = "≈\(t.0)" + rmb
            }
        }
        
    }
    
    func updatePrices(model: BTItemModel) {
          symbolLabel.text = model.name
          let color = (model.trend == .up) ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
          priceLabel.text = (model.last_px as NSString).toSmallPrice(withContractID: model.instrument_id)
          priceLabel.textColor = color
          changeLabel.textColor = color
          changeLabel.text = model.change_rate.count > 0 ? (model.change_rate as NSString).toPercentString(2) : "--"
          let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(model.contractInfo.margin_coin)
          if let rmb = model.last_px.multiplyingBy1(t.1, decimals: t.2) {
              rmbLabel.text = "≈\(t.0)" + rmb
          }
      }
}
