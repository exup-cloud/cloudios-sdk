//
//  EXForgetPWOneView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXForgetPWOneView: UIView {
    
    lazy var gt3Tool : GT3Tool = {
        let gt3Tool = GT3Tool()
        gt3Tool.captchaButton.isHidden = true
        gt3Tool.validationSuccessBlock = {[weak self]() in
            guard let mySelf = self else{return}
            mySelf.requestOne()
        }
        gt3Tool.start()
        return gt3Tool
    }()

    lazy var logoLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.H1Bold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = LanguageTools.getString(key: "login_action_fogotPassword")
        return label
    }()
    
    lazy var inputText : EXTextField = {
        let text = EXTextField()
        text.extUseAutoLayout()
        text.layoutIfNeeded()
        text.textfieldValueChangeBlock = {[weak self](str) in
            self?.nextBtnType(str.count > 0)
        }
        text.input.font = UIFont().themeHNMediumFont(size: 16)
        text.setPlaceHolder(placeHolder: LanguageTools.getString(key: "login_text_phoneOrMail"),font : 16)
        return text
    }()
    
    lazy var nextBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickNextBtn))
        btn.isEnabled = false
        btn.setTitleColor(UIColor.ThemeLabel.white, for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([logoLabel,inputText,nextBtn])
        logoLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(28)
        }
        inputText.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(logoLabel.snp.bottom).offset(50)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(inputText.snp.bottom).offset(50)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EXForgetPWOneView{
    
    func nextBtnType(_ b : Bool){
        nextBtn.isEnabled = b
    }
    
    //点击下一步
    @objc func clickNextBtn(){
        //如果极验开启
        if PublicInfoEntity.sharedInstance.verificationType == "2"{
            gt3Tool.start()
            return
        }
        requestOne()
    }
    
    func requestOne(){
        var verificationType = "0"
        if inputText.input.text == ""{
            EXAlert.showFail(msg:LanguageTools.getString(key: "common_tip_inputPhoneOrMail"))
            return
        }
        if PublicInfoEntity.sharedInstance.verificationType  == "2" {
            //            if gt3Tool.geetest_challenge == nil{
            //                ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_sliding_block"))
            //                return
            //            }
            verificationType = "2"
        }
//        var mobileNumber = ""
//        var email = ""
//        if inputText.input.text?.contains("@") == true{
//            email = inputText.input.text ?? ""
//        }else{
//            mobileNumber = inputText.input.text ?? ""
//        }
//
//        appApi.rx.request(.forgetPwOne(verificationType: verificationType, mobileNumber: mobileNumber, geetest_challenge: gt3Tool.geetest_challenge ?? "", geetest_seccode: gt3Tool.geetest_seccode ?? "", geetest_validate: gt3Tool.geetest_validate ?? "", email: email)).MJObjectMap(EXForgetOneEntity.self).subscribe(onSuccess: {[weak self] (entity) in
//            self?.gotoEXForgetPWTwoVC(entity.token)
//        }) { (error) in
//
//            }.disposed(by: disposeBag)
        
        appApi.rx.request(.forgetPwOne(verificationType: verificationType, geetest_challenge: gt3Tool.geetest_challenge ?? "", geetest_seccode: gt3Tool.geetest_seccode ?? "", geetest_validate: gt3Tool.geetest_validate ?? "", registerCode: inputText.input.text ?? "")).MJObjectMap(EXForgetOneEntity.self).subscribe(onSuccess: {[weak self] (entity) in
            self?.gotoEXForgetPWTwoVC(entity.token)
        }) { (error) in

            }.disposed(by: disposeBag)
    }
    
    func gotoEXForgetPWTwoVC(_ token : String){
        let vc = EXForgetPWTwoVC()
        if let v = inputText.input.text , v.contains("@"){
            vc.mainView.type = .mail
        }else{
            vc.mainView.type = .phone
        }
        vc.mainView.account = inputText.input.text ?? ""
        vc.mainView.token = token
        vc.mainView.clickNextBlock = {[weak self](entity) in
            if entity.isCertificateNumber == "0" && entity.isGoogleAuth == "0"{
                let vc = EXForgetPWFourVC()
                vc.mainView.token = token
                self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = EXForgetPWThreeVC()
                vc.mainView.token = token
                vc.mainView.entity = entity
                self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
