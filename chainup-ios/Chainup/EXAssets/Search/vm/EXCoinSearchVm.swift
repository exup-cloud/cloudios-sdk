//
//  EXCoinSearchVm.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXCoinSearchSourceType {
    case sourceForDeposit // 充币
    case sourceForWithdraw // 提币
    case sourceForAll // 所有
}

class EXCoinSearchVm: NSObject {
    
    var sourceType:EXCoinSearchSourceType = .sourceForAll
    
    func getFirstCoinModel(_ accountType:EXAccountType = .coin) -> CoinListEntity {
        let allcoins = self.getCoinDataSource(accountType)
        let alphaKeys = Array(allcoins.keys).sorted(by: <)
        if alphaKeys.count > 0 {
            let firstKey = alphaKeys[0]
            let entity = allcoins[firstKey]
            if let coinLists = allcoins[firstKey] {
                if coinLists.count > 0 {
                    return coinLists[0]
                }
            }
        }
        return CoinListEntity()
    }
    
    func getCoinDataSource(_ accountType:EXAccountType = .coin) -> [String:[CoinListEntity]] {
        let coins = PublicInfoManager.sharedInstance.getAllCoinList()
        var allCoins:[String:[CoinListEntity]] = [:]
        var sorted = coins.sorted { $0.name < $1.name }
        var subsetCoins:[String] = []
        if accountType == .otc {
            let otccoins = PublicInfoManager.sharedInstance.getAllOTCCoinList()
            for otcItem in otccoins {
                subsetCoins.append(otcItem.name)
            }
        }else if accountType == .contract {
            // swap获取用户合约开通资产币种
            for item in SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() ?? [] {
                subsetCoins.append(item.coin_code)
            }
            var swapSorted = [CoinListEntity]()
            if coins.count == 0 {
                for item in SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() ?? [] {
                    let entity = CoinListEntity()
                    entity.name = item.coin_code
                    swapSorted.append(entity)
                }
                sorted = swapSorted.sorted { $0.name < $1.name }
            }
        }else if accountType == .coin {
            let balanceMap = EXAccountBalanceManager.manager.accountModel.allCoinMapList
            if sourceType == .sourceForDeposit {
                let openDepositCoins = balanceMap.filter({ (item) -> Bool in
                    return item.depositOpen == "1"
                })
                for depositOn in openDepositCoins {
                    subsetCoins.append(depositOn.coinName)
                }
            }else if sourceType == .sourceForWithdraw {
                let openWithdraws = balanceMap.filter({ (item) -> Bool in
                    return item.withdrawOpen == "1"
                })
                for withdrawOn in openWithdraws {
                    subsetCoins.append(withdrawOn.coinName)
                }
            }
        }
        for item in sorted {
            if subsetCoins.count > 0 {
                if subsetCoins.contains(item.name) {
                    let alpha = String(item.name.prefix(1))
                    if var itemList = allCoins[alpha] {
                        itemList.append(item)
                        allCoins[alpha] = itemList
                    }else {
                        allCoins[alpha] = [item]
                    }
                }
            }else {
                
                let alpha = String(item.name.prefix(1))
                if var itemList = allCoins[alpha] {
                    itemList.append(item)
                    allCoins[alpha] = itemList
                }else {
                    allCoins[alpha] = [item]
                }
            }
        }
        return allCoins
    }

}
