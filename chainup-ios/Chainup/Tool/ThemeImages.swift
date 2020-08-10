//
//  ThemeImages.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIImage {
    
    static func themeImageNamed(imageName:String) -> UIImage {    
        if EXThemeManager.isNight() {
            let temp = UIImage.init(named:imageName + "_night")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }else {
            let temp = UIImage.init(named:imageName + "_daytime")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }
    }
}
