//
//  EXThreeColumnView.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/4.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum EXColumnAlignment {
    case left
    case right
    case center
}

class ExThreeColumnDataModel:NSObject {
    var title:String = ""
    var content:String = ""
    var style:ExThreeColumnStyle = ExThreeColumnStyle()
    var aliment :EXColumnAlignment = .left
    var iconStatus:Bool = false
}


class ExThreeColumnStyle:NSObject {
    var topLabelFont:UIFont = UIFont.ThemeFont.MinimumRegular
    var topLabelColor:UIColor = UIColor.ThemeLabel.colorDark
    var bottomLabelFont:UIFont = UIFont.ThemeFont.BodyRegular
    var bottomLabelColor:UIColor = UIColor.ThemeLabel.colorMedium
}

class EXThreeColumnView: NibBaseView {

    @IBOutlet var titleLeft: UILabel!
    @IBOutlet var bottomLeft: UILabel!
    @IBOutlet var titleMiddle: UILabel!
    @IBOutlet var bottomMiddle: UILabel!
    @IBOutlet var titleRight: UILabel!
    @IBOutlet var bottomRight: UILabel!
    @IBOutlet var middleView: UIView!
    @IBOutlet var middleBgView: UIView!
    @IBOutlet var rightBgView: UIView!
    
    override func onCreate() {
        
    }
    
    func configStyle(with title:UILabel,bottom:UILabel,style:ExThreeColumnStyle ) {
        title.font = style.topLabelFont
        title.textColor = style.topLabelColor
        bottom.font = style.bottomLabelFont
        bottom.textColor = style.bottomLabelColor
    }
    
    func bindItems(with models:[ExThreeColumnDataModel],ignoreModelCount:Bool = true) {
        if models.count <= 0 || models.count > 3 {
            return
        }
        //忽略个数,默认就是3个
        if ignoreModelCount  {
            for(idx,model) in models.enumerated() {
                if idx == 0 {
                    titleLeft.text = model.title
                    bottomLeft.text = model.content
                    self.configStyle(with: titleLeft, bottom: bottomLeft, style: model.style)
                }else if idx == 1 {
                    titleMiddle.text = model.title
                    bottomMiddle.text = model.content
                    titleMiddle.textAlignment = .left
                    bottomMiddle.textAlignment = .left
                    self.configStyle(with: titleMiddle, bottom: bottomMiddle, style: model.style)
                }else if idx == 2 {
                    titleRight.text = model.title
                    bottomRight.text = model.content
                    self.configStyle(with: titleRight, bottom: bottomRight, style: model.style)
                }
            }
        }
        else {
            if models.count == 1 {
                middleBgView.isHidden = true
                rightBgView.isHidden = true
                let modelA = models[0]
                titleLeft.text = modelA.title
                bottomLeft.text = modelA.content
                self.configStyle(with: titleLeft, bottom: bottomLeft, style: modelA.style)
            }else if models.count == 2 {
                middleBgView.isHidden = true
                for(idx,model) in models.enumerated() {
                    if idx == 0 {
                        titleLeft.text = model.title
                        bottomLeft.text = model.content
                        self.configStyle(with: titleLeft, bottom: bottomLeft, style: model.style)
                    }else if idx == 1 {
                        titleRight.text = model.title
                        bottomRight.text = model.content
                        self.configStyle(with: titleRight, bottom: bottomRight, style: model.style)
                    }
                }
            }else {
                for(idx,model) in models.enumerated() {
                    if idx == 0 {
                        titleLeft.text = model.title
                        bottomLeft.text = model.content
                        self.configStyle(with: titleLeft, bottom: bottomLeft, style: model.style)
                    }else if idx == 1 {
                        titleMiddle.text = model.title
                        bottomMiddle.text = model.content
                        titleMiddle.textAlignment = .left
                        bottomMiddle.textAlignment = .left
                        self.configStyle(with: titleMiddle, bottom: bottomMiddle, style: model.style)
                    }else if idx == 2 {
                        titleRight.text = model.title
                        bottomRight.text = model.content
                        self.configStyle(with: titleRight, bottom: bottomRight, style: model.style)
                    }
                }
            }
        }
    }
}
