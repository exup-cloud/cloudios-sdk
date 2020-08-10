//
//  EXCoinWithDrawEmptyAddress.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXCoinWithDrawEmptyAddress: NibBaseView {
    @IBOutlet var withdrawAddress: EXWithDrawAddressField!
    
    typealias QRActionCallback = ()->()
    typealias AddressBookCallback = ()->()
    var onQRScanCallback:QRActionCallback?
    var onAddressBookCallback:AddressBookCallback?
    
    override func onCreate() {
        withdrawAddress.setTitle(title: "withdraw_text_address".localized())
        withdrawAddress.setPlaceHolder(placeHolder: "withdraw_tip_addressEmpty".localized())
        withdrawAddress.scanBtn.addTarget(self, action: #selector(scanDidTapped), for: .touchUpInside)
        withdrawAddress.addressBtn.addTarget(self, action: #selector(addressDidTapped), for: .touchUpInside)
    }
    
    @objc func scanDidTapped(){
        onQRScanCallback?()
    }
    
    @objc func addressDidTapped() {
        onAddressBookCallback?()
    }
    
    func setAddress(_ text:String) {
        withdrawAddress.setText(text: text)
        withdrawAddress.input.sendActions(for: .valueChanged)
    }
    
    func setEmpty() {
        withdrawAddress.setText(text: "")
    }
    
    func setWithdrawSingleScanMode() {
        withdrawAddress.onlyScan()
    }
}
