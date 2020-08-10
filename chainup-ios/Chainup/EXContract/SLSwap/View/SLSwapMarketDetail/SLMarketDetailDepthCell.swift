//
//  SLMarketDetailDepthCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 详情页中的深度数据 cell
class SLMarketDetailDepthCell: UITableViewCell {
    
    lazy var depthView: SLKLineDepthView = {
        let view = SLKLineDepthView()
        return view
    }()
    
    private lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    private lazy var leftTitle: UILabel = UILabel(text: "charge_text_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    private lazy var middleTitle: UILabel = UILabel(text: "contract_text_price".localized() + "(USDT)", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    private lazy var rightTitle: UILabel = UILabel(text: "charge_text_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.extSetCell()
        
        self.titleBar.addSubViews([topLineView, leftTitle, middleTitle, rightTitle])
        
        self.contentView.addSubViews([depthView, titleBar])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        depthView.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(titleBar.snp_top)
        }
        titleBar.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        topLineView.snp_remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        leftTitle.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        middleTitle.snp_makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        rightTitle.snp_makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
}
