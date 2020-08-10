//
//  EXFourColumnView.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/29.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXFourColumnView: NibBaseView {
    
    @IBOutlet var fourColumnTitles: [UILabel]!
    @IBOutlet var forColumnValues: [UILabel]!
    
    override func onCreate() {
        
    }
    
    func bindItems(_ models:[ExThreeColumnDataModel]) {
        if models.count == 4 {
    
            for(idx,model) in models.enumerated() {
                let titleLabel = fourColumnTitles[idx]
                titleLabel.font = model.style.topLabelFont
                titleLabel.textColor = model.style.topLabelColor
                titleLabel.text = model.title

                let detailLabel = forColumnValues[idx]
                detailLabel.font = model.style.bottomLabelFont
                detailLabel.textColor = model.style.bottomLabelColor
                detailLabel.text = model.content
                
                switch model.aliment {
                case .left:
                    titleLabel.textAlignment = .left
                    detailLabel.textAlignment = .left
                case .center:
                    titleLabel.textAlignment = .left
                    detailLabel.textAlignment = .left
                case .right:
                    titleLabel.textAlignment = .right
                    detailLabel.textAlignment = .right
                }
                
            }
        }
    }
}
