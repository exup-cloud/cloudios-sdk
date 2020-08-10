//
//  EXSmsService.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum EXCodeTypes {
    case google
    case sms
    case mail
    case none
}

class EXSmsServiceModel:NSObject {
    var key = ""
    var codeType:EXCodeTypes = .none
}

class EXSmsService: NSObject {
    let disposeBag = DisposeBag()
    
    typealias ServiceDidFinishCallback = ([String:String])->()
    var onServiceFinishCallback:ServiceDidFinishCallback?

    func getOTCAddPaymentService() {
        let user = UserInfoEntity.sharedInstance()
        var verifycations:[EXInputSheetModel] = []
        
        if user.didBindPhone() {
            let phone = EXInputSheetModel.setModel(withTitle:user.mobileNumber,key:"smsAuthCode",placeHolder: "personal_text_smsCode".localized(), type: .sms)
            verifycations.append(phone)
        }
        
        if user.didBindGoolge() {
            let google = EXInputSheetModel.setModel(withTitle:user.mobileNumber,key:"googleCode",placeHolder: "personal_text_googleCode".localized(), type: .paste)
            verifycations.append(google)
        }
        
        if user.didBindPhone() == false && user.didBindMail() == false {
            let mail = EXInputSheetModel.setModel(withTitle:user.mobileNumber,key:"emailValidCode",placeHolder: "personal_text_mailCode".localized(), type: .paste)
            verifycations.append(mail)
        }
        
        let sheet = EXActionSheetView()
        sheet.itemBtnCallback = {[weak self] key in
            self?.handlePaymentAddSheetAction(key)
        }
        sheet.configTextfields(title: "login_action_fogetpwdSafety".localized(), itemModels:verifycations)
        sheet.actionFormCallback = {[weak self] formDic in
            self?.onServiceFinishCallback?(formDic)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func getOTCAddAddressService(_ smsType:String = EXSendVerificationCode.addNewAddress) {
        let user = UserInfoEntity.sharedInstance()
        var verifycations:[EXInputSheetModel] = []
        
        if user.didBindPhone() {
            let phone = EXInputSheetModel.setModel(withTitle:user.mobileNumber,key:"smsAuthCode",placeHolder: "personal_text_smsCode".localized(), type: .sms)
            verifycations.append(phone)
        }
        //添加地址需要校验google。删除不需要
        if smsType == EXSendVerificationCode.addNewAddress {
            if user.didBindGoolge() {
                let google = EXInputSheetModel.setModel(withTitle:user.mobileNumber,key:"googleCode",placeHolder: "personal_text_googleCode".localized(), type: .paste)
                verifycations.append(google)
            }
        }
        
        let sheet = EXActionSheetView()
        sheet.itemBtnCallback = {[weak self] key in
            self?.handleAddressAddSheetAction(key,smsType)
        }
        sheet.configTextfields(title: "login_action_fogetpwdSafety".localized(), itemModels:verifycations)
        sheet.actionFormCallback = {[weak self] formDic in
            self?.onServiceFinishCallback?(formDic)
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func handlePaymentAddSheetAction(_ key:String) {
        if key == "smsAuthCode" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                appApi.hideAutoLoading()
                appApi.rx.request(.getsmsValidCode(token: "", operationType: EXSendVerificationCode.otcAddPayment, countryCode: "", mobile: ""))
                    .MJObjectMap(EXVoidModel.self)
                    .subscribe{event in
                        switch event {
                        case .success(_):
                            break
                        case .error(_):
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }
        }
    }
    
    func handleAddressAddSheetAction(_ key:String, _ smsType:String) {
        if key == "smsAuthCode" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                appApi.hideAutoLoading()
                appApi.rx.request(.getsmsValidCode(token: "", operationType: smsType, countryCode: "", mobile: ""))
                    .MJObjectMap(EXVoidModel.self)
                    .subscribe{event in
                        switch event {
                        case .success(_):
                            break
                        case .error(_):
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }
        }
    }

}
