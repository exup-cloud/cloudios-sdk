//
//  EXSecurityView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXSecurityView: UIView {
    
    
    var tableViewNameDatas : [String] = [LanguageTools.getString(key: "register_text_phone"),LanguageTools.getString(key: "register_text_mail"),LanguageTools.getString(key: "register_text_googleAuth"),"",LanguageTools.getString(key: "register_text_loginPwd"),"",LanguageTools.getString(key: "login_text_gesture")]
    var tableViewRowDatas : [EXSecurityEntity] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([EXSecurityTC.classForCoder(),UITableViewCell.classForCoder()], ["EXSecurityTC","UITableViewCell"])
        return tableView
    }()
    
    var touchOrFace = "1"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if PublicInfoEntity.sharedInstance.haveOTC == "1"{
            tableViewNameDatas = [LanguageTools.getString(key: "register_text_phone"),LanguageTools.getString(key: "register_text_mail"),LanguageTools.getString(key: "register_text_googleAuth"),"",LanguageTools.getString(key: "register_text_loginPwd"),LanguageTools.getString(key: "otc_text_pwd"),"",LanguageTools.getString(key: "login_text_gesture")]
        }
        
        FingerPrintVerify.fingerIsSupportCallBack1 {[weak self] (type) in
            if type == "1" {
                self?.touchOrFace = "1"
                self?.tableViewNameDatas.append(LanguageTools.getString(key: "login_text_fingerprint"))
            }else if type == "2"{
                self?.touchOrFace = "2"
                self?.tableViewNameDatas.append(LanguageTools.getString(key: "login_text_face"))
            }
            self?.setData()
        }
    }
    
    func setData(){
        var arr : [EXSecurityEntity] = []
        for str in tableViewNameDatas{
            let entity = EXSecurityEntity()
            entity.name = str
            switch str{
            case LanguageTools.getString(key: "register_text_phone"):
                if UserInfoEntity.sharedInstance().mobileNumber != ""{
                    if UserInfoEntity.sharedInstance().isOpenMobileCheck == "1"{
                        entity.info = LanguageTools.getString(key: "personal_text_safeSettingOpen")
                    }else{
                        entity.info = LanguageTools.getString(key: "personal_text_safeSettingOff")
                    }
                }else{
                    entity.info = LanguageTools.getString(key: "userinfo_text_mailUnbind")
                }
            case LanguageTools.getString(key: "register_text_mail"):
                if UserInfoEntity.sharedInstance().email != ""{
                    entity.info = LanguageTools.getString(key: "personal_text_safeSettingOpen")
                }else{
                    entity.info = LanguageTools.getString(key: "userinfo_text_mailUnbind")
                }
            case LanguageTools.getString(key: "register_text_googleAuth"):
                if UserInfoEntity.sharedInstance().googleStatus == "1"{
                    entity.info = LanguageTools.getString(key: "personal_text_safeSettingOpen")
                }else{
                    entity.info = LanguageTools.getString(key: "userinfo_text_mailUnbind")
                }
            case LanguageTools.getString(key: "register_text_loginPwd"):
                entity.info = LanguageTools.getString(key: "common_action_edit")
            case LanguageTools.getString(key: "otc_text_pwd"):
                if UserInfoEntity.sharedInstance().isCapitalPwordSet == "0"{
                    entity.info = LanguageTools.getString(key: "safety_action_otcPassword".localized())
                }else{
                    entity.info = LanguageTools.getString(key: "common_action_edit")
                }
            case LanguageTools.getString(key: "login_text_gesture"):
                if XUserDefault.getGesturesPassword() != nil{
                    entity.switchOn = true
                }else{
                    entity.switchOn = false
                }
            case LanguageTools.getString(key: "login_text_fingerprint") , LanguageTools.getString(key: "login_text_face"):
                if XUserDefault.getFaceIdOrTouchIdPassword() != ""{
                    entity.switchOn = true
                }else{
                    entity.switchOn = false
                }
            default:
                break
            }
            arr.append(entity)
        }
        self.tableViewRowDatas = arr
        self.tableView.reloadData()
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

extension EXSecurityView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let entity = tableViewRowDatas[indexPath.row]
        if entity.name != ""{
            return 52
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = tableViewRowDatas[indexPath.row]
        if entity.name != ""{
            let cell : EXSecurityTC = tableView.dequeueReusableCell(withIdentifier: "EXSecurityTC") as! EXSecurityTC
            cell.tag = 1000 + indexPath.row
            cell.setCell(entity)
            cell.onValueChangeCallback = {[weak self](b , entity) in
                guard let mySelf = self else{return}
                mySelf.switchV(b, entity: entity)
            }
            return cell
        }
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell()
        cell.backgroundColor = UIColor.ThemeNav.bg
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = tableViewRowDatas[indexPath.row]
        switch entity.name{
        case LanguageTools.getString(key: "register_text_phone"):
            if UserInfoEntity.sharedInstance().mobileNumber == ""{//未绑定 进入绑定页面
                let vc = EXMoblieBindingVC()
                vc.clickBlock = {[weak self] in
                    let vc = EXGoogleBindingVC()
                    self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }else{//已绑定 进入设置绑定页面
                let vc = EXMoblieOneVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case LanguageTools.getString(key: "register_text_mail"):
            if UserInfoEntity.sharedInstance().email == ""{//未绑定 进入绑定页面
                let vc = EXEmailBindingVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }else{//已绑定 进入设置绑定页面
                let vc = EXEmailOpenVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case LanguageTools.getString(key: "register_text_googleAuth"):
            if UserInfoEntity.sharedInstance().googleStatus == "0"{//未绑定 进入绑定页面
                let vc = EXGoogleBindingVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }else{//已绑定 进入设置绑定页面
                let vc = EXGoogleOpenVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case LanguageTools.getString(key: "register_text_loginPwd"):
            //如果两个都没开
            if UserInfoEntity.sharedInstance().isOpenMobileCheck == "0" && UserInfoEntity.sharedInstance().googleStatus == "0"{
                EXAlert.showFail(msg: "common_text_pleaseBindGoogleFirst".localized())
                return
            }
            self.exalertsecuritySheet(EXChangePWVC())
           
        case LanguageTools.getString(key: "otc_text_pwd"):
            self.exalertOTCPW()
            break
        case LanguageTools.getString(key: "login_text_gesture"):
            break
        case LanguageTools.getString(key: "login_text_fingerprint"):
            break
        case LanguageTools.getString(key: "login_text_face"):
            break
        default:
            break
        }
    }
}

extension EXSecurityView{
    
    //展示修改法币密码的提示
    func exalertOTCPW(){
        
    }
    
    //提示用户48小时
    func exalertsecuritySheet(_ vc : UIViewController){
        //如果后台开启
        if PublicInfoEntity.sharedInstance.update_safe_withdraw.is_open == "1"{
            //提示框
            let alert = EXNormalAlert()
            let message = String(format:"login_tip_safeSettingChange".localized(),PublicInfoEntity.sharedInstance.update_safe_withdraw.hour)
            
            alert.configAlert(title: "", message: message, passiveBtnTitle: LanguageTools.getString(key: "common_text_btnCancel"), positiveBtnTitle: LanguageTools.getString(key: "common_text_btnConfirm"))
            alert.alertCallback = {tag in
                if tag == 1{//
                    
                }else if tag == 0{
                    self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            //展示
            EXAlert.showAlert(alertView: alert)
        }else{
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func switchV(_ b : Bool , entity : EXSecurityEntity){
        self.setData()
        switch entity.name{
        case LanguageTools.getString(key: "login_text_gesture"):
            if b == true,XUserDefault.getFaceIdOrTouchIdPassword() != ""{//开启手势
                
                EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_otherFastLoginIsActive"))
                entity.switchOn = false
                self.tableView.reloadData()
                return
            }
            gesturesValidation()
        case LanguageTools.getString(key: "login_text_fingerprint"),LanguageTools.getString(key: "login_text_face"):
            if b == true ,XUserDefault.getGesturesPassword() != nil{//开启指纹和面部
                EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_otherFastLoginIsActive"))
                entity.switchOn = false
                self.tableView.reloadData()
                return
            }
            faceortouchValidation()
        default:
            break
        }
    }
    
    //手势二次验证
    func gesturesValidation(){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.models())
        sheet.autoDismiss = false
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            var googleCode = ""//谷歌验证码
            var mobile = ""//手机号验证
            var password = ""//登录密码
            if UserInfoEntity.sharedInstance().googleStatus != "0"{
                if let google = formDic["googleCode"]{
                    googleCode = google
                }
                if googleCode == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_googleAuth".localized()))
                    return
                }
            }
            
            if UserInfoEntity.sharedInstance().isOpenMobileCheck != "0"{
                if let moblie = formDic["mobile"]{
                    mobile = moblie
                }
                if mobile == ""{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "personal_tip_inputPhoneCode"))
                    return
                }
            }
            
            if let pw = formDic["password"]{
                password = pw
            }
            if password == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_inputLoginPwd"))
                return
            }
            
            if XUserDefault.getGesturesPassword() != nil{//关闭手势验证
                appApi.rx.request(AppAPIEndPoint.closeGesture(loginPwd: password, smsValidCode: mobile, googleCode: googleCode)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (model) in
                    EXAlert.showSuccess(msg: "login_tip_gestureClosed".localized())
                    XUserDefault.setGesturesPassword("")
                    UserInfoEntity.sharedInstance().gesturePwd = ""
                    mySelf.setData()
                    sheet.dismiss()
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }else{//打开手势验证
                appApi.rx.request(AppAPIEndPoint.openGesture(loginPwd: password, smsValidCode: mobile, googleCode: googleCode, uid: UserInfoEntity.sharedInstance().uid)).MJObjectMap(EXGuestureEntity.self).subscribe(onSuccess: { (model) in
                    let token = model.token
                    mySelf.gotoGestView(token)
                    sheet.dismiss()
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }
        }
        sheet.itemBtnCallback = {[weak self]key in
            guard let mySelf = self else{return}
            switch key {
            case "mobile":
                mySelf.getsmsValidCode()
            default:
                break
            }
        }
        sheet.actionCancelCallback = {[weak self]() in
            self?.setData()
        }
        EXAlert.showSheet(sheetView:sheet)
        
    }
    
    func models()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:LanguageTools.getString(key: "register_text_loginPwd"),key:"password",placeHolder: "register_tip_inputPassword".localized(), type: .input , privacyMode : true)
        models.append(model1)
        if UserInfoEntity.sharedInstance().isOpenMobileCheck != "0"{//手机
            let model = EXInputSheetModel.setModel(withTitle:UserInfoEntity.sharedInstance().mobileNumber,key:"mobile",placeHolder: "personal_tip_inputPhoneCode".localized(), type: .sms , keyBoard : .numberPad)
            models.append(model)
        }
        if UserInfoEntity.sharedInstance().googleStatus != "0"{//谷歌
            let model = EXInputSheetModel.setModel(withTitle:"personal_text_googleCode".localized(),key:"googleCode",placeHolder: "common_tip_googleAuth".localized(), type: .paste, keyBoard : .numberPad)
            models.append(model)
        }
        return models
    }
    
    //面部和指纹二次认证
    func faceortouchValidation(){
        let sheet = EXActionSheetView()
        sheet.configTextfields(title: "common_text_safetyAuth".localized(), itemModels:self.facemodels())
        sheet.actionFormCallback = {[weak self] formDic in
            guard let mySelf = self else{return}
            var password = ""//登录密码
            if let pw = formDic["password"]{
                password = pw
            }
            if password == ""{
                EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_inputLoginPwd"))
                return
            }
            
            if XUserDefault.getFaceIdOrTouchIdPassword() != ""{//关闭面部验证
                appApi.rx.request(AppAPIEndPoint.openQuick(loginPwd: password, smsValidCode: "", googleCode: "",uid : UserInfoEntity.sharedInstance().uid)).MJObjectMap(EXFaceOrTouch.self).subscribe(onSuccess: {[weak self] (model) in
                    if model.isPass == "1"{
                        if self?.touchOrFace == "1"{
                            EXAlert.showSuccess(msg: "login_tip_fingerprintClosed".localized())
                        }else if self?.touchOrFace == "2"{
                            EXAlert.showSuccess(msg: "login_tip_faceIDClosed".localized())
                        }
                        XUserDefault.setFaceIdOrTouchId("")
                    }else{
                        EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_passwordWrong"))
                    }
                    sheet.dismiss()
                    mySelf.setData()
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }else{//打开面部和指纹验证
                appApi.rx.request(AppAPIEndPoint.openQuick(loginPwd: password, smsValidCode: "", googleCode: "",uid : UserInfoEntity.sharedInstance().uid)).MJObjectMap(EXFaceOrTouch.self).subscribe(onSuccess: { (model) in
                    if model.isPass == "1"{
                        FingerPrintVerify.fingerPrintLocalAuthenticationFallBackTitle(LanguageTools.getString(key: "login_action_oneClick"), localizedReason: LanguageTools.getString(key: "login_action_oneClick")) { (success, error, alert) in
                            if success == true{
                                XUserDefault.setFaceIdOrTouchId("100")
                                EXAlert.showSuccess(msg: alert ?? "")
                            }else{
                                XUserDefault.setFaceIdOrTouchId("")
                                EXAlert.showFail(msg: alert ?? "")
                            }
                            mySelf.setData()
                        }
                    }else{
                        EXAlert.showFail(msg: LanguageTools.getString(key: "login_tip_passwordWrong"))
                    }
                    sheet.dismiss()
                }, onError: { (error) in
                    
                }).disposed(by: mySelf.disposeBag)
            }
        }
        sheet.itemBtnCallback = {[weak self]key in
            guard let mySelf = self else{return}
            switch key {
            case "mobile":
                mySelf.getsmsValidCode()
            default:
                break
            }
        }
        EXAlert.showSheet(sheetView:sheet)
    }
    
    func facemodels()->[EXInputSheetModel] {
        var models : [EXInputSheetModel] = []
        let model1 = EXInputSheetModel.setModel(withTitle:LanguageTools.getString(key: "register_text_loginPwd"),key:"password",placeHolder: "register_tip_inputPassword".localized(), type: .input , privacyMode : true)
        models.append(model1)
        return models
    }
    
    //获取手机验证码
    func getsmsValidCode(){
        appApi.rx.request(.getsmsValidCode(token: XUserDefault.getToken() ?? "", operationType: EXSendVerificationCode.closegoogleAndmoblie, countryCode: "", mobile: "")).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (m) in
        }) { (erro) in
            
            }.disposed(by: disposeBag)
    }
    
    //进入手势密码设置页面
    func gotoGestView(_ token : String){
        let onevc = GestureValidationVC()
        onevc.type = GestureValidationType.input
        onevc.gesToken = token
        onevc.confirmGesturesBlock = {[weak self](password) in
            guard let mySelf = self else{return}
            let twovc = GestureValidationVC()
            twovc.type = GestureValidationType.EnterAgain
            twovc.code = password
            twovc.gesToken = token
            onevc.popBack(false)
            mySelf.yy_viewController?.navigationController?.pushViewController(twovc, animated: true)
        }
        self.yy_viewController?.navigationController?.pushViewController(onevc, animated: true)
    }
    
}
