//
//  EXCoinAddressListVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/5.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinAddressListVc: UIViewController,StoryBoardLoadable,NavigationPlugin,EXEmptyDataSetable {

    @IBOutlet var addressTable: UITableView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    var addressDatasource:[AddressItem] = []
    var coinSymbol:String = ""//子链名称
    var mainChainName = ""//主链名称
    
    var selectAddressItem:AddressItem?
    
    typealias AddressItemCallback = (AddressItem)->()
    var onAddressItemCallback:AddressItemCallback?
    
    
    typealias AddressDeleteCallback = (AddressItem)->()
    var onAddressDeleteCallback:AddressDeleteCallback?
    
    let smsService:EXSmsService = EXSmsService()

    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: self.addressTable, presenter: self)
        return nav
    }()
    
    func handleNavigation() {
        self.navigation.setTitle(title: "withdraw_text_address".localized())
        navigation.configRightItems(["address_action_addnew".localized()],isImageName: false)
        navigation.rightItemCallback = {[weak self] tag in
            self?.addnewAddress()
        }
    }
    
    func addnewAddress() {
        let addnew = EXCoinAddNewAddressVc.instanceFromStoryboard(name: StoryBoardNameAsset)
        addnew.coinSymbol = self.coinSymbol
        addnew.mainChainName = mainChainName
        addnew.onAddressSuccessed = {[weak self] in
            self?.handleNewAddress()
        }
        self.navigationController?.pushViewController(addnew, animated: true)
    }
    
    func handleNewAddress() {
        requestAddressList()
    }
    
    func handleTableView() {
        self.addressTable.register(UINib.init(nibName: "EXAddressListCell", bundle: nil), forCellReuseIdentifier: "EXAddressListCell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTableView()
        handleNavigation()
        requestAddressList()
        self.exEmptyDataSet(self.addressTable, attributeBlock: { () -> ([EXEmptyDataSetAttributeKeyType : Any]) in
            return [
                .verticalOffset:0,
            ]
        })
    }
    
    func requestAddressList() {
        if coinSymbol.isEmpty {
            return
        }
        appApi.rx.request(.addressList(coinSymbol: coinSymbol))
        .MJObjectMap(EXAddressListModel.self)
        .subscribe{[weak self] event in
            switch event {
            case .success(let model):
                self?.handleAddressList(model.addressList)
                break
            case .error(_):
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    func handleAddressList(_ addressList:[AddressItem]) {
        self.addressDatasource = addressList
        addressTable.reloadData()
    }
    
    func largeTitleValueChanged(height: CGFloat) {
        topConstraint.constant = height
    }
    
    func isTagSupportCoin() -> Bool {
        let hasTag = PublicInfoManager.sharedInstance.coinNeedTag(coinSymbol)
        return hasTag
    }
}

extension EXCoinAddressListVc : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isTagSupportCoin() {
            return 96
        }else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addressItem = addressDatasource[indexPath.row]
        onAddressItemCallback?(addressItem)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "address_action_delete".localized()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            let addressItem = addressDatasource[indexPath.row]
            let normalAlert = EXNormalAlert()
//删除去掉安全验证
            normalAlert.configAlert(title: "common_text_tip".localized(), message: "common_text_confirmDelete".localized(), passiveBtnTitle: "common_text_btnCancel".localized(), positiveBtnTitle: "common_text_btnConfirm".localized())
            normalAlert.alertCallback = {[weak self] idx in
                guard let `self` = self else { return }
                if idx == 0 {
                    self.verifiedSafety([:], addressItem.id,indexPath.row)
                }
            }
            EXAlert.showAlert(alertView: normalAlert)
//            smsService.getOTCAddAddressService(EXSendVerificationCode.updateNewAddress)
//            smsService.onServiceFinishCallback = {[weak self] dict in
//                self?.verifiedSafety(dict, addressItem.id,indexPath.row)
//            }
        }
    }
    
    func verifiedSafety(_ info:[String:String],_ key:String, _ index:Int) {
        appApi.rx.request(.deleteWithDrawAddr(ids: key,
                                            googleCode: info["googleCode"],
                                            smsCode: info["smsAuthCode"]))
            .MJObjectMap(EXVoidModel.self)
            .subscribe{[weak self] event in
                switch event {
                case .success(_):
                    self?.updateRowDatas(index)
                    EXAlert.showSuccess(msg: "address_tip_deleteSuccess".localized())
                    break
                case .error(_):
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func updateRowDatas(_ index: Int) {
        if addressDatasource.count > index {
            let addressItem = addressDatasource[index]
            self.onAddressDeleteCallback?(addressItem)
            addressDatasource.remove(at: index)
            addressTable.reloadData()
        }
    }
    
}

extension EXCoinAddressListVc : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressItem = addressDatasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EXAddressListCell") as! EXAddressListCell
        cell.updateCellItem(addressItem)
        if let selectItem = selectAddressItem,selectItem.address == addressItem.address {
            cell.showAddressCheckMark(true)
        }else {
            cell.showAddressCheckMark(false)
        }
        return cell
    }
}
