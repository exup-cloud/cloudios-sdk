//
//  EXAccountTransferVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EXAccountTransferVc: UIViewController,StoryBoardLoadable,NavigationPlugin {
    
    typealias TransferSuccessCallback = (EXAccountType,EXAccountType) -> ()
    var onTrasferSuccessCallback:TransferSuccessCallback?
    var isPopRoot = false
    
    @IBOutlet var transferScroll: UIScrollView!
    @IBOutlet var accountTransferHeader: EXAccountTransferHeaderView!
    @IBOutlet var footerBar: EXCoinWithdrawFooter!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var coinSelector: EXSelectionField!
    @IBOutlet var grantsTipView: UIView!
    @IBOutlet var grantsTipBtn: UIButton!
    
    @IBOutlet weak var coinDoubleView: UIView!//只有杠杆时候显示
    @IBOutlet weak var coinDoubleSelector: EXSelectionField!//杠杆时候用
    @IBOutlet var amountView: EXWithDrawAmountField!
    var transferVm:EXTransferVm = EXTransferVm()
    var coinListVm:EXCoinSearchVm = EXCoinSearchVm()
    var transferFlow:EXTransferFlow = .exchangeToOther
    
    //从某个账户进来,可带入一个.其余自动获取
    var coinModel:EXAccountCoinMapItem?
    var otcModel:CoinMapItem?
    var contractModel:EXContractAccountModel?
    var contractModels:[EXContractAccountModel] = []

    var fromModel:EXTransferCommonModel = EXTransferCommonModel()
    var toModel  :EXTransferCommonModel = EXTransferCommonModel()
    var canTransferType:EXAccountType = .coin // 可以互换账户的选项,如果等于币币账户,不对.只有otc/contract可以互换
    
    var symbol:String = ""
    var amount:String = ""
    
    var coinMapName = ""//币对名字，杠杆时候用
    var coinName = ""//币种名字//杠杆时候用
    var leverModel = EXLeverCoinBorrowRecord()
    
    var coinTitleArr = [String]()
    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: nil, presenter: self)
        return nav
    }()
    
    
    func configRightItem() {
        self.navigation.configRightItems(["transfer_text_record".localized()],isImageName: false)
        self.navigation.rightItemCallback = {[weak self] tag in
            self?.handleHistory()
        }
    }
    
    func configNavigation(){
        self.navigation.setdefaultType(type:.list)
        self.navigation.setTitle(title: "assets_action_transfer".localized())
        configRightItem()
    }
    
    func handleHistory() {
        if canTransferType == .leverage {
           let vc = EXLeverageTransferRecordVc.init(nibName: "EXLeverageTransferRecordVc", bundle: nil)
            vc.symbol = coinMapName
            vc.coinName = coinName
           self.navigationController?.pushViewController(vc, animated: true)
        }
        else if canTransferType == .contract {
            let vc = SLSwapTransferRecordVc()
            vc.symbol = symbol
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    func configInputs() {
        coinSelector.setTitle(title: "common_text_coinsymbol".localized())
        coinSelector.arrowModel(enabled: true)
        coinSelector.titleMode(enabled: true)
        coinSelector.textfieldDidTapBlock = {[weak self] in
            self?.handleCoinSelection()
        }
        if canTransferType == .leverage && coinMapName.count > 0 &&  coinMapName.contains("/") {
              coinTitleArr = (coinMapName as NSString).components(separatedBy: "/")
            if coinName.count ==  0  && coinTitleArr.count > 0{
                coinName = coinTitleArr[0]
            }
            loadData()
        }
        coinDoubleSelector.setTitle(title: "leverage_coinMap".localized())
        coinDoubleSelector.arrowModel(enabled: true)
        coinDoubleSelector.titleMode(enabled: true)
        coinDoubleSelector.textfieldDidTapBlock = {[weak self] in
            self?.handleCoinDoubleSelection()
        }
        updateCoinDatas()
        amountView.rightSendAllLabel.text = "common_action_sendall".localized()
        amountView.setTitle(title: "charge_text_volume".localized())
        amountView.input.rx.text.orEmpty.asObservable()
        .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.amount = text
            }).disposed(by: self.disposeBag)
    }
    
    func handleCoinSelection() {
        coinSelector.normalStyle()
        if canTransferType == .leverage {
            leveSelect()
        }else{
            let searchVc = EXCoinSearchListVc.instanceFromStoryboard(name: StoryBoardNameAsset)
            searchVc.subsetCoinAccountType = canTransferType
            searchVc.onEntityCallback = {[weak self] model in
                self?.updateCoinEntity(model)
            }
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
        
    }
    func leveSelect() {
       var selectIdx = 0
       var titlesArr = [String]()
       for (idx,item) in coinTitleArr.enumerated() {
        if self.coinSelector.input.text == item.aliasName() {
               selectIdx = idx
               break
           }
       }
        for item in coinTitleArr {
            titlesArr.append(item.aliasName())
        }
       let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: titlesArr,selectedIdx: selectIdx)
        sheet.actionIdxCallback = {[weak self] tag in
            self?.coinSelector.input.text = self?.coinTitleArr[tag].aliasName()
            self?.coinName = self?.coinTitleArr[tag] ?? ""
            self?.updateCoinDatas()
            self?.amountView.setText(text: "")
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    func handleCoinDoubleSelection() {//杠杆币对选择
        coinDoubleSelector.normalStyle()
        let vc = EXLeverageCoinSearchVc.init(nibName: "EXLeverageCoinSearchVc", bundle: nil)
        vc.backCoinNameBlock = {[weak self] str in
            guard let mySelf = self else {return}
            mySelf.amountView.setText(text: "")
            mySelf.coinMapName = str
            if mySelf.coinMapName.count > 0 &&  mySelf.coinMapName.contains("/") {
                mySelf.coinTitleArr = (mySelf.coinMapName as NSString).components(separatedBy: "/")
                if mySelf.coinTitleArr.count > 0{
                   mySelf.coinName = mySelf.coinTitleArr[0]
                }
            }
            mySelf.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCoinEntity(_ model:CoinListEntity) {
        self.symbol = model.name
        if let hasModel = EXAccountBalanceManager.manager.getCoinMapItem(model.name) {
            self.coinModel = hasModel
        }
        
        if let otcModel = EXAccountBalanceManager.manager.getOtcAccountItem(model.name) {
            self.otcModel = otcModel
        }
        
        if let swapModel =  EXAccountBalanceManager.manager.getSwapAccountItem(model.name) {
            self.contractModel = swapModel
        }
        
        amountView.setText(text: "")
        updateCoinDatas()

    }

    func updateCoinDatas() {
        guard let fromAccountType = accountTransferHeader.fromAccountView.accountType else {return}
        guard let toAccountType = accountTransferHeader.toAccountView.accountType else {return}
        
        if self.accountTransferHeader.upsideDown {
            self.handleFromModel(toAccountType)
            self.handleToModel(fromAccountType)
        }else {
            self.handleFromModel(fromAccountType)
            self.handleToModel(toAccountType)
        }
        configRightItem()
        
        if canTransferType != .leverage {//其它
           amountView.symbol = self.symbol
           amountView.leftSymbolLabel.text = self.symbol.aliasName()
           coinSelector.setText(text: self.symbol.aliasName())
           amountView.setAmount(amount: fromModel.balance,title:"transfer_tip_maxTransfer".localized())
            if accountTransferHeader.upsideDown == true && PublicInfoEntity.sharedInstance.coCouponSwitchStatus == "1" {
                if toAccountType == .contract {
                    let qty = contractModel?.bouns_qty ?? "0"
                    if qty.greaterThan(BT_ZERO) {
                        grantsTipView.isHidden = false
                        grantsTipBtn.extSetTitle(String(format: "(%@%@%@)", "contract_tips_noExperience".localized(),qty.toString(2),contractModel!.quoteSymbol), titleColor: UIColor.ThemeLabel.colorMedium)
                        grantsTipBtn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
                        grantsTipBtn.addTarget(self, action: #selector(clickBounsTips), for: .touchUpInside)
                    } else {
                        grantsTipView.isHidden = true
                    }
                } else {
                    grantsTipView.isHidden = true
                }
            } else {
                grantsTipView.isHidden = true
            }
            
        }else {//杠杆
            grantsTipView.isHidden = true
            coinDoubleSelector.setText(text: coinMapName.aliasCoinMapName())
            coinSelector.setText(text: self.coinName.aliasName())
            amountView.symbol = self.coinName
            amountView.leftSymbolLabel.text = self.coinName.aliasName()
            amountView.setAmount(amount: fromModel.balance,title:"transfer_tip_maxTransfer".localized())
            amountView.decimal = ""
            amountView.setText(text: "")
            if self.accountTransferHeader.upsideDown {//只有杠杆转到币币的时候，数量和可用资产使用8位精度，其它不变
                if toAccountType == .leverage {
                    amountView.decimal = "8"
                    amountView.setAmount(amount: fromModel.balance,title:"transfer_tip_maxTransfer".localized(),isLeverage: true)
                }
            }else {
                if fromAccountType == .leverage {
                    amountView.decimal = "8"
                    amountView.setAmount(amount: fromModel.balance,title:"transfer_tip_maxTransfer".localized(),isLeverage: true)
                }
            }
        }
       
    }
    
    func configFooter() {
        footerBar.hideFooterTitle()
        footerBar.confirmBtn.addTarget(self, action:#selector(doTransferAction), for: .touchUpInside)
        let amount = amountView.input.rx.text.orEmpty.asObservable()
        let coinsymbol = coinSelector.input.rx.text.orEmpty.asObservable()
        let coinMap = coinDoubleSelector.input.rx.text.orEmpty.asObservable()
        if canTransferType == .leverage{//杠杆
            Observable.combineLatest(amount,coinsymbol,coinMap)
                .map( { tuple in
                    let (amount,symbol,coinMap) = tuple
                    guard let a = Double(amount) else{return false}
                    return (amount.count > 0 && symbol.count > 0 && a > 0 && coinMap.count > 0)
                })
            .bind(to: footerBar.confirmBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        }else {
            Observable.combineLatest(amount,coinsymbol)
                .map( { tuple in
                    let (amount,symbol) = tuple
                    guard let a = Double(amount) else{return false}
                    return (amount.count > 0 && symbol.count > 0 && a > 0)
                })
            .bind(to: footerBar.confirmBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        }
        
    }
    
    
    @objc func clickBounsTips() {
        let alert = EXNormalAlert()
        alert.configSigleAlert(title: "contract_swap_gift".localized(), message: "contract_tips_experienceGold".localized(), sigleBtnTitle: "alert_common_iknow".localized())
        //展示
        EXAlert.showAlert(alertView: alert)
    }
    
    @objc func doTransferAction() {
        //不知道谁转谁,排异常
        guard let fromAccountType = accountTransferHeader.fromAccountView.accountType else {return}
        guard let toAccountType = accountTransferHeader.toAccountView.accountType else {return}
        
        let nsAmount = self.amount as NSString
        if nsAmount.isBig(fromModel.balance) {
            EXAlert.showFail(msg: "common_tip_balanceNotEnough".localized())
            return
        }
        var symolName = self.symbol
        if accountTransferHeader.upsideDown {
            if canTransferType == .leverage {
                symolName = coinName
            }
            self.transferVm.doTransfer(from: toAccountType, to: fromAccountType, amount:self.amount, symbol: symolName,symbolMap: coinMapName)
        }else {
            if canTransferType == .leverage {
               symolName = coinName
            }
            self.transferVm.doTransfer(from: fromAccountType, to:toAccountType, amount:self.amount, symbol: symolName,symbolMap: coinMapName)
        }
    }
    
    func handleViewTransition(_ upsideDonw:Bool) {
        configRightItem()
        self.updateCoinDatas()
    }
    
    func configHeaderFlow() {
        
        accountTransferHeader.onTransferTapCallback = {[weak self] in
            self?.handleAccountChangeAction()
        }
        accountTransferHeader.onTransferUpsidedownCallback = { [weak self] upsideDown in
            self?.handleViewTransition(upsideDown)
        }
        
        switch transferFlow {
        case .exchangeToOther:
            canTransferType = self.transferVm.getToAccountType()
            if self.symbol.isEmpty {
                self.symbol = self.coinModel?.coinName ?? ""
            }else {
                //币币交易页面会直接带入symbol进来,没有model.如果symbol在otc列表
                if canTransferType == .otc {
                    var coinNames:[String] = []
                    let otccoins = PublicInfoManager.sharedInstance.getAllOTCCoinList()
                    for otcItem in otccoins {
                        coinNames.append(otcItem.name)
                    }
                    if coinNames.count > 0, !coinNames.contains(self.symbol) {
                        let firstModel = self.coinListVm.getFirstCoinModel(.otc)
                        self.symbol = firstModel.name
                    }
                }
            }
            accountTransferHeader.setFromAccountType(.coin)
            accountTransferHeader.setToAccountType(canTransferType)
            accountTransferHeader.setFromAccountTitle("assets_text_exchange".localized())
            accountTransferHeader.setToAccountTitle(self.transferVm.getToAccountName())
            accountTransferHeader.setMultiAccountStyle(isfromAccountMulti: false)
        case .otcToExchange:
            self.symbol = self.otcModel?.coinSymbol ?? ""
            accountTransferHeader.setFromAccountType(.coin)
            accountTransferHeader.setToAccountType(.otc)
            accountTransferHeader.setFromAccountTitle("assets_text_exchange".localized())
            if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                accountTransferHeader.setToAccountTitle("assets_text_otc_forotc".localized())
            }else{
                accountTransferHeader.setToAccountTitle("assets_text_otc".localized())
            }
            accountTransferHeader.setMultiAccountStyle(isfromAccountMulti: false)
            canTransferType = .otc
        case .contractToExchagne:
            self.symbol = self.contractModel?.quoteSymbol ?? ""
            accountTransferHeader.setFromAccountType(.coin)
            accountTransferHeader.setToAccountType(.contract)
            accountTransferHeader.setFromAccountTitle("assets_text_exchange".localized())
            accountTransferHeader.setToAccountTitle("assets_text_contract".localized())
            accountTransferHeader.setMultiAccountStyle(isfromAccountMulti: false)
            canTransferType = .contract
            let firstModel = self.coinListVm.getFirstCoinModel(canTransferType)
            self.updateCoinEntity(firstModel)
        case .leverageToExchagne:
            accountTransferHeader.setFromAccountType(.coin)
            accountTransferHeader.setToAccountType(.leverage)
            accountTransferHeader.setFromAccountTitle("assets_text_exchange".localized())
            accountTransferHeader.setToAccountTitle("leverage_asset".localized())
            accountTransferHeader.setMultiAccountStyle(isfromAccountMulti: false)
            canTransferType = .leverage
            coinDoubleView.isHidden = false
//            if !UserDefaults.standard.bool(forKey: "EXLeverageAlertView") && PublicInfoManager.sharedInstance.getLeverProtocolUrl().count > 0{
//                let alertView = EXLeverageAlertView.show()
//                if let alertView = alertView {
//                    alertView.isTransfer = true
//                    alertView.cancleBlock = {
//                        let accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
//                        if accounts.count == 2 && accounts.contains(.leverage) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//            }
        }
    }
    
    func configVm() {
        
        if self.transferFlow == .exchangeToOther {
            let accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
            if accounts.contains(.contract) {
                EXAccountBalanceManager.manager.updateContractAccountBalance()
            }
            if accounts.contains(.otc) {
                EXAccountBalanceManager.manager.updateOTCAccountBalance()
            }
        }else {
            EXAccountBalanceManager.manager.updateExchangeAccountBalance()
        }
        
        transferVm.onTransferSuccessCallback = {[weak self] toAccount in
            self?.onSuccessAlert(toAccount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigation()
        configHeaderFlow()
        configInputs()
        configFooter()
        
        configVm()
        configAccountsBalance()
    }
    
    func configAccountsBalance() {
        EXAccountBalanceManager.manager.updateExchangeAccountBalance()

        let accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
        if accounts.contains(.otc) {
            if self.otcModel == nil {
                EXAccountBalanceManager.manager.updateOTCAccountBalance()
            }
        }
        if accounts.contains(.contract) {
            EXAccountBalanceManager.manager.updateContractAccountBalance()
        }
        
        if self.coinModel == nil {
            EXAccountBalanceManager.manager.updateExchangeAccountBalance()
        }
        
        EXAccountBalanceManager.manager.accountCallback = {[weak self] _ in
            self?.updateExchangeBalance()
        }
        
        EXAccountBalanceManager.manager.otcAccountCallback = {[weak self] _ in
            self?.updateOTCBalance()
        }
        
        EXAccountBalanceManager.manager.swapAccountCallback = {[weak self] contractModel in
            self?.updateContractBalance()
        }
        updateContractBalance()
    }
    
    func updateContractBalance() {
        self.contractModels = EXAccountBalanceManager.manager.swapAccountModels
        if self.symbol == "" && self.contractModels.count > 0 {
            self.symbol = self.contractModels[0].quoteSymbol
            self.contractModel = self.contractModels[0]
        } else {
            for itemModel in self.contractModels {
                if itemModel.quoteSymbol == self.coinName {
                    self.contractModel = itemModel
                }
            }
        }
        self.updateCoinDatas()
    }
    
    func updateOTCBalance() {
        self.otcModel = EXAccountBalanceManager.manager.getOtcAccountItem(self.symbol)
        self.updateCoinDatas()
    }
    
    func updateExchangeBalance() {
        self.coinModel = EXAccountBalanceManager.manager.getCoinMapItem(self.symbol)
        self.updateCoinDatas()
    }
//
//    func updateContractBalance() {
//        self.contractModel = EXAccountBalanceManager.manager.contractAccountModel
//        self.updateCoinDatas()
//    }
    
    func largeTitleValueChanged(height: CGFloat) {
        topConstraint.constant = height
    }
    
    func handleAccountChangeAction() {
        var accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
        accounts.remove(at: 0)
        //移除第一个币币账户
        var titles:[String] = []
        var types : [EXAccountType] = []
        if accounts.contains(.otc) {
            if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                titles.append("assets_text_otc_forotc".localized())
            }else{
                titles.append("assets_text_otc".localized())
            }
            types.append(.otc)
        }
        if accounts.contains(.contract) {
            titles.append("assets_text_contract".localized())
            types.append(.contract)
        }
        if accounts.contains(.leverage) {
            titles.append("leverage_asset".localized())
            types.append(.leverage)
        }
        let sheet = EXActionSheetView()
        sheet.configButtonTitles(buttons: titles)
        sheet.actionIdxCallback = {[weak self] tag in
            self?.handleSheetAction(types[tag])
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func handleSheetAction(_ accountType:EXAccountType) {
//        if accountType == .leverage && !UserDefaults.standard.bool(forKey: "EXLeverageAlertView") && PublicInfoManager.sharedInstance.getLeverProtocolUrl().count > 0{
//            let alertView = EXLeverageAlertView.show()
//            if let alertView = alertView {
//                alertView.isTransfer = true
//                alertView.confirmBlock = {
//                    self.handleSheetAction(.leverage)
//                }
//                alertView.cancleBlock = {
//                    let accounts = PublicInfoManager.sharedInstance.getSupportAccounts()
//                    if accounts.count == 2 && accounts.contains(.leverage) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            }
//            return
//        }
        
        if canTransferType == accountType {
            return
        }
        //可变账户变了
        canTransferType = accountType
        amountView.setText(text: "")
        coinDoubleView.isHidden = true//只有杠杆显示
        if accountType == .contract {
            if self.transferFlow == .exchangeToOther {
                accountTransferHeader.setToAccountTitle("assets_text_contract".localized())
                accountTransferHeader.setToAccountType(.contract)
            }else if self.transferFlow == .contractToExchagne {
                accountTransferHeader.setToAccountTitle("assets_text_contract".localized())
                accountTransferHeader.setToAccountType(.contract)
            }else if self.transferFlow == .otcToExchange {
                accountTransferHeader.setToAccountTitle("assets_text_contract".localized())
                accountTransferHeader.setToAccountType(.contract)
            }else if self.transferFlow == .leverageToExchagne {
                accountTransferHeader.setToAccountTitle("assets_text_contract".localized())
                accountTransferHeader.setToAccountType(.contract)
            }
        }else if accountType == .otc {
            if self.transferFlow == .exchangeToOther {
                if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                    accountTransferHeader.setToAccountTitle("assets_text_otc_forotc".localized())
                }else{
                    accountTransferHeader.setToAccountTitle("assets_text_otc".localized())
                }
                accountTransferHeader.setToAccountType(.otc)
            }else if self.transferFlow == .otcToExchange {
                if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                    accountTransferHeader.setToAccountTitle("assets_text_otc_forotc".localized())
                }else{
                    accountTransferHeader.setToAccountTitle("assets_text_otc".localized())
                }
                accountTransferHeader.setToAccountType(.otc)
            }else if self.transferFlow == .contractToExchagne {
                if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                    accountTransferHeader.setToAccountTitle("assets_text_otc_forotc".localized())
                }else{
                    accountTransferHeader.setToAccountTitle("assets_text_otc".localized())
                }
                accountTransferHeader.setToAccountType(.otc)
            }else if self.transferFlow == .leverageToExchagne {
                accountTransferHeader.setToAccountTitle("assets_text_otc".localized())
                accountTransferHeader.setToAccountType(.otc)
            }
        }else if accountType == .leverage {
            coinDoubleView.isHidden = false
            if self.transferFlow == .exchangeToOther {
                accountTransferHeader.setToAccountTitle("leverage_asset".localized())
                accountTransferHeader.setToAccountType(.leverage)
            }else if self.transferFlow == .otcToExchange {
                accountTransferHeader.setToAccountTitle("leverage_asset".localized())
                accountTransferHeader.setToAccountType(.leverage)
            }else if self.transferFlow == .contractToExchagne {
                accountTransferHeader.setToAccountTitle("leverage_asset".localized())
                accountTransferHeader.setToAccountType(.leverage)
            }else if self.transferFlow == .leverageToExchagne {
                accountTransferHeader.setToAccountTitle("leverage_asset".localized())
                accountTransferHeader.setToAccountType(.leverage)
            }
            if coinMapName.count == 0 {
                let vc = EXLeverageCoinSearchVc.init(nibName: "EXLeverageCoinSearchVc", bundle: nil)
                vc.backCoinNameBlock = {[weak self] str in
                    guard let mySelf = self else {return}
                    mySelf.coinMapName = str
                    mySelf.coinTitleArr = (mySelf.coinMapName as NSString).components(separatedBy: "/")
                    if mySelf.coinTitleArr.count > 0 {
                        mySelf.coinName = mySelf.coinTitleArr[0]
                    }
                    mySelf.loadData()

                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let firstModel = self.coinListVm.getFirstCoinModel(canTransferType)
        self.updateCoinEntity(firstModel)
//        self.symbol = firstModel.name
//        self.updateCoinDatas()
    }
}

extension EXAccountTransferVc  {
    
    func handleFromModel(_ withType:EXAccountType) {
        if withType == .coin {
            if canTransferType == .contract {
                fromModel.key = self.contractModel?.walletAccountType ?? ""
            }else {
                fromModel.key = EXTransferAccountKey.accountKeyExchange.rawValue
            }
            if canTransferType == .leverage {
                if self.coinName.uppercased() == leverModel.baseCoin.uppercased(){
                    fromModel.balance = leverModel.baseExNormalBalance
                }else {
                    fromModel.balance = leverModel.quoteEXNormalBalance
                }
            }else {
               fromModel.balance = self.coinModel?.normal_balance ?? "--"
            }
        }else if withType == .otc {
            fromModel.key = EXTransferAccountKey.accountKeyOTC.rawValue
            fromModel.balance = self.otcModel?.normal ?? "--"
        }else if withType == .leverage {
            fromModel.key = EXTransferAccountKey.accountKeyOTC.rawValue
            if self.coinName.uppercased() == leverModel.baseCoin.uppercased(){
                fromModel.balance = leverModel.baseCanTransfer.formatAmountUseDecimal("8")
            }else {
                fromModel.balance = leverModel.quoteCanTransfer.formatAmountUseDecimal("8")
            }
            
        }else {
            fromModel.key = self.contractModel?.contractAccountType ?? ""
            fromModel.balance = self.contractModel?.canUseBalance ?? ""
        }
    }
    
    func handleToModel(_ withType: EXAccountType) {
        if withType == .coin {
            if canTransferType == .contract {
                toModel.key = self.contractModel?.walletAccountType ?? ""
            }else {
                toModel.key = EXTransferAccountKey.accountKeyExchange.rawValue
            }
            toModel.balance = self.coinModel?.normal_balance ?? "--"
        }else if withType == .otc {
            toModel.key = EXTransferAccountKey.accountKeyOTC.rawValue
            toModel.balance = self.otcModel?.normal ?? "--"
        }else if withType == .leverage {
            toModel.key = EXTransferAccountKey.accountKeyOTC.rawValue
            if self.coinName.uppercased() == leverModel.baseCoin.uppercased(){
                toModel.balance = leverModel.baseNormalBalance
            }else {
                toModel.balance = leverModel.quoteNormalBalance
            }
            
        }else {
            toModel.key = self.contractModel?.contractAccountType ?? ""
            toModel.balance = self.contractModel?.canUseBalance ?? ""
        }
    }
}

extension EXAccountTransferVc {
    
    func onSuccessAlert(_ account:EXAccountType) {
        let normalAlert = EXNormalAlert()
        normalAlert.configAlert(title:nil, message: "transfer_text_guideTransaction".localized(), passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "transfer_action_goTransaction".localized())
        normalAlert.alertCallback = {[weak self] tag in
            self?.handleAlert(tag,account)
        }
        EXAlert.showAlert(alertView: normalAlert)
    }
    
    func handleAlert(_ alertTag:Int, _ account:EXAccountType ) {
        if alertTag == 0 {
            self.handlePositiveBtnAction(account)
        }else  {
            if isPopRoot {
           self.navigationController?.popToRootViewController(animated: true)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }

        // 成功划转的2个账户,无所谓谁转谁.刷新相关api
        guard let fromAccountType = accountTransferHeader.fromAccountView.accountType else {return}
        guard let toAccountType = accountTransferHeader.toAccountView.accountType else {return}
        self.onTrasferSuccessCallback?(fromAccountType,toAccountType)
    }
    
    func handlePositiveBtnAction(_ account:EXAccountType) {
        //去交易页面/去otc页面/去合约页面/杠杆页面
        self.navigationController?.popToRootViewController(animated: false)
        if account == .coin {
            var coinEntity = CoinMapEntity()
            if canTransferType == .leverage {
                self.symbol = (self.coinMapName as NSString).replacingOccurrences(of: "/", with: "").lowercased()
                coinEntity = PublicInfoManager.sharedInstance.getCoinMapWithSymbol(self.symbol)
            }else{
                coinEntity = PublicInfoManager.sharedInstance.getDealEntity(self.symbol)
            }
            if coinEntity.name.isEmpty {
                EXAlert.showFail(msg: "common_tip_coinTradeNotOpen".localized())
            }else {
                EXNavigationHandler.sharedHandler.commandTradingCoin(coinEntity.symbol, "buy")
            }
        }else if account == .otc {
            EXNavigationHandler.sharedHandler.commandToOTC(self.symbol, "")
        }else if account == .leverage {
            EXNavigationHandler.sharedHandler.commandTradingCoin((self.coinMapName as NSString).replacingOccurrences(of: "/", with: "").lowercased(), "leverBuy")
        }else  {
            EXNavigationHandler.sharedHandler.commandToContract(self.symbol, "")
        }
    }
}
extension EXAccountTransferVc {//杠杆用
    func loadData() {
        if coinMapName.count == 0 {
            return
        }
        let str = (coinMapName as NSString).replacingOccurrences(of: "/", with: "").uppercased()
        appApi.rx.request(.leverFinanceSymbolInfo(symbol: str))
            .MJObjectMap(EXLeverCoinBorrowRecord.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.leverModel = model
                    self?.updateCoinDatas()
                    break
                case .error(_):
                    break
                }
        }.disposed(by: self.disposeBag)
    }
}
