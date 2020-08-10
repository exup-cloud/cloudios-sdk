//
//  EXAssetsListContentVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXAssetsListContentVc: EXAssetBaseVc,StoryBoardLoadable {
    
    @IBOutlet var coinAssetTable: UITableView!
    let toolbarHeader:EXAccountTableHeader = EXAccountTableHeader()
    let searchHeader:EXAssetSearchHeader = EXAssetSearchHeader()
    var assetVm:EXAssetsVm = EXAssetsVm()
    var accountModel:EXCommonAssetModel = EXCommonAssetModel()
    
    override func updatePrivacy() {
        if self.coinAssetTable != nil {
            self.coinAssetTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchHeader.checkBox != nil {
            assetVm.reloadZeroAccountSetting(searchHeader.checkBox)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSearchHeader()
        handleToolbar()
        bindVm()
    }
    
    func handleSearchHeader() {
        assetVm.bindSearch(searchHeader.searchBar, searchHeader.checkBox, .coin)
    }
    
    func handleToolbar(){
        toolbarHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 103)
        toolbarHeader.toolBar.bindToolBarItems(self.assetVm.getExchangeToolbars())
        toolbarHeader.toolBar.onToolBarSelected = {[weak self] action in
            self?.handleToolbarAction(action)
        }
        self.coinAssetTable.tableHeaderView = toolbarHeader
    }
    
    func subSetCoins() -> [String] {
        var subsetCoins:[String] = []
        //有otc 不管多个账户还是一个,都过滤otc的币种出来
        if PublicInfoManager.sharedInstance.isSupportOTC() {
            let otccoins = PublicInfoManager.sharedInstance.getAllOTCCoinList()
            for otcItem in otccoins {
                subsetCoins.append(otcItem.name)
            }
        }else {
            if PublicInfoManager.sharedInstance.isSupportContract() {
                subsetCoins.append("BTC")
            }
        }
        return subsetCoins
    }
    
    func handleToolbarAction(_ action:EXAssetToolBarAction) {
        if action == .transfer {
            let items = self.assetVm.coinAssetsList.value
            if items.count > 0 {
                let subsets = subSetCoins()
                for item in items {
                    if subsets.contains(item.coinName) {
                        assetVm.handleToolbarAction(action, item,self)
                        break
                    }
                }
            }
        }else {
            let items = self.assetVm.coinAssetsList.value
            if items.count > 0 {
                for item in items {
                    if assetVm.isCoinSupportAction(action, item.coinName) {
                        assetVm.handleToolbarAction(action, item, self)
                        break
                    }
                }
            }
        }
    }
    
    
    func bindVm() {
        self.assetVm.onAssetCallback = {[weak self] accountModel in
            self?.updateBalance(accountModel)
        }
        requestBalalance()
        bindTable()
    }
    
    func requestBalalance() {
        if XUserDefault.isOffLine() {
            self.assetVm.coinAssetsList.accept([])
        }else {
            self.assetVm.requestExchangeBalance()
        }
    }
    
    func updateBalance(_ model:EXCommonAssetModel){
        self.accountModel = model
        self.onAssetupdate?(model)
    }
    
    func bindTable() {
//        coinAssetTable.register(UINib.init(nibName: "EXAssetInfoCell", bundle: nil), forCellReuseIdentifier: "EXAssetInfoCell")
        coinAssetTable.register(UINib.init(nibName: "EXJournalAccountListCell", bundle: nil), forCellReuseIdentifier: "EXJournalAccountListCell")

        coinAssetTable.register(UINib.init(nibName: "EXAssetSearchCell", bundle: nil), forCellReuseIdentifier: "EXAssetSearchCell")
        
        assetVm.coinAssetsList.asDriver()
            .drive(coinAssetTable.rx.items){(tableview,row,element) in
                let cell = tableview.dequeueReusableCell(withIdentifier: "EXJournalAccountListCell", for: IndexPath.init(row: row, section: 0)) as! EXJournalAccountListCell
                
                cell.bindExchangeModel(element,self.accountModel.totalBalanceSymbol)
                return cell
        }.disposed(by: self.disposeBag)
        
        coinAssetTable.rx.modelSelected(EXAccountCoinMapItem.self).subscribe(onNext: {[weak self] model in
            self?.handleModel(model)
        }).disposed(by: self.disposeBag)
    }
    
    func handleModel(_ model:EXAccountCoinMapItem) {
        self.assetVm.handleExActionSheet(inVc: self, model)
    }
}

extension EXAssetsListContentVc : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let items = assetVm.coinAssetsList.value
        if items.count > indexPath.row {
            let model = items[indexPath.row]
            if EXJournalAccountListCell.hasOverChargeAccount(symbol: model.coinName) {
                return 203
            }
        }
   
        return 152
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


