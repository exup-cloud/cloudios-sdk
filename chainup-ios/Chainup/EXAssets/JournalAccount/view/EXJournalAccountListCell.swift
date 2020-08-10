//
//  EXJournalAccountListCell.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXJournalAccountListCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    var containerView: EXTwoByTwoContainer = EXTwoByTwoContainer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = UIColor.ThemeView.bg
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindContainerModel(_ model:FinanceItem,_ scene:EXAccountType, _ transactionScene:String? = nil ) {
        if scene == .coin {
            if let title = transactionScene {
                titleLabel.text = title
            }else {
                titleLabel.text = model.transactionScene
            }
        }else if scene == .b2c {
            if let title = transactionScene {
                titleLabel.text = title
            }else {
                titleLabel.text = model.transactionScene
            }
        }else if scene == .otc {
            titleLabel.text = model.status_text
        }
        let modelA = EXTwoByTwoItemModel()
        modelA.lcontentFont = self.themeHNFont(size: 14)
        modelA.lcontentColor = UIColor.ThemeLabel.colorMedium
        
        modelA.rcontentFont = self.themeHNMediumFont(size: 14)
        modelA.rcontentColor = UIColor.ThemeLabel.colorLite
        modelA.ltitle = "charge_text_date".localized()
        modelA.rtitle = "journalAccount_text_amount".localized()
        modelA.lcontent = model.createdAtTime
        modelA.rcontent = model.amount + " " + model.coinSymbol.aliasName()
        containerView.bindContainers([modelA])
    }
    
    func bindContractModel(_ model:ContractTransactionItem) {
        titleLabel.text = model.sceneStr
        let modelA = EXTwoByTwoItemModel()
        modelA.ltitle = "charge_text_date".localized()
        modelA.rtitle = "journalAccount_text_amount".localized()
        modelA.lcontent = model.ctimeL.fmtTimeStr()
        modelA.rcontent = model.amountStr + " " + model.quoteSymbol
        modelA.rcontentColor = UIColor.ThemeLabel.colorLite

        let modelB = EXTwoByTwoItemModel()
        modelB.ltitle = "journalAccount_text_contract".localized()
        modelB.rtitle = "journalAccount_text_contractBalance".localized()
        modelB.lcontent = model.address
        modelB.rcontent = model.fmtAccountBalance() + " " + model.quoteSymbol
        
        containerView.bindContainers([modelA,modelB])
    }
    
