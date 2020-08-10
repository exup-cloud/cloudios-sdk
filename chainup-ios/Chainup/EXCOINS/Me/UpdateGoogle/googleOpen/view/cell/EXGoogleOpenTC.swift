//
//  EXGoogleOpenTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXGoogleOpenTC: UITableViewCell {
    
    typealias OnValueChangeCallback = (Bool) -> ()
    var valueChangeCallback : OnValueChangeCallback?
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = LanguageTools.getString(key: "common_action_activeGoogle")
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    lazy var switchV : EXSwitch = {
        let view = EXSwitch()
        view.extUseAutoLayout()
        view.setOn(isOn: true)
        view.layoutIfNeeded()
        view.onValueChangeCallback = {[weak self]b in
            self?.valueChangeCallback?(b)
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
        contentView.addSubViews([nameLabel,switchV,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(switchV.snp.left).offset(-10)
            make.height.equalTo(20)
        }
        switchV.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(36)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        lineV.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(0.5)
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
