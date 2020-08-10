//
//  EXAccountBalanceManager.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXAccountBalanceManager: NSObject {
    
    let disposeBag = DisposeBag()
    var accountModel = EXAccountBalanceModel()
    var otcAccountModel = EXOTCAccountListModel()
    var contractAccountModel = EXContractAccountModel()
    var swapAccountModels : [EXContractAccountModel] = []

    static let `manager` = EXAccountBalanceManager()
    typealias AccountModelCallback = (EXAccountBalanceModel) -> ()
    var accountCallback:AccountModelCallback?
    
    typealias OTCAccountModelCallback = (EXOTCAccountListModel) -> ()
    var otcAccountCallback:OTCAccountModelCallback?
    
    typealias ContractAccountModelCallback = (EXContractAccountModel) -> ()
    var contractAccountCallback:ContractAccountModelCallback?
    
    typealias SwapAccountModelCallback = ([EXContractAccountModel]) -> ()
    var swapAccountCallback:SwapAccountModelCallback?
    
    typealias AllAccountModelCallback = (EXHomeAssetModel) -> ()
    var allAccountCallback:AllAccountModelCallback?
    
    typealias LeverAccountModelCallback = (EXLeverageAccountListModel) -> ()
    var leverAccountModelCallback : LeverAccountModelCallback?
    
    override init() {
        super.init()
    }
    
    func updateExchangeAccountBalance() {
        self.requestAccountBalance()
    }
    
    func updateOTCAccountBalance() {
        self.requestOtcAccountBalance()
    }
    
    func updateContractAccountBalance() {
        let accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
        if accounts.contains(.contract) {
            self.handleSwapAccountBalance()
        }
    }
    
    func updateAllAccountBalance() {
        self.requestAllBlance()
    }
    
    func updateLeverAccountBalance(){
        self.requestleverAccountBalance()
    }
    
}

//币币
extension EXAccountBalanceManager  {
    private func requestAccountBalance() {
        appApi.hideAutoLoading()
        appApi.rx.request(.accountBalance(coinSymbols: nil))
            .MJObjectMap(EXAccountBalanceModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.handleCoinAssets(model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func handleCoinAssets(_ model:EXAccountBalanceModel) {
        self.accountModel = model
        accountCallback?(model)
    }
    
    func getTotalBalance() -> String {
        return self.accountModel.totalBalance
    }
    
    func getTotalBalanceSymbol() ->String {
        return self.accountModel.totalBalanceSymbol
    }
    
    func getAllCoinMapItems()->[EXAccountCoinMapItem] {
        return self.accountModel.allCoinMapList
    }
    
    func getCoinMapItem(_ forSymbol:String)->EXAccountCoinMapItem? {
        for mapItem in self.accountModel.allCoinMapList {
            if mapItem.coinName == forSymbol {
                return mapItem
            }
        }
        return nil
    }
}

//otc
extension EXAccountBalanceManager  {
    
    private func requestOtcAccountBalance() {
        appApi.hideAutoLoading()
        appApi.rx.request(.financeAccountList)
            .MJObjectMap(EXOTCAccountListModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.handleOtcAssets(model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func handleOtcAssets(_ model:EXOTCAccountListModel) {
        self.otcAccountModel = model
        otcAccountCallback?(model)
    }
    
    func getOtcAccountItem(_ forSymbol:String)->CoinMapItem? {
        for mapItem in self.otcAccountModel.allCoinMap {
            if mapItem.coinSymbol == forSymbol {
                return mapItem
            }
        }
        return nil
    }
    
    func getSwapAccountItem(_ forSymbol:String)->EXContractAccountModel? {
         for mapItem in self.swapAccountModels {
             if mapItem.quoteSymbol == forSymbol {
                 return mapItem
             }
         }
         return nil
     }
}

//contract

extension EXAccountBalanceManager {
    
    private func requestContractAccountBalance() {
        contractApi.hideAutoLoading()
        contractApi.rx.request(.accountBalance)
            .MJObjectMap(CommonAryModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.handleContractAccount(model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    private  func handleContractAccount(_ aryModel:CommonAryModel) {
        //合约有可能多个账户，目前只用了一个
        var contractItems:[EXContractAccountModel] = []
        for item in  aryModel.dictAry {
            let listItem = EXContractAccountModel.mj_object(withKeyValues: item)
            if let contractItem = listItem {
                contractItems.append(contractItem)
            }
        }
        if contractItems.count > 0 {
            let accountModel = contractItems[0]
            self.contractAccountModel = accountModel
            contractAccountCallback?(accountModel)
        }
    }
    
    private func handleSwapAccountBalance() {
          var contractItems:[EXContractAccountModel] = []

          for item in SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() ?? [] {
              let listItem = EXContractAccountModel()
              listItem.walletBalance = item.available_vol
              listItem.canUseBalance = item.transfer
              listItem.quoteSymbol = item.coin_code
              listItem.bouns_qty = item.bonus_vol
              contractItems.append(listItem)
          }
          if contractItems.count > 0 {
              self.swapAccountModels = contractItems
              let accountModel = contractItems[0]
              self.contractAccountModel = accountModel
              swapAccountCallback?(self.swapAccountModels)
          }
      }
}

//总资产
extension EXAccountBalanceManager{
    
    //获取所有资产
    private func requestAllBlance(){
        appApi.rx.request(AppAPIEndPoint.totalAccountBalance).MJObjectMap(EXHomeAssetModel.self).subscribe(onSuccess: {[weak self] (model) in
            self?.allAccountCallback?(model)
        }) { (error) in
            
            }.disposed(by: disposeBag)
    }
}

//lever
extension EXAccountBalanceManager  {
    
    private func requestleverAccountBalance() {
        appApi.hideAutoLoading()
        appApi.rx.request(.leverageBalance)
            .MJObjectMap(EXLeverageAccountListModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.handleLeverAssets(model)
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func handleLeverAssets(_ model:EXLeverageAccountListModel) {
        leverAccountModelCallback?(model)
    }
}
