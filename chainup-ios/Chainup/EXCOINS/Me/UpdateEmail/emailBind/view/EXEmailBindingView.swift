//
//  EXEmailBindingView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/16.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXEmailBindingView: UIView {
    
    var type : [String] = []
    
    var email : String = ""

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXEmailBindingTC.classForCoder()], ["EXEmailBindingTC"])
        return tableView
    }()
    
    lazy var nextBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickNextBtn))
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView,nextBtn])
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
        }
        if UserInfoEntity.sharedInstance().isOpenMobileCheck == "1"{
            type.append("2")
        }
        if UserInfoEntity.sharedInstance().googleStatus == "1"{
            type.append("1")
        }
        if UserInfoEntity.sharedInstance().email != ""{
            type.append("3")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXEmailBindingView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EXEmailBindingTC = tableView.dequeueReusableCell(withIdentifier: "EXEmailBindingTC") as! EXEmailBindingTC
        cell.textfieldValueChangeBlock = {[weak self]str in
            self?.email = str
        }
        return cell
    }
}

extension EXEmailBindingView{
    @objc func clickNextBtn(){
        if BusinessTools.isEmail(self.email) == false{
            EXAlert.showFail(msg:LanguageTools.getString(key: "safety_tip_inputMail"))
            nextBtn.hideLoading()
            return
        }
        validation()
    }
    
    //二次验证
    func validation(){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.models())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            var googleCode = ""//谷歌验证码
            var smsAuthCode = ""//手机验证码
            var oldemailCode = ""//老的邮箱
            var newmailCode = ""//新的邮箱
            if mySelf.type.contains("1"){
                if let google = formDic["googleCode"]{
                    googleCode = google
                }
                if googleCode == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_googleAuth".localized()))
                    return
                }
            }
            
            if mySelf.type.contains("2"){
                if let moblie = formDic["moblie"]{
                    smsAuthCode = moblie
                }
                if smsAuthCode == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_inputPhoneCode"))
                    return
                }
            }
            
            if mySelf.type.contains("3"){
                if let email = formDic["oldemail"]{
                    oldemailCode = email
                }
                if oldemailCode == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_pleaseInputOldMailCode"))
                    return
                }
            }
            
            if let code = formDic["newmailCode"]{
                newmailCode = code
            }
            if newmailCode == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_pleaseInputBindMailCode"))
                return
            }
            
            if UserInfoEntity.sharedInstance().email == ""{//绑定
                appApi.rx.request(AppAPIEndPoint.bindEmail(smsValidCode: smsAuthCode, googleCode: googleCode, emailValidCode: newmailCode, email: mySelf.email)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (model) in
                    EXAlert.showSuccess(msg: LanguageTools.getString(key: LanguageTools.getString(key: "login_tip_mailBindSuccess".localized())))
                    UserInfoEntity.sharedInstance().email = mySelf.email
                    UserInfoEntity.setTmpDict()
                    self?.yy_viewController?.navigationController?.popViewController(animated: true)
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }else{//更改
                appApi.rx.request(AppAPIEndPoint.updateEmail(emailOldValidCode: oldemailCode, emailNewValidCode: newmailCode, smsValidCode: smsAuthCode, googleCode: googleCode, emailValidCode: newmailCode, email: mySelf.email)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (model) in
                    EXAlert.showSuccess(msg: LanguageTools.getString(key: LanguageTools.getString(key: "login_tip_mailEditSucess")))
                    UserInfoEntity.sharedInstance().email = mySelf.email
                    UserInfoEntity.setTmpDict()
                    self?.yy_viewController?.navigationController?.popViewController(animated: true)
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }
        }
        sheet.itemBtnCallback = {[weak self]key in
            guard let mySelf = self else{return}
            switch key {
            case "moblie":
                mySelf.getsmsValidCode()
                break
            case "oldemail":
//                mySelf.getemailVallidCode(UserInfoEntity.sharedInstance().email)
                mySelf.getemailVallidCode("")
            case "newmailCode":
                mySelf.getemailVallidCode(mySelf.email)
                break
            default:
                break
            }
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func models()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:self.email,key:"newmailCode",placeHolder: "personal_tip_inputMailCode".localized(), type: .sms,keyBoard : .numberPad)
        models.append(model1)
        if type.contains("3"){//邮箱
            let model = EXInputSheetModel.setModel(withTitle:UserInfoEntity.sharedInstance().email,key:"oldemail",placeHolder: "personal_tip_inputMailCode".localized(), type: .sms , keyBoard : .numberPad)
            models.append(model)
        }
        if type.contains("2"){//手机
            let model = EXInputSheetModel.setModel(withTitle:UserInfoEntity.sharedInstance().mobileNumber,key:"moblie",placeHolder: "personal_tip_inputPhoneCode".localized(), type: .sms,keyBoard : .numberPad)
            models.append(model)
        }
        if type.contains("1"){//谷歌
            let model = EXInputSheetModel.setModel(withTitle:"personal_text_googleCode".localized(),key:"googleCode",placeHolder: "common_tip_googleAuth".localized(), type: .paste, keyBoard : .numberPad)
            models.append(model)
        }
        return models
    }
    
    //获取手机验证码
    func getsmsValidCode(){
        appApi.rx.request(.getsmsValidCode(token: XUserDefault.getToken() ?? "", operationType: EXSendVerificationCode.updateemailwithphone, countryCode: "", mobile: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
    //获取邮箱验证码
    func getemailVallidCode(_ email : String){
        appApi.rx.request(.getemailVallidCode(email: email, operationType: EXSendVerificationCode.updateemailwithemail,token:"")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
}
