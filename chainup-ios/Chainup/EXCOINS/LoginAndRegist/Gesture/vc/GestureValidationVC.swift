//
//  GestureValidationVC.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/4.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

enum GestureValidationType {
    case input//输入手势密码
    case EnterAgain//重新输入手势密码
    case login//手势密码登录
    case loginSet//登录提醒设置
    case loginSetAgain//登录提醒再次设置
}

class GestureValidationVC: NavCustomVC {
    
    let vm = GestureValidationVM()
    
    var type = GestureValidationType.EnterAgain
    {
        didSet{
            gestureValidationView.setView(type)
        }
    }
    
    var code = ""//手势密码
    
    var gesToken = ""//手势token
    
    typealias ConfirmGesturesBlock = (String)->()//确认手势
    var confirmGesturesBlock : ConfirmGesturesBlock?

    typealias ConfirmGesturesCompleteBlock = () -> ()//第二次确认手势
    var confirmGesturesCompleteBlock : ConfirmGesturesCompleteBlock?
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitle(LanguageTools.getString(key: "common_text_btnCancel"), for: UIControlState.normal)
        btn.contentHorizontalAlignment = .left
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        btn.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        return btn
    }()
    
    lazy var gestureValidationView : GestureValidationView = {
        let view = GestureValidationView()
        view.extUseAutoLayout()
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        vm.setVC(self)
        gestureValidationView.vm = self.vm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentView.addSubview(gestureValidationView)
        gestureValidationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setNavCustomV() {
        self.navCustomView.backView.backgroundColor = UIColor.ThemeView.bg
        self.navCustomView.popBtn.isHidden = true
        self.navCustomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(self.navCustomView.popBtn)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(16)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //手势验证
    func sendGestDatas(afterLogin:Bool){
        let quickToken = XUserDefault.getVauleForKey(key: XUserDefault.quickToken) as! String

        appApi.rx.request(.handOpen(quickToken:afterLogin ? quickToken : gesToken, handPwd: code, afterLogin: afterLogin))
            .subscribe(onSuccess: {[weak self] (_) in
            
            XUserDefault.setGesturesPassword(self?.code ?? "")
            self?.confirmGesturesCompleteBlock?()
            self?.clickCancelBtn()
            EXAlert.showSuccess(msg: "login_tip_gestureLoginSuccess".localized())
        }, onError: nil).disposed(by: self.disposeBag)
    }
    
    //手势登录
    func gestLogin(){
        
        if  XUserDefault.getGesturesPassword() != nil {
            
            let quickToken = XUserDefault.getVauleForKey(key: XUserDefault.quickToken) as? String ?? ""

            appApi.rx.request(.handLogin(quickToken: quickToken, handPwd: XUserDefault.getGesturesPassword() ?? "")).MJObjectMap(EXLoginSuccessEntity.self).subscribe(onSuccess: {[weak self] (entity) in
                UserInfoEntity.sharedInstance().loginSuccess(entity.token)
                UserInfoEntity.sharedInstance().getUserInfo {}
                EXAlert.showSuccess(msg: LanguageTools.getString(key: "login_tip_loginsuccess"))
                self?.popBack()
                EXGameJumpManager.shareInstance.presentAuthorVc()
            }) {[weak self] (error) in
                if error._code == 104008{
                    self?.popBack()
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
           
        }
    }
    
    @objc func clickCancelBtn(){
        //        super.navBack()
        guard BusinessTools.getRootNavBar() != nil else{
            return
        }
        popBack()
    }
}
