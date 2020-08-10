//
//  EXAssetsContainerVc.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SGPagingView

class EXAssetsContainerVc: UIViewController,StoryBoardLoadable,NavigationPlugin {
    
    internal lazy var navigation : EXNavigation = {
        let nav =  EXNavigation.init(affectScroll: nil, presenter: self)
        return nav
    }()
    var controllers : [UIViewController] = []

    var pageTitleView = EXAssetHeader()
    var pageContentView = SGPageContentScrollView()
    var coinAsset = EXAssetsListContentVc.instanceFromStoryboard(name: StoryBoardNameAsset)
    var swapAsset = SLSwapAssetListVc.instanceFromStoryboard(name: StoryBoardNameAsset)

    
    var assetModels:[EXCommonAssetModel] = []
    
    private var selectIndex = 0 {
        didSet {
            configNaviTitle(selectIndex)
        }
    }
    
    var assetType:EXAccountType?
    
    func configNaviTitle(_ atIdx:Int) {
        let supportAccounts = self.supportAccounts()
        let type = supportAccounts[atIdx]
        switch type {
        case .coin:
            self.navigation.setTitle(title: "assets_text_exchange".localized())
        case .otc:
            if PublicInfoManager.sharedInstance.getFiatTradeOpen(){
                self.navigation.setTitle(title: "assets_text_otc_forotc".localized())
            }else{
                self.navigation.setTitle(title: "assets_text_otc".localized())
            }
        case .contract:
            self.navigation.setTitle(title: "assets_text_contract".localized())
        case .b2c:
            self.navigation.setTitle(title:"assets_text_otc".localized())
        case .leverage:
            self.navigation.setTitle(title:"leverage_asset".localized())
        }
    }

    func configNavigation(){
        if let navC = self.navigationController {
            let controllers = navC.viewControllers
            if controllers.count == 1 {
                self.navigation.setdefaultType(type: .nopopback)
            }else {
                self.navigation.setdefaultType(type: .list)
            }
        }else {
            self.navigation.setdefaultType(type: .list)
        }

        self.navigation.rightItemCallback = {[weak self] tag in
            self?.privacyBtnAction()
        }
        configPrivacy()
    }
    
    func configPrivacy(){
        if XUserDefault.assetPrivacyIsOn() {
            self.navigation.configRightItems(["hide"])
        }else {
            self.navigation.configRightItems(["visible"])
        }
    }
    
    func updateContainersPrivacy() {
        for controller in controllers {
            if controller .isKind(of: EXAssetBaseVc.self) {
                coinAsset.updatePrivacy()
                swapAsset.updatePrivacy()
            }
        }
        pageTitleView.reloadHeader()
    }
    
