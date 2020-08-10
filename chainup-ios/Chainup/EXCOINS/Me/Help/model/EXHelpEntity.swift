//
//  EXHelpEntity.swift
//  Chainup
//
//  Created by zewu wang on 2019/4/22.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class EXHelpEntity: SuperEntity {

    var ID = ""
    
    var fileName = ""
    
    var title = ""
    
    override func setEntityWithDict(_ dict: [String : Any]) {
        super.setEntityWithDict(dict)
        ID = dictContains("ID")
        fileName = dictContains("fileName")
        title = dictContains("title")
    }
    
}
