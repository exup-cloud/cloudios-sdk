//
//  EXLeverageJournalCell.swift
//  Chainup
//
//  Created by ljw on 2019/11/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverageJournalCell: UITableViewCell {

    @IBOutlet weak var topTimeLab: UILabel!
    @IBOutlet weak var titleTypeLab: UILabel!
    @IBOutlet weak var coinMapLab: UILabel!
    
    @IBOutlet weak var coinMapTitleLab: UILabel!
    
    @IBOutlet weak var coinSymbolTitleLab: UILabel!
    
    @IBOutlet weak var amountTitleLab: UILabel!
    
    @IBOutlet weak var noReturnTitleLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var coinSymbolLab: UILabel!
    
    @IBOutlet weak var noReturnLab: UILabel!
    @IBOutlet weak var rateTitleLab: UILabel!
    @IBOutlet weak var rateLab: UILabel!
    @IBOutlet weak var noReturnLiXiTitleLab: UILabel!
    
    @IBOutlet weak var noReturnLiXiLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        amountTitleLab.text = "charge_text_volume".localized()
        coinSymbolTitleLab.text = "common_text_coinsymbol".localized()
        coinMapTitleLab.text = "leverage_coinMap".localized()
    }
    func setCurrentBorrowModel(model : EXCurrentBorrowListModel) {
        amountTitleLab.text = "charge_text_volume".localized()
        titleTypeLab.text = "leverage_current_borrow".localized()
        rateTitleLab.text = "leverage_rate".localized()
        noReturnTitleLab.text = "leverage_noreturn_amount".localized()
        noReturnLiXiTitleLab.text = "leverage_noreturn_interest".localized()
        topTimeLab.text = DateTools.strToTimeString(model.ctime, dateFormat: "yyyy/MM/dd HH:mm:ss")
        amountLab.text = model.borrowMoney.formatAmount(model.coin,isLeverage: true)
        rateLab.text = model.interestRate
        coinSymbolLab.text = model.coin.aliasName()
        coinMapLab.text = model.showName.aliasCoinMapName()
        noReturnLab.text = model.oweAmount.formatAmount(model.coin,isLeverage: true)
        noReturnLiXiLab.text = model.oweInterest.formatAmount(model.coin,isLeverage: true)
    }
    func setHistoryModel(model : EXCurrentBorrowListModel)  {
        amountTitleLab.text = "charge_text_volume".localized()
        titleTypeLab.text = "leverage_history_borrow".localized()
        rateTitleLab.text = "leverage_rate".localized()
        noReturnTitleLab.text = "leverage_interest".localized()
        noReturnLiXiTitleLab.text = "charge_text_state".localized()
        topTimeLab.text = DateTools.strToTimeString(model.ctime, dateFormat: "yyyy/MM/dd HH:mm:ss")
        amountLab.text = model.borrowMoney.formatAmount(model.coin,isLeverage: true)
        rateLab.text = model.interestRate
        coinSymbolLab.text = model.coin.aliasName()
         coinMapLab.text = model.showName.aliasCoinMapName()
        noReturnLab.text = model.interest.formatAmount(model.coin,isLeverage: true)
        if model.status == "3" {
            noReturnLiXiLab.text = "leverage_all_return".localized() 
        }else if model.status == "4" {
            noReturnLiXiLab.text = "leverage_have_blowUp".localized()
        }else if model.status == "5" {
            noReturnLiXiLab.text = "leverage_have_wearStore".localized()
        }else if model.status == "6" {
            noReturnLiXiLab.text = "leverage_blowUp_end".localized()
        }else if model.status == "7" {
            noReturnLiXiLab.text = "leverage_wearStore_end".localized()
        }/// 状态：1借贷 2部分归还 3全部归还 4爆仓 5穿仓  6爆仓完结 7 穿仓完结
    }
    func setTransModel(model:EXLeveTransferListModel) {
        titleTypeLab.text = "transfer_text_record".localized()
        rateTitleLab.text = "charge_text_volume".localized()
        amountLab.text = ""//隐藏不用
        amountTitleLab.text = ""//隐藏不用
        noReturnTitleLab.text = "leverage_direction".localized()
        noReturnLiXiTitleLab.text = "contract_text_type".localized()
        topTimeLab.text = DateTools.strToTimeString(model.createTime, dateFormat: "yyyy/MM/dd HH:mm:ss")
        rateLab.text = model.amount.formatAmount(model.coinSymbol,isLeverage: true)
        coinSymbolLab.text = model.coinSymbol.aliasName()
        coinMapLab.text = model.showName.aliasCoinMapName()
        if model.transferType == "1" {
            noReturnLab.text = "leverage_get_in".localized()
            noReturnLiXiLab.text = "coin_to_leverage".localized()
        }else {
            noReturnLab.text = "leverage_roll_out".localized()
            noReturnLiXiLab.text = "leverage_to_coin".localized()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
