//
//  EXSideBySideLabel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/13.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSideBySideLabel: NibBaseView {

    @IBOutlet var leftSideLabel: UILabel!
    @IBOutlet var rightSideLabel: UILabel!
    
    override func onCreate() {
        self.backgroundColor = UIColor.ThemeNav.bg
        leftSideLabel.minimumRegular()
        rightSideLabel.minimumRegular()
    }
    
}
