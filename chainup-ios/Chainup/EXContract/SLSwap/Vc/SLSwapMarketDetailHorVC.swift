//
//  SLSwapMarketDetailHorVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/11.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

/// 市场详情 k 线 横屏
class SLSwapMarketDetailHorVC: UIViewController {
    
    var itemModel: BTItemModel?
    
    lazy var kLineVM: SLKLineVM = SLKLineVM()
    
    let menuPublish: PublishSubject<EXMenuSelectionModel> = PublishSubject.init()
    
    private lazy var topHeader: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    private lazy var topLeftHeader: EXHorizontalTopLeft = {
        let view = EXHorizontalTopLeft()
        view.backgroundColor = UIColor.ThemeNav.bg
        view.rmbLabel.isHidden = true
        return view
    }()
    
    private lazy var topRightHeader: SLHorizontalTopRightView = {
        let view = SLHorizontalTopRightView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    private lazy var topHeaderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    private lazy var rightVerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    private lazy var mainMenu = EXHorizontalMainMenu()
    private lazy var rightHorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    private lazy var assistantMenu = EXHorizonAssistantMenu()
    
    /// k 线
    lazy var kLineView: SLKLineView = {
        let view = SLKLineView()
        view.clipsToBounds = true
        view.kLineChartView.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    private lazy var indexFooterView: EXHorizonlIndexContainer = {
        let view = EXHorizonlIndexContainer()
        view.defaultScale(key: menuModel.scaleKey)
        view.scaleDidChage = {[weak self] key in
            self?.menuModel.scaleKey = key
            self?.handleScale(key: key)
            self?.kLineView.hideSelection()
            // 重新请求 k 线数据
            self?.requestLineChartData(scaleKey: key)
        }
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "quotes_scaling"))
        button.extSetAddTarget(self, #selector(clickCloseButton))
        return button
    }()
    
    var menuModel:EXMenuSelectionModel = EXMenuSelectionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.ThemeView.bg
        
        self.transform()
        
        self.topHeader.addSubViews([topLeftHeader, topRightHeader, closeButton, topHeaderLine])
        
        self.view.addSubViews([topHeader, rightVerLine, mainMenu, rightHorLine, assistantMenu, kLineView, indexFooterView])
        
        self.initLayout()
        
        self.handleMenu()
        
        self.updateAllContent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTickerSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification), object: nil)
        
        self.kLineVM.reciveKLineSocketData = {[weak self] itemArr in
            self?.kLineView.appendData(data: itemArr)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    private func initLayout() {
        self.topHeader.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(44)
            make.right.equalTo(-TABBAR_BOTTOM)
        }
        self.topLeftHeader.snp_makeConstraints { (make) in
            make.left.equalTo(BANG_HEIGHT + 10)
            make.top.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        self.topRightHeader.snp_makeConstraints { (make) in
            make.right.equalTo(self.closeButton.snp_left).offset(-15)
            make.top.height.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.5)
        }
        self.closeButton.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.height.equalToSuperview()
            make.width.equalTo(50)
        }
        self.topHeaderLine.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.kLineView.snp_makeConstraints { (make) in
            make.left.equalTo(BANG_HEIGHT)
            make.top.equalTo(self.topHeader.snp_bottom)
            make.right.equalTo(self.rightVerLine.snp_left)
            make.bottom.equalTo(self.indexFooterView.snp_top)
        }
        self.indexFooterView.snp_makeConstraints { (make) in
            make.left.equalTo(BANG_HEIGHT)
            make.height.equalTo(42)
            make.right.equalTo(self.kLineView)
            make.bottom.equalToSuperview()
        }
        self.rightVerLine.snp_makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.right.equalTo(self.mainMenu.snp_left)
            make.top.equalTo(self.mainMenu)
            make.bottom.equalToSuperview()
        }
        self.mainMenu.snp_makeConstraints { (make) in
            make.right.equalTo(self.topHeader)
            make.width.equalTo(55)
            make.top.equalTo(self.topHeader.snp_bottom)
            make.height.equalTo(130)
        }
        self.rightHorLine.snp_makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalTo(self.mainMenu)
            make.top.equalTo(self.mainMenu.snp_bottom)
        }
        self.assistantMenu.snp_makeConstraints { (make) in
            make.right.equalTo(self.mainMenu)
            make.width.equalTo(self.mainMenu)
            make.top.equalTo(self.mainMenu.snp_bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func transform() {
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH)
        let frame = UIScreen.main.bounds
        let center = CGPoint(x: frame.origin.x + ceil(frame.size.width/2), y: frame.origin.y + ceil(frame.size.height/2))
        self.view.center = center
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/2))
    }
    
    private func handleMenu() {
        self.mainMenu.selectOn(type: menuModel.masterType)
        self.kLineView.updateMasterAlgorithm(to: menuModel.masterType)
        self.mainMenu.masterAlgorithmCallback = {[weak self] type in
            self?.menuModel.masterType = type
            self?.kLineView.updateMasterAlgorithm(to: type)
            self?.kLineView.hideSelection()
        }
        
        self.assistantMenu.selectOn(type: menuModel.assitantType)
        self.kLineView.updateAssistantAlgorithm(to: menuModel.assitantType)
        self.assistantMenu.assistantAlgorithmCallback = {[weak self] type in
            self?.menuModel.assitantType = type
            self?.kLineView.updateAssistantAlgorithm(to: type)
            self?.kLineView.hideSelection()

        }
    }
    
    private func handleScale(key:String) {
        self.kLineView.chartSerieSwitchToLineMode(on: (key == EXKlineWsVm.keyLine))
    }
}


// MARK: - Update Data

extension SLSwapMarketDetailHorVC {
    /// 更新全部数据
    private func updateAllContent() {
        self.updateHeader()
        self.requestLineChartData(scaleKey: self.menuModel.scaleKey)
    }
    
    private func updateHeader() {
        guard let _itemModel = self.itemModel else {
            return
        }
        self.kLineView.px_unit = Int(_itemModel.precision)
        self.kLineView.qty_unit = (Int(_itemModel.contractInfo.qty_unit.ch_length - 2) > 0) ? Int(_itemModel.contractInfo.qty_unit.ch_length - 2) : 0
        self.topLeftHeader.updatePrices(model: _itemModel)
        self.topRightHeader.updatePrices(itemModel: _itemModel)
    }
    
    /// 请求 k 线数据
    private func requestLineChartData(scaleKey: String) {
        guard let _itemModel = self.itemModel else {
            return
        }
        
        self.kLineVM.requestKLineData(scaleKey: scaleKey, contract_id: _itemModel.instrument_id, complete: {[weak self] (itemArray) in
            guard let _itemArray = itemArray else {
                return
            }
            self?.kLineView.reloadData(data: _itemArray)
        }) { [weak self] (itemArray) in
            guard let _itemArray = itemArray else {
                return
            }
            self?.kLineView.reloadData(data: _itemArray)
            self?.kLineVM.subscribKLineSocketData(contract_id: _itemModel.instrument_id, scaleKey: scaleKey)
        }
    }
    
    
    // MARK: - Socket Data
    
    @objc func handleTickerSocketData(notify: Notification) {
        guard let itemModel = notify.userInfo?["data"] as? BTItemModel else {
            return
        }
        if itemModel.instrument_id == self.itemModel?.instrument_id {
            self.itemModel = itemModel
            self.updateHeader()
        }
    }
}


// MARK: - Click Events

extension SLSwapMarketDetailHorVC {
    
    @objc func clickCloseButton() {
        self.menuPublish.onNext(self.menuModel)
        self.navigationController?.popViewController(animated: true)
    }
}
