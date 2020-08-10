//
//  EXRealNameTwoEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameTwoEntity: NSObject {

    var userName = ""//名字
    
    var familyName = ""//姓
    
    var name = ""//名
    
    var certificateType = ""//证件类型 1身份证 2护照
    
    var countryCode = ""//地区编码
    
    var certificateNumber = ""//证件号
    
    var firstPhoto = ""//第一张
    
    var secondPhoto = ""//第二张
    
    var thirdPhoto = ""//第三张
    
    var numberCode = ""//国家编码
    
}

class EXRealBtnEntity : NSObject{
    
    var title = ""
    
    var imgUrl = ""
    
    var placeholderImg = ""
    
    var image : UIImage?
    
}
