//
//  SLSwapFundRateHeader.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/5.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLSwapFundRateHeader: UIView {
    
    /// 币种名称
    private lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 总持仓量
    private lazy var holdingVolumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_all_position_holding".localized() + " (" + "contract_text_volumeUnit".localized() + ")")
        return view
    }()
    
    /// 成交量
    private lazy var dealVolumeView : SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.topLabel.textAlignment = .center
        view.bottomLabel.textAlignment = .center
        view.setTopText("kline_text_volume".localized() + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
    /// 换手比
    private lazy var turnoverView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.topLabel.textAlignment = .right
        view.bottomLabel.textAlignment = .right
        view.setTopText("contract_fund_rate_turnover".localized())
        return view
    }()
    
    private lazy var marginView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    /// 行情变动信息
    private lazy var marketInfoLabel: UILabel = {
        let label = UILabel(text: "contract_fund_rate_market_info".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    private lazy var marginLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    /// 日内波动信息
    private lazy var dayMarketInfoView: SLMarketInfoView = {
        let view = SLMarketInfoView(title: "contract_fund_market_change_interval_day".localized())
        view.extUseAutoLayout()
        return view
    }()
    
    /// 30日内波动信息
    private lazy var thirtyDaysMarketInfoView: SLMarketInfoView = {
        let view = SLMarketInfoView(title: "contract_fund_market_change_interval_30_days".localized())
        view.extUseAutoLayout()
        return view
    }()
 
    private lazy var marginView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([nameLabel, holdingVolumeView, dealVolumeView, turnoverView, marginView1, marketInfoLabel, marginLine, dayMarketInfoView, thirtyDaysMarketInfoView, marginView2])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin = 15
        self.nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(horMargin)
            make.height.equalTo(19)
        }
        self.holdingVolumeView.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(self.nameLabel.snp_bottom).offset(15)
            make.height.equalTo(36)
        }
        self.dealVolumeView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.holdingVolumeView)
            make.height.equalTo(self.holdingVolumeView)
            make.width.equalTo(holdingVolumeView.snp_width)
        }
        self.turnoverView.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.top.equalTo(self.holdingVolumeView)
            make.height.equalTo(self.holdingVolumeView)
            make.width.equalTo(holdingVolumeView.snp_width)
        }
        self.marginView1.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(self.holdingVolumeView.snp_bottom).offset(15)
        }
        self.marketInfoLabel.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(self.marginView1.snp_bottom).offset(13)
            make.height.equalTo(20)
        }
        self.marginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(self.marketInfoLabel.snp_bottom).offset(13)
        }
        self.dayMarketInfoView.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin);
            make.right.equalTo(-horMargin);
            make.top.equalTo(self.marginLine.snp_bottom).offset(13)
            make.height.equalTo(60)
        }
        self.thirtyDaysMarketInfoView.snp_makeConstraints { (make) in
            make.left.equalTo(dayMarketInfoView);
            make.right.equalTo(dayMarketInfoView);
            make.top.equalTo(dayMarketInfoView.snp_bottom).offset(20)
            make.height.equalTo(dayMarketInfoView)
        }
        self.marginView2.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(self.thirtyDaysMarketInfoView.snp_bottom).offset(15)
        }
    }
    
    func updateView(itemModel: BTItemModel) {
        self.nameLabel.text = itemModel.name
        let position = (itemModel.position_size as NSString).toSmallVolume(withContractID: itemModel.instrument_id) ?? "--"
        self.holdingVolumeView.setBottomText(position)
        let volume = BTFormat.totalVolume(fromNumberStr: (itemModel.qty24 as NSString).toSmallVolume(withContractID: itemModel.instrument_id)) ?? "--"
        self.dealVolumeView.setBottomText(volume)
        let turnover = (((itemModel.qty24 as NSString).bigDiv(itemModel.position_size) as NSString)).toSmallVolume(withContractID: itemModel.instrument_id) ?? "--"
        self.turnoverView.setBottomText(turnover)
        
        self.dayMarketInfoView.updateNewPrice(openPrice: itemModel.open, newPrice: itemModel.last_px, minPrice: itemModel.low, maxPrice: itemModel.high)
    }
    
    func updateThirtyDaysInfo(itemModel: BTItemModel) {
        self.thirtyDaysMarketInfoView.updateNewPrice(openPrice: itemModel.open, newPrice: itemModel.last_px, minPrice: itemModel.low, maxPrice: itemModel.high)
    }
}


