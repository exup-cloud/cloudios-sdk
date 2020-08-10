//
//  SLUIView+Extension.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

extension UILabel {
    public convenience init(text: String?, font: UIFont?, textColor: UIColor?, alignment: NSTextAlignment) {
        self.init(text: text, frame: CGRect.zero, font: font, textColor: textColor, alignment: alignment)
    }
    
    public convenience init(text: String?, frame: CGRect, font: UIFont?, textColor: UIColor?, alignment: NSTextAlignment) {
        self.init()
        
        self.text = text
        self.frame = frame
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
    
    /// 获取内容对应的宽度
    func textWidth() -> CGFloat {
        return self.text?.getWidth(height: self.height, font: self.font) ?? 0
    }
    
    /// 获取内容对应的高度
    func textHeight() -> CGFloat {
        return self.text?.getHeight(width: self.width, font: self.font) ?? 0
    }
}

extension UIButton {
    public convenience init(buttonType: UIButton.ButtonType, title: String?, titleFont: UIFont?, titleColor: UIColor?) {
        self.init(type: buttonType)
        if title != nil {
            self.setTitle(title, for: .normal)
        }
        if titleFont != nil {
            self.titleLabel?.font = titleFont
        }
        if titleColor != nil {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    public convenience init(buttonType: UIButton.ButtonType, image: UIImage?, hightlightedImage: UIImage? = nil, imageContentMode: UIViewContentMode = UIViewContentMode.scaleAspectFit) {
        self.init(type: buttonType)
        if image != nil {
            self.setImage(image, for: .normal)
        }
        if hightlightedImage != nil {
            self.setImage(hightlightedImage, for: .highlighted)
        }
        self.imageView?.contentMode = imageContentMode
    }
}


extension String {
    func getHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: width, height: 9999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.size.height + 1
    }
    
    func getWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: 9999, height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return rect.size.width + 1
    }
}
