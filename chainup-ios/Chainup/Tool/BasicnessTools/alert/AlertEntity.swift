//
//  AlertEntity.swift
//  AppProject
//
//  Created by zewu wang on 2018/8/3.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

import UIKit

class AlertEntity: NSObject {

    var cellTitle : (String ,String) = ("","")//展示的celltitle
    
    var cellPrompt : String = ""//默认展示
    
    var showBtn = true
    
    var cellHeight : CGFloat = 76
    
    func setCellHeight(){
        if cellTitle.0 == "" && cellTitle.1 == ""{
            cellHeight = 53
        }
    }

}
