//
//  EXTriangleIndicator.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/21.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXTriangleIndicator: UIControl {
    
    var fillColor:UIColor = UIColor.ThemeView.bgIcon
    var highlight:UIColor = UIColor.ThemeView.highlight
    
    var textNormalColor:UIColor = UIColor.ThemeLabel.colorMedium
    var textHighLightColor:UIColor = UIColor.ThemeLabel.colorLite
    
    private var titleLabel :UILabel = UILabel.init()

    var triangleWidth :CGFloat = 6
    var triangleHeight :CGFloat = 6
    
    var isChecked:Bool = false {
        didSet {
            titleLabel.textColor = isChecked ? textHighLightColor : textNormalColor
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config(){
        self.backgroundColor = UIColor.clear
        self.addSubview(titleLabel)
        titleLabel.secondaryRegular()
        titleLabel.textAlignment = .left
        self.isChecked = false
        titleLabel.snp.makeConstraints { (make ) in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
    }
    
    func setTitle(content:String) {
        titleLabel.text = content
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        if isChecked {
            highlight .setFill()
        }else {
            fillColor .setFill()
        }
        let startX = rect.width
        let startY = rect.height
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: startX, y: startY - triangleHeight))
        path.addLine(to: CGPoint(x: startX - triangleWidth, y: startY))
        path.close()
        path.fill()
    }
}
