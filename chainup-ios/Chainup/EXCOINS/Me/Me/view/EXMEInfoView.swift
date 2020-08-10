//
//  EXMEInfoView.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXMEInfoView: UIView {
    
    //名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont().themeHNBoldFont(size: 24)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    //头像
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "personal_headportrait")
        return imgV
    }()
    
    //实名认证
    lazy var authenticationImgV : AuthenticationView = {
        let imgV = AuthenticationView()
        imgV.extUseAutoLayout()
        imgV.extSetCornerRadius(1.5)
        imgV.layoutIfNeeded()
        return imgV
    }()
    
    //uid
    lazy var uidLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont().themeHNFont(size: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeNav.bg
        addSubViews([nameLabel,imgV,authenticationImgV,uidLabel])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.bottom.equalTo(uidLabel.snp.top).offset(-7)
            make.height.equalTo(24)
            make.right.equalTo(imgV.snp.left).offset(-10)
        }
        imgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(80)
            make.right.equalToSuperview().offset(-35)
            make.bottom.equalToSuperview().offset(-35)
        }
        authenticationImgV.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.top.equalTo(uidLabel.snp.bottom).offset(11)
            make.left.equalTo(nameLabel)
        }
        uidLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.centerY.equalTo(imgV)
            make.height.equalTo(14)
            make.right.equalTo(imgV.snp.left).offset(-10)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapSelf))
        self.addGestureRecognizer(tap)
    }
    
    func reloadView(){
        if XUserDefault.getToken() == nil{//未登录
            nameLabel.text = LanguageTools.getString(key: "noun_login_notLogin")
            uidLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(35)
                make.bottom.equalTo(imgV.snp.centerY).offset(-4)
                make.height.equalTo(25)
                make.right.equalTo(imgV.snp.left).offset(-10)
            }
            authenticationImgV.snp.remakeConstraints { (make) in
                make.height.equalTo(18)
                make.top.equalTo(imgV.snp.centerY).offset(4)
                make.left.equalTo(nameLabel)
            }
            authenticationImgV.auth("2")
        }else{//已登录
            if let account = XUserDefault.getVauleForKey(key: XUserDefault.mobileNumber) as? String{
                nameLabel.text = account
                nameLabel.text?.coverStringWithString("*", startIndex: 3, endindex: 7)
            }else{
                nameLabel.text = ""
            }
            uidLabel.text = "ID:" + UserInfoEntity.sharedInstance().uid
            uidLabel.isHidden = false
            nameLabel.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(35)
                make.bottom.equalTo(uidLabel.snp.top).offset(-7)
                make.height.equalTo(24)
                make.right.equalTo(imgV.snp.left).offset(-10)
            }
            authenticationImgV.snp.remakeConstraints { (make) in
                make.height.equalTo(18)
                make.top.equalTo(uidLabel.snp.bottom).offset(11)
                make.left.equalTo(nameLabel)
            }
            authenticationImgV.auth(UserInfoEntity.sharedInstance().authLevel)
        }
    }
    
    @objc func tapSelf(){
        if XUserDefault.getToken() == nil{//未登录
            BusinessTools.modalLoginVC()
            return
        }
        let vc = EXMyInfoVC()
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AuthenticationView : UIView {
    
    var type = ""
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.font = UIFont.ThemeFont.MinimumRegular
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgV,label])
        imgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.height.equalTo(10)
            make.width.equalTo(12)
            make.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(12)
            make.right.equalToSuperview().offset(-10)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickV))
        self.addGestureRecognizer(tap)
    }
    
    func setView(_ imgStr : String , name : String){
        imgV.image = UIImage.themeImageNamed(imageName: imgStr)
        label.text = name
    }
    
    func auth(_ type : String){
        self.type = type
        switch type {
        case "0":
            self.extSetBorderWidth(1, color: UIColor.ThemeState.warning)
            self.label.textColor = UIColor.ThemeState.warning
            setView("personal_underreview", name: LanguageTools.getString(key: "noun_login_pending"))
        case "1":
            self.extSetBorderWidth(1, color: UIColor.ThemeLabel.colorHighlight)
            self.label.textColor = UIColor.ThemeLabel.colorHighlight
            setView("personal_certified", name: LanguageTools.getString(key: "personal_text_verified"))
        case "2" , "3":
            self.extSetBorderWidth(1, color: UIColor.ThemeView.mySign)
            self.label.textColor = UIColor.ThemeView.mySign
            setView("personal_notcertified", name: LanguageTools.getString(key: "personal_text_unverified"))
        default:
            setView("personal_notcertified", name: LanguageTools.getString(key: "personal_text_unverified"))
            break
        }
    }
    
    //点击
    @objc func clickV(){
        if XUserDefault.getToken() != nil{
//            let vv = EXJsApiMethodSwift()
//            vv.exchangeRouter("{\"routerName\":\"kyccomplete\"}") { (string, b) in
//
//            }
//            return
            switch type {
            case "0":
                let vc = EXRealNameThreeVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            case "1":
                break
            case "2" , "3":
                let vc = EXRealNameCertificationChooseVC()
                self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

