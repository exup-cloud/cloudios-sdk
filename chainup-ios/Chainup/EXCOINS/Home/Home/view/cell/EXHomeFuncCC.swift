//
//  EXHomeFuncCC.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//  功能

import UIKit
import YYWebImage

class EXHomeFuncCC: UICollectionViewCell {
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        contentView.addSubViews([imgV,nameLabel])
        imgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(32)
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(imgV.snp.bottom).offset(5)
        }
    }
    
    func setCell(_ entity : HomeFunctionEntity){
        imgV.isHidden = entity.type == ""
        nameLabel.isHidden = imgV.isHidden
        if entity.type != ""{
            imgV.yy_setImage(with: URL.init(string: entity.imageUrl), options: YYWebImageOptions.allowBackgroundTask)
            nameLabel.text = entity.title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
