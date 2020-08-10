//
//  LoginTC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/2.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit
import YYText

class PhoneNumLoginTC: UITableViewCell{
    

    var token = ""//临时token
    
    //电话输入框
    lazy var phoneInputV : InputBoxView = {
        let view = InputBoxView()
        view.extUseAutoLayout()
        view.setPlaceHolderAtt(LanguageTools.getString(key: "toast_no_account"))
        view.leftImageView.image = UIImage.init(named: "phoneNum")
        view.rightImageBtn.extSetImages([UIImage.init(named: "delete_phoneNum")! ], controlStates: [UIControlState.normal])
        if let num = XUserDefault.getVauleForKey(key: XUserDefault.mobileNumber) as? String{
            view.textfiled.text = num
        }else{
            view.rightImageBtn.isHidden = true
        }
        view.textfiled.rx.text.orEmpty.asObservable().subscribe({ (event) in
            if let text = event.element{
                view.rightImageBtn.isHidden = text.count == 0
            }
        }).disposed(by: disposeBag)
        view.clickRightBlock = {[weak self] () in
            guard let mySelf = self else{return}
            mySelf.clickDeletePhoneNum()
            view.rightImageBtn.isHidden = true
        }
        return view
    }()
    
    //密码输入框
    lazy var pwInputV : InputBoxView = {
        let view = InputBoxView()
        view.extUseAutoLayout()
        view.setPlaceHolderAtt(LanguageTools.getString(key: "toast_no_pass"))
        view.leftImageView.image = UIImage.init(named: "lock")
        view.rightImageBtn.extSetImages([UIImage.init(named: "pw_see")! , UIImage.init(named: "pw_nosee")!], controlStates: [UIControlState.selected,UIControlState.normal])
        view.textfiled.isSecureTextEntry = true
        view.clickRightBlock = {[weak self] () in
            guard let mySelf = self else{return}
            mySelf.clickLock(view.rightImageBtn)
        }
        return view
    }()
    
    //极验按钮
    lazy var gt3Tool : GT3Tool = {

       let tool = GT3Tool()
        
        return tool
    }()

    
    //登录按钮
    lazy var bottomView : LoginBottomView = {
        let view = LoginBottomView()
        view.extUseAutoLayout()
        view.clickLoginBlock = {[weak self] () in
            guard let mySelf = self else{return}
            mySelf.login()
        }
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        if PublicInfoEntity.sharedInstance.verificationType  == "2"{
            contentView.addSubViews([phoneInputV,pwInputV,gt3Tool.captchaButton,bottomView])
            contentView.isUserInteractionEnabled = true
            phoneInputV.snp.makeConstraints { (make) in
                make.top.equalTo(contentView)
                make.height.equalTo(45)
                make.left.equalTo(contentView).offset(41)
                make.right.equalTo(contentView).offset(-41)
            }
            
            pwInputV.snp.makeConstraints { (make) in
                make.top.equalTo(phoneInputV.snp.bottom).offset(14)
                make.left.right.height.equalTo(phoneInputV)

            }
            gt3Tool.captchaButton.snp.makeConstraints { (make) in
                make.top.equalTo(pwInputV.snp.bottom).offset(14)
                make.left.right.height.equalTo(phoneInputV)
            }
            bottomView.snp.makeConstraints { (make) in
                make.top.equalTo(gt3Tool.captchaButton.snp.bottom).offset(14)
                make.left.right.equalToSuperview()
                make.height.equalTo(155)
            }
            
            gt3Tool.start()
        }else{
            contentView.addSubViews([phoneInputV,pwInputV,bottomView])
            phoneInputV.snp.makeConstraints { (make) in
                make.top.equalTo(contentView)
                make.height.equalTo(45)
                make.left.equalTo(contentView).offset(41)
                make.right.equalTo(contentView).offset(-41)
            }
            
            pwInputV.snp.makeConstraints { (make) in
                make.top.equalTo(phoneInputV.snp.bottom).offset(14)
                make.height.equalTo(45)
                make.left.equalTo(contentView).offset(41)
                make.right.equalTo(contentView).offset(-41)
            }
            bottomView.snp.makeConstraints { (make) in
                make.top.equalTo(pwInputV.snp.bottom).offset(14)
                make.left.right.equalToSuperview()
                make.height.equalTo(155)
            }
            
        }
        
        self.extSetCell()


    }

    //MARK:是否隐藏密码
    @objc func clickLock(_ btn : UIButton){
        pwInputV.textfiled.isSecureTextEntry = btn.isSelected
        btn.isSelected = !btn.isSelected
    }
    
