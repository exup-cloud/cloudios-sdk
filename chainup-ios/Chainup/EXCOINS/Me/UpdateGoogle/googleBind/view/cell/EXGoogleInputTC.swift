//
//  EXGoogleInputTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXGoogleInputTC: UITableViewCell {
    
    var entity = EXGoogleCellEntity()
    
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.BodyBoldTalic
        return label
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.layoutIfNeeded()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var pwInputV : EXTextField = {
        let inputV = EXTextField()
        inputV.extUseAutoLayout()
        inputV.enablePrivacyModel = true
        inputV.enableTitleModel = true
        inputV.setTitle(title: LanguageTools.getString(key: "register_text_loginPwd"))
        inputV.textfieldValueChangeBlock = {[weak self]str in
            self?.entity.info1 = str
        }
        return inputV
    }()
    
    lazy var googleCodeV : EXPasteField = {
        let inputV = EXPasteField()
        inputV.extUseAutoLayout()
        inputV.input.keyboardType = UIKeyboardType.numberPad
        inputV.showTitle = true
        inputV.setTitle(title: LanguageTools.getString(key: "safety_text_googleAuth"))
        inputV.textfieldValueChangeBlock = {[weak self]str in
            self?.entity.info2 = str
        }
        return inputV
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([numLabel,nameLabel,pwInputV,googleCodeV])
        numLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(numLabel.snp.right).offset(10)
            make.top.equalTo(numLabel)
            make.right.equalToSuperview().offset(-15)
        }
        
        pwInputV.snp.makeConstraints { (make) in
            make.height.equalTo(54)
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.bottom.equalTo(googleCodeV.snp.top).offset(-15)
        }
        
        googleCodeV.snp.makeConstraints { (make) in
            make.height.equalTo(54)
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(pwInputV.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : EXGoogleCellEntity){
        self.entity = entity
        numLabel.text = "\(entity.tag)."
        nameLabel.text = entity.name
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
