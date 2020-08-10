//
//  EXAssetsVm.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK:APIS

class EXAssetsVm: NSObject {
    
    let disposeBag = DisposeBag()
    let coinAssetsList = BehaviorRelay<[EXAccountCoinMapItem]>(value: [])
    let otcAssetsList = BehaviorRelay<[CoinMapItem]>(value: [])
    let contractAssetsList = BehaviorRelay<[EXContractHoldModel]>(value: [])
    var originCoinModels:[EXAccountCoinMapItem] = []
    var originOtcModels:[CoinMapItem] = []

    var searchRstModels:[EXAccountCoinMapItem] = []
    var searchotcRstModels:[CoinMapItem] = []
    var hideRstModels:[EXAccountCoinMapItem] = []
    var hideotcRstModels:[CoinMapItem] = []
    var searchkey:String = ""
    var hideZeroBalance:Bool = false
    var searchCheck:EXCheckBox?
    //这个类以后改个名字


    typealias AssetCallback = (EXCommonAssetModel) -> ()
    var onAssetCallback:AssetCallback?
    
    typealias ContractAssetCallback = (EXContractAccountModel) -> ()
    var onContractAssetCallback:ContractAssetCallback?
    typealias SwapAssetCallback = ([EXContractAccountModel]) -> ()
    var onSwapAssetCallback:SwapAssetCallback?
    
    func requestExchangeBalance() {
        EXAccountBalanceManager.manager.updateExchangeAccountBalance()
        EXAccountBalanceManager.manager.accountCallback = {[weak self] model in
            self?.handleCoinAssets(model)
        }
    }
    
    private func handleCoinAssets(_ model:EXAccountBalanceModel) {
        let assetModel = EXCommonAssetModel()
        assetModel.totalBalance = model.totalBalance
        assetModel.totalBalanceSymbol = model.totalBalanceSymbol
        assetModel.assetType = .coin
        self.originCoinModels = model.allCoinMapList
        
        self.onAssetCallback?(assetModel)
        //防止在隐藏资产情况下，刷新页面
        hideZeroBalance = XUserDefault.zeroAssetsSetting()
        self.searchCheck?.checked(check: hideZeroBalance)
        self.hideZeroBalance(hideZeroBalance, .coin)
//        self.coinAssetsList.accept(model.allCoinMapList)
    }
    
    func getotcAccountBalance() {
        EXAccountBalanceManager.manager.updateOTCAccountBalance()
        EXAccountBalanceManager.manager.otcAccountCallback = {[weak self] model in
            self?.handleOtcAssets(model)
        }
    }
    
    private func handleOtcAssets(_ model:EXOTCAccountListModel) {
        let assetModel = EXCommonAssetModel()
        assetModel.totalBalance = model.totalBalance
        assetModel.totalBalanceSymbol = model.totalBalanceSymbol
        assetModel.assetType = .otc
        self.originOtcModels = model.allCoinMap
        self.onAssetCallback?(assetModel)
        hideZeroBalance = XUserDefault.zeroAssetsSetting()
        self.searchCheck?.checked(check: hideZeroBalance)
        self.hideZeroBalance(hideZeroBalance, .otc)
    }
    
