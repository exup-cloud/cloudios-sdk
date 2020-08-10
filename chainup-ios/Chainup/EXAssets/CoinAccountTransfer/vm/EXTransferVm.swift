//
//  EXTransferVm.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EXTransferContractAccountModel :NSObject {
    var contractWalletType = "201101" //普通账户
    var contractAccountType = "2161001" //合约账户
}

class EXTransferCommonModel :NSObject {
    var key = "" //账户key,fromtype/totype
    var balance = ""//余额
    var symbol = ""
}

class EXTransferVm: NSObject {
    
    let disposeBag = DisposeBag()
    let model = EXTransferContractAccountModel()
    typealias TransferSuccessCallback = (EXAccountType) -> ()
    var onTransferSuccessCallback:TransferSuccessCallback?
    //symbolMap只有杠杆用
    func doTransfer(from:EXAccountType,to:EXAccountType,amount:String,symbol:String,symbolMap : String? = nil) {
        //如果有合约划转，走合约api
        if from == .contract || to == .contract {
            if SLPlatformSDK.sharedInstance()!.sl_determineWhetherToOpenContract(withCoinCode: symbol) == false {
                EXAlert.showFail(msg: "该币种合约未开通，暂不能划转")
                return
            }
            var type = ""
//            var fromType = ""
//            var toType = ""
//            if from == .contract {
//                fromType = model.contractAccountType
//                toType = model.contractWalletType
//            }else {
//                fromType = model.contractWalletType
//                toType = model.contractAccountType
//            }
            if from == .contract {
                type = "contract_to_wallet"
            } else if to == .contract {
                type = "wallet_to_contract"
            }
    /// biki
            appApi.rx.request(.swapTransfer(type: type, amount: amount, bound: symbol))
                .MJObjectMap(EXVoidModel.self)
                .subscribe{[weak self] event in
                    switch event {
                    case .success(_):
                        self?.onTransferSuccessCallback?(to)
                        break
                    case .error(_):
                        break
                    }
            }.disposed(by: self.disposeBag)
            
            /// 通用版本
//            contractApi.rx.request(.capitalTransfer(fromType: fromType, toType: toType, amount: amount, bound: "BTC"))
//            .MJObjectMap(EXVoidModel.self)
//            .subscribe{[weak self] event in
//                switch event {
//                case .success(_):
//                    self?.onTransferSuccessCallback?(to)
//                    break
//                case .error(_):
//                    break
//                }
//            }.disposed(by: self.disposeBag)
            
        }else if from == .leverage || to == .leverage {
            var fromType = ""
            var toType = ""
            if from == .leverage {
                fromType = EXTransferAccountKey.accountKeyOTC.rawValue
                toType = EXTransferAccountKey.accountKeyExchange.rawValue
            }else {
               fromType = EXTransferAccountKey.accountKeyExchange.rawValue
                toType = EXTransferAccountKey.accountKeyOTC.rawValue
            }
            
            appApi.rx.request(.leverFinanceTransfer(fromAccount: fromType, toAccount: toType, amount: amount, coinSymbol: symbol, symbol: ((symbolMap ?? "") as NSString).replacingOccurrences(of: "/", with: "").uppercased()))
                .MJObjectMap(EXVoidModel.self)
                .subscribe{[weak self] event in
                    switch event {
                    case .success(_):
                        self?.onTransferSuccessCallback?(to)
                        break
                    case .error(_):
                        break
                    }
            }.disposed(by: self.disposeBag)
            
        }else {
            var fromType = ""
            var toType = ""
            if from == .coin {
                fromType = EXTransferAccountKey.accountKeyExchange.rawValue
                toType = EXTransferAccountKey.accountKeyOTC.rawValue
            }else {
                fromType = EXTransferAccountKey.accountKeyOTC.rawValue
                toType = EXTransferAccountKey.accountKeyExchange.rawValue
            }
            
            appApi.rx.request(.financeOtcTransfer(fromAccount: fromType,
                                                  toAccount: toType,
                                                  amount: amount,
                                                  coinSymbol: symbol))
                .MJObjectMap(EXVoidModel.self)
                .subscribe{[weak self] event in
                    switch event {
                    case .success(_):
                        self?.onTransferSuccessCallback?(to)
                        break
                    case .error(_):
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func getToAccountName()->String {
        if PublicInfoManager.sharedInstance.isSupportOTC() {
            if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                return "assets_text_otc_forotc".localized()
            }else{
                return "assets_text_otc".localized()
            }
        }else if PublicInfoManager.sharedInstance.isSupportContract() {
            return "assets_text_contract".localized()
        }else if PublicInfoManager.sharedInstance.getLeverOpen() == true {
            return "leverage_asset".localized()
        }
        return ""
    }
    
    func getToAccountType()-> EXAccountType{
        if PublicInfoManager.sharedInstance.isSupportOTC() {
            return .otc
        }else if PublicInfoManager.sharedInstance.isSupportContract() {
            return .contract
        }else if PublicInfoManager.sharedInstance.getLeverOpen() == true {
            return .leverage
        }
        return .coin
    }
    
    
    func hasMultiAccounts() -> Bool {
        return  PublicInfoManager.sharedInstance.hasMultiAccounts()
    }

}
