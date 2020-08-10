//
//  EXJournalDetailHeader.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXJournalDetailHeader: UIView {
    var headerTitle: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHeaderTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configHeaderTitle()
    }
    
    func configHeaderTitle() {
        self.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
        self.backgroundColor = UIColor.ThemeView.bg
        headerTitle.textColor = UIColor.ThemeLabel.colorLite
        headerTitle.font = UIFont.ThemeFont.HeadBold
    }

}
