//
//  EXSecurityEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXSecurityEntity: NSObject {

    var name = ""//名字
    
    var info = ""//默认
    
    var switchOn = false
    
}

@objcMembers class EXGuestureEntity : NSObject {
    var token = ""//
}

@objcMembers class EXFaceOrTouch: NSObject {
    var isPass = ""//是否通过
}
