//
//  SLLabel+Extension.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

extension UILabel {
    convenience init(title: String,
                     fontSize: CGFloat = 14,
                     color: UIColor = UIColor.darkGray,
                     screenInset: CGFloat = 0) {
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        if screenInset == 0 {
            textAlignment = .center
        } else {
            // 设置换行宽度
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset
            textAlignment = .left
        }
        sizeToFit()
    }
}