    func getContractAccountBalance() {
        EXAccountBalanceManager.manager.updateContractAccountBalance()
        EXAccountBalanceManager.manager.contractAccountCallback = { [weak self] model in
            self?.handleContractAccount(model)
        }
        contractApi.hideAutoLoading()
        contractApi.rx.request(.holdContractList)
            .MJObjectMap(CommonAryModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.handleContractLists(model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getSwapAccountBalance() {
         let property = SLMinePerprotyModel()
         property.conversionContractAssets(withCoin: "USDT", property: SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem())
         let assetModel = EXCommonAssetModel()
         assetModel.totalBalance = property.total_amount
         assetModel.canUseBalance = property.avail_funds
         assetModel.positionMargin = "USDT"
         assetModel.totalBalanceSymbol = "USDT"
         assetModel.assetType = .contract
         self.onAssetCallback?(assetModel)
     }
    
    func handleContractAccount(_ accountModel:EXContractAccountModel) {
        self.onContractAssetCallback?(accountModel)
    }
    
    func handleContractLists(_ aryModel:CommonAryModel) {
        var contractItems:[EXContractHoldModel] = []
        for item in aryModel.dictAry {
            let listItem = EXContractHoldModel.mj_object(withKeyValues: item)
            if let contractItem = listItem {
                contractItems.append(contractItem)
            }
        }
        contractAssetsList.accept(contractItems)
    }
    
}

//MARK:ToolBarModes

extension EXAssetsVm {
    
    func isCoinSupportAction(_ action:EXAssetToolBarAction,_ coinName:String) -> Bool {
        
        if action == .transfer {
            //有otc 不管多个账户还是一个,都过滤otc的币种出来
            if PublicInfoManager.sharedInstance.isSupportOTC() {
                let otccoins = PublicInfoManager.sharedInstance.getAllOTCCoinList()
                for otcItem in otccoins {
                    if otcItem.name == coinName {
                        return true
                    }
                }
                return false
            }else {
                if PublicInfoManager.sharedInstance.isSupportContract() {
                    return coinName == "BTC"
                }
                return false
            }
        }else if action == .withdraw {

            let model = EXAccountBalanceManager.manager.getCoinMapItem(coinName)
            if let withdrawItem = model {
                return withdrawItem.withdrawOpen == "1"
            }
            //如果没找着就放开,让他进页面
            return true
        }else if action == .recharge {
            let model = EXAccountBalanceManager.manager.getCoinMapItem(coinName)
            if let withdrawItem = model {
                return withdrawItem.depositOpen == "1"
            }
            //如果没找着就放开,让他进页面
            return true
        }else if action == .transaction {
            let entity = PublicInfoManager.sharedInstance.getDealEntity(coinName)
            return entity.name.count > 0
        } else {
            return true
        }
    }
    
    func getExchangeToolbars()->[EXAssetToolBarItem] {
        
        var toolItems:[EXAssetToolBarItem] = []
        
        let itemA = EXAssetToolBarItem()
        itemA.action = .recharge
        itemA.title = "assets_action_chargeCoin".localized()
        itemA.iconImageName = "assets_deposit"
        
        let itemB = EXAssetToolBarItem()
        itemB.action = .withdraw
        itemB.title = "assets_action_withdraw".localized()
        itemB.iconImageName = "assets_withdraw"

        let itemC = EXAssetToolBarItem()
        itemC.action = .transfer
        itemC.title = "assets_action_transfer".localized()
        itemC.iconImageName = "assets_transfer"
        
        toolItems.append(itemA)
        toolItems.append(itemB)
        toolItems.append(itemC)
        
        if PublicInfoEntity.sharedInstance.red_packet_open == "1" {
            let itemHb = EXAssetToolBarItem()
            itemHb.action = .redPack
            itemHb.title = "redpacket_redpacket".localized()
            itemHb.iconImageName = "assets_redenvelope"
            toolItems.append(itemHb)
        }
   
        let itemD = EXAssetToolBarItem()
        itemD.action = .journalAccount
        itemD.title = "assets_action_journalaccount".localized()
        itemD.iconImageName = "assets_capitalflow"
        toolItems.append(itemD)
        return toolItems
    }
    
    func getExchangeSheets(_ symbol:String) ->[EXAssetToolBarItem] {
        var items:[EXAssetToolBarItem] = []
        if isCoinSupportAction(.recharge, symbol) {
            let itemA = EXAssetToolBarItem()
            itemA.action = .recharge
            itemA.title = "assets_action_chargeCoin".localized()
            items.append(itemA)
        }
        
        if isCoinSupportAction(.withdraw, symbol) {
            let itemB = EXAssetToolBarItem()
            itemB.action = .withdraw
            itemB.title = "assets_action_withdraw".localized()
            items.append(itemB)
        }
        
        if isCoinSupportAction(.transfer, symbol) {
            let itemC = EXAssetToolBarItem()
            itemC.action = .transfer
            itemC.title = "assets_action_transfer".localized()
            items.append(itemC)
        }
 
        if isCoinSupportAction(.transaction, symbol) {
            let itemD = EXAssetToolBarItem()
            itemD.action = .transaction
            itemD.title = "assets_action_transaction".localized()
            items.append(itemD)
        }

        return items
    }
    
    func getOtcToolbars()->[EXAssetToolBarItem] {
        let itemA = EXAssetToolBarItem()
        itemA.action = .paymentTerm
        itemA.title = "noun_order_paymentTerm".localized()
        itemA.iconImageName = "assets_paymentmethod"
        let itemB = EXAssetToolBarItem()
        itemB.action = .transfer
        itemB.title =  "assets_action_transfer".localized()
        itemB.iconImageName = "assets_transfer"
        let itemC = EXAssetToolBarItem()
        itemC.action = .journalAccount
        itemC.title = "assets_action_journalaccount".localized()
        itemC.iconImageName = "assets_capitalflow"
        return [itemA,itemB,itemC]
    }
    func getB2CToolbars()->[EXAssetToolBarItem] {
       var toolItems:[EXAssetToolBarItem] = []
               
       let itemA = EXAssetToolBarItem()
       itemA.action = .B2CRecharge
       itemA.title = "assets_action_chargeCoin".localized()
       itemA.iconImageName = "assets_deposit"
       
       let itemB = EXAssetToolBarItem()
       itemB.action = .B2CWithdraw
       itemB.title = "assets_action_withdraw".localized()
       itemB.iconImageName = "assets_withdraw"

       let itemC = EXAssetToolBarItem()
       itemC.action = .B2CJournalAccount
       itemC.title = "assets_action_journalaccount".localized()
       itemC.iconImageName = "assets_capitalflow"
       
       toolItems.append(itemA)
       toolItems.append(itemB)
       toolItems.append(itemC)
        return toolItems;
    }
    
    func getLeverageToolbars()->[EXAssetToolBarItem] {
        let itemA = EXAssetToolBarItem()
        itemA.action = .borrow
        itemA.title = "leverage_borrow".localized()
        itemA.iconImageName = "assets_loan"
        let itemB = EXAssetToolBarItem()
        itemB.action = .transfer
        itemB.title =  "assets_action_transfer".localized()
        itemB.iconImageName = "assets_transfer"
        let itemC = EXAssetToolBarItem()
        itemC.action = .journalAccount
        itemC.title = "assets_action_journalaccount".localized()
        itemC.iconImageName = "assets_capitalflow"
        return [itemA,itemB,itemC]
    }
    
    func getOtcSheets() ->[EXAssetToolBarItem] {
        let itemC = EXAssetToolBarItem()
        itemC.action = .transfer
        itemC.title = "assets_action_transfer".localized()
        let itemD = EXAssetToolBarItem()
        itemD.action = .transaction
        itemD.title = "assets_action_transaction".localized()
        return [itemC,itemD]
    }
    
    func getContractToolbars()->[EXAssetToolBarItem] {
        let itemA = EXAssetToolBarItem()
        itemA.action = .transfer
        itemA.title = "assets_action_transfer".localized()
        itemA.iconImageName = "assets_transfer"
        let itemB = EXAssetToolBarItem()
        itemB.action = .journalAccount
        itemB.title = "assets_action_contractNote".localized()
        itemB.iconImageName = "assets_capitalflow"
        return [itemA,itemB]
    }
    
    func getSwapToolbars()->[EXAssetToolBarItem] {
        let itemA = EXAssetToolBarItem()
        itemA.action = .transfer
        itemA.title = "assets_action_transfer".localized()
        itemA.iconImageName = "assets_transfer"
        let itemB = EXAssetToolBarItem()
        itemB.action = .journalAccount
        itemB.title = "contract_assets_record".localized()
        itemB.iconImageName = "assets_capitalflow"
        if PublicInfoEntity.sharedInstance.coCouponSwitch_url != "" && PublicInfoEntity.sharedInstance.coCouponSwitchStatus == "1" {
            let itemC = EXAssetToolBarItem()
            itemC.action = .swapGift
            itemC.title = "contract_swap_gift".localized()
            itemC.iconImageName = "icon_tiyanjin_zichan"
            return [itemA,itemB,itemC]
        }
        return [itemA,itemB]
    }
    
    func getContractSheets() ->[EXAssetToolBarItem] {

        let itemD = EXAssetToolBarItem()
        itemD.action = .transaction
        itemD.title = "assets_action_transaction".localized()
        return [itemD]
    }
}

//MARK:ToolBarActions

extension EXAssetsVm {
    
    func handleToolbarAction(_ action:EXAssetToolBarAction, _ firstItem:EXAccountCoinMapItem, _ inVc:UIViewController) {
        if action == .withdraw {
            
        }else if action == .recharge {
            //如果开通了kyc认证且未认证kyc则return
         
        }else {
            self.handleExSheetAction(itemAction: action, selectedModel: firstItem, vc: inVc)
        }
    }
    
    func handleOtcToolbarAction(_ action:EXAssetToolBarAction, _ firstItem:CoinMapItem, _ inVc:UIViewController) {
        self.handleOtcSheetAction(itemAction: action, selectedModel: firstItem, vc: inVc)
    }
   
    func handleContractToolbarAction(_ action:EXAssetToolBarAction, _ item:EXContractAccountModel, _ inVc:UIViewController) {
        self.handleContractSheetAction(itemAction: action, selectedModel: item, vc: inVc)
    }
    
    func handleSwapToolbarAction(_ action:EXAssetToolBarAction, _ item:EXContractAccountModel, _ inVc:UIViewController) {
        self.handleSwapSheetAction(itemAction: action, selectedModel: item, vc: inVc)
    }


}


//MARK:SearchBar
extension EXAssetsVm {
    
    func reloadZeroAccountSetting(_ checkBox:EXCheckBox) {
        let setting = XUserDefault.zeroAssetsSetting()
        checkBox.checked(check:setting)
    }
    
    func bindSearch(_ textField:UITextField, _ checkBox:EXCheckBox, _ type:EXAccountType) {
        self.searchCheck = checkBox
        reloadZeroAccountSetting(checkBox)
        textField.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext:{[weak self] text in
                self?.searchFor(key: text, type: type)
            }).disposed(by: self.disposeBag)
        
        checkBox.rx.checkState.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext:{[weak self] checked in
                self?.hideZeroBalance(checked,type)
            }).disposed(by: self.disposeBag)
    }
    
    func filterZeroCoins(source:[EXAccountCoinMapItem]) ->[EXAccountCoinMapItem] {
        var filterResult: [EXAccountCoinMapItem] = []
        for coinMapModel in source {
            let balance = coinMapModel.allBtcValuatin as NSString
            if balance.isBig(limitValue()) {
                filterResult.append(coinMapModel)
            }
        }
        return filterResult
    }
    
    func filterZeroOTCs(source:[CoinMapItem]) ->[CoinMapItem] {
        var filterResult: [CoinMapItem] = []
        for coinMapModel in source {
            let balance = coinMapModel.btcValuation as NSString
            if balance.isBig(limitValue()) {
                filterResult.append(coinMapModel)
            }
        }
        return filterResult
    }
    
    private func searchFor(key:String,type:EXAccountType) {
        searchRstModels.removeAll()
        searchotcRstModels.removeAll()
        searchkey = key
        if type == .coin {
            if key.isEmpty {
                if hideZeroBalance {
                    self.hideZeroBalance(true, .coin)
                }else {
                    self.coinAssetsList.accept(originCoinModels)
                }
            }else {
                var searchResult: [EXAccountCoinMapItem] = []
                for coinMapModel in originCoinModels {
                    let alias = coinMapModel.coinName.aliasName()
                    if let _ = alias.range(of: key, options:.caseInsensitive, range: nil, locale: nil) {
                        searchResult.append(coinMapModel)
                    }
                }
                searchRstModels = hideZeroBalance ? self.filterZeroCoins(source: searchResult) : searchResult
                self.coinAssetsList.accept(searchRstModels)
            }
            
        }else if type == .otc {
            if key.isEmpty {
                if hideZeroBalance {
                    self.hideZeroBalance(true, .otc)
                }else {
                    self.otcAssetsList.accept(originOtcModels)
                }
            }else {
                var searchResult: [CoinMapItem] = []
                for coinMapModel in originOtcModels {
                    let alias = coinMapModel.coinSymbol.aliasName()
                    if let _ = alias.range(of: key, options:.caseInsensitive, range: nil, locale: nil) {
                        searchResult.append(coinMapModel)
                    }
                }
                searchotcRstModels = hideZeroBalance ? self.filterZeroOTCs(source: searchResult) : searchResult
                self.otcAssetsList.accept(searchotcRstModels)
            }
        }
    }
    
    func limitValue() -> String {
        return String.limitSatoshi()
    }
    
    private func hideZeroBalance(_ isHide:Bool, _ type:EXAccountType) {
        hideRstModels.removeAll()
        hideotcRstModels.removeAll()
        hideZeroBalance = isHide
        XUserDefault.switchZeroAssets(isHide)
        if type == .coin {
            let baseModels = searchRstModels.count > 0 ? searchRstModels : originCoinModels
            if isHide {
                var searchResult: [EXAccountCoinMapItem] = []
                for coinMapModel in baseModels {
                    let balance = coinMapModel.allBtcValuatin as NSString
                    if balance.isBig(limitValue()) {
                        searchResult.append(coinMapModel)
                    }
                }
                hideRstModels = searchResult
                self.coinAssetsList.accept(searchResult)
            }else {
                self.searchFor(key: self.searchkey, type: .coin )
            }
        }else if type == .otc {
            let baseModels = searchotcRstModels.count > 0 ? searchotcRstModels : originOtcModels
            
            if isHide {
                var searchResult: [CoinMapItem] = []
                for coinMapModel in baseModels {
                    let balance = coinMapModel.btcValuation as NSString
                    if balance.isBig(limitValue()) {
                        searchResult.append(coinMapModel)
                    }
                }
                hideotcRstModels = searchResult
                self.otcAssetsList.accept(searchResult)
            }else {
                self.searchFor(key: self.searchkey, type: .otc )
            }
        }
    }
}

extension EXAssetsVm  {
    
