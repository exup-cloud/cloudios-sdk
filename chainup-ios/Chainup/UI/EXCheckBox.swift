//
//  EXCheckBox.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@IBDesignable

class EXCheckBox: UIControl {
    
    var checkEnabled:Bool = true
    var isChecked:Bool = false
    var text:String = ""
    var checkIcon:UIImageView = UIImageView()
    var fillColor:UIColor = UIColor.clear
    var borderColor:UIColor = UIColor.ThemeView.border
    var checkColor :UIColor = UIColor.ThemeView.highlight
    var checkLabel :UILabel = UILabel.init()
    let checkBoxLineWidth:CGFloat = 2

    
    typealias CheckBoxValueChanged = (Bool) -> ()
    var checkCallback : CheckBoxValueChanged?
    
    func checked(check:Bool){
        isChecked = check
        checkIcon.image = UIImage.themeImageNamed(imageName: check ? "fiat_selected" : "fiat_unchecked")
//        self.setNeedsDisplay()
        sendActions(for: .valueChanged)
    }
    
    func enabled(enable:Bool = true) {
        
    }
    
    func text(content:String) {
        checkLabel.text = content
        self.setNeedsDisplay()
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
        self.addSubview(checkLabel)
        self.addSubview(checkIcon)
        checkIcon.image = UIImage.themeImageNamed(imageName: "fiat_unchecked")
        checkLabel.bodyRegular()
        checkLabel.textColor = UIColor.ThemeLabel.colorMedium
        checkLabel.snp.makeConstraints { (make ) in
            make.left.equalTo(20)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
        
        checkIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self .checked(check: !isChecked)
        checkCallback?(self.isChecked)
        sendActions(for: .valueChanged)
        return true
    }
    
    override func draw(_ rect: CGRect) {
//        fillColor .setFill()
//        borderColor .setStroke()
//        let width:CGFloat = 10
//        let boxBezier = UIBezierPath.init(roundedRect: CGRect(x: checkBoxLineWidth, y:(rect.height - width)/2, width: width, height: width), cornerRadius: 1.5)
//        boxBezier.lineWidth = checkBoxLineWidth
//        boxBezier .fill()
//        boxBezier .stroke()
//        if isChecked {
//            UIColor.ThemeView.highlight.setFill()
//            let checkBezier = UIBezierPath.init(rect: CGRect(x: 4, y: (rect.height - 6)/2, width: 6, height: 6))
//            checkBezier.fill()
//        }
    }
}


extension Reactive where Base: EXCheckBox {
    var checkState: ControlProperty<Bool> {
        return base.rx.controlProperty(editingEvents: UIControlEvents.valueChanged,
                                       getter: { customView in
                                        return  customView.isChecked},
                                       setter: { (customView, newValue) in
                                        customView.isChecked = newValue})
    }
    
}