/// 行情变动信息
class SLMarketInfoView: UIView {
    /// 日内最新价格
    private lazy var newPriceView: UIView = {
        let view = UIView()
        let label = UILabel(text: "contract_fund_rate_new".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        let imageView = UIImageView()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 5, y: 7))
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.ThemeLabel.colorMedium.cgColor
        layer.path = path.cgPath
        imageView.layer.addSublayer(layer)
        view.addSubViews([label, imageView])
        label.snp_makeConstraints { (make) in
            make.left.top.right.width.equalToSuperview()
        }
        imageView.snp_makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(7)
            make.top.equalTo(label.snp_bottom).offset(3)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeLabel.colorHighlight
        return view
    }()
    
    private lazy var minPriceLabel: UILabel = {
        let label = UILabel(text: "contract_fund_rate_min".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    private lazy var maxPriceLabel: UILabel = {
        let label = UILabel(text: "contract_fund_rate_max".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(text: "contract_fund_market_change_interval_day".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([newPriceView, lineView, coverView, minPriceLabel, maxPriceLabel, titleLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        
        self.titleLabel.text = title
    }
    
    func updateNewPrice(openPrice: String, newPrice: String, minPrice: String, maxPrice: String) {
        var minPrice = minPrice
        if (BasicParameter.handleDouble(openPrice) < BasicParameter.handleDouble(minPrice)) {
            minPrice = openPrice
        }
        
        if (BasicParameter.handleDouble(maxPrice) <= BasicParameter.handleDouble(minPrice)) {
            self.newPriceView.snp_updateConstraints { (make) in
                make.centerX.equalTo(100)
            }
            return
        }
        
        if let label = (self.newPriceView.subviews.first as? UILabel) {
            label.text = "\("contract_fund_rate_new".localized())\(newPrice)"
        }
        
        self.minPriceLabel.text = "\("contract_fund_rate_min".localized())\(minPrice)"
        self.maxPriceLabel.text = "\("contract_fund_rate_max".localized())\(maxPrice)"
        
        let openX = (BasicParameter.handleDouble(openPrice) - BasicParameter.handleDouble(minPrice)) / (BasicParameter.handleDouble(maxPrice) - BasicParameter.handleDouble(minPrice)) * Double(SCREEN_WIDTH - 30)
        let newX = (BasicParameter.handleDouble(newPrice) - BasicParameter.handleDouble(minPrice)) / (BasicParameter.handleDouble(maxPrice) - BasicParameter.handleDouble(minPrice)) * Double(SCREEN_WIDTH - 30)
        self.coverView.snp_updateConstraints { (make) in
            make.left.equalTo(openX)
            make.width.equalTo(newX - openX)
        }
        
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        if newX < Double(self.newPriceView.width / 2 - 5) {
            self.newPriceView.subviews.first?.snp_updateConstraints({ (make) in
                make.left.equalTo(Double(self.newPriceView.width / 2 - 5) - newX)
            })
        } else if newX > Double(self.width - self.newPriceView.width / 2 + 5) {
            self.newPriceView.subviews.first?.snp_updateConstraints({ (make) in
                make.left.equalTo(Double(self.width - self.newPriceView.width / 2 + 5) - newX)
            })
        }
        
        self.newPriceView.snp_updateConstraints { (make) in
            make.centerX.equalTo(newX)
        }
    }
    
    private func initLayout() {
        self.newPriceView.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(0)
        }
        self.lineView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.newPriceView.snp_bottom).offset(7)
            make.height.equalTo(5)
        }
        self.coverView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(0)
            make.height.top.equalTo(self.lineView)
        }
        self.minPriceLabel.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.lineView.snp_bottom).offset(10)
        }
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.minPriceLabel)
            make.centerX.equalToSuperview()
        }
        self.maxPriceLabel.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.minPriceLabel)
            make.right.equalToSuperview()
        }
    }
}
