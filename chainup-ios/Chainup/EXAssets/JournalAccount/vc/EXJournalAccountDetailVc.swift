//
//  EXJournalAccountDetailVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXJournalAccountDetailVc: UIViewController,StoryBoardLoadable,NavigationPlugin {

    @IBOutlet var journalTable: UITableView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    var financeItem:FinanceItem = FinanceItem()
    let detailHeader:EXJournalDetailHeader = EXJournalDetailHeader()
    @IBOutlet var footerView: EXCoinWithdrawFooter!
    
    let financeRowType = "financeRowType"
    let financeRowTime = "financeRowTime"
    let financeRowSymbol = "financeRowSymbol"
    let financeRowAmount = "financeRowAmount"//通用-数量
    let financeRowStatus = "financeRowStatus"//通用-状态
    let financeRowAddress = "financeRowAddress"//提现类型-地址
    let financeRowDepositAddress = "financeRowDepositAddress"//充值类型-地址

    let financeRowRemark = "financeRowRemark"//提现类型-备注
    let financeRowFee = "financeRowFee"//提现类型-手续费
    let financeRowConfirmNumber = "financeRowConfirmNumber" // 充值类型-后的确认次数
    let financeRowTXID = "financeRowTXID"//充值 -txid
    let financeRowProcessTime = "financeRowProcessTime" // 充值提现，钱包处理时间

    var rowDatas:[String] = []
    var sceneKey = ""
    
    typealias CancelWithdrawCallback = () -> ()
    var onCancelSuccessCallback:CancelWithdrawCallback?
    
    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: journalTable, presenter: self)
        return nav
    }()
    
    func configNavigation(){
        self.navigation.isLastNavigationStyle = true
        self.navigation.setdefaultType(type: .list)
        self.navigation.setTitle(title: "common_text_detailInfo".localized())
    }
    
    func configTableView() {
        self.journalTable.register(UINib.init(nibName: "EXJournalDetailCell", bundle: nil), forCellReuseIdentifier: "EXJournalDetailCell")
    }
    
    func configFooter () {
        if self.financeItem.status == EXWithDrawVerifyStep.notStated.rawValue,self.sceneKey == EXJournalListSceneKey.withdraw.rawValue {
            footerView.isHidden = false
            footerView.hideFooterTitle()
            footerView.confirmBtn.setTitle("common_action_orderCancel".localized(), for: .normal)
            footerView.confirmBtn.rx.tap.asObservable()
                .throttle(1, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.handleWithdrawRevocation()
                }).disposed(by: self.disposeBag)
        }else {
            footerView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configFooter()
        configNavigation()
        configTableView()
        configDetailModel()
    }
    
    func configDetailModel() {
    
        rowDatas.append(financeRowTime)
        rowDatas.append(financeRowType)
        if self.sceneKey != EXJournalListSceneKey.otctransfer.rawValue {
            rowDatas.append(financeRowAmount)
        }

        if self.sceneKey == EXJournalListSceneKey.withdraw.rawValue {
            //提现
            rowDatas.append(financeRowAddress)
            rowDatas.append(financeRowRemark)
            rowDatas.append(financeRowFee)
            rowDatas.append(financeRowTXID)
            rowDatas.append(financeRowProcessTime)

        }else if self.sceneKey == EXJournalListSceneKey.deposit.rawValue {
            //充值charge_text_chargeAddress
            rowDatas.append(financeRowConfirmNumber)
            rowDatas.append(financeRowDepositAddress)
            rowDatas.append(financeRowTXID)
            rowDatas.append(financeRowProcessTime)
        }
        
        if self.sceneKey != EXJournalListSceneKey.otctransfer.rawValue {
            rowDatas.append(financeRowStatus)
        }
        self.journalTable.reloadData()
    }
    
    func largeTitleValueChanged(height: CGFloat) {
        topConstraint.constant = height
    }
    
}

extension EXJournalAccountDetailVc {
    func handleWithdrawRevocation() {
        let normalAlert = EXNormalAlert()
        normalAlert.configAlert(title: "common_text_tip".localized(), message: "withdraw_tip_confirmCancelWithdraw".localized())
        normalAlert.alertCallback = {[weak self] tag in
            if tag == 0 {
                self?.doRevocation()
            }
        }
        EXAlert.showAlert(alertView: normalAlert)
    }
    
    func doRevocation() {
        let withdrawId = self.financeItem.id
        appApi.rx.request(.cancelWithDraw(withDrawId: withdrawId))
            .MJObjectMap(EXVoidModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(_):
                    self?.cancelWithdrawSuccess()
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func cancelWithdrawSuccess() {
        self.onCancelSuccessCallback?()
        EXAlert.showSuccess(msg: "withdraw_tip_didCancelWithdraw".localized())
        self.navigationController?.popViewController(animated:true)
    }
}


extension EXJournalAccountDetailVc : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 48
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        detailHeader.headerTitle.text = self.financeItem.amount.formatAmount(self.financeItem.coinSymbol) + " " + self.financeItem.coinSymbol.aliasName()
        detailHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 30)
        return detailHeader
    }
}

extension EXJournalAccountDetailVc : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowKey = self.rowDatas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXJournalDetailCell") as! EXJournalDetailCell
        var title = ""
        var desc = ""
        
        if rowKey == financeRowType {
            title = "contract_text_type".localized()
            if sceneKey == EXJournalListSceneKey.otctransfer.rawValue {
                desc = self.financeItem.status_text
            }else {
                desc = self.financeItem.transactionScene
            }
        }else if rowKey == financeRowTime {
            title = "kline_text_dealTime".localized()
            desc = self.financeItem.createTime
        }else if rowKey == financeRowSymbol {
            title = "common_text_coinsymbol".localized()
            desc = self.financeItem.coinSymbol.aliasName()
        }else if rowKey == financeRowAmount{
            title = "charge_text_volume".localized()
            desc = self.financeItem.amount.formatAmount(self.financeItem.coinSymbol)
        }else if rowKey == financeRowStatus {
            title = "charge_text_state".localized()
            desc = self.financeItem.status_text
        }else if rowKey == financeRowConfirmNumber {
            title = "withdraw_text_txConfirmCount".localized()
            desc = self.financeItem.confirmDesc
        }else if rowKey == financeRowTXID {
            title = "TXID"
            if self.financeItem.txid.isEmpty {
                desc = "--"
            }else {
                desc = self.financeItem.txid
            }
        }else if rowKey == financeRowAddress {
            title = "withdraw_text_address".localized()
            desc = self.financeItem.addressTo
        }else if rowKey == financeRowDepositAddress {
            title = "charge_text_chargeAddress".localized()
            desc = self.financeItem.addressTo
        }else if rowKey == financeRowRemark{
            title = "address_text_remark".localized()
            desc = self.financeItem.label
        }else if rowKey == financeRowFee {
            title = "withdraw_text_fee".localized()
            desc = self.financeItem.fee.formatAmount(self.financeItem.coinSymbol)
        }else if rowKey == financeRowProcessTime {
            title = "common_text_walletProcessTime".localized()
            desc = self.financeItem.walletTime
        }
        let needCopy = ((rowKey == financeRowTXID && self.financeItem.txid.count > 0) || (rowKey == financeRowAddress) || (rowKey == financeRowDepositAddress))
        cell.updateTitle(title, desc,needCopy)
        return cell
    }
}

