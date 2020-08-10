//
//  SLTransactionRecordCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 详情页 - 成交记录列表
class SLTransactionRecordCell: UITableViewCell {

    /// 时间
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 12)
        label.text = "--"
        return label
    }()
    
    /// 数量
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 12)
        label.layoutIfNeeded()
        label.textAlignment = .right
        label.text = "--"
        return label
    }()
    
    /// 价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorMedium, fontSize: 12)
        label.text = "--"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([timeLabel, numLabel, priceLabel])
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initLayout() {
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
            make.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(timeLabel)
            make.centerY.equalTo(timeLabel)
        }
        numLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.height.equalTo(timeLabel)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    /// 数据更新
    func updateCell(_ model: SLTransactionRecordModel?) {
        if let _model = model {
            self.timeLabel.text = _model.time
            self.priceLabel.text = _model.price
            self.numLabel.text = _model.vol
            
            if _model.side == .buy {
                self.priceLabel.textColor = UIColor.ThemekLine.up
            } else {
                self.priceLabel.textColor = UIColor.ThemekLine.down
            }
            
        } else {
            self.timeLabel.text = "--"
            self.priceLabel.text = "--"
            self.numLabel.text = "--"
        }
    }
}


/// 详情页 - 成交记录列表顶部标题
class SLTransactionRecordTitleCell: UITableViewCell {
    
    private lazy var leftLabel: UILabel = UILabel(text: "kline_text_dealTime".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    private lazy var middleLabel: UILabel = UILabel(text: "contract_text_price".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
    
    private lazy var rightLabel: UILabel = UILabel(text: "charge_text_volume".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([leftLabel, middleLabel, rightLabel])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        leftLabel.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        middleLabel.snp_makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        rightLabel.snp_makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
    }
}


enum SLTransactionRecordType {
    case buy
    case sell
}

class SLTransactionRecordModel: NSObject {
    var time = "--"
    
    var price = "--"
    
    var vol = "--"
    
    var side: SLTransactionRecordType = .buy
}
