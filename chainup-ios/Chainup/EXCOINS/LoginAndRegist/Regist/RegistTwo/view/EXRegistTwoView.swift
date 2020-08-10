//
//  EXRegistTwoView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class EXRegistTwoView: LoginTwoView {
    
    var countryCode = ""
    
    var verificationType = "0"
    
    var geetest_challenge = ""
    
    var geetest_seccode = ""
    
    var geetest_validate = ""
    
    typealias ClickNextBlock = (EXRegistTwoEntity) -> ()
    var clickNextBlock : ClickNextBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sumbitBtn.setTitle(LanguageTools.getString(key: "common_action_next"), for: UIControlState.normal)
        validationText.becomeFirstResponder()
    }
    
    override func getVerificationCode() {
        if self.type == .phone{//手机验证码
            appApi.rx.request(.registGetsmsValidCode(token: self.token, operationType: EXSendVerificationCode.regist , countryCode: countryCode, mobile: self.account, verificationType: verificationType, geetest_challenge: geetest_challenge, geetest_seccode: geetest_seccode, geetest_validate: geetest_validate)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (response) in
            }) { (error) in
                
                }.disposed(by: disposeBag)
        }else{//邮箱验证码
            appApi.rx.request(.registGetemailVallidCode(email: self.account, operationType: EXSendVerificationCode.regist,token: self.token, verificationType: verificationType, geetest_challenge: geetest_challenge, geetest_seccode: geetest_seccode, geetest_validate: geetest_validate)).MJObjectMap(EXVoidModel.self).subscribe(onSuccess: { (reponse) in
            }) { (error) in
                
                }.disposed(by: disposeBag)
        }
    }
    
    @objc override func clickConfimBtn(){
        sumbitBtn.showLoading()
        if inVerification {
            return
        }
        
        appApi.rx.request(.registerTwo(registerCode: self.account, numberCode: validationText.input.text ?? "")).MJObjectMap(EXRegistTwoEntity.self).subscribe(onSuccess: {[weak self] (entitiy) in
            self?.yy_viewController?.navigationController?.popViewController(animated: false)
            self?.clickNextBlock?(entitiy)
            self?.sumbitBtn.hideLoading()
        }) {[weak self] (error) in
            self?.inVerification = false
            self?.sumbitBtn.hideLoading()
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
