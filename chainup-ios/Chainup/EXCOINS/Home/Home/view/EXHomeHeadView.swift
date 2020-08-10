//
//  EXHomeHeadView.swift
//  Chainup
//
//  Created by zewu wang on 2019/8/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

//第三种
class EXThreeHomeHeadView : UIView{
    
    var bannerHeight : CGFloat = pagewheelrect.height + 15//banner高度
    
    var announcementHeight : CGFloat = 0//公告高度
    
    var assetHeight : CGFloat = SCREEN_WIDTH / 375 * 234//账户高度
    
    typealias ChangeHeadHeightBlock = () -> ()
    var changeHeadHeightBlock : ChangeHeadHeightBlock?
    
    var headHeight : CGFloat = 0
    {
        didSet{
            self.changeHeadHeightBlock?()
        }
    }
    
    //banner
    lazy var pageWheelView : PageWheelView = {
        let view = PageWheelView()
        view.extUseAutoLayout()
        return view
    }()
    
    //公告
    lazy var announcementView : AnnouncementView = {
        let view = AnnouncementView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bg
        view.lineV.isHidden = true
        view.isHidden = true
        return view
    }()
    
    //账户
    lazy var assetView : EXHomeBannerAssetView = {
        let view = EXHomeBannerAssetView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var bottomLineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([assetView,announcementView,pageWheelView,bottomLineV])
        assetView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(assetHeight)
        }
        announcementView.snp.makeConstraints { (make) in
            make.height.equalTo(0)
            make.left.right.equalToSuperview()
            make.top.equalTo(assetView.snp.bottom)
        }
        pageWheelView.snp.makeConstraints { (make) in
            make.height.equalTo(pagewheelrect.height + 15)
            make.left.right.equalToSuperview()
            make.top.equalTo(announcementView.snp.bottom)
        }
        bottomLineV.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.left.right.equalToSuperview()
            make.top.equalTo(pageWheelView.snp.bottom)
        }
        reloadView()
    }
    
    //设置元素
    func setView(_ entity : HomeEntity){
        pageWheelView.setView(entity)
        if entity.noticeInfoList.count == 0{
            announcementView.isHidden = true
            announcementView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            announcementHeight = 0
        }else{
            announcementView.isHidden = false
            announcementView.snp.updateConstraints { (make) in
                make.height.equalTo(40)
            }
            announcementView.setView(entity)
            announcementHeight = 40
        }
        
        reloadView()
    }
    
    func setAssetView(_ totalAccountBlance : String){
        assetView.setView(totalAccountBlance)
    }
    
    func reloadView(){
        assetView.setView(assetView.loginView.balance)
        headHeight = bannerHeight + announcementHeight + assetHeight + 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//第二种
class EXTwoHomeHeadView : UIView{
    
    var bannerHeight : CGFloat = pagewheelHeight//banner高度
    
    var recommendHeight : CGFloat = 0//推荐高度 10
    
    var announcementHeight : CGFloat = 0//公告高度
    
    var funcHeight : CGFloat = 0//功能高度10
    
    typealias ChangeHeadHeightBlock = () -> ()
    var changeHeadHeightBlock : ChangeHeadHeightBlock?
    
    var headHeight : CGFloat = 0
    {
        didSet{
            self.changeHeadHeightBlock?()
        }
    }
    
    //banner
    lazy var pageWheelView : PageWheelView = {
        let view = PageWheelView()
        view.extUseAutoLayout()
        return view
    }()
    
    //公告
    lazy var announcementView : AnnouncementView = {
        let view = AnnouncementView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        view.lineV.isHidden = true
        return view
    }()
    
    //功能
    lazy var funcView : EXHomeFuncThreeAllView = {
        let view = EXHomeFuncThreeAllView()
        view.extUseAutoLayout()
        return view
    }()
    
    //推荐页
    lazy var recommendView : RecommendedView = {
        let view = RecommendedView()
        view.extUseAutoLayout()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([pageWheelView,announcementView,funcView,recommendView])
        pageWheelView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(pagewheelHeight)
        }
        announcementView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(pageWheelView.snp.bottom)
        }
        funcView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(announcementView.snp.bottom)
        }
        recommendView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(funcView.snp.bottom)
        }
        reloadView()
    }
    
    //设置元素
    func setView(_ entity : HomeEntity){
        pageWheelView.setView(entity)
        setISHidden(false)
        if entity.noticeInfoList.count == 0{
            announcementView.isHidden = true
            announcementView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            announcementHeight = 0
        }else{
            announcementView.isHidden = false
            announcementView.snp.updateConstraints { (make) in
                make.height.equalTo(40)
            }
            announcementView.setView(entity)
            announcementHeight = 40
        }
        
        if entity.homeFunctionEntityList.count == 0{
            funcView.isHidden = true
            funcView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            funcHeight = 0
        }else{
            funcView.isHidden = false
            funcView.snp.updateConstraints({ (make) in
                make.height.equalTo(112)
            })
            funcView.setView(entity.homeFunctionEntityList)
            funcHeight = 112
        }
        
//        if announcementHeight != 0 || funcHeight != 0{
//            funcHeight = funcHeight
//        }
        reloadView()
    }
    
    //设置是否展示
    func setISHidden(_ b : Bool){
        recommendView.isHidden = b
        announcementView.isHidden = b
        funcView.isHidden = b
    }
    
    //设置推荐
    func setRecomendView(_ arr : [HomeRecommendedEntity]){
        if arr.count == 0{
            recommendView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            recommendHeight = 0
        }else{
            recommendView.snp.updateConstraints { (make) in
                make.height.equalTo(156)
            }
            recommendHeight = 156
            recommendView.setView(arr)
        }
        reloadView()
    }
    
    
    func reloadView(){
        headHeight = bannerHeight + recommendHeight + announcementHeight + funcHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//第一种
class EXHomeHeadView: UIView {
    
    var bannerHeight : CGFloat = pagewheelHeight//banner高度
    
    var recommendHeight : CGFloat = 0//推荐高度 10
    
    var announcementHeight : CGFloat = 0//公告高度
    
    var funcHeight : CGFloat = 0//功能高度10
    
    var assets : CGFloat = 0//资产高度 10
    
    typealias ChangeHeadHeightBlock = () -> ()
    var changeHeadHeightBlock : ChangeHeadHeightBlock?
    
    var headHeight : CGFloat = 0
    {
        didSet{
            self.changeHeadHeightBlock?()
        }
    }
    
    lazy var headerContainer:UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    
    //banner
    lazy var pageWheelView : PageWheelView = {
        let view = PageWheelView()
        view.extUseAutoLayout()
        return view
    }()
    
    //推荐
    lazy var recommendedView : RecommendedView = {
        let view = RecommendedView()
        view.extUseAutoLayout()
        return view
    }()
    
    //推荐gap
    lazy var recommendedTopGapView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        view.extUseAutoLayout()
        return view
    }()
    
    //公告
    lazy var announcementView : AnnouncementView = {
        let view = AnnouncementView()
        view.extUseAutoLayout()
        return view
    }()
    
    //功能
    lazy var homeFunCView : EXHomeFunCView = {
        let view = EXHomeFunCView()
        view.extUseAutoLayout()
        return view
    }()
    
    //资产
    lazy var homeAssetsView : EXHomeAssetsView = {
        let view = EXHomeAssetsView()
        view.extUseAutoLayout()
        return view
    }()
    
    //banner
    lazy var adBanner : EXCustomBanner = {
        let view = EXCustomBanner()
        return view
    }()
    
    //推荐gap
    lazy var adBannerGap : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        view.extUseAutoLayout()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeNav.bg
        self.addSubview(headerContainer)
        if EXHomeViewModel.homepageStyle() == .bitsg {
            headerContainer.addArrangedSubview(pageWheelView)
            headerContainer.addArrangedSubview(announcementView)
            headerContainer.addArrangedSubview(homeFunCView)
            headerContainer.addArrangedSubview(recommendedTopGapView)
            headerContainer.addArrangedSubview(recommendedView)
            headerContainer.addArrangedSubview(homeAssetsView)
        }else if EXHomeViewModel.homepageStyle() == .momo {
            headerContainer.addArrangedSubview(pageWheelView)
            headerContainer.addArrangedSubview(announcementView)
            headerContainer.addArrangedSubview(recommendedView)
            headerContainer.addArrangedSubview(homeFunCView)
            headerContainer.addArrangedSubview(recommendedTopGapView)
            headerContainer.addArrangedSubview(homeAssetsView)
        }else {
            headerContainer.addArrangedSubview(pageWheelView)
            headerContainer.addArrangedSubview(recommendedView)
            headerContainer.addArrangedSubview(announcementView)
            headerContainer.addArrangedSubview(homeFunCView)
            headerContainer.addArrangedSubview(recommendedTopGapView)
            headerContainer.addArrangedSubview(homeAssetsView)
            if EXCustomConfigVm.shared().customAds().count > 0 {
                headerContainer.addArrangedSubview(adBanner)
                headerContainer.addArrangedSubview(adBannerGap)
            }
        }

        
        headerContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageWheelView.snp.makeConstraints { (make) in
            make.height.equalTo(pagewheelHeight)
        }
        
        if EXCustomConfigVm.shared().customAds().count > 0 {
            adBanner.snp.makeConstraints { (make) in
                make.height.equalTo(HEIGHT_SHORT)
            }
            adBannerGap.snp.makeConstraints { (make) in
                make.height.equalTo(10)
            }
        }
        
        var h : CGFloat = 0
        if EXHomeViewModel.homepageStyle() == .momo{
            h = 117
        }else{
            h = 90
        }
        recommendedView.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
        recommendHeight = h
//        recommendedView.snp.makeConstraints { (make) in
////            make.left.right.equalToSuperview()
//            make.height.equalTo(90)
////            make.top.equalTo(pageWheelView.snp.bottom)
//        }
        
        recommendedTopGapView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
        }
        
        announcementView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
            make.height.equalTo(40)