    func handleExActionSheet(inVc:UIViewController, _ selectedItemModel:EXAccountCoinMapItem) {

        let sheetsItem = self.getExchangeSheets(selectedItemModel.coinName)
        if sheetsItem.count == 0 {
            return
        }
        var titles:[String] = []
        for sheet in sheetsItem {
            titles.append(sheet.title)
        }
        let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: titles)
        sheet.actionIdxCallback = {[weak self] tag in
            let item = sheetsItem[tag]
            self?.handleExSheetAction(itemAction: item.action, selectedModel: selectedItemModel, vc: inVc)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func handleExSheetAction(itemAction:EXAssetToolBarAction,selectedModel:EXAccountCoinMapItem,vc:UIViewController) {
        if itemAction == .recharge {

        }else if itemAction == .transfer {
            let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            transfer.coinModel = selectedModel
            transfer.transferFlow = .exchangeToOther
            transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in
                self?.updateBalance(ftype)
                self?.updateBalance(ttype)
            }
            vc.navigationController?.pushViewController(transfer, animated: true)
        }else if itemAction == .transaction {
            let coinEntity = PublicInfoManager.sharedInstance.getDealEntity(selectedModel.coinName)
            EXNavigationHandler.sharedHandler.commandTradingCoin(coinEntity.symbol, "buy")
            vc.navigationController?.popToRootViewController(animated: false)
        }else if itemAction == .journalAccount {
            let journalVc = EXJournalAccountVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            journalVc.assetType = .coin
            vc.navigationController?.pushViewController(journalVc, animated: true)
        }
    }
    
