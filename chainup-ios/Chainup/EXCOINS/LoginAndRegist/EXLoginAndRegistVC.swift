//
//  EXLoginAndRegistVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

typealias EXLoginBlock = (EXLoginType) -> ()
enum EXLoginType {
    case login
    case regist
}

class EXLoginAndRegistVC: BaseVC {
    
    var height = SCREEN_HEIGHT > 568 ? SCREEN_HEIGHT - NAV_STATUS_HEIGHT - TABBAR_BOTTOM : 600
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        scrollView.bounces = false
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH, height: height )
        return scrollView
    }()
    
    lazy var loginView : EXLoginView = {
        let view = EXLoginView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height ))
        view.loginBlock = {[weak self](type) in
            self?.changeView(type)
        }
        view.clickPopBackBlock = {[weak self] in
            self?.popBackVC()
        }
        return view
    }()
    
    lazy var registView : EXRegistOneView = {
        let view = EXRegistOneView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height ))
        view.isHidden = true
        view.loginBlock = {[weak self](type) in
            self?.changeView(type)
        }
        view.clickPopBackBlock = {[weak self] in
            self?.popBackVC()
        }
        return view
    }()
    
    func changeView(_ type : EXLoginType){
        loginView.isHidden = type != EXLoginType.login
        registView.isHidden = type != EXLoginType.regist
    }
    
    //页面消失
    func popBackVC(){
        NotificationCenter.default.post(name:  NSNotification.Name.init("EXCancelLogin"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeView.bg
        view.addSubview(scrollView)
        scrollView.addSubViews([loginView,registView])
        NotificationCenter.default.addObserver(self, selector: #selector(EXRegistSuccess), name: NSNotification.Name.init("EXRegistSuccess"), object: nil)
//        loginView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalToSuperview().offset(NAV_STATUS_HEIGHT)
//        }
//        registView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalToSuperview().offset(NAV_STATUS_HEIGHT)
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func EXRegistSuccess(){
        changeView(EXLoginType.login)
    }
    
}
