//
//  EXStepBg.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXStepBg: UIView {

    override func draw(_ rect: CGRect) {
        let height = rect.size.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.lineWidth = 1
        UIColor.ThemeView.border .setStroke()
        path.stroke()
    }
}
