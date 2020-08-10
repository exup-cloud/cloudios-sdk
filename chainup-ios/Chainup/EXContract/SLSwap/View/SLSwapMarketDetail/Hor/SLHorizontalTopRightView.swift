//
//  SLHorizontalTopRightView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/12.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLHorizontalTopRightView: UIView {
    
    /// 合理价格
    private lazy var fairPriceLabel: UILabel = UILabel(text: "contract_text_fairPrice".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var fairPriceValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 指数价格
    private lazy var indexPriceLabel: UILabel = UILabel(text: "contract_text_indexPrice".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var indexPriceValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 资金费率
//    private lazy var fundRateLabel: UILabel = UILabel(text: "contract_fund_rate".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
//    private lazy var fundRateValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 24h量
    private lazy var volume24HLabel: UILabel = UILabel(text: "contract_market_detail_24h_volume".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    private lazy var volume24HValue: UILabel = UILabel(text: "-", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([fairPriceLabel, fairPriceValue, indexPriceLabel, indexPriceValue, volume24HLabel, volume24HValue])
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        self.volume24HValue.snp_makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }
        self.volume24HLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.volume24HValue.snp_left).offset(-5)
            make.centerY.equalToSuperview()
        }
//        self.fundRateValue.snp_makeConstraints { (make) in
//            make.right.equalTo(self.volume24HLabel.snp_left).offset(-10)
//            make.centerY.equalToSuperview()
//        }
//        self.fundRateLabel.snp_makeConstraints { (make) in
//            make.right.equalTo(self.fundRateValue.snp_left).offset(-5)
//            make.centerY.equalToSuperview()
//        }
        self.indexPriceValue.snp_makeConstraints { (make) in
            make.right.equalTo(self.volume24HLabel.snp_left).offset(-10)
            make.centerY.equalToSuperview()
        }
        self.indexPriceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.indexPriceValue.snp_left).offset(-5)
            make.centerY.equalToSuperview()
        }
        self.fairPriceValue.snp_makeConstraints { (make) in
            make.right.equalTo(self.indexPriceLabel.snp_left).offset(-10)
            make.centerY.equalToSuperview()
        }
        self.fairPriceLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.fairPriceValue.snp_left).offset(-5)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    
    // MARK: - Update
    
    /// 重载之前的更新方法
    func updatePrices(itemModel: BTItemModel) {
        self.fairPriceValue.text = (itemModel.fair_px as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
        self.indexPriceValue.text = (itemModel.index_px as NSString).toSmallPrice(withContractID: itemModel.instrument_id)
//        self.fundRateValue.text = itemModel.funding_rate.count > 0 ? (itemModel.funding_rate as NSString).toPercentString(4) : "0"
        self.volume24HValue.text = itemModel.qty24.count > 0 ? BTFormat.depthValue(fromNumberStr: itemModel.qty24) : "0"
    }
}