    //MARK:点击删除手机号按钮
    @objc func clickDeletePhoneNum(){
        phoneInputV.textfiled.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //登录
    func login(){
        if phoneInputV.textfiled.text == ""{
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_account"))
            return
        }
        if  pwInputV.textfiled.text == ""{
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_pass"))
            return
        }
        
        if gt3Tool.geetest_challenge == nil && PublicInfoEntity.sharedInstance.verificationType  == "2" {
            ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_sliding_block"))

            return
        }
        
        let param = ["mobileNumber" : phoneInputV.textfiled.text ?? "" , "loginPword" : pwInputV.textfiled.text ?? "","geetest_challenge":gt3Tool.geetest_challenge ?? "","geetest_seccode":gt3Tool.geetest_seccode ?? "","geetest_validate":gt3Tool.geetest_validate ?? ""]
        LoginVM().login(param).subscribe(onNext: {[weak self] (dict) in
            guard let mySelf = self else{return}
            if let data = dict["data"] as? [String : Any]{
                guard let type = data["type"] as? String else{return}
                guard let token = data["token"] as? String else{return}
                mySelf.token = token//存储临时token
                XUserDefault.setValueForKey(token, key: XUserDefault.token)//二次登录成功后才会存储token
                mySelf.sendVerificationCode(type)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PhoneNumLoginTC{
    
    //发送验证码
    func sendVerificationCode(_ type : String){

        var title = ""
        var prompts = ""
        var params : [String:Any] = [:]
        switch type{
        case "1":
            title = LanguageTools.getString(key: "google_code")
            prompts = LanguageTools.getString(key: "toast_no_google_code")
            showWithNoCode(title,prompts:prompts)
        case "2":
            title = LanguageTools.getString(key: "mobile_code")
            prompts = LanguageTools.getString(key: "toast_no_mobile_code")
//            params["countryCode"] = "86"
            params["token"] = XUserDefault.getToken() //现在改成了二次验证参数不传手机号和国家编码，传token
            params["operationType"] = "25"
            showWithCode(title,prompts: prompts,params: params, type : "2")
        case "3":
            title = LanguageTools.getString(key: "email_code")
            prompts = LanguageTools.getString(key: "toast_no_email_code")
            params["operationType"] = "4"
            params["email"] = self.phoneInputV.textfiled.text!
            showWithCode(title,prompts: prompts,params: params, type : "3")
        default :
            break
        }
    }
    
    //显示有获取验证码的
    func showWithCode(_ title : String , prompts: String ,params : [String : Any] , type : String){
        let view = UIAlertWithCodeView()
        //展示
        view.alertWith(LanguageTools.getString(key: "title_safty_valid"),cellTitles: [(title,self.phoneInputV.textfiled.text ?? "")],cellPrompts : [prompts] , cellshowMessageBtn : [true])
        //点击确定
        view.clickBtnBlock = {[weak self](b , cells) in
            guard let mySelf = self else{return}
            if b{
                var params : [String : Any] = [:]
                if cells.count > 0{
                    if cells[0].codeTextFiled.textfiled.text == ""{
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_verify_code"))
                        return
                    }
                    if let code = cells[0].codeTextFiled.textfiled.text{
                        params["authCode"] = code
                        params["token"] = mySelf.token
                    }else{
                        ProgressHUDManager.showSuccessWithStatus(prompts)
                    }
                    mySelf.againLogin(params)
                }
            }
        }
        //获取验证码
        view.clickCellBtnBlock = {(index,cells) in
            if type == "3"{
                _ = SendVerificationCode().requestCode(params,action: NetDefine.emailValidCode).subscribe(onNext: {(i) in
                    if cells.count > index{
                        cells[index].codeTextFiled.clickGetMessageBtn()
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            }else{
                _ = SendVerificationCode().requestCode(params).subscribe(onNext: {(i) in
                    if cells.count > index{
                        cells[index].codeTextFiled.clickGetMessageBtn()
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            }
        }
        view.selectCellBtn(0)
        view.show((self.yy_viewController?.view)!)
    }
    
    //显示没有验证码的
    func showWithNoCode(_ title : String , prompts: String){
        let view = UIAlertWithCodeView()
        //添加数据
        view.alertWith(LanguageTools.getString(key: "title_safty_valid"),cellTitles: [(title,"")],cellPrompts : [prompts] , cellshowMessageBtn : [false])
        //点击确定
        view.clickBtnBlock = {[weak self](b , cells) in
            guard let mySelf = self else{return}
            if b{
                var params : [String : Any] = [:]
                if cells.count > 0{
                    if cells[0].codeTextFiled.textfiled.text == ""{
                        ProgressHUDManager.showFailWithStatus(LanguageTools.getString(key: "toast_no_google_code"))
                        return
                    }
                    if let code = cells[0].codeTextFiled.textfiled.text{
                        params["authCode"] = code
                        params["token"] = mySelf.token
                    }else{
                        ProgressHUDManager.showSuccessWithStatus(prompts)
                    }
                    mySelf.againLogin(params)
                }
            }
        }
        view.show((self.yy_viewController?.view)!)
    }
    
    //MARK:二次登录
    func againLogin(_ param : [String : Any]){
        _ = LoginVM().againLogin(param , token : self.token).subscribe(onNext: {[weak self] (dict) in
            guard let mySelf = self else{return}
            ProgressHUDManager.showSuccessWithStatus(LanguageTools.getString(key: "login_suc"))
//            LoginVC.sharedInstance.subject.onNext(1)
            if let text = mySelf.phoneInputV.textfiled.text{
                XUserDefault.setValueForKey(text , key: XUserDefault.mobileNumber)
            }
            UserInfoEntity.removeAllData()
            AccountVM().getPersonlInformation().subscribe(onNext: {(dict) in
                if let data = dict["data"] as? [String : Any]{
                    UserInfoEntity.sharedInstance().setEntityWithDict(data)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by:mySelf.disposeBag)
            mySelf.yy_viewController?.dismiss(animated: true, completion: nil)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
}