    func privacyBtnAction() {
        if XUserDefault.assetPrivacyIsOn() {
            XUserDefault.switchAssets(false)
        }else {
            XUserDefault.switchAssets(true)
        }
        updateContainersPrivacy()
        configPrivacy()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if EXThemeManager.isNight() == true{
            return .lightContent
        }else{
            return .default
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ThemeView.bg
        configNavigation()
        configChilds()
        forbidMoveFromScreenLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BasicParameter.getVersionForPublicInfo()
    }
    
    open func forbidMoveFromScreenLeft(){
        //导航控制器根控制器禁止左滑 否则 左滑 易出现卡顿现象
        let screenPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightSliderScreen))
        screenPan.edges = UIRectEdge.left
        self.view.addGestureRecognizer(screenPan)
    }
    
    @objc open func rightSliderScreen(_ pan : UIScreenEdgePanGestureRecognizer){
        //do nothing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configPrivacy()
        updateContainersPrivacy()
        if pageTitleView.page != self.selectIndex {
            pageTitleView.headerScroll(selectIndex)
        }
        if XUserDefault.isOffLine() {
            if let tabbar = BusinessTools.getRootTabbar(){
                tabbar.selectIndex(0)
            }
        }else {
            //当资产在tab的时候，每次过来刷新一下资产
            if let navC = self.navigationController {
                let controllers = navC.viewControllers
                if controllers.count == 1 {
                    if isSupport(type: .otc) {
                    }
                    coinAsset.requestBalalance()
                }
                if isSupport(type: .contract) {
                    handleAlertOpenSwap(self.selectIndex)
                }
            }
        }
    }
    
    func isFirstController() -> Bool {
        if let navC = self.navigationController {
            let controllers = navC.viewControllers
            if controllers.count == 1 {
                return true
            }
        }
        return false
    }
    
    func supportAccounts() ->[EXAccountType] {
        return PublicInfoManager.sharedInstance.getSupportAccounts()
    }
    
    func updateAsset(_ model:EXCommonAssetModel) {
        for item in assetModels {
            if let updatetype = model.assetType,
                let origintype = item.assetType {
                if updatetype == origintype {
                    item.totalBalance = model.totalBalance
                    item.totalBalanceSymbol = model.totalBalanceSymbol
                    if updatetype == .contract {
                        item.canUseBalance = model.canUseBalance
                        item.orderMargin = model.orderMargin
                        item.positionMargin = model.positionMargin
                    }
                }
            }
        }
        pageTitleView.updateHeaderDatas(assetModels)
    }
    
    func isSupport(type:EXAccountType) -> Bool {
        let supportAccounts = self.supportAccounts()
        return supportAccounts.contains(type)
    }
    
    func configChilds (){
        
        if isSupport(type: .coin) {
            let model = EXCommonAssetModel()
            model.title = "assets_text_exchange".localized() + "assets_text_total".localized()
            model.bgIcon = "assets_exchange"
            model.assetType = .coin
            assetModels.append(model)
            controllers .append(coinAsset)
        }

        if isSupport(type: .contract) {
            let model = EXCommonAssetModel()
            model.title = "home_text_contractTotal".localized()
            model.bgIcon = "assets_contract"
            model.assetType = .contract
            assetModels.append(model)
            controllers.append(swapAsset)
        }
        coinAsset.onAssetupdate = {[weak self] assetModel in
            self?.updateAsset(assetModel)
        }

        swapAsset.onAssetupdate = {[weak self] assetModel in
            self?.updateAsset(assetModel)
        }

        pageTitleView.frame = CGRect(x: 0, y: NAV_SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 145)
        pageTitleView.updateHeaderDatas(assetModels)
        pageTitleView.currentPageCallback  = {[weak self] currentPage in
            self?.headerScrolled(currentPage)
        }
        pageTitleView.backgroundColor = UIColor.ThemeNav.bg
        self.view .addSubview(self.pageTitleView)
        let hasTabbar = self.isFirstController()
        
        self.pageContentView = SGPageContentScrollView.init(frame: CGRect(x: 0, y:pageTitleView.frame.maxY, width: SCREEN_WIDTH, height: CONTENTVIEW_HEIGHT - (hasTabbar ? TABBAR_HEIGHT : 0) - 135), parentVC: self, childVCs: controllers)
        self.pageContentView.delegatePageContentScrollView = self;
        self.pageContentView.backgroundColor = UIColor.clear
        self.view .addSubview(pageContentView)
        self.anchorToAssetAccount()
    }
    
    func anchorToAssetAccount() {
        if let accountType = self.assetType {
            for item in assetModels {
                if item.assetType == accountType {
                    let index = assetModels.index(of: item) ?? 0
                    self.handleCurrentAccount(index)
                    break;
                }
            }
        }else {
            self.handleCurrentAccount(0)
        }
    }
    
    func handleCurrentAccount(_ idx:Int) {
        self.selectIndex = idx
        pageContentView.setPageContentScrollViewCurrentIndex(idx)
    }
    
    func headerScrolled(_ toPage:Int) {
        if controllers.count > toPage,toPage >= 0 {
            pageContentView.setPageContentScrollViewCurrentIndex(toPage)
        }
        handleAlertOpenSwap(toPage)
    }
    
    func handleAlertOpenSwap(_ currentPage:Int) {
        let swapIndex = getSwapVcIndex()
        if currentPage == swapIndex && swapIndex >= 0 {
            BTMineAccountTool.share()?.loadContractAccountPropertyInfo(withContractID: "0", success: {[weak self] (propertyArr) in
                guard let mySelf = self else {return}
                if (propertyArr ?? []).count == 0 {
                    // 去开通合约
                    let alert = SLSwapAssetAlertView.createAlert(contentStr: "contract_text_openSwap_operation".localized(), btnTitle: "contract_text_btn_swapopen".localized(), imageStr:"reminders" , frame: CGRect.init(x: 0, y: 0, width: 311, height: 298))
                    alert.alertCallback = {[weak self] idx in
                        guard let mySelf = self else {return}
                        if idx == 1 {
                            mySelf.swapAsset.handleJumpToSwapVc()
                        }
                    }
                    alert.show()
                } else {
                    mySelf.swapAsset.updatePrivacy()
                    mySelf.swapAsset.requestBalalance()
                }
            }, failure: { (error) in
            })
        }
    }
    
    
    func getSwapVcIndex() -> Int {
        for (index,value) in assetModels.enumerated() {
            if value.assetType == .contract {
                return index
            }
        }
        return -1
    }
}


extension EXAssetsContainerVc : SGPageContentScrollViewDelegate {
    
    func pageContentScrollView(_ pageContentScrollView: SGPageContentScrollView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        if progress > 0.5 {
            self.selectIndex = targetIndex
            pageTitleView.headerScroll(targetIndex)
        }
    }
}
extension EXAssetsContainerVc {
    
}
extension EXAssetsContainerVc : EXTradeCmdProtocal {
    
    func excuteCmd(symbol: String, action: String) {
        if action == "otc" {
            self.assetType = .otc
        }else if action == "contract" {
            self.assetType = .contract
        }else if action == "b2c" {
            self.assetType = .b2c
        }else if action == "leverage" {
            self.assetType = .leverage
        }else {
            self.assetType = .coin
        }
        self.anchorToAssetAccount()
    }
    
}
