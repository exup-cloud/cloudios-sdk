//
//  SLSwapFundRateCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/5.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLSwapFundRateCell: UITableViewCell {

    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.isHidden = true
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        return label
    }()
    
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
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(150)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        self.middleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.lessThanOrEqualTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
