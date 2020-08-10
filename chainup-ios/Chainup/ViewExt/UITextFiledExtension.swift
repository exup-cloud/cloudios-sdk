//
//  UITextFiledExtension.swift
//  Chainup
//
//  Created by zewu wang on 2018/8/22.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

extension UITextField{
    
    //设置placeHolder的富文本
    func setPlaceHolderAtt(_ str : String , color : UIColor = UIColor.ThemeLabel.colorDark , font : CGFloat = 13){
        let placeHolderAtt = NSMutableAttributedString().add(string: str, attrDic: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font) , NSAttributedStringKey.foregroundColor : color])
        self.attributedPlaceholder = placeHolderAtt
    }
}
