//
//  EXAppMailEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

@objcMembers class EXAppMailAllEntity : NSObject {
    
    var typeList : [EXMessageTypesEntity] = []
    
    var userMessageList : [EXAppMailEntity] = []
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.typeList = EXMessageTypesEntity.mj_objectArray(withKeyValuesArray: self.typeList).copy() as! [EXMessageTypesEntity]
        self.userMessageList = EXAppMailEntity.mj_objectArray(withKeyValuesArray: self.userMessageList).copy() as! [EXAppMailEntity]
    }
}

@objcMembers class EXAppMailEntity: NSObject {

    var ctime = ""//时间
    {
        didSet{
            ctime = DateTools.strToTimeString(ctime)
        }
    }
    
    var id = ""//id
    
    var messageContent = ""//消息内容
    
    var messageType = ""//消息类型
    
    var messageTitle = ""//标题
    
    var receiveUid = ""//接收消息用户
    
    var status = ""//1未读 2已读
    
}

//MARK:侧边栏
@objcMembers class EXMessageTypesEntity:SuperEntity{
    var tid = ""
    
    var title = ""
}
