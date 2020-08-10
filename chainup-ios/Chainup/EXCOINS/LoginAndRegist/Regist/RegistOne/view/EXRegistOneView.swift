//
//  RegistOneView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import YYText
import RxSwift

enum EXRegistType {
    case mail
    case phone
}

class EXRegistOneView: UIView {
    
    typealias ClickPopBackBlock = () -> ()
    var clickPopBackBlock : ClickPopBackBlock?
    
    var loginBlock : EXLoginBlock?
    
    var type = EXRegistType.phone
    {
        didSet{
            self.setView()
        }
    }
        
    lazy var gt3Tool : GT3Tool = {
        let gt3Tool = GT3Tool()
        gt3Tool.captchaButton.isHidden = true
        gt3Tool.validationSuccessBlock = {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.requestRegist()
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

    lazy var registLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.H1Bold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = LanguageTools.getString(key: "register_action_phone")
        return label
    }()
    
    lazy var regionText : EXSelectionField = {
        let text = EXSelectionField()
        text.extUseAutoLayout()
        text.layoutIfNeeded()
        text.triangle.useBig = true
        text.textfieldDidTapBlock = {[weak self]() in
            self?.clickRegion()
        }
        let defaultCountryCode = PublicInfoEntity.sharedInstance.default_country_code
        let defaultCountryCodeReal = PublicInfoEntity.sharedInstance.default_country_code_real
        if let region = CountryList.getRegionWithNumber(defaultCountryCodeReal){
            if BasicParameter.isHan() == true{
                text.input.text = region.cnName + " " + region.dialingCode
            }else{
                text.input.text = region.enName + " " + region.dialingCode
            }
        }else if let region = CountryList.getRegion(defaultCountryCode){
            if BasicParameter.isHan() == true{
                text.input.text = region.cnName + " " + region.dialingCode
            }else{
                text.input.text = region.enName + " " + region.dialingCode
            }
        }
        return text
    }()
    
    lazy var inputText : EXTextField = {
        let text = EXTextField()
        text.extUseAutoLayout()
        text.layoutIfNeeded()
        text.input.keyboardType = UIKeyboardType.numberPad
        text.input.font = UIFont().themeHNMediumFont(size: 16)
        text.setPlaceHolder(placeHolder: LanguageTools.getString(key: "userinfo_tip_inputPhone"),font: 16)
        text.textfieldValueChangeBlock = {[weak self](str) in
            if str.count > 0{
                self?.nextBtn.isEnabled = true
            }else{
                self?.nextBtn.isEnabled = false
            }
        }
        return text
    }()

    lazy var nextBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.isEnabled = false
        btn.extSetAddTarget(self, #selector(clickNextBtn))
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.white, for: UIControlState.normal)
        return btn
    }()
    
