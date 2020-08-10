//
//  EXSecurityTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSecurityTC: UITableViewCell {
    
    var entity = EXSecurityEntity()
    
    typealias OnValueChangeCallback = (Bool , EXSecurityEntity) -> ()
    var onValueChangeCallback : OnValueChangeCallback?
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadRegular
        label.textColor = UIColor.ThemeLabel.colorLite
        return label
    }()

    lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        return label
    }()
    
    lazy var rightBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "enter"), for: UIControlState.normal)
        return btn
    }()
    
    lazy var switchV : EXSwitch = {
        let view = EXSwitch()
        view.extUseAutoLayout()
        view.layoutIfNeeded()
        view.onValueChangeCallback = {[weak self] b in
            guard let mySelf = self else{return}
            mySelf.onValueChangeCallback?(b , mySelf.entity)
        }
        return view
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
        contentView.addSubViews([nameLabel,infoLabel,rightBtn,switchV,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightBtn.snp.left).offset(-5)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(200)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(8.5)
        }
        switchV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        lineV.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(0.5)
        }
    }
    
    func setCell(_ entity : EXSecurityEntity){
        self.entity = entity
        infoLabel.isHidden = entity.info == ""
        switchV.isHidden = !infoLabel.isHidden
        
        nameLabel.text = entity.name
        infoLabel.text = entity.info
        switchV.setOn(isOn: entity.switchOn)
        
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
