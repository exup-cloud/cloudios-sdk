//
//  EXTwoByTwoView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXTwoByTwoView: NibBaseView {
    @IBOutlet var leftTopLabel: UILabel!
    @IBOutlet var leftBottomLabel: UILabel!
    @IBOutlet var rightTopLabel: UILabel!
    @IBOutlet var rightBottomLabel: UILabel!

    override func onCreate() {
        
    }
    
    func bindModel(_ model:EXTwoByTwoItemModel) {
        leftTopLabel.text = model.ltitle
        leftBottomLabel.text = model.lcontent
        rightTopLabel.text = model.rtitle
        rightBottomLabel.text = model.rcontent
        leftTopLabel.textColor = model.ltitleColor
        leftBottomLabel.textColor = model.lcontentColor
        rightTopLabel.textColor = model.rtitleColor
        rightBottomLabel.textColor = model.rcontentColor
    }
    
    

}
