//
//  EXReLoginView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/11.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXReLoginView: UIView {
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.clear
        view.layoutIfNeeded()
        return view
    }()

    lazy var headImgV : UIImageView = {
        let view = UIImageView()
        view.extUseAutoLayout()
        view.image = UIImage.themeImageNamed(imageName: "personal_headportrait")
        return view
    }()
    
    lazy var accountLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.H1Bold
        label.textColor = UIColor.ThemeLabel.colorLite
        if let t = XUserDefault.getVauleForKey(key: "mobileNumber") as? String{
            label.text = t
            if let tt = label.text , tt.count > 2{
                var ttt = tt
                if ttt.contains("@") == true{
                    let endIndex = ttt.positionOf(sub: "@",backwards: true )
                    ttt.coverStringWithString("*", startIndex: 2, endindex: endIndex)
                }else{
                    ttt.coverStringWithString("*", startIndex: 2, endindex: ttt.count - 2)
                }
                label.text = ttt
            }
        }
        return label
    }()
    
    lazy var clickBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickCert))
        return btn
    }()
    
    lazy var titleText : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.headRegular()
        label.textAlignment = .center
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()
    //账号登录
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "login_action_otherAccount"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickLoginBtn))
        btn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([backView,clickBtn,titleText,loginBtn])
        backView.addSubViews([headImgV,accountLabel])
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(130 - NAV_SCREEN_HEIGHT)
            make.centerX.equalToSuperview()
        }
        headImgV.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(130 - NAV_SCREEN_HEIGHT)
            make.top.left.equalToSuperview()
            make.height.width.equalTo(28)
            make.right.equalTo(self.accountLabel.snp.left).offset(-8)
        }
        accountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headImgV)
            make.height.equalTo(30)
            make.right.equalToSuperview()
//            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(200)
        }
        clickBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(accountLabel.snp.bottom).offset(102)
            make.centerY.equalToSuperview().offset( -(NAV_SCREEN_HEIGHT / 2 + 23))
            make.height.equalTo(88)
            make.width.equalTo(136)
            make.centerX.equalToSuperview()
        }
        titleText.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(clickBtn.snp.bottom).offset(30)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-74)
        }
        FingerPrintVerify.fingerIsSupportCallBack { (type) in
            if type == "1"{
                self.titleText.text = LanguageTools.getString(key: "Touch-ID")
//                self.contentL.text = LanguageTools.getString(key: "click_fingerprint_identification")
                self.clickBtn.setImage(UIImage.themeImageNamed(imageName: "login_fingerprintlogin"), for: UIControlState.normal)
            }else if type == "2"{
                self.titleText.text = LanguageTools.getString(key: "Face-ID")
//                self.contentL.text = LanguageTools.getString(key: "click_face_recognition")
                self.clickBtn.setImage(UIImage.themeImageNamed(imageName: "login_facelogin"), for: UIControlState.normal)
            }
        }
        clickCert()
        
    }
    
    @objc func clickCert() {
        
        FingerPrintVerify.fingerPrintLocalAuthenticationFallBackTitle(LanguageTools.getString(key: "login_action_oneClick"), localizedReason: LanguageTools.getString(key: "login_action_oneClick")) { (success, error, errorStr) in
            print("---------")
            
            if success == true{
                let quickToken = XUserDefault.getVauleForKey(key: XUserDefault.quickToken) as! String
                appApi.rx.request(.quickLogin(quickToken: quickToken)).MJObjectMap(EXLoginSuccessEntity.self).subscribe(onSuccess: { [weak self](entity) in
                    EXAlert.showSuccess(msg: errorStr ?? "")
                    UserInfoEntity.sharedInstance().loginSuccess(entity.token)
                    UserInfoEntity.sharedInstance().getUserInfo {
                        
                    }
                    EXAlert.showSuccess(msg: LanguageTools.getString(key: "login_tip_loginsuccess"))
                    XUserDefault.setFaceIdOrTouchId("100")
                    DispatchQueue.main.async {
                        self?.yy_viewController?.dismiss(animated: true, completion: nil)
                        EXGameJumpManager.shareInstance.presentAuthorVc()
                    }
                    
                }) {[weak self] (error) in
                    if error._code == 104008{
                        self?.yy_viewController?.popBack()
                        guard let appDelegate  = UIApplication.shared.delegate else {
                            return
                        }
                        if appDelegate.window != nil   {
                            let nav = NavController()
                            nav.modalPresentationStyle = .fullScreen
                            nav.isNavigationBarHidden = true
                            let loginVC = EXLoginAndRegistVC()
                            nav.viewControllers = [loginVC]
                            appDelegate.window??.rootViewController?.present(nav, animated: true, completion: nil)
                        }
                    }
                }.disposed(by: self.disposeBag)
            }else {
                EXAlert.showFail(msg: errorStr ?? "")
            }
        }
    }
        
        //点击账号登录
    @objc func clickLoginBtn(_ btn :UIButton){
        self.yy_viewController?.popBack()
        BusinessTools.modalLoginVC("1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