    lazy var chooseBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickChooseBtn))
        btn.setTitle(LanguageTools.getString(key: "register_action_mail"), for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "register_action_phone"), for: UIControlState.selected)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        return btn
    }()
    
    lazy var loginLabel : YYLabel = {
        let label = YYLabel()
        label.extUseAutoLayout()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([popBtn,registLabel,regionText,inputText,nextBtn,chooseBtn,loginLabel])
        popBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(14)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(16)
        }
        registLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(popBtn.snp.bottom).offset(44)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(28)
        }
        regionText.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(registLabel.snp.bottom).offset(50)
        }
        inputText.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(regionText.snp.bottom).offset(40)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(inputText.snp.bottom).offset(50)
            make.height.equalTo(44)
        }
        chooseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(nextBtn.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        if SCREEN_HEIGHT > 568{
            loginLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(22)
                make.bottom.equalToSuperview().offset(-40)
            }
        }else{
            loginLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(22)
                make.top.equalTo(chooseBtn.snp.bottom).offset(40)
            }
        }
        addAttTap()
        getStatus()
    }
    
    func setView(){
        
        switch self.type {
        case .mail:
            registLabel.text = LanguageTools.getString(key: "register_action_mail")
            regionText.isHidden = true
            inputText.input.keyboardType = UIKeyboardType.default
            inputText.setPlaceHolder(placeHolder: LanguageTools.getString(key: "register_action_mail"),font: 16)
            inputText.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-30)
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(registLabel.snp.bottom).offset(50)
            }
            inputText.input.keyboardType = UIKeyboardType.default
        case .phone:
            registLabel.text = LanguageTools.getString(key: "register_action_phone")
            regionText.isHidden = false
            inputText.input.keyboardType = UIKeyboardType.numberPad
            inputText.setPlaceHolder(placeHolder: LanguageTools.getString(key: "userinfo_tip_inputPhone"),font: 16)
            inputText.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-30)
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(regionText.snp.bottom).offset(40)
            }
            inputText.input.keyboardType = UIKeyboardType.numberPad
        }
    }
    
    //添加手势
    func addAttTap(){
        let accatt = NSMutableAttributedString.init().add(string: LanguageTools.getString(key: "register_tip_exsitUser"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium , NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold]).add(string: LanguageTools.getString(key: "login_action_login"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorHighlight , NSAttributedStringKey.font : UIFont.ThemeFont.HeadBold])
        accatt.highLightTap((accatt.string as NSString).range(of: LanguageTools.getString(key: "login_action_login")), {[weak self] (view, attstr, range, rect) in
            guard let mySelf = self else{return}
            mySelf.clickLogin()
        })
        loginLabel.attributedText = accatt
    }
    
    //根据后台返回的值来判断展示的顺序和是否隐藏
    func getStatus(){
        let arr : [String] = PublicInfoManager.sharedInstance.getRegistTypes()
        if arr.count > 0{
            let style = arr[0]
            if style == "1"{
                type = .phone
            }else{
                type = .mail
            }
            chooseBtn.isHidden = arr.count == 1
            chooseBtn.isSelected = type == .mail
        }
        setView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXRegistOneView{
    
    @objc func clickPopBackBtn(){
        self.clickPopBackBlock?()
        self.yy_viewController?.popBack()
    }
    
    //点击地区
    func clickRegion(){
        let vc = RegionVC()
        vc.clickRegionCellBlock = {[weak self](entity) in
            if BasicParameter.isHan() == true{
                self?.regionText.input.text = entity.cnName + entity.dialingCode
            }else{
                self?.regionText.input.text = entity.enName + entity.dialingCode
            }
        }
        self.regionText.normalStyle()
        vc.modalPresentationStyle = .fullScreen
        self.yy_viewController?.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    //点击下一步
    @objc func clickNextBtn(){
        nextBtn.showLoading()
        //如果极验开启
        if PublicInfoEntity.sharedInstance.verificationType == "2"{
            gt3Tool.start()
            return
        }
        requestRegist()
    }
    
    func requestRegist(){
        var email = ""
        var mobile = ""
        var country = ""
        var verificationType = ""
        if type == .mail{
            if inputText.input.text == "" || inputText.input.text?.contains("@") == false{
                EXAlert.showFail(msg:LanguageTools.getString(key: "safety_tip_inputMail"))
                nextBtn.hideLoading()
                return
            }
            if let text = inputText.input.text , text.count < 5 || text.count > 100{
                EXAlert.showFail(msg:LanguageTools.getString(key: "safety_tip_inputMail"))
                nextBtn.hideLoading()
                return
            }
            if let text = inputText.input.text , BusinessTools.isEmail(text) == false{
                EXAlert.showFail(msg:LanguageTools.getString(key: "safety_tip_inputMail"))
                nextBtn.hideLoading()
                return
            }
            email = inputText.input.text ?? ""
        }else{
            if inputText.input.text == ""{
                EXAlert.showFail(msg:LanguageTools.getString(key: "userinfo_tip_inputPhone"))
                nextBtn.hideLoading()
                return
            }
            mobile = inputText.input.text ?? ""
            if let arr = regionText.input.text?.components(separatedBy: "+") , arr.count > 1{
                country = "+" + arr[1]
            }else{
                country = regionText.input.text ?? ""
            }
        }
        if PublicInfoEntity.sharedInstance.verificationType  == "2" {
            //            if gt3Tool.geetest_challenge == nil{
            //                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_sliding_block"))
            //                return
            //            }
            verificationType = "2"
        }
        appApi.rx.request(.registerOne(verificationType: verificationType, geetest_challenge: gt3Tool.geetest_challenge ?? "", geetest_seccode: gt3Tool.geetest_seccode ?? "", geetest_validate: gt3Tool.geetest_validate ?? "", email: email, mobile: mobile, country: country)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: {[weak self] (repsonse) in
            self?.gotoRegistTwo()
            self?.nextBtn.hideLoading()
        }) {[weak self](error) in
            self?.nextBtn.hideLoading()
        }.disposed(by: disposeBag)
    }
    
    //进入注册第二步
    func gotoRegistTwo(){
        let vc = EXRegistTwoVC()
        vc.mainView.account = self.inputText.input.text ?? ""
        if type == .mail{
            vc.mainView.type = .mail
        }else{
            if let arr = regionText.input.text?.components(separatedBy: "+") , arr.count > 1{
                vc.mainView.countryCode = "+" + arr[1]
            }else{
                vc.mainView.countryCode = regionText.input.text ?? ""
            }
            vc.mainView.type = .phone
        }
        
        if PublicInfoEntity.sharedInstance.verificationType  == "2" {
            vc.mainView.verificationType = "2"
            vc.mainView.geetest_challenge = gt3Tool.geetest_challenge ?? ""
            vc.mainView.geetest_seccode = gt3Tool.geetest_seccode ?? ""
            vc.mainView.geetest_validate = gt3Tool.geetest_validate ?? ""
        }else{
            vc.mainView.verificationType = "0"
        }
        
        vc.mainView.clickNextBlock = {[weak self](entity) in
            //跳转
            let vc = EXRegistTreeVC()
            vc.mainView.entity = entity
            vc.mainView.account = self?.inputText.input.text ?? ""
            self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    //点击切换注册按钮
    @objc func clickChooseBtn(_ btn : UIButton){
        inputText.input.text = ""
        type = btn.isSelected == true ? EXRegistType.phone : EXRegistType.mail
        btn.isSelected = !btn.isSelected
        self.endEditing(true)
    }
    
    //点击登录按钮
    func clickLogin(){
        loginBlock?(.login)
    }
    
}
