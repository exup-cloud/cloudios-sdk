//
//  EXSetTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/25.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSetTC: UITableViewCell {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadRegular
        return label
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var rightBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "enter"), for: UIControlState.normal)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([nameLabel,lineV,rightLabel,rightBtn])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(rightLabel.snp.left).offset(-10)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.height.equalTo(0.5)
            make.bottom.right.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(rightBtn.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(17)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(10)
            make.width.equalTo(7)
            make.centerY.equalToSuperview()
        }
    }
    
    func setCell(_ entity : EXSetEntity){
        
        nameLabel.text = entity.name
        rightLabel.text = entity.rightName
        
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
