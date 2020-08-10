//
//  EXOTCAssetsListVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXOTCAssetsListVc: EXAssetBaseVc,StoryBoardLoadable {
    @IBOutlet var otcAssetTable: UITableView!
    let toolbarHeader:EXAccountTableHeader = EXAccountTableHeader()
    let searchHeader:EXAssetSearchHeader = EXAssetSearchHeader()
    var assetVm:EXAssetsVm = EXAssetsVm()
    var accountModel:EXCommonAssetModel = EXCommonAssetModel()
    
    override func updatePrivacy() {
        if self.otcAssetTable != nil {
            self.otcAssetTable.reloadData()
            
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
        handleToolbar()
        bindVm()
        handleSearchHeader()
    }
    
    func requestBalalance() {
        if XUserDefault.isOffLine() {
            self.assetVm.otcAssetsList.accept([])
        }else {
            self.assetVm.getotcAccountBalance()
        }
        
    }
    
    func handleSearchHeader() {
        assetVm.bindSearch(searchHeader.searchBar, searchHeader.checkBox, .otc)
    }
    
    func handleToolbar(){
        toolbarHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 103)
        toolbarHeader.toolBar.bindToolBarItems(self.assetVm.getOtcToolbars())
        toolbarHeader.toolBar.onToolBarSelected = {[weak self] action in
            self?.handleToolbarAction(action)
        }
        self.otcAssetTable.tableHeaderView = toolbarHeader
    }
    
    func handleToolbarAction(_ action:EXAssetToolBarAction) {
        let items = self.assetVm.otcAssetsList.value
        if items.count > 0 {
            assetVm.handleOtcToolbarAction(action, items.first!, self)
        }
    }
    
    func bindVm() {
        bindTable()
        requestBalalance()
        self.assetVm.onAssetCallback = {[weak self] accountModel in
            self?.updateBalance(accountModel)
        }
    }
    
    func updateBalance(_ model:EXCommonAssetModel){
        self.accountModel = model
        self.onAssetupdate?(model)
    }
    
    func bindTable() {
        otcAssetTable.register(UINib.init(nibName: "EXAssetInfoCell", bundle: nil), forCellReuseIdentifier: "EXAssetInfoCell")
        assetVm.otcAssetsList.asDriver()
            .drive(otcAssetTable.rx.items){(tableview,row,element) in
                let cell = tableview.dequeueReusableCell(withIdentifier: "EXAssetInfoCell", for: IndexPath.init(row: row, section: 0)) as! EXAssetInfoCell
                cell.bindOTCInfo(element,self.accountModel.totalBalanceSymbol)
                return cell
            }.disposed(by: self.disposeBag)
        
        otcAssetTable.rx.modelSelected(CoinMapItem.self)
            .subscribe(onNext: {[weak self] model in
                self?.handleModel(model)
        }).disposed(by: self.disposeBag)
    }
    
    func handleModel(_ model:CoinMapItem) {
        self.assetVm.handleOTCActionSheet(inVc: self, model)
    }
}

extension EXOTCAssetsListVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchHeader
    }

}
