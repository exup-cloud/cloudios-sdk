//
//  SLTransactionDepthCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 详情页 - 深度列表
class SLTransactionDepthCell: UITableViewCell {

    /// 买盘数量
    lazy var buyNumLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 买价格
    lazy var buyPriceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .right)
    
    /// 卖价格
    lazy var sellPriceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.down, alignment: .left)
    
    /// 卖盘数量
    lazy var sellNumLabel : UILabel = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
    
    /// 买背景
    lazy var buyBackV: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemekLine.up
        view.alpha = 0.15
        return view
    }()
    
    /// 卖背景
    lazy var sellBackV: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemekLine.down
        view.alpha = 0.15
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubViews([buyNumLabel, buyPriceLabel, sellPriceLabel, sellNumLabel, buyBackV, sellBackV])
        
        self.extSetCell()
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        buyNumLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        buyPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.centerX).offset(-5)
            make.centerY.equalTo(buyNumLabel)
            make.height.equalTo(13)
        }
        sellPriceLabel.snp.makeConstraints { (make ) in
            make.left.equalTo(contentView.snp.centerX).offset(5)
            make.centerY.equalTo(buyNumLabel)
            make.height.equalTo(13)
        }
        sellNumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.height.equalTo(buyNumLabel)
        }
        buyBackV.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.centerX)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(0)
        }
        sellBackV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.centerX)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(0)
        }
    }
}


// MARK: - Update Data

extension SLTransactionDepthCell {
    /// 数据更新
    func updateCell(buyModel: SLOrderBookModel?, sellModel: SLOrderBookModel?, maxVol: Double) {
        var buyPriceStr: String = "--"
        var buyVolStr: String = "--"
        var buysWidth: Double = 0.0
        if let _buyModel = buyModel {
            buyPriceStr = _buyModel.px
            buyVolStr = _buyModel.qty.elementsEqual("0") ? "--" : _buyModel.qty
            buysWidth = BasicParameter.handleDouble(_buyModel.qty) / maxVol * Double(SCREEN_WIDTH / 2)
        }
        self.buyPriceLabel.text = buyPriceStr
        self.buyNumLabel.text = buyVolStr
        buyBackV.snp.updateConstraints { (make) in
            make.width.equalTo(buysWidth)
        }
        
        var sellPriceStr: String = "--"
        var sellVolStr: String = "--"
        var sellsWidth: Double = 0.0
        if let _sellModel = sellModel {
            sellPriceStr = _sellModel.px
            sellVolStr = _sellModel.qty.elementsEqual("0") ? "--" : _sellModel.qty
            sellsWidth = BasicParameter.handleDouble(_sellModel.qty) / maxVol * Double(SCREEN_WIDTH / 2)
        }
        self.sellPriceLabel.text = sellPriceStr
        self.sellNumLabel.text = sellVolStr
        sellBackV.snp.updateConstraints { (make) in
            make.width.equalTo(sellsWidth)
        }
    }
}
