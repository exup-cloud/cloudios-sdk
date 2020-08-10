//
//  SLSwapMarketDetailHeader.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/7.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import RxSwift

class SLSwapMarketDetailHeader: UIView {
    
    var enterFundRateVCCallBack: (() -> ())?
    var enterFullScreenCallBack: (() -> ())?
    
    /// k 线时间间隔
    let scalePublish: PublishSubject<String> = PublishSubject.init()
    /// k 线主图指标
    let masterType: PublishSubject<MasterAlgorithmType> = PublishSubject.init()
    /// k 线副图指标
    let assistantType: PublishSubject<AssistantAlgorithmType> = PublishSubject.init()
    
    /// 顶部价格视图
    private lazy var headerContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    /// k 线相关设置
    private lazy var kLineSettingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    private lazy var scaleChangeControl: EXTriangleIndicator = {
        let ctl = EXTriangleIndicator()
        ctl.textNormalColor = UIColor.ThemeLabel.colorLite
        ctl.textHighLightColor = UIColor.ThemeLabel.colorLite
        ctl.setTitle(content: "15" + "noun_date_minute".localized())
        ctl.addTarget(self, action: #selector(scaleAction), for: .touchUpInside)
        return ctl
    }()
    private lazy var indexChangeControl: EXTriangleIndicator = {
        let ctl = EXTriangleIndicator()
        ctl.textNormalColor = UIColor.ThemeLabel.colorLite
        ctl.textHighLightColor = UIColor.ThemeLabel.colorLite
        ctl.setTitle(content: "kline_text_scale".localized())
        ctl.addTarget(self, action: #selector(indexAction), for: .touchUpInside)
        return ctl
    }()
    private lazy var fullScreenButton: UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "contract_zoom"))
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
        return button
    }()
    private lazy var marginLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    /// k 线设置弹框
    private lazy var scaleDrop = EXScaleDropView()
    private lazy var algorithmDrop = EXAlgorithmDropView()
    
    /// k 线相关设置
    var menuModel = EXMenuSelectionModel.init() {
        didSet {
            scaleChangeControl.setTitle(content: menuModel.scaleKey.localized())
            kLineView.updateMasterAlgorithm(to: menuModel.masterType)
            kLineView.updateAssistantAlgorithm(to: menuModel.assitantType)
            scaleDrop.menuModel = menuModel
            algorithmDrop.menuModel = menuModel
        }
    }
    
    /// k 线
    lazy var kLineView: SLKLineView = {
        let view = SLKLineView()
        view.kLineChartView.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    /// 底部分隔
    private lazy var marginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    /// 当前价格
    private lazy var priceLabel: UILabel = {
        let label = UILabel(text: "-", font: UIFont.ThemeFont.H1Bold, textColor: UIColor.ThemekLine.up, alignment: .left)
        return label
    }()
    
    /// 法币价格
    private lazy var otcPriceLabel: UILabel = {
        let label = UILabel(text: "≈-CNY", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return label
    }()
    
    /// 纯粹为了布局
    private lazy var leftViewForLayout: UIView = UIView()
    
    /// 涨跌额
    private lazy var changeAmountLabel: UILabel = UILabel(text: "contract_market_detail_change_amount".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var changeAmountValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
    
    /// 合理价格
    private lazy var fairPriceLabel: UILabel = UILabel(text: "contract_text_fairPrice".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var fairPriceValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 指数价格
    private lazy var indexPriceLabel: UILabel = UILabel(text: "contract_text_indexPrice".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var indexPriceValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 纯粹为了布局
    private lazy var rightViewForLayout: UIView = UIView()
    
    /// 涨跌幅
    private lazy var priceLimitLabel: UILabel = UILabel(text: "common_text_priceLimit".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    private lazy var priceLimitValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
    
    /// 资金费率
    private lazy var fundRateLabel: UILabel = UILabel(text: "contract_fund_rate".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var fundRateValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 24h量
    private lazy var volume24HLabel: UILabel = UILabel(text: "contract_market_detail_24h_volume".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var volume24HValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 箭头
    private lazy var arrowButton: UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "contract_enter"))
        button.extSetAddTarget(self, #selector(enterFundRateVC))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftViewForLayout.addSubViews([changeAmountLabel, fairPriceLabel, indexPriceLabel])
        rightViewForLayout.addSubViews([priceLimitValue, fundRateValue, volume24HValue])
            
        headerContentView.addSubViews([priceLabel, otcPriceLabel, leftViewForLayout, changeAmountValue, fairPriceValue, indexPriceValue, priceLimitLabel, fundRateLabel, volume24HLabel, rightViewForLayout, arrowButton])
        
        kLineSettingView.addSubViews([scaleChangeControl, indexChangeControl, fullScreenButton, marginLine])
        
        self.addSubViews([headerContentView, kLineSettingView, kLineView, marginView])
        
        rightViewForLayout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterFundRateVC)))
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        headerContentView.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(4)
        }
        otcPriceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp_right).offset(5)
            make.bottom.equalTo(priceLabel).offset(-5)
        }
        leftViewForLayout.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp_bottom).offset(10)
        }
        changeAmountLabel.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(12)
            make.right.lessThanOrEqualToSuperview()
        }
        changeAmountValue.snp_makeConstraints { (make) in
            make.top.equalTo(leftViewForLayout)
            make.height.equalTo(changeAmountLabel)
            make.left.equalTo(leftViewForLayout.snp_right).offset(10)
        }
        fairPriceLabel.snp_makeConstraints { (make) in
            make.left.height.equalTo(changeAmountLabel)
            make.top.equalTo(changeAmountLabel.snp_bottom).offset(10)
            make.right.lessThanOrEqualToSuperview()
        }
        fairPriceValue.snp_makeConstraints { (make) in
            make.left.height.equalTo(changeAmountValue)
            make.top.equalTo(changeAmountValue.snp_bottom).offset(10)
        }
        indexPriceLabel.snp_makeConstraints { (make) in
            make.left.height.equalTo(changeAmountLabel)
            make.top.equalTo(fairPriceLabel.snp_bottom).offset(10)
            make.right.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
        indexPriceValue.snp_makeConstraints { (make) in
            make.left.height.equalTo(changeAmountValue)
            make.top.equalTo(fairPriceValue.snp_bottom).offset(10)
        }
        
        arrowButton.snp_makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(30)
            make.right.equalTo(-5)
            make.centerY.equalTo(fundRateLabel)
        }
        rightViewForLayout.snp_makeConstraints { (make) in
            make.right.equalTo(arrowButton.snp_left).offset(-5)
            make.top.equalTo(leftViewForLayout)
        }
        priceLimitValue.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(changeAmountLabel)
        }
        priceLimitLabel.snp_makeConstraints { (make) in
            make.right.equalTo(rightViewForLayout.snp_left).offset(-10)
            make.height.equalTo(changeAmountLabel)
            make.top.equalTo(changeAmountValue)
        }
        fundRateValue.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(changeAmountLabel)
            make.top.equalTo(priceLimitValue.snp_bottom).offset(10)
        }
        fundRateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(priceLimitLabel.snp_bottom).offset(10)
            make.right.height.equalTo(priceLimitLabel)
        }
        volume24HValue.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(priceLimitValue)
            make.top.equalTo(fundRateValue.snp_bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        volume24HLabel.snp_makeConstraints { (make) in
            make.right.height.equalTo(priceLimitLabel)
            make.top.equalTo(fundRateLabel.snp_bottom).offset(10)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        kLineSettingView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerContentView.snp_bottom)
            make.height.equalTo(35)
        }
        scaleChangeControl.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        indexChangeControl.snp_makeConstraints { (make) in
            make.left.equalTo(scaleChangeControl.snp_right).offset(30)
            make.centerY.equalTo(scaleChangeControl)
        }
        fullScreenButton.snp_makeConstraints { (make) in
            make.width.equalTo(46)
            make.top.height.right.equalToSuperview()
        }
        marginLine.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        kLineView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kLineSettingView.snp_bottom)
            make.height.equalTo(375)
        }
        marginView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(kLineView.snp_bottom)
        }
    }
}


