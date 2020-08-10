//
//  EXRealNameThreeView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/29.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameThreeView: UIView {
    
    lazy var popbackBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "quotes_delete"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickBtn))
        return btn
    }()
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "personal_successfulhints")
        return imgV
    }()

    lazy var submitLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = LanguageTools.getString(key: "common_tip_cerSubmitSuccess")
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.H3Bold
        label.textAlignment = .center
        return label
    }()
    
    lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = LanguageTools.getString(key: "common_tip_cerSubmitDesc")
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.layoutIfNeeded()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([popbackBtn,imgV,submitLabel,detailLabel])
        popbackBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NAV_STATUS_HEIGHT + 17)
            make.width.height.equalTo(16)
            make.left.equalToSuperview().offset(15)
        }
        imgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(123)
            make.height.width.equalTo(66)
            make.centerX.equalToSuperview()
        }
        submitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(submitLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(49)
            make.right.equalToSuperview().offset(-49)
        }
    }
    
    @objc func clickBtn(){
        self.yy_viewController?.popBack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
