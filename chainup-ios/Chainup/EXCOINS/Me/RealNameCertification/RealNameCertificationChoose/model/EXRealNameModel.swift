//
//  EXRealNameModel.swift
//  Chainup
//
//  Created by zewu wang on 2019/7/31.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXRealNameModel: EXBaseModel {
    
    
    var openAuto = ""// --开启自动审核   0未开启 1开启
    var language = ""//文案，未开启是能够获取文案，开启后字段不返回
    var limitFlag = ""//--当日平台、个人是否超出使用次数，0未超出，1超出
    var limitMsg = ""//提示
    var toKenUrl = ""//唤醒第三方认证流程，以上不通过，字段不返回；
    var toResultUrl = ""//回调url ，以上不通过，字段不返回；
}

class EXRealNameWriteModel : EXBaseModel{
    var language = ""//文案，未开启是能够获取文案，开启后字段不返回
}

class EXRealNameModelManager : NSObject{
    //MARK:单例
    public static var sharedInstance : EXRealNameModelManager{
        struct Static {
            static let instance : EXRealNameModelManager = EXRealNameModelManager()
        }
        return Static.instance
    }
    
    var model = EXRealNameModel()
    
}

class EXKYCConfigModel : EXBaseModel{
    var openSingPass = ""//是否开启SingPass 0 关闭 1 开启
    var verfyTemplet = ""//人工审核资料模板 1 精简 2 完整
    var h5_templet2_url = ""//模板2
    var h5_singpass_url = ""//singpass地址
}