    func goolebinding(fvc:UIViewController) {
        let google = EXGoogleBindingVC()
        fvc.navigationController?.pushViewController(google, animated: true)
    }
    
    func updateBalance(_ type:EXAccountType) {
        if type == .otc {
            self .requestExchangeBalance()
        }else if type == .coin {
            self .getotcAccountBalance()
        }else if type == .contract {
            self .getSwapAccountBalance()
        }
    }
}



extension EXAssetsVm  {
    
    func handleOTCActionSheet(inVc:UIViewController, _ selectedItemModel:CoinMapItem) {
    
        let sheetsItem = self.getOtcSheets()
        var titles:[String] = []
        for sheet in sheetsItem {
            titles.append(sheet.title)
        }
        let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: titles)
        sheet.actionIdxCallback = {[weak self] tag in
            let item = sheetsItem[tag]
            self?.handleOtcSheetAction(itemAction: item.action, selectedModel: selectedItemModel, vc: inVc)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func handleOtcSheetAction(itemAction:EXAssetToolBarAction,selectedModel:CoinMapItem,vc:UIViewController) {
        
        if itemAction == .transfer {
            let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            transfer.otcModel = selectedModel
            transfer.transferFlow = .otcToExchange
            transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in
                self?.updateBalance(ftype)
                self?.updateBalance(ttype)
            }
            vc.navigationController?.pushViewController(transfer, animated: true)
        }else if itemAction == .transaction {
            EXNavigationHandler.sharedHandler.commandToOTC(selectedModel.coinSymbol, "buy")
            vc.navigationController?.popToRootViewController(animated: false)
        }else if itemAction == .paymentTerm {
           
        }else if itemAction == .journalAccount {
            let journalVc = EXJournalAccountVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            journalVc.assetType = .otc
            vc.navigationController?.pushViewController(journalVc, animated: true)
        }
    }
    
   
}

extension EXAssetsVm  {
    
