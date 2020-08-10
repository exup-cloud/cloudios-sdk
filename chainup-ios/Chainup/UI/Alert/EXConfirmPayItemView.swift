//
//  EXConfirmPayItemView.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/1.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXConfirmPayItemView: NibBaseView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    typealias AlertCallback = (Int) -> ()
    var alertCallback : AlertCallback?
    
}
