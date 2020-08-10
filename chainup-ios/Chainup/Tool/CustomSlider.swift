//
//  CustomSlider.swift
//  Chainup
//
//  Created by zewu wang on 2018/9/10.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.trackRect(forBounds: bounds)
        return CGRect.init(x: bounds.origin.x, y: bounds.origin.y, width: bounds.origin.x, height: 20)
    }
    

}
