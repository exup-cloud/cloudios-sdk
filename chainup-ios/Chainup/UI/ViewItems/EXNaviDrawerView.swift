//
//  EXNaviDrawerView.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXNaviDrawerView: NibBaseView {
    @IBOutlet var verticalLine: UIView!
    @IBOutlet var iconBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tapBtn: UIButton!
    lazy var tagView :EXTagView = {
        let view = EXTagView.commonTagView()
        view.isHidden = true
        return view
    }()
    
    override func onCreate() {
        iconBtn.setImage(UIImage.themeImageNamed(imageName: "exchange_sidepull"), for: .normal)
        titleLabel.font = UIFont.ThemeFont.H3Bold
        titleLabel.textColor = UIColor.ThemeLabel.colorLite
        self.addSubview(tagView)
    }
    
    func showTag(_ originTitle:String) {
        let symbol = PublicInfoManager.sharedInstance.getCoinMapLeft(originTitle)
        let marketTag = PublicInfoManager.sharedInstance.getCoinMarketTag(symbol)
        if marketTag.isEmpty {
            tagView.isHidden = true
        }else {
            tagView.isHidden = false
            tagView.setTitle(marketTag, for: .normal)
            let tagWidth = tagView.commonTagWidth(titleStr: marketTag)
            tagView.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp_right).offset(5)
                make.top.equalTo(titleLabel.snp_top).offset(-5)
                make.width.equalTo(tagWidth)
            }
        }
    }
    
    func bind(_ title:String) {
        titleLabel.text = title
    }
    
}
