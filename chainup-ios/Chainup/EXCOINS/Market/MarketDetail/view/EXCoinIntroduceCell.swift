//
//  EXCoinIntroduceCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinIntroduceCell: UITableViewCell {
    
    @IBOutlet var introTitleLabel: UILabel!
    @IBOutlet var stacks: UIStackView!
    @IBOutlet var introNameLabel: UILabel!
    @IBOutlet var introContent: UILabel!
    @IBOutlet var introduces: [EXIntroduceItem]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        introTitleLabel.font = UIFont.ThemeFont.HeadBold
        introNameLabel.font = UIFont.ThemeFont.HeadBold
        introNameLabel.text = "market_text_coinInfo".localized()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func titles() -> [String] {
        return ["market_text_publishtime".localized(),"market_text_publishTotal".localized(),"market_text_currentTotal".localized(),"market_text_coinHomepage".localized(),"market_text_blockSearch".localized()]
    }
    
    func contents(_ model:EXIntroduceModel) -> [String] {
        return [model.publishTimeStr,model.publishAmount,model.currencyAmount,model.officialUrl,model.blockchainUrl]
    }
    
    func bindModel(_ model:EXIntroduceModel) {
        if model.symbolName.count > 0 {
            introTitleLabel.text = model.symbolName + "(\(model.coinSymbol))"
        }else {
            introTitleLabel.text = model.coinSymbol.aliasName()
        }
        if model.introduction.count > 0 {
            introContent.text = model.introduction
        }else {
            introContent.text = "--"
        }
        
        for (idx,item) in introduces.enumerated() {
            item.bind(title: titles()[idx], value: contents(model)[idx])
        }
    }
    
    static func getHeightByContent(_ content:String) -> CGFloat {
        
        let introduceHeight = ceilf(Float(content.textSizeWithFont(UIFont.ThemeFont.BodyRegular, width: SCREEN_WIDTH - 30).height))
        
        return CGFloat(introduceHeight + 375)
        
    }
    
}
