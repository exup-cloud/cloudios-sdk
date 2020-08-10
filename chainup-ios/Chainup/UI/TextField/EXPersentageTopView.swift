//
//  EXPersentageTopView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXPersentageTopView: UIView {
    
    var highlightMode :Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners:[.topRight, .topLeft],
            cornerRadii: CGSize(width: 2, height: 2))
        path.lineWidth = 0.5
        if highlightMode {
            UIColor.ThemeView.highlight .setStroke()
        }else {
            UIColor.ThemeView.border .setStroke()
        }
        path.stroke()
    }

}