    func handleContractActionSheet(inVc:UIViewController, _ selectedItemModel:EXContractHoldModel) {
        
        let sheetsItem = self.getContractSheets()
        var titles:[String] = []
        for sheet in sheetsItem {
            titles.append(sheet.title)
        }
        let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: titles)
        sheet.actionIdxCallback = {[weak self] tag in
            let item = sheetsItem[tag]
            self?.handleHoldModelSheet(item.action, selectedItemModel, vc: inVc)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func handleHoldModelSheet(_ itemAction:EXAssetToolBarAction, _ model:EXContractHoldModel, vc:UIViewController) {
        if itemAction == .transaction {
            EXNavigationHandler.sharedHandler.commandToContract(model.contractId, "")
            vc.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func handleContractSheetAction(itemAction:EXAssetToolBarAction,selectedModel:EXContractAccountModel,vc:UIViewController) {
        
        if itemAction == .transfer {
            let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            transfer.contractModel = selectedModel
            transfer.transferFlow = .contractToExchagne
            transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in
                self?.updateBalance(ftype)
                self?.updateBalance(ttype)
            }
            vc.navigationController?.pushViewController(transfer, animated: true)
        }else if itemAction == .journalAccount {
            let journalVc = EXJournalAccountVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            journalVc.assetType = .contract
            vc.navigationController?.pushViewController(journalVc, animated: true)
        }
    }
    
     func handleSwapSheetAction(itemAction:EXAssetToolBarAction,selectedModel:EXContractAccountModel,vc:UIViewController) {
            
        if itemAction == .transfer {
            let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            transfer.contractModel = selectedModel
            transfer.transferFlow = .contractToExchagne
            transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in
                self?.updateBalance(ftype)
                self?.updateBalance(ttype)
            }
            vc.navigationController?.pushViewController(transfer, animated: true)
        }else if itemAction == .journalAccount {
            
            let assetsRecordVC = SLAssetsRecordVC()
            assetsRecordVC.isBouns = true
            vc.navigationController?.pushViewController(assetsRecordVC, animated: true)
        } else if itemAction == .swapGift {
            let webVc = WebVC()
            webVc.loadUrl(PublicInfoEntity.sharedInstance.coCouponSwitch_url)
            vc.navigationController?.pushViewController(webVc, animated: true)
        }
    }
}
