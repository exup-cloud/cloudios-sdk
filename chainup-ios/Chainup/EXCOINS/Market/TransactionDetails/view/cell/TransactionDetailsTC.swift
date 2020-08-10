//
//  TransactionDetailsTC.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/27.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class TransactionDetailsTC: UITableViewCell {

    //时间label
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 12)
        label.text = "--"
        return label
    }()
    
    //数量
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 12)
        label.layoutIfNeeded()
        label.textAlignment = .right
        label.text = "--"
        return label
    }()
    
    //价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 12)
        label.text = "--"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([timeLabel,numLabel,priceLabel])
        addConstraints()
    }
    
    func addConstraints() {
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }
        numLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setCellWithEntity(_ entity : TransacionEntity?){
        if let item = entity {
            timeLabel.text = item.time
            numLabel.text = item.vol
            priceLabel.text = item.price
            priceLabel.textColor = item.side == "BUY" ? UIColor.ThemekLine.up : UIColor.ThemekLine.down
        }else {
            timeLabel.text = "--"
            numLabel.text = "--"
            priceLabel.text = "--"
            priceLabel.textColor = UIColor.ThemeLabel.colorMedium
        }
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

class TransactionDetailsV : UIView{
    
    //时间label
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 11)
        label.text = LanguageTools.getString(key: "kline_text_dealTime")
        return label
    }()
    
    //价格
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 11)
        label.layoutIfNeeded()
        label.text = LanguageTools.getString(key: "contract_text_price")
        return label
    }()
    
    //数量
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 11)
        label.textAlignment = .right
        label.text = LanguageTools.getString(key: "charge_text_volume")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeView.bg
        addSubViews([timeLabel,priceLabel,numLabel])
        addConstraints()
    }
    
    func addConstraints() {
//        dealLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(10)
//            make.left.equalToSuperview().offset(10)
//        }
        
        let offsetX = (SCREEN_WIDTH - 20)/8
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(priceLabel.snp.left).offset(-10)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(-15)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        numLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(priceLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setView(_ buy : String , sell : String){
        
        priceLabel.text = priceLabel.text! + "(\(buy))"
        numLabel.text = numLabel.text! + "(\(sell))"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
