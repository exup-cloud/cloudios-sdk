//
//  EXHomeVC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import YYWebImage

class EXHomeVC: NavCustomVC {
    
    
    lazy var navView : EXHomeNavBar = {
        var view = EXHomeNavBar()
        if EXHomeViewModel.status() == .two{
            view = EXHomeTwoNavBar()
        }
        view.extUseAutoLayout()
        return view
    }()
    
    let mainView : EXHomeView = {
        let view = EXHomeView()
        view.extUseAutoLayout()
        return view
    }()
    
  
    
    let reachability = Reachability.forInternetConnection()
    
    func configNoti() {
        let notificationName = Notification.Name(rawValue: "SLSwapBalanceRefresh")
        _ = NotificationCenter.default.rx
            .notification(notificationName)
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {[weak self] notification in
                guard let `self` = self else {return}
                    //获取通知数据
                guard let rst = notification.object as? String else {return}
                self.mainView.updateCoBalance(balance: rst)
            })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNoti()
        EXCustomConfigVm.shared().registerCustomConfig()
        // Do any additional setup after loading the view.
        showAlert()
        self.view.addSubViews([mainView,navView])
        mainView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_HEIGHT)
        }
        navView.snp.makeConstraints { (make) in
            make.height.equalTo(NAV_SCREEN_HEIGHT)
            make.left.right.top.equalToSuperview()
        }
        
        self.contentView.isHidden = true
        self.navCustomView.isHidden = true
        //解决tableview 顶部留白
        if #available(iOS 11.0, *) {
            mainView.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        _ = mainView.tableView.rx.contentOffset.subscribe({[weak self] (event) in
            if let contentOffset = event.element{
                let y = contentOffset.y
                let poor = y - pagewheelHeight / 2
                if poor > 0{
                    self?.navView.setView(poor / (pagewheelHeight / 2 - NAV_SCREEN_HEIGHT))
                }else{
                    self?.navView.setView()
                }
                self?.setStatusBar(poor)
            }
        })
                
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"),
            object: reachability
        )
        reachability?.startNotifier()
        

    }
    func showAlert() {
        
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (event) in
//            if let e = event.element , e == 1{
        
//            }
        }.disposed(by: self.disposeBag)
    }
    func reachabilityChanged(notification: NSNotification) {
        if  let reachability =   notification.object as? Reachability{
            
            if reachability.currentReachabilityStatus().rawValue != 0{
                PublicInfo.sharedInstance.getData()
                self.mainView.getHomeData()
                reachability.stopNotifier()
                NotificationCenter.default.removeObserver(self , name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if EXHomeViewModel.status() == .one{
            mainView.headView.reloadView()
        }else if EXHomeViewModel.status() == .two{
            mainView.headTwoView.reloadView()
        }else if EXHomeViewModel.status() == .three{
            mainView.headThreeView.reloadView()
        }
        mainView.getHomeData()
        setStatusBar()
        mainView.getAssets()
        mainView.timer?.fireDate = Date.init()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBar(1)
        mainView.timer?.fireDate = Date.distantFuture
    }
    
    //设置状态栏
    func setStatusBar(_ poor : CGFloat = 0){
//        if EXThemeManager.isNight() == true{
//            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//        }else{
//            if poor > 0{
//                if UIApplication.shared.statusBarStyle == UIStatusBarStyle.lightContent{
//                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//                }
//            }else{
//                if UIApplication.shared.statusBarStyle == UIStatusBarStyle.default{
//                    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//                }
//            }
//        }
    }
    

}

class EXHomeTwoNavBar : EXHomeNavBar{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userBtn.setImage(UIImage.themeImageNamed(imageName: "home_head"), for: UIControlState.normal)
        userBtn.setImage(UIImage.themeImageNamed(imageName: "home_head"), for: UIControlState.selected)
        logoImgV.snp.remakeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        userBtn.snp.remakeConstraints { (make) in
            make.centerY.equalTo(logoImgV)
            make.height.width.equalTo(22)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXHomeNavBar : UIView{
    
    lazy var logoImgV : UIImageView = {
        let imgV = UIImageView.init()
        imgV.extUseAutoLayout()
        imgV.isUserInteractionEnabled = true
        #if DEBUG
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickImgV))
        imgV.addGestureRecognizer(tap)
        #endif
        return imgV
    }()
    
    lazy var userBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        if EXHomeViewModel.status() == .one{
            btn.setImage(UIImage.themeImageNamed(imageName: EXHomeViewModel.getHomePersonDayImage()), for: UIControlState.normal)
            btn.setImage(UIImage.themeImageNamed(imageName: EXHomeViewModel.getHomePersonNightImage()), for: UIControlState.selected)
        }else if EXHomeViewModel.status() == .three{
            btn.setImage(UIImage.themeImageNamed(imageName: "head_japan"), for: UIControlState.normal)
            btn.setImage(UIImage.themeImageNamed(imageName: "head_japan"), for: UIControlState.selected)
        }
        btn.extSetAddTarget(self, #selector(clickUserBtn))
        btn.setEnlargeEdgeWithTop(10, left: 10, bottom: 10, right: 10)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([logoImgV,userBtn])
        logoImgV.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(120)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        userBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(logoImgV)
            make.height.width.equalTo(22)
            make.right.equalToSuperview().offset(-15)
        }
        setView()
        setImgV()
    }
    
    //
    func setImgV(_ f : CGFloat = 0){
        PublicInfo.sharedInstance.subject.asObserver().subscribe {[weak self] (i) in
            guard let mySelf = self else{return}
            if EXThemeManager.isNight() == true{
                if let url = URL.init(string: PublicInfoEntity.sharedInstance.app_logo_list_new.logo_black){
                    mySelf.logoImgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                }
            }else{
                if f <= 0{
                    if let url = URL.init(string: PublicInfoEntity.sharedInstance.app_logo_list_new.logo_black){
                        mySelf.logoImgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                    }
                }else{
                    if let url = URL.init(string: PublicInfoEntity.sharedInstance.app_logo_list_new.logo_white){
                        mySelf.logoImgV.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
                    }
                }
            }
            }.disposed(by: disposeBag)
    }
    
    func setView(_ alpha : CGFloat = 0){
        if EXThemeManager.isNight() == true{
            userBtn.isSelected = true
        }else{
            userBtn.isSelected = alpha <= 0
        }
        self.backgroundColor = UIColor.ThemeNav.bg.withAlphaComponent(alpha)
        self.setImgV(alpha)
    }
    
    @objc func clickImgV(){
//        let vc = EXRealNameOneVC()
//        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickUserBtn(){
        let vc = EXMEVC()
        self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