// MARK: - Update Data

extension SLSwapMarketDetailHeader {
    func updateHeader(_ itemModel: BTItemModel) {
        self.updatePrice(itemModel)
        self.kLineView.px_unit = Int(itemModel.precision)
        self.kLineView.qty_unit = (Int(itemModel.contractInfo.qty_unit.ch_length - 2) > 0) ? Int(itemModel.contractInfo.qty_unit.ch_length - 2) : 0
    }
    
    private func updatePrice(_ itemModel: BTItemModel) {
        self.priceLabel.text = (itemModel.last_px as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
        self.priceLabel.textColor = (itemModel.trend == .up) ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        let t = PublicInfoManager.sharedInstance.getCoinExchangeRate(itemModel.contractInfo.quote_coin)
        if let rmb = itemModel.last_px.multiplyingBy1(t.1, decimals: t.2) {
            self.otcPriceLabel.text = "≈\(t.0)" + rmb
        }
        self.changeAmountValue.text = (itemModel.change_value as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
        self.changeAmountValue.textColor = self.priceLabel.textColor
        self.fairPriceValue.text = (itemModel.fair_px as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
        self.indexPriceValue.text = (itemModel.index_px as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
        self.priceLimitValue.text = itemModel.change_rate.count > 0 ? (itemModel.change_rate as NSString).toPercentString(2) : "--"
        self.priceLimitValue.textColor = self.priceLabel.textColor
        if itemModel.funding_rate != nil {
            
            self.fundRateValue.text = itemModel.funding_rate.count > 0 ? (itemModel.funding_rate as NSString).toPercentString(4) : "0"
        }
        
        self.volume24HValue.text = itemModel.qty24.count > 0 ? BTFormat.depthValue(fromNumberStr: itemModel.qty24) : "0"
    }
}


// MARK: - Click Events

extension SLSwapMarketDetailHeader {
    /// 进入资金费率界面
    @objc func enterFundRateVC() {
        self.enterFundRateVCCallBack?()
    }
    
    /// 切换k线时间间隔
    @objc func scaleAction() {
        if (scaleDrop.superview == nil) {
            self.dismissDropView()
            self.addSubview(scaleDrop)
            scaleDrop.scaleDidChage = {[weak self] key in
                self?.scaleChangeControl.setTitle(content: key.localized())
                self?.kLineView.chartSerieSwitchToLineMode(on: (key == EXKlineWsVm.keyLine))
                self?.dismissDropView()
                self?.scalePublish.onNext(key)
            }
            
            scaleChangeControl.isChecked = true
            scaleDrop.snp.makeConstraints { (make) in
                make.top.equalTo(kLineView.snp.top)
                make.left.equalTo(kLineView.snp.left)
                make.right.equalTo(kLineView.snp.right)
                make.height.equalTo(EXScaleDropView.getHeight())
            }
        } else {
            self.dismissDropView()
        }
    }
    
    /// 切换k线指标
    @objc func indexAction() {
        if (algorithmDrop.superview == nil) {
            self.dismissDropView()
            self.addSubview(algorithmDrop)
            indexChangeControl.isChecked = true
            algorithmDrop.masterTypeChange = {[weak self] type in
                self?.masterType.onNext(type)
                self?.kLineView.updateMasterAlgorithm(to: type)
            }
            algorithmDrop.assistantTypeChange = {[weak self] type in
                self?.assistantType.onNext(type)
                self?.kLineView.updateAssistantAlgorithm(to: type)
            }
            algorithmDrop.snp.makeConstraints { (make) in
                make.top.equalTo(kLineView.snp.top)
                make.left.equalTo(kLineView.snp.left)
                make.right.equalTo(kLineView.snp.right)
                make.height.equalTo(122)
            }
        } else {
            self.dismissDropView()
        }
    }
    
    /// 进入全屏
    @objc func fullScreenAction() {
        self.enterFullScreenCallBack?()
    }
    
    func dismissDropView() {
        scaleChangeControl.isChecked = false
        indexChangeControl.isChecked = false
        scaleDrop.removeFromSuperview()
        algorithmDrop.removeFromSuperview()
    }
}


