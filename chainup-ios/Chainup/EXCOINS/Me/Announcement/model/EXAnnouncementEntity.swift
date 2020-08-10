//
//  EXAnnouncementEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit


class EXAnnouncementNoticeInfoList: EXBaseModel {
    var noticeInfoList : [EXAnnouncementEntity] = []
    override func mj_keyValuesDidFinishConvertingToObject(){
        self.noticeInfoList = EXAnnouncementEntity.mj_objectArray(withKeyValuesArray: self.noticeInfoList).copy() as! [EXAnnouncementEntity]
    }
}

class EXAnnouncementEntity: EXBaseModel {

    var id = ""
    
    var title = ""
    
    var timeLong = ""
    {
        didSet{
            timeLong = DateTools.strToTimeString(timeLong)
        }
    }
    
    var content = ""
    
    var lang = ""
    
}