//            make.top.equalTo(recommendedView.snp.bottom)
        }
        
        homeFunCView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
            make.height.equalTo(99)
//            make.top.equalTo(announcementView.snp.bottom)
        }
        
        if XUserDefault.getToken() == nil{
            homeAssetsView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
//                make.top.equalTo(homeFunCView.snp.bottom).offset(10)
                make.height.equalTo(128)
            }
        }else{
            homeAssetsView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
//                make.top.equalTo(homeFunCView.snp.bottom).offset(10)
                make.height.equalTo(150)
            }
        }
        setISHidden(true)
    }
    
    //设置是否展示
    func setISHidden(_ b : Bool){
        recommendedView.isHidden = b
        announcementView.isHidden = b
        homeFunCView.isHidden = b
        homeAssetsView.isHidden = b
    }
    
    //设置元素
    func setView(_ entity : HomeEntity){
        
        pageWheelView.setView(entity)
        setISHidden(false)
        
        if entity.noticeInfoList.count == 0{
            announcementView.isHidden = true
//            announcementView.snp.updateConstraints { (make) in
//                make.height.equalTo(0)
//            }
            announcementHeight = 0
        }else{
            announcementView.isHidden = false
//            announcementView.snp.updateConstraints { (make) in
//                make.height.equalTo(40)
//            }
            announcementView.setView(entity)
            announcementHeight = 40
        }
        
        if entity.homeFunctionEntityList.count == 0{
            homeFunCView.isHidden = true
            announcementView.lineV.isHidden = true
            homeFunCView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            funcHeight = 0
        }else{
            homeFunCView.isHidden = false
            announcementView.lineV.isHidden = false
            if EXCustomConfigVm.shared().homeFunctionDirection() == .horizontal {
                if entity.homeFunctionEntityList.count - 4 > 0{
                     homeFunCView.snp.updateConstraints({ (make) in
                         make.height.equalTo(99)
                     })
                     homeFunCView.setView(entity.homeFunctionEntityList)
                     funcHeight = 99
                 }else{
                     homeFunCView.snp.updateConstraints({ (make) in
                         make.height.equalTo(89)
                     })
                     homeFunCView.setView(entity.homeFunctionEntityList)
                     funcHeight = 89
                 }
            }else {
                let rowAtIdx = entity.homeFunctionEntityList.count/4
                let reminder = entity.homeFunctionEntityList.count%4
                
                let height = 99 * (rowAtIdx + (reminder > 0 ? 1 : 0))
                homeFunCView.setView(entity.homeFunctionEntityList)
                funcHeight = CGFloat(height)
                homeFunCView.snp.updateConstraints({ (make) in
                    make.height.equalTo(height)
                })
            }
 
        }
        if EXHomeViewModel.homepageStyle() == .bitsg {
            recommendedTopGapView.isHidden = false
            funcHeight = funcHeight + 10
        }else if EXHomeViewModel.homepageStyle() == .momo {
            recommendedTopGapView.isHidden = false
            funcHeight = funcHeight + 10
        }else {
            if announcementHeight != 0 || funcHeight != 0{
                funcHeight = funcHeight + 10
                recommendedTopGapView.isHidden = false
            }else {
                recommendedTopGapView.isHidden = true
            }
            
            if EXCustomConfigVm.shared().customAds().count > 0 {
                funcHeight = funcHeight + 10
                adBannerGap.isHidden = false
            }else {
                adBannerGap.isHidden = true
            }
        }
        
     
        reloadView()
    }
    
    //设置推荐
    func setRecomendView(_ arr : [HomeRecommendedEntity]){
        if arr.count == 0{
            recommendedView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            recommendedView.isHidden = true
            recommendHeight = 0
        }else{
            recommendedView.isHidden = false
            var h : CGFloat = 0
            if EXHomeViewModel.homepageStyle() == .momo{
                h = 117
            }else{
                h = 90
            }
            recommendedView.snp.updateConstraints { (make) in
                make.height.equalTo(h)
            }
            recommendHeight = h

            recommendedView.setView(arr)
        }
        reloadView()
    }
    
    //设置账户
    func setAssetView(){
        homeAssetsView.setView()
        if XUserDefault.getToken() == nil{
            assets = 128
            homeAssetsView.snp.updateConstraints { (make) in
                make.height.equalTo(128)
            }
        }else{
            assets = 150
            homeAssetsView.snp.updateConstraints { (make) in
                make.height.equalTo(150)
            }
        }
    }
    
    func reloadView(){
        if EXCustomConfigVm.shared().showAccountUI() {
            homeAssetsView.isHidden = false
            setAssetView()
        }else {
            homeAssetsView.isHidden = true
        }
        
        var adHeight:CGFloat = 0
        if EXCustomConfigVm.shared().customAds().count > 0 {
            adHeight = HEIGHT_SHORT
        }
        
        headHeight = bannerHeight + recommendHeight + announcementHeight + funcHeight + assets + adHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

