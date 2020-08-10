//
//  SLSwapDrawerViewTC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

class SLSwapDrawerViewTC: UITableViewCell {
    
    var entity = BTItemModel()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.ThemeFont.HeadBold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = "--"
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var multipleLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.layoutIfNeeded()
        label.textColor = UIColor.ThemeLabel.colorHighlight
        label.font = UIFont.ThemeFont.MinimumRegular
        label.backgroundColor = UIColor.ThemeLabel.colorHighlight.withAlphaComponent(0.15)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([nameLabel,priceLabel,multipleLabel,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(19)
        }
        multipleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.height.equalTo(14)
            make.centerY.equalTo(nameLabel)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
        lineV.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func setCell(_ itemModel : BTItemModel , showMultiple : Bool = false){
        nameLabel.text = itemModel.name
        priceLabel.text = itemModel.change_rate.toPercentString(2)
        if entity.trend == BTPriceFluctuationType.up {
            priceLabel.textColor = UIColor.ThemekLine.up
        } else {
            priceLabel.textColor = UIColor.ThemekLine.down
        }
        
        self.entity = itemModel
        multipleLabel.isHidden = !showMultiple
        multipleLabel.text = " 3X "
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
