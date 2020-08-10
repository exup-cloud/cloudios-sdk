
//
//  EXLeverageAssetsListVc.swift
//  Chainup
//
//  Created by ljw on 2019/11/4.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXLeverageAssetsListVc: EXAssetBaseVc {
    @IBOutlet weak var tableView: UITableView!
    let toolbarHeader:EXAccountTableHeader = EXAccountTableHeader()
    let searchHeader:EXAssetSearchHeader = EXAssetSearchHeader()
    var assetVm:EXAssetsVm = EXAssetsVm()
    var accountModel:EXCommonAssetModel = EXCommonAssetModel()
    var searchotcRstModels:[EXLeverageCoinMapItem] = []
    var hideotcRstModels:[EXLeverageCoinMapItem] = []
    var searchkey:String = ""
//    let LeverageVm = EXOTCVm.init()
    var hideZeroBalance:Bool = false
    var originDataArr = [EXLeverageCoinMapItem]()//最原始的数据
    var resultArr = [EXLeverageCoinMapItem]()//搜索或者隐藏后的真实展示数据
    override func viewDidLoad() {
        super.viewDidLoad()
        handleToolbar()
        bindSearch(searchHeader.searchBar, searchHeader.checkBox, .leverage)
        setupCell()
        loadData()
        self.tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if searchHeader.checkBox != nil {
            self.reloadZeroAccountSetting(searchHeader.checkBox)
           }
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+0.5) { [weak self] in
            self?.loadData()
        }
    }
    override func updatePrivacy() {
        if self.tableView != nil  {
            self.tableView.reloadData()
        }
    }

}
extension EXLeverageAssetsListVc {
    func loadData() {
        //获取杠杆
        let manager = EXAccountBalanceManager.manager
        manager.updateLeverAccountBalance()
        manager.leverAccountModelCallback = {[weak self] accountModel in
            self?.handleLeverageAssets(accountModel)
        }
    }
    func handleLeverageAssets(_ model:EXLeverageAccountListModel) {
        let assetModel = EXCommonAssetModel()
        assetModel.totalBalance = model.totalBalance.formatAmountUseDecimal("8")
        assetModel.totalBalanceSymbol = model.totalBalanceSymbol
        assetModel.assetType = .leverage
        self.accountModel = assetModel
        self.originDataArr = model.leverCoinMapListArr
        EXLeverageAccountListModel.shareInstance.memoryLeverCoinMapListArr = self.originDataArr
        self.resultArr = self.originDataArr

        let hideZeroBalance = XUserDefault.zeroAssetsSetting()
        self.assetVm.reloadZeroAccountSetting(searchHeader.checkBox)
        self.hideZeroBalance(hideZeroBalance, .leverage)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() , execute: {
            self.tableView.reloadData()
            self.onAssetupdate?(assetModel)
        })

    }
        func filterZeroOTCs(source:[EXLeverageCoinMapItem]) ->[EXLeverageCoinMapItem] {
            var filterResult: [EXLeverageCoinMapItem] = []
            for coinMapModel in source {
                let balance = coinMapModel.symbolBalance as NSString
                if balance.isBig(limitValue()) {
                    filterResult.append(coinMapModel)
                }
            }
            return filterResult
        }

        private func searchFor(key:String,type:EXAccountType) {
            searchotcRstModels.removeAll()
            searchkey = key
            if key.isEmpty {
                if hideZeroBalance {
                    self.hideZeroBalance(true, .leverage)
                }else {
                    self.resultArr = originDataArr
                }
            }else {
                var searchResult: [EXLeverageCoinMapItem] = []
                for coinMapModel in originDataArr {
                    if let _ = coinMapModel.name.aliasCoinMapName().range(of: key, options:.caseInsensitive, range: nil, locale: nil) {
                        searchResult.append(coinMapModel)
                    }
                }
                searchotcRstModels = hideZeroBalance ? self.filterZeroOTCs(source: searchResult) : searchResult
                self.resultArr = searchotcRstModels
            }
            tableView.reloadData()
        }

        func limitValue() -> String {
            return String.limitSatoshi()
        }

        private func hideZeroBalance(_ isHide:Bool, _ type:EXAccountType) {
            hideotcRstModels.removeAll()
            hideZeroBalance = isHide
            XUserDefault.switchZeroAssets(isHide)
            let baseModels = searchotcRstModels.count > 0 ? searchotcRstModels : originDataArr

            if isHide {
                var searchResult: [EXLeverageCoinMapItem] = []
                for coinMapModel in baseModels {
                    let balance = coinMapModel.symbolBalance as NSString
                    if balance.isBig(limitValue()) {
                        searchResult.append(coinMapModel)
                    }
                }
                hideotcRstModels = searchResult
                self.resultArr = searchResult
            }else {
                self.searchFor(key: self.searchkey, type: .leverage )
            }
            tableView.reloadData()
        }

        func gotoBorrow() {
            let searchVc = EXLeverageCoinSearchVc.init(nibName: "EXLeverageCoinSearchVc", bundle: nil)
                    searchVc.type = .borrow
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
     
        func gotoTransfer() {
            let searchVc = EXLeverageCoinSearchVc.init(nibName: "EXLeverageCoinSearchVc", bundle: nil)
                           searchVc.type = .transfer
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
    
         //Leverage
        func handleLeverageSheetAction(itemAction:EXAssetToolBarAction) {
            let flag = UserDefaults.standard.bool(forKey: "EXLeverageAlertView")
            if itemAction == .borrow {//借贷
                if !flag && PublicInfoManager.sharedInstance.getLeverProtocolUrl().count > 0{
                    
                }else {
                    gotoBorrow()
                }
            }else if itemAction == .transfer {//划转
              if !flag && PublicInfoManager.sharedInstance.getLeverProtocolUrl().count > 0{
                
              }else {
                  gotoTransfer()
              }
            }else if itemAction == .journalAccount {//资金流水
               let journalVc = EXLeverageJournalVc.init(nibName: "EXLeverageJournalVc", bundle: nil)
                self.navigationController?.pushViewController(journalVc, animated: true)
            }
        }
       func reloadZeroAccountSetting(_ checkBox:EXCheckBox) {
              let setting = XUserDefault.zeroAssetsSetting()
              checkBox.checked(check:setting)
        }

      func bindSearch(_ textField:UITextField, _ checkBox:EXCheckBox, _ type:EXAccountType) {
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
    
        func setupCell() {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.register(UINib.init(nibName: "EXLeverageAssetListCell", bundle: nil), forCellReuseIdentifier: "EXLeverageAssetListCell")
            self.tableView.backgroundColor = UIColor.ThemeView.bg
            tableView.estimatedRowHeight = 200;
            tableView.rowHeight = UITableViewAutomaticDimension;
        }
        func handleToolbar(){
            toolbarHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 103)
            toolbarHeader.toolBar.bindToolBarItems(self.assetVm.getLeverageToolbars())
            toolbarHeader.toolBar.onToolBarSelected = {[weak self] action in
             self?.handleLeverageSheetAction(itemAction: action)
            }
            self.tableView.tableHeaderView = toolbarHeader
        }
}

extension EXLeverageAssetsListVc : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = resultArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXLeverageAssetListCell", for: indexPath) as! EXLeverageAssetListCell
        cell.totalBalanceSymbol = self.accountModel.totalBalanceSymbol
        cell.setModel(model: model)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchHeader
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = resultArr[indexPath.row]
        let vc = EXCoinBorrowRecordVc.init(nibName: "EXCoinBorrowRecordVc", bundle: nil)
        vc.model = element
        vc.totalBalanceSymbol = self.accountModel.totalBalanceSymbol
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
