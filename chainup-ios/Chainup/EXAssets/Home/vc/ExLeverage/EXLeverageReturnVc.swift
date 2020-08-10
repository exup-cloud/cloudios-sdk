//
//  EXLeverageReturnVc.swift
//  Chainup
//
//  Created by ljw on 2019/11/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
enum EXLeverageType {
    case none
    case leverageReturn//归还
    case leverageBorrow//借贷
}
class EXLeverageReturnVc: UIViewController,NavigationPlugin{
    
    internal lazy var navigation : EXNavigation = {
           let nav =  EXNavigation.init(affectScroll: self.scrollView, presenter: self)
           nav.isLastNavigationStyle = false
           return nav
       }()
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    var selectIdx = 0
    var isBase = true
    var borrowModel = EXLeverCoinBorrowRecord()
    typealias returnSuccessBlock = () -> ()
    var successBlock : returnSuccessBlock?
    var currentCoinName = ""//借贷币对
    var model = EXCurrentBorrowListModel()//归还用
    @IBOutlet weak var typeLab: UILabel!//做空还是做单
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leverageTitleLab: UILabel!
    @IBOutlet weak var leverageLab: UILabel!
    @IBOutlet weak var returnSymbolTitleLab: UILabel!
    @IBOutlet weak var returnSymbolLab: UILabel!
    @IBOutlet weak var shouldReturnLab: UILabel!
    @IBOutlet weak var shouldReturnTitleLab: UILabel!
    @IBOutlet weak var rateTitleLab: UILabel!
    @IBOutlet weak var rateLab: UILabel!
    @IBOutlet weak var allAmountLab: UILabel!
    @IBOutlet weak var allAmountTitleLab: UILabel!
    @IBOutlet weak var amountField: EXWithDrawAmountField!
    @IBOutlet weak var topCon: NSLayoutConstraint!
    @IBOutlet weak var bottomCon: NSLayoutConstraint!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var topLab: UILabel!
    @IBOutlet weak var topBackView: UIView!//归还的时候隐藏
    @IBOutlet weak var bottomBackView: UIView!//归还的时候隐藏
    @IBOutlet weak var returnStackView: UIStackView!//借贷的时候隐藏
    var type : EXLeverageType = .none
    var titlesArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ThemeView.bg
        handNavigationBar()
        if type == .leverageReturn {
            currentCoinName = model.symbol
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    func configUI(){
        amountField.titleLabel.text = "charge_text_volume".localized()
        amountField.rightSendAllLabel.text = "common_action_sendall".localized()
        if type == .leverageReturn{
            leverageTitleLab.text = "leverage_asset".localized()
            leverageLab.text = borrowModel.name.aliasCoinMapName().uppercased()
            returnSymbolTitleLab.text = "leverage_returnCoin".localized()
            returnSymbolLab.text = model.coin.aliasName()
            shouldReturnTitleLab.text = "leverage_shouldReturn_amount".localized()
            shouldReturnLab.text = (model.oweAmount as NSString).adding(model.oweInterest, decimals: PublicInfoManager.sharedInstance.coinPrecision(model.coin)).formatAmount(model.coin,isLeverage: true) + model.coin.aliasName()
            
            allAmountTitleLab.text = "leverage_totalBorrow_amount".localized()
            allAmountLab.text = model.borrowMoney.formatAmount(model.coin,isLeverage: true) + model.coin.aliasName()
            rateTitleLab.text = "leverage_interest".localized()
            rateLab.text = model.oweInterest.formatAmount(model.coin,isLeverage: true) + model.coin.aliasName()
            self.navigation.setTitle(title:"leverage_return".localized())
            returnBtn.setTitle("leverage_return".localized(), for: UIControlState.normal)//归还
            topBackView.isHidden = true
            bottomBackView.isHidden = true
            if model.coin.uppercased() == borrowModel.baseCoin.uppercased() {
                self.basicSet(isBase: true)
            }else {
                self.basicSet(isBase: false)
            }
            
        }else {
            let totalMoney = borrowModel.symbolBalance as NSString
            if totalMoney.isEqualValue("0") {
                let normalAlert = EXNormalAlert()
                let att = NSMutableAttributedString.init(string:String.init(format: "leverage_notEnught_prompt".localized(), currentCoinName.aliasCoinMapName()))
                att.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.ThemeLabel.colorLite], range: att.yy_rangeOfAll())
                att.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.ThemeState.warning], range: (att.string as NSString) .range(of: currentCoinName.aliasCoinMapName()))
                normalAlert.configAttributeAlert(title:nil, message: att, passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "assets_action_transfer".localized())
                normalAlert.alertCallback = {[weak self] tag in
                    guard let mySelf = self else {
                        return
                    }
                    if tag == 0 {
                        let transfer = EXAccountTransferVc.instanceFromStoryboard(name: StoryBoardNameAsset)
                        transfer.coinName = mySelf.isBase ? mySelf.borrowModel.baseCoin : mySelf.borrowModel.quoteCoin
                        transfer.coinMapName =  mySelf.borrowModel.name.uppercased()
                        transfer.transferFlow = .leverageToExchagne
                        transfer.onTrasferSuccessCallback = { [weak self] (ftype,ttype) in
                              
                        }
                self?.navigationController?.pushViewController(transfer, animated: true)
                    }
                }
                EXAlert.showAlert(alertView: normalAlert)
                
            }
            if currentCoinName.count > 0 && currentCoinName.contains("/"){
                titlesArr = (currentCoinName.aliasCoinMapName() as NSString).components(separatedBy: "/")
                var tempArr = [String]()
                for (idx,item) in titlesArr.enumerated() {
                    if idx == 0 {
                        tempArr.append(String(format: "leverage_short".localized(), item))
                    }else {
                        tempArr.append(String(format: "leverage_more".localized(), item))
                    }
                }
                titlesArr = tempArr
                if titlesArr.count == 2 {
                    if isBase {
                        typeLab.text = titlesArr[0]
                    }else {
                        typeLab.text = titlesArr[1]
                    }
                    
                }
            }
            leverageTitleLab.text = "leverage_asset".localized()
            leverageLab.text = currentCoinName.aliasCoinMapName()
            shouldReturnTitleLab.text = "leverage_have_borrowed".localized()
            allAmountTitleLab.text = "leverage_text_biggestLimit".localized()
            self.basicSet(isBase: isBase)
            rateTitleLab.text = "leverage_rate".localized()
            
            rateLab.text = borrowModel.rate
            returnStackView.isHidden = true
            self.navigation.setTitle(title:"leverage_borrow".localized())
            self.getTopTitle(coin: currentCoinName.aliasCoinMapName())
            returnBtn.setTitle("leverage_borrow".localized(), for: UIControlState.normal)
          bottomBtn.setImage(UIImage.themeImageNamed(imageName: "dropdown_small"), for: UIControlState.normal)
          bottomBtn.setImage(UIImage.themeImageNamed(imageName: "collapse_small"), for: UIControlState.selected)
            navigation.configRightItems(["leverage_borrowRecord".localized()], isImageName: false)
            navigation.rightItemCallback = {[weak self] tag in
                if var currentCoinName = self?.currentCoinName {
                   currentCoinName = (currentCoinName as NSString).replacingOccurrences(of: "/", with: "")
                    let vc = EXCurrentBorrowVc.init(nibName: "EXCurrentBorrowVc", bundle: nil)
                    vc.coinMapName = currentCoinName.uppercased()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        if isiPhoneX {
            bottomCon.constant = TABBAR_BOTTOM + 10;
        }else {
            bottomCon.constant = 30;
        }
    }
    func basicSet(isBase : Bool) {
        if type == .leverageReturn {//归还
             amountField.decimal = "8"
            if isBase {
                amountField.input.placeholder = "withdraw_text_minimumVolume".localized() + borrowModel.baseMinPayment.formatAmount(model.coin,isLeverage: true)
                amountField.leftSymbolLabel.text = model.coin.aliasName()
                amountField.symbol = model.coin
                amountField.setAmount(amount:borrowModel.baseNormalBalance, title: "redpacket_send_availableBalance".localized(),isLeverage: true)
            }else {
                amountField.input.placeholder = "withdraw_text_minimumVolume".localized() + borrowModel.quoteMinPayment.formatAmount(model.coin,isLeverage: true)
                amountField.leftSymbolLabel.text = model.coin.aliasName()
                amountField.symbol = model.coin
                amountField.setAmount(amount:borrowModel.quoteNormalBalance, title: "redpacket_send_availableBalance".localized(),isLeverage: true)
            }
            amountField.input.rx.text.orEmpty.changed.asObservable().subscribe {[weak self] (event) in
                guard let mySelf = self else {return}
                let inputMoney = (mySelf.amountField.input.text ?? "") as NSString
                let total = (mySelf.model.oweAmount as NSString).adding(mySelf.model.oweInterest, decimals: PublicInfoManager.sharedInstance.coinPrecision(mySelf.model.coin)).formatAmount(mySelf.model.coin,isLeverage: true)
                if isBase {
                    let normalBalnance = mySelf.borrowModel.baseNormalBalance.formatAmount(mySelf.model.coin,isLeverage: true)
                    
                    if inputMoney.isEqualValue(normalBalnance) && (normalBalnance as NSString).isBig(total)  {
                       mySelf.amountField.input.text = total
                    }
                }else {
                   let normalBalnance = mySelf.borrowModel.quoteNormalBalance.formatAmount(mySelf.model.coin,isLeverage: true)
            
                   if inputMoney.isEqualValue(normalBalnance) && (normalBalnance as NSString).isBig(total)  {
                      mySelf.amountField.input.text = total
                   }
                }
            }.disposed(by: self.disposeBag)
        }else {
            amountField.decimal = "3"
            amountField.input.text = ""
            amountField.changeThemeColor(isRed: false)
            if isBase {
                shouldReturnLab.text = borrowModel.baseBorrowBalance.formatAmount(borrowModel.baseCoin,isLeverage: true) + borrowModel.baseCoin.aliasName()
                allAmountLab.text = (borrowModel.baseCanBorrow as NSString).adding(borrowModel.baseBorrowBalance, decimals: PublicInfoManager.sharedInstance.coinPrecision(borrowModel.baseCoin)) .formatAmount(borrowModel.baseCoin,isLeverage: true) + borrowModel.baseCoin.aliasName()
               amountField.input.placeholder = "withdraw_text_minimumVolume".localized() + borrowModel.baseMinBorrow.formatAmountUseDecimal("3")
                amountField.leftSymbolLabel.text = borrowModel.baseCoin.aliasName()
               amountField.symbol = borrowModel.baseCoin
               amountField.setLeverageAmount(amount: borrowModel.baseCanBorrow, title:"leverage_text_canborrow".localized())
            }else {
                shouldReturnLab.text = borrowModel.quoteBorrowBalance.formatAmount(borrowModel.quoteCoin,isLeverage: true) + borrowModel.quoteCoin.aliasName()
                allAmountLab.text = (borrowModel.quoteCanBorrow as NSString).adding(borrowModel.quoteBorrowBalance, decimals: PublicInfoManager.sharedInstance.coinPrecision(borrowModel.quoteCoin)) .formatAmount(borrowModel.quoteCoin,isLeverage: true) + borrowModel.quoteCoin.aliasName()
                amountField.input.placeholder = "withdraw_text_minimumVolume".localized() + borrowModel.quoteMinBorrow.formatAmountUseDecimal("3")
                amountField.leftSymbolLabel.text = borrowModel.quoteCoin.aliasName()
                amountField.symbol = borrowModel.quoteCoin
                amountField.setLeverageAmount(amount: borrowModel.quoteCanBorrow, title: "leverage_text_canborrow".localized())
            }
            amountField.input.rx.text.orEmpty.changed.asObservable().subscribe {[weak self] (event) in
                guard let mySelf = self else {return}
                let inputMoney = (mySelf.amountField.input.text ?? "") as NSString
                var coin = ""
                if isBase {
                    coin = mySelf.borrowModel.baseCoin
                    if inputMoney.isBig(mySelf.borrowModel.baseCanBorrow.formatAmountUseDecimal("3")) || inputMoney.isSmall(mySelf.borrowModel.baseMinBorrow.formatAmountUseDecimal("3")) {
                    }else {
                        mySelf.amountField.setLeverageAmount(amount: mySelf.borrowModel.baseCanBorrow, title:"leverage_text_canborrow".localized())
                        mySelf.amountField.changeThemeColor(isRed: false)
                    }
                }else {
                    coin = mySelf.borrowModel.quoteCoin
                   if inputMoney.isBig(mySelf.borrowModel.quoteCanBorrow.formatAmountUseDecimal("3")) || inputMoney.isSmall(mySelf.borrowModel.quoteMinBorrow.formatAmountUseDecimal("3")) {
                   }else {
                       mySelf.amountField.changeThemeColor(isRed: false)
                      mySelf.amountField.setLeverageAmount(amount: mySelf.borrowModel.quoteCanBorrow, title: "leverage_text_canborrow".localized())
                   }
                }
            }.disposed(by: self.disposeBag)
        }
    }
    func handNavigationBar() {
        self.navigation.setdefaultType(type: .list)
    }
    func largeTitleValueChanged(height: CGFloat) {
        topCon.constant = height
    }

    @IBAction func returnBtnClick(_ sender: Any) {
 
        if type == .leverageReturn {//归还
            let inputMoney = (amountField.input.text ?? "") as NSString
            if inputMoney.length == 0{
                return
            }
            appApi.rx.request(.leverFinanceReturn(id: model.id, amount: amountField.input.text ?? ""))
                .MJObjectMap(EXVoidModel.self)
                .subscribe{[weak self] event in
                    switch event {
                    case .success(_):
                        self?.successBlock?()
                        self?.navigationController?.popViewController(animated:true)
                        break
                    case .error(_):
                        break
                    }
            }.disposed(by: self.disposeBag)
        }else {//借贷
             
             let inputMoney = (amountField.input.text ?? "") as NSString
            if inputMoney.length == 0 {
                return
            }
            if inputMoney.isEqualValue("0") {
               return
           }
             var coin = ""
            if isBase {
                coin = borrowModel.baseCoin
                if inputMoney.isBig(borrowModel.baseCanBorrow.formatAmount(coin,isLeverage: true)) {
                    amountField.amountLabel.text = "leverage_text_lessThanCanuse".localized()
                    amountField.changeThemeColor(isRed: true)
                    return
                }
                if inputMoney.isSmall(borrowModel.baseMinBorrow.formatAmount(coin,isLeverage: true)) {
                    amountField.amountLabel.text = String.init(format: "leverage_text_noLess".localized(),borrowModel.baseMinBorrow.formatAmount(coin,isLeverage: true),coin.aliasName())
                    amountField.changeThemeColor(isRed: true)
                    return
                }

            }else {
                coin = borrowModel.quoteCoin
                
                if inputMoney.isBig(borrowModel.quoteCanBorrow.formatAmount(coin,isLeverage: true)) {
                    amountField.amountLabel.text = "leverage_text_lessThanCanuse".localized()
                    amountField.changeThemeColor(isRed: true)
                    return
                }
                if inputMoney.isSmall(borrowModel.quoteMinBorrow.formatAmount(coin,isLeverage: true)) {
                    amountField.amountLabel.text = String.init(format: "leverage_text_noLess".localized(),borrowModel.quoteMinBorrow.formatAmount(coin,isLeverage: true),coin.aliasName())
                    amountField.changeThemeColor(isRed: true)
                    return
                }

            }
           appApi.rx.request(.leverFinanceBorrow(symbol:(currentCoinName as NSString).replacingOccurrences(of: "/", with: "").uppercased(), coin: coin, amount: amountField.input.text ?? ""))
                .MJObjectMap(EXVoidModel.self)
                .subscribe{[weak self] event in
                    switch event {
                    case .success(_):

                        self?.navigationController?.popToRootViewController(animated:true)
                        break
                    case .error(_):
                        break
                    }
            }.disposed(by: self.disposeBag)
        }
    }
    
    @IBAction func bottomBtnClick() {
        for (idx,item) in titlesArr.enumerated() {
            if self.typeLab.text == item {
                selectIdx = idx
                break
            }
        }
        let sheet = EXActionSheetView()
         sheet.configButtonTitles(buttons: titlesArr,selectedIdx: selectIdx)
         sheet.actionIdxCallback = {[weak self] tag in
            guard let mySelf = self else {
                return
            }
            mySelf.isBase = (tag == 0)
            mySelf.configUI()
         }
         EXAlert.showSheet(sheetView:sheet)
         //self.bottomBtn.isSelected = false
    }
    @IBAction func topBackViewClick(_ sender: UITapGestureRecognizer) {
        let vc = EXLeverageCoinSearchVc.init(nibName: "EXLeverageCoinSearchVc", bundle: nil)
        vc.backCoinNameBlock = {[weak self] str in
            self?.currentCoinName = str
            self?.getTopTitle(coin: str)
            self?.isBase = true
            //self?.loadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTopTitle(coin : String) {
        self.topLab.text = coin + "leverage_asset".localized()
    }
}
extension EXLeverageReturnVc {
    func loadData() {
        let str = (currentCoinName as NSString).replacingOccurrences(of: "/", with: "").uppercased()
        appApi.rx.request(.leverFinanceSymbolInfo(symbol: str))
            .MJObjectMap(EXLeverCoinBorrowRecord.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(let model):
                    self?.borrowModel = model
                    self?.returnBtn.isHidden = false
                    self?.contentView.isHidden = false
                    self?.configUI()
                    break
                case .error(_):
                    break
                }
        }.disposed(by: self.disposeBag)
    }
}

