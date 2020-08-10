//
//  EXChangeOTCPWView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXChangeOTCPWView: UIView {

    var tableViewNameDatas : [String] = [LanguageTools.getString(key: "otcSafeAlert_text_otcPwd"),LanguageTools.getString(key: "safety_text_confrimPasswod")]
    
    var tableViewRowDatas : [EXChangeOTCEntity] = []
    
    var type : [String] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extRegistCell([EXChangeOTCPWTC.classForCoder()], ["EXChangeOTCPWTC"])
        tableView.extSetTableView(self, self)
        return tableView
    }()
    
    lazy var confimBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.isEnabled = false
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickConfimBtn))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView,confimBtn])
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(confimBtn.snp.top).offset(-10)
        }
        confimBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-30 - TABBAR_BOTTOM)
        }
        setData()
    }
    
    func setData(){
        var arr : [EXChangeOTCEntity] = []
        for str in tableViewNameDatas{
            let entity = EXChangeOTCEntity()
            entity.name = str
            switch str{
            case LanguageTools.getString(key: "otcSafeAlert_text_otcPwd"):
                entity.placeHolder = LanguageTools.getString(key: "otcSafeAlert_text_otcPwd")
            case LanguageTools.getString(key: "safety_text_confrimPasswod"):
                entity.placeHolder = LanguageTools.getString(key: "safety_text_confrimPasswod")
            default:
                break
            }
            arr.append(entity)
        }
        tableViewRowDatas = arr
        tableView.reloadData()
        if UserInfoEntity.sharedInstance().isOpenMobileCheck == "1"{
            type.append("2")
        }
        if UserInfoEntity.sharedInstance().googleStatus == "1"{
            type.append("1")
        }
    }
    
    //监听
    func textfieldValueChange(){
        
        for entity in tableViewRowDatas{
            if entity.info == ""{
                confimBtn.isEnabled = false
                return
            }
        }
        confimBtn.isEnabled = true
    }
    
    //点击下一步
    @objc func clickConfimBtn(){
        for i in 0..<tableViewRowDatas.count{
            let entity = tableViewRowDatas[i]
            switch entity.name{
            case LanguageTools.getString(key: "otcSafeAlert_text_otcPwd"):
                if BusinessTools.numberAndCharacter(entity.info) == false{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_pwdNotice"))
                    return
                }
                if entity.info == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "safety_tip_inputOtcPassword"))
                    return
                }
            case LanguageTools.getString(key: "safety_text_confrimPasswod"):
                if entity.info == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_inputOtcPwdAgain"))
                    return
                }
                if entity.info != tableViewRowDatas[i - 1].info{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_inputsNotMatch"))
                    return
                }
            default:
                break
            }
        }
        validation()
    }
    
    //二次验证
    func validation(){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.models())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
//            let idx =  UserInfoEntity.sharedInstance().authLevel == "1" ? 1 : 0
//            guard let googleCode = formDic["googleCode"]else{return}
            var googleCode = ""
            var smsAuthCode = ""
            if mySelf.type.contains("1"){
                if let googleCode1 = formDic["googleCode"]{
                    googleCode = googleCode1
                }
            }
            if mySelf.type.contains("2"){
                if let moblie = formDic["moblie"]{
                    smsAuthCode = moblie
                }
            }
//            else if mySelf.type.contains("3"){
//                if let email = formDic["email"]{
//                    smsAuthCode = email
//                }
//            }
            if googleCode == "" && smsAuthCode == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_inputCode"))
                return
            }
        
        }
        sheet.itemBtnCallback = {[weak self]key in
            switch key {
            case "moblie":
                self?.getsmsValidCode()
                break
            case "email":
                self?.getemailVallidCode()
                break
            default:
                break
            }
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func models()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        if type.contains("2"){//手机
            let model = EXInputSheetModel.setModel(withTitle:"personal_text_phoneCode".localized(),key:"moblie",placeHolder: "personal_tip_inputPhoneCode".localized(), type: .sms , keyBoard : .numberPad)
            models.append(model)
        }
        if type.contains("1"){//谷歌
            let model = EXInputSheetModel.setModel(withTitle:"personal_text_googleCode".localized(),key:"googleCode",placeHolder: "common_tip_googleAuth".localized(), type: .paste , keyBoard : .numberPad)
            models.append(model)
        }

        return models
    }
    
    //获取手机验证码
    func getsmsValidCode(){
        appApi.rx.request(.getsmsValidCode(token: XUserDefault.getToken() ?? "", operationType: EXSendVerificationCode.changeotcpw, countryCode: "", mobile: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
//            EXAlert.showSuccess(msg: LanguageTools.getString(key: "验证码已发送"))
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
    //获取邮箱验证码
    func getemailVallidCode(){
        appApi.rx.request(.getemailVallidCode(email: "", operationType: EXSendVerificationCode.changeotcpw,token: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
            EXAlert.showSuccess(msg: LanguageTools.getString(key: "login_tip_didSendCode"))
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension EXChangeOTCPWView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        let cell : EXChangeOTCPWTC = tableView.dequeueReusableCell(withIdentifier: "EXChangeOTCPWTC") as! EXChangeOTCPWTC
        cell.setCell(entity)
        cell.textfieldValueChangeBlock = {[weak self] in
            self?.textfieldValueChange()
        }
        return cell
    }
}
