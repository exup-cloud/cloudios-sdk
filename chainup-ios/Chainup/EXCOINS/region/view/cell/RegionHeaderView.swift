//
//  RegionHeaderView.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/17.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class RegionHeaderView: UITableViewHeaderFooterView {
    
    //名字
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.extUseAutoLayout()
        nameLabel.headRegular()
        nameLabel.textColor = UIColor.ThemeLabel.colorLite
        return nameLabel
    }()
    
    lazy var backView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.bgGap
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.ThemeView.bg
        contentView.addSubViews([backView,nameLabel])
        backView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(11)
        }
    }
    
    func setCellLabel(_ str : String){
        nameLabel.text = str
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
