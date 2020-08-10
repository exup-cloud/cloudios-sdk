//
//  EXGoogleOpenView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXGoogleOpenView: UIView {

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self,self)
        tableView.estimatedRowHeight = 44
        tableView.extRegistCell([EXGoogleOpenTC.classForCoder()], ["EXGoogleOpenTC"])
//        tableView.extRegistCell()
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //二次验证
    func validation(){
        if UserInfoEntity.sharedInstance().isOpenMobileCheck == "0"{
            EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_bindPhoneFirst"))
            return
        }
        
        let sheet = EXActionSheetView()
        sheet.autoDismiss = false
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.models())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            guard let googleCode = formDic["googleCode"]else{return}
            guard let smsAuthCode = formDic["smsAuthCode"] else{return}
            if googleCode == "" && smsAuthCode == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_inputCode"))
                return
            }
            //关闭谷歌验证
            appApi.rx.request(.closeGoogle(smsValidCode: smsAuthCode, googleCode: googleCode)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (model) in
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "common_text_googleAuthOff"))
                mySelf.yy_viewController?.navigationController?.popViewController(animated: true)
                UserInfoEntity.sharedInstance().googleStatus = "0"
                UserInfoEntity.setTmpDict()
                sheet.dismiss()
            }, onError: { (error) in
                
            }).disposed(by: mySelf.disposeBag)
        }
        sheet.itemBtnCallback = {[weak self]key in
            switch key {
            case "smsAuthCode":
                self?.getsmsValidCode()
                break
            default:
                break
            }
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func models()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:"personal_text_googleCode".localized(),key:"googleCode",placeHolder: "common_tip_googleAuth".localized(), type: .paste , keyBoard:.numberPad)
        let model2 = EXInputSheetModel.setModel(withTitle:"personal_text_phoneCode".localized(),key:"smsAuthCode",placeHolder: "personal_tip_inputPhoneCode".localized(), type: .sms, keyBoard:.numberPad)
        models.append(model2)
        models.append(model1)
        return models
    }
    
    //获取手机验证码
    func getsmsValidCode(){
        appApi.rx.request(.getsmsValidCode(token: "", operationType: EXSendVerificationCode.closegoogleAndmoblie, countryCode: "", mobile: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
            //            EXAlert.showSuccess(msg: LanguageTools.getString(key: "验证码已发送"))
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXGoogleOpenView : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EXGoogleOpenTC = tableView.dequeueReusableCell(withIdentifier: "EXGoogleOpenTC") as! EXGoogleOpenTC
        cell.valueChangeCallback = {[weak self]b in
            self?.validation()
            cell.switchV.setOn(isOn: true)
        }
        return cell
    }
    
    
}
