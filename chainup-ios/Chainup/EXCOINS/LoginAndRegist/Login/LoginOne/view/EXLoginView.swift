//
//  EXLoginView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import YYText
import RxSwift
import YYWebImage

class EXLoginView: UIView{
    
    typealias ClickPopBackBlock = () -> ()
    var clickPopBackBlock : ClickPopBackBlock?
    
    let arr = ["safety_text_googleAuth".localized(),"safety_text_phoneAuth".localized(),"safety_text_mailAuth".localized()]
    
    var loginBlock : EXLoginBlock?
        
    lazy var gt3Tool : GT3Tool = {
        let gt3Tool = GT3Tool()
        gt3Tool.captchaButton.isHidden = true
        gt3Tool.validationSuccessBlock = {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.loginOne()
        }
        gt3Tool.start()
        return gt3Tool
    }()
    
    lazy var popBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "common_text_btnCancel"), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        btn.extSetAddTarget(self, #selector(clickPopBackBtn))
        return btn
    }()
    
    lazy var logoImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    lazy var loginText : EXTextField = {
        let textField = EXTextField()
        textField.extUseAutoLayout()
        textField.layoutIfNeeded()
        textField.input.font = UIFont().themeHNMediumFont(size: 16)
        textField.setPlaceHolder(placeHolder: "common_text_phoneOrMail".localized(),font: 16)
        if let num = XUserDefault.getVauleForKey(key: XUserDefault.mobileNumber) as? String{
            textField.input.text = num
        }
        textField.textfieldValueChangeBlock = {[weak self](str) in
            self?.btnType()
        }
        return textField
    }()
    
    lazy var msText : EXTextField = {
        let textField = EXTextField()
        textField.extUseAutoLayout()
        textField.enablePrivacyModel = true
        textField.layoutIfNeeded()
        textField.input.font = UIFont().themeHNMediumFont(size: 16)
        textField.setPlaceHolder(placeHolder: "login_text_pwd".localized(),font: 16)
        textField.textfieldValueChangeBlock = {[weak self](str) in
            self?.btnType()
        }
        return textField
    }()
    
    lazy var chooseT : EXSelectionField = {
        let textField = EXSelectionField()
        textField.extUseAutoLayout()
        textField.layoutIfNeeded()
        textField.triangle.useBig = true
        textField.input.text = "safety_text_phoneAuth".localized()
        textField.textfieldDidTapBlock = {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.clickvalidationBtn()
        }
        textField.isHidden = true
        textField.input.font = UIFont().themeHNMediumFont(size: 16)
        return textField
    }()
    
    lazy var loginBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.isEnabled = false
        btn.setTitle(LanguageTools.getString(key: "login_action_login"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickLoginBtn))
        btn.setTitleColor(UIColor.ThemeLabel.white, for: UIControlState.normal)
        return btn
    }()
    
    lazy var forgetPW : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickForgetBtn))
        btn.setTitle(LanguageTools.getString(key: "login_action_fogotPassword"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        return btn
    }()
    
    lazy var registLabel : YYLabel = {
        let label = YYLabel()
        label.extUseAutoLayout()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([popBtn,logoImgV,loginText,msText,chooseT,loginBtn,forgetPW,registLabel])
        popBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(14)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(16)
        }
        logoImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(popBtn.snp.bottom).offset(49)
            make.width.equalTo(160)
            make.height.equalTo(32)
        }
        loginText.snp.makeConstraints { (make) in
            make.top.equalTo(logoImgV.snp.bottom).offset(47)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        msText.snp.makeConstraints { (make) in
            make.top.equalTo(loginText.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
//        chooseT.snp.makeConstraints { (make) in
//            make.top.equalTo(msText.snp.bottom).offset(36)
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
//        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(msText.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
        forgetPW.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(20)
        }
        
        if SCREEN_HEIGHT > 568{
            registLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(22)
                make.bottom.equalToSuperview().offset(-40)
            }
        }else{
            registLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(22)
                make.top.equalTo(forgetPW.snp.bottom).offset(40)
            }
        }
        
        addAttTap()
        
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (i) in
            guard let mySelf = self else{return}
            if EXThemeManager.isNight() == true{
                if let url = URL.init(string: PublicInfoEntity.sharedInstance.app_logo_list_new.logo_black){
                    mySelf.logoImgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                }
            }else{
                if let url = URL.init(string: PublicInfoEntity.sharedInstance.app_logo_list_new.logo_white){
                    mySelf.logoImgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                }
            }
            }.disposed(by: disposeBag)
    }
    
    //添加手势
    func addAttTap(){
        let accatt = NSMutableAttributedString.init().add(string: LanguageTools.getString(key: "login_action_noAccount"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium , NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: LanguageTools.getString(key: "login_action_register"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorHighlight , NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
        accatt.highLightTap((accatt.string as NSString).range(of: LanguageTools.getString(key: "login_action_register")), {[weak self] (view, attstr, range, rect) in
            guard let mySelf = self else{return}
            mySelf.clickRegistBtn()
        })
        registLabel.attributedText = accatt
    }
    
    func btnType(){
        if let t = self.loginText.input.text?.count , t > 0 ,let x = self.msText.input.text?.count , x > 0{
            self.loginBtn.isEnabled = true
        }else{
            self.loginBtn.isEnabled = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//点击方法
extension EXLoginView{
    
    //点击取消按钮
    @objc func clickPopBackBtn(){
        self.clickPopBackBlock?()
        self.yy_viewController?.popBack()
    }
    
    //点击登录按钮
    @objc func clickLoginBtn(){
        loginBtn.showLoading()
        //如果极验开启
        if PublicInfoEntity.sharedInstance.verificationType == "2"{
            gt3Tool.start()
            loginBtn.hideLoading()
            return
        }
        loginOne()
    }
    
    func loginOne(){
        
        var verificationType = ""
        
        if loginText.input.text == ""{
            EXAlert.showFail(msg:LanguageTools.getString(key: "common_tip_inputPhoneOrMail"))
            return
        }
        if  msText.input.text == ""{
            EXAlert.showFail(msg:LanguageTools.getString(key: "register_tip_inputPassword"))
            return
        }
        
//        if gt3Tool.geetest_challenge == nil && PublicInfoEntity.sharedInstance.verificationType  == "2" {
//            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_sliding_block"))
//            return
//        }
        
        if PublicInfoEntity.sharedInstance.verificationType  == "2" {
//            if gt3Tool.geetest_challenge == nil{
//                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_sliding_block"))
//                return
//            }
            verificationType = "2"
        }
        
//        if judgeVerificationType() == true{
            appApi.rx.request(.loginOne(mobileNumber: loginText.input.text ?? "",
                                        loginPword: msText.input.text ?? "",
                                        geetest_challenge: gt3Tool.geetest_challenge ?? "",
                                        geetest_seccode: gt3Tool.geetest_seccode ?? "",
                                        geetest_validate: gt3Tool.geetest_validate ?? "",
                                        verificationType: verificationType))
                .MJObjectMap(EXLoginEntity.self).subscribe(onSuccess: {[weak self] (entity) in
//                if self?.judgeVerificationType(entity.googleAuth) == true{
                    self?.gotoEXLoginTwoVC(entity)
//                }
                    self?.loginBtn.hideLoading()
                }) {[weak self] (error) in
                    self?.loginBtn.hideLoading()
                }.disposed(by: disposeBag)
//        }else{
//            self.loginBtn.hideLoading()
//        }
    }
    
    func judgeVerificationType(_ google : String = "1") -> Bool{//
        if let chooseT = chooseT.input.text{
            if chooseT == arr[0]{
                if google == "1"{//如果开了谷歌
                    return true
                }else{
                    EXAlert.showFail(msg: LanguageTools.getString(key: "common_text_googleAuthNotOpen"))
                    return false
                }
            }else{
                if let account = loginText.input.text{
                    if account.contains("@"){//如果包含则要选择邮箱验证
                        if chooseT != arr[2]{
                            EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_selectMailAuth"))
                            return false
                        }
                    }else{//如果不包含则要选择手机验证
                        if chooseT != arr[1]{
                            EXAlert.showFail(msg: LanguageTools.getString(key: "common_tip_selectPhoneAuth"))
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    //去登录的第二个页面
    func gotoEXLoginTwoVC(_ loginModel: EXLoginEntity){
        let secureTypes = loginModel.getSecureTyeps()
        if secureTypes.count == 0 || secureTypes.count > 2 {
            let vc = EXLoginTwoVC()
            vc.mainView.token = loginModel.token
            vc.mainView.account = loginText.input.text ?? ""
            vc.mainView.loginPwd = msText.input.text ?? ""
            if loginModel.googleAuth == "1"{//开启谷歌
                vc.mainView.type = .google
            }else{
                if let account = loginText.input.text{
                    if account.contains("@"){//如果包含则要选择邮箱验证
                        vc.mainView.type = .mail
                    }else{//如果不包含则要选择手机验证
                        vc.mainView.type = .phone
                    }
                }
            }
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = EXLoginSecureVc()
            vc.types = secureTypes
            vc.token = loginModel.token
            vc.account = loginText.input.text ?? ""
            vc.loginPwd = msText.input.text ?? ""
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //点击注册按钮
    func clickRegistBtn(){
        loginBlock?(.regist)
    }
    
    //点击忘记密码按钮
    @objc func clickForgetBtn(){
        let vc = EXForgetPWOneVC()
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击验证方式
    func clickvalidationBtn(){
        let sheet = EXActionSheetView()
        sheet.actionIdxCallback = {[weak self](idx) in
            guard let mySelf = self else{return}
            mySelf.chooseT.input.text = self?.arr[idx]
            mySelf.chooseT.normalStyle()
        }
        sheet.actionCancelCallback =  {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.chooseT.normalStyle()
        }
        var idx = 0
        for i in 0..<arr.count{
            if arr[i] == chooseT.input.text{
                idx = i
                break
            }
        }
        sheet.configButtonTitles(buttons:  arr,selectedIdx: idx)
        EXAlert.showSheet(sheetView: sheet)
    }
        
}
