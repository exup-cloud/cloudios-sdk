//
//  EXShieldEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/26.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXShieldEntity: EXBaseModel {

    var relationshipList : [EXRelationShip] = []
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.relationshipList = EXRelationShip.mj_objectArray(withKeyValuesArray: self.relationshipList).copy() as! [EXRelationShip]
    }
    
}

class EXRelationShip: EXBaseModel {
    
    //     "userId": "10001", // 用户ID
    //     "otcNickName": "153****6666", // 用户昵称
    //     "creditGrade": 1, // 信用度
    //     "completeOrders": 4 // 交易次数
    
    var userId = ""
    var otcNickName = ""
    var creditGrade = ""
    var completeOrders = ""
    var image = ""
//    override func setEntityWithDict(_ dict: [String : Any]) {
//        super.setEntityWithDict(dict)
//        userId = dictContains("userId")
//        otcNickName = dictContains("otcNickName")
//        creditGrade = dictContains("creditGrade")
//        completeOrders = dictContains("completeOrders")
//        image = dictContains("image")
//    }
}