//    func bindExchangeModel(_ model:EXAccountCoinMapItem, _ allbalanceSymbol:String) {
//        titleLabel.textColor = UIColor.ThemeLabel.colorHighlight
//        titleLabel.text = model.coinName.aliasName()
    func getAccountModels(_ itemModel:EXAccountCoinMapItem, _ allbalanceSymbol:String) -> [EXTwoByTwoItemModel] {
        let hasOverChargeModel = EXJournalAccountListCell.hasOverChargeAccount(symbol: itemModel.coinName)
        let privacy = XUserDefault.assetPrivacyIsOn()
        let currency = PublicInfoManager.sharedInstance.getCoinExchangeRate(itemModel.coinName)
        var models:[EXTwoByTwoItemModel] = []
        
        let modelA = EXTwoByTwoItemModel()
        modelA.lcontentColor = UIColor.ThemeLabel.colorLite
        modelA.rcontentColor = UIColor.ThemeLabel.colorLite
        modelA.lcontentFont = self.themeHNMediumFont(size: 14)
        modelA.rcontentFont = self.themeHNMediumFont(size: 14)
        modelA.ltitle = "assets_text_available".localized()
        modelA.lcontent = !privacy ? itemModel.normal_balance.formatAmount(itemModel.coinName) : String.privacyString()
        
        let modelB = EXTwoByTwoItemModel()
        modelB.lcontentColor = UIColor.ThemeLabel.colorLite
        modelB.rcontentColor = UIColor.ThemeLabel.colorLite
        modelB.lcontentFont = self.themeHNMediumFont(size: 14)
        modelB.rcontentFont = self.themeHNMediumFont(size: 14)
        models.append(modelA)
        models.append(modelB)
        
        
        if hasOverChargeModel {
            modelA.rtitle = "common_text_limitAvailable".localized()
            modelA.rcontent = !privacy ? itemModel.overcharge_balance.formatAmount(itemModel.coinName) : String.privacyString()
            
            modelB.ltitle =  "assets_text_freeze".localized()
            modelB.lcontent = !privacy ? itemModel.lock_balance.formatAmount(itemModel.coinName) : String.privacyString()

            modelB.rtitle =  "assets_text_lockup".localized()
            modelB.rcontent = !privacy ? itemModel.lock_grant_divided_balance.formatAmount(itemModel.coinName) : String.privacyString()
            
            let modelC = EXTwoByTwoItemModel()
            modelC.lcontentColor = UIColor.ThemeLabel.colorLite
            modelC.rcontentColor = UIColor.ThemeLabel.colorLite
            modelC.lcontentFont = self.themeHNMediumFont(size: 14)
            modelC.rcontentFont = self.themeHNMediumFont(size: 14)
            modelC.ltitle =  "assets_text_equivalence".localized() + "(\(currency.0))"
            modelC.lcontent =  !privacy ? itemModel.allBtcValuatin.getCaculatePrice(forSymbol:allbalanceSymbol) : String.privacyString()
            models.append(modelC)
        }else {
            modelA.rtitle = "assets_text_freeze".localized()
            modelA.rcontent = !privacy ? itemModel.lock_balance.formatAmount(itemModel.coinName) : String.privacyString()
            modelB.ltitle = "assets_text_lockup".localized()
            modelB.rtitle =  "assets_text_equivalence".localized() + "(\(currency.0))"
            modelB.lcontent =  !privacy ? itemModel.lock_grant_divided_balance.formatAmount(itemModel.coinName) : String.privacyString()
            modelB.rcontent = !privacy ? itemModel.allBtcValuatin.getCaculatePrice(forSymbol:allbalanceSymbol) : String.privacyString()
        }
   
        return models
    }
    
    func bindExchangeModel(_ model:EXAccountCoinMapItem, _ allbalanceSymbol:String) {
        titleLabel.textColor = UIColor.ThemeLabel.colorHighlight
        titleLabel.text = model.coinName.aliasName()
//        let privacy = XUserDefault.assetPrivacyIsOn()
//        let currency = PublicInfoManager.sharedInstance.getCoinExchangeRate(model.coinName)
//
//        let modelA = EXTwoByTwoItemModel()
//        modelA.lcontentColor = UIColor.ThemeLabel.colorLite
//        modelA.rcontentColor = UIColor.ThemeLabel.colorLite
//        modelA.lcontentFont = self.themeHNMediumFont(size: 14)
//        modelA.rcontentFont = self.themeHNMediumFont(size: 14)
//
//        modelA.ltitle = "assets_text_available".localized()
//        modelA.rtitle = "assets_text_freeze".localized()
//        modelA.lcontent = !privacy ? model.normal_balance.formatAmount(model.coinName) : String.privacyString()
//        modelA.rcontent = !privacy ? model.lock_balance.formatAmount(model.coinName) : String.privacyString()
//
//        let modelB = EXTwoByTwoItemModel()
//        modelB.lcontentColor = UIColor.ThemeLabel.colorLite
//        modelB.rcontentColor = UIColor.ThemeLabel.colorLite
//        modelB.lcontentFont = self.themeHNMediumFont(size: 14)
//        modelB.rcontentFont = self.themeHNMediumFont(size: 14)
//
//        modelB.ltitle = "assets_text_lockup".localized()
//        modelB.rtitle =  "assets_text_equivalence".localized() + "(\(currency.0))"
//        modelB.lcontent =  !privacy ? model.lock_grant_divided_balance.formatAmount(model.coinName) : String.privacyString()
//        modelB.rcontent = !privacy ? model.allBtcValuatin.getCaculatePrice(forSymbol:allbalanceSymbol) : String.privacyString()
        containerView.bindContainers(self.getAccountModels(model, allbalanceSymbol))

    }
    
    static func hasOverChargeAccount(symbol:String) ->Bool {
        return PublicInfoManager.sharedInstance.getCoinEntity(symbol)?.isOvercharge == "1" 
    }
}
