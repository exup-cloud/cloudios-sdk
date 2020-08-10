//
//  EXContractAssetListVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXContractAssetListVc: EXAssetBaseVc,StoryBoardLoadable {
    @IBOutlet var contractAssetTable: UITableView!
    var assetVm:EXAssetsVm = EXAssetsVm()
    let toolbarHeader:EXContractTableHeader = EXContractTableHeader()
    var contractAssetModel:EXContractAccountModel = EXContractAccountModel()
    var needUpdatedPrivacy:Bool = false
    
    override func updatePrivacy() {
        if self.contractAssetTable != nil  {
            self.contractAssetTable.reloadData()
            self.toolbarHeader.reloadHeader()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleToolbar()
        bindVm()
    }
    
    func requestBalalance() {
        if XUserDefault.isOffLine() {
            self.assetVm.otcAssetsList.accept([])
        }else {
            self.assetVm.getContractAccountBalance()
        }
    }
    
    func bindVm() {
        bindTable()
        requestBalalance()
        self.assetVm.onContractAssetCallback = {[weak self] accountModel in
            self?.updateBalance(accountModel)
        }
    }
    
    func updateBalance(_ model:EXContractAccountModel){
        toolbarHeader.bindHeaderModel(model)
        self.contractAssetModel = model
        
        let assetModel = EXCommonAssetModel()
        assetModel.totalBalance = model.margin
        assetModel.totalBalanceSymbol = model.quoteSymbol
        assetModel.canUseBalance = model.canUseBalance
        assetModel.positionMargin = model.positionMargin
        assetModel.orderMargin = model.orderMargin
        assetModel.assetType = .contract
        self.onAssetupdate?(assetModel)
    }
    
    func handleToolbar(){
        toolbarHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 212)
        toolbarHeader.toolBar.bindToolBarItems(self.assetVm.getContractToolbars())
        toolbarHeader.toolBar.onToolBarSelected = {[weak self] action in
            self?.handleToolbarAction(action)
        }
        self.contractAssetTable.tableHeaderView = toolbarHeader
    }
    
    func handleToolbarAction(_ action:EXAssetToolBarAction) {
        assetVm.handleContractToolbarAction(action, contractAssetModel, self)
    }
    
    func bindTable() {
        contractAssetTable.register(UINib.init(nibName: "EXAssetInfoCell", bundle: nil), forCellReuseIdentifier: "EXAssetInfoCell")
        assetVm.contractAssetsList.asDriver()
            .drive(contractAssetTable.rx.items){(tableview,row,element) in
                let cell = tableview.dequeueReusableCell(withIdentifier: "EXAssetInfoCell", for: IndexPath.init(row: row, section: 0)) as! EXAssetInfoCell
                cell.bindContractHoldModel(element)
                return cell
            }.disposed(by: self.disposeBag)
        
        contractAssetTable.rx.modelSelected(EXContractHoldModel.self)
            .subscribe(onNext: {[weak self] model in
                self?.handleModel(model)
            }).disposed(by: self.disposeBag)
        
    }
    
    func handleModel(_ holdModel:EXContractHoldModel) {
        self.assetVm.handleContractActionSheet(inVc: self, holdModel)
    }
}

extension EXContractAssetListVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.ThemeNav.bg
        header.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10)
        return header
    }
}

