//
//  EXChangeHostTableViewCell.swift
//  Chainup
//
//  Created by chainup on 2020/6/16.
//  Copyright © 2020 ChainUP. All rights reserved.
//

import UIKit

class EXChangeHostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    lazy var hintView : UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.ThemeState.warning
        v.layer.cornerRadius = 3
        return v
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        
        hintView.isHidden = true
        
        contentView.addSubViews([nameLabel,statusLabel,hintView,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        hintView.snp.makeConstraints { (make) in
            make.trailing.equalTo(statusLabel.snp_leading).offset(-4)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(150)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func setCell(_ name : String, status: String, isHint:Bool){
        nameLabel.text = name
        statusLabel.text = status
        hintView.isHidden = !isHint
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
