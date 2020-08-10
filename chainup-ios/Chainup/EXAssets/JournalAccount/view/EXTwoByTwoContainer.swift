//
//  EXTwoByTwoContainer.swift
//  Chainup
//
//  Created by liuxuan on 2019/5/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXTwoByTwoItemModel:NSObject {
    var ltitle:String = ""
    var lcontent:String = ""
    var rtitle:String = ""
    var rcontent:String = ""
    
    var ltitleColor:UIColor = UIColor.ThemeLabel.colorDark
    var lcontentColor:UIColor = UIColor.ThemeLabel.colorMedium
    var rtitleColor:UIColor = UIColor.ThemeLabel.colorDark
    var rcontentColor:UIColor = UIColor.ThemeLabel.colorMedium
    var lcontentFont:UIFont = UIFont.ThemeFont.BodyBold
    var rcontentFont:UIFont = UIFont.ThemeFont.BodyBold

}

class EXTwoByTwoContainer: UIView {
    
    var containers:[EXTwoByTwoView] = []
    
    func bindContainers(_ items:[EXTwoByTwoItemModel] ) {
        if containers.count > 0 {
            for item in containers {
                item.removeFromSuperview()
            }
            containers.removeAll()
        }
        var lastItem:EXTwoByTwoView? = nil
        
        for (_,item) in items.enumerated() {
            let twoByTwoView = EXTwoByTwoView()
            twoByTwoView.backgroundColor = UIColor.ThemeView.bg
            twoByTwoView.leftBottomLabel.font = item.lcontentFont
            twoByTwoView.rightBottomLabel.font = item.rcontentFont

            twoByTwoView.bindModel(item)
            containers.append(twoByTwoView)
            self.addSubview(twoByTwoView)
            containers.append(twoByTwoView)
            if let lastView = lastItem {
                twoByTwoView.snp.makeConstraints { (make) in
                    make.top.equalTo(lastView.snp.bottom).offset(15)
                    make.width.equalToSuperview()
                    make.left.equalToSuperview()
                    make.height.equalTo(38)
                }
            }else {
                twoByTwoView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.width.equalToSuperview()
                    make.left.equalToSuperview()
                    make.height.equalTo(38)
                }
            }
            lastItem = twoByTwoView
        }
        
    }
}
