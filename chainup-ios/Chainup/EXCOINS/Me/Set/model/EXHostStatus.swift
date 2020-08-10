//
//  EXHostStatus.swift
//  Chainup
//
//  Created by chainup on 2020/6/17.
//  Copyright © 2020 ChainUP. All rights reserved.
//

import UIKit
enum EXHostStatus {

    case none
    case testing
    case success
    case unusable
}

struct EXHostEntity {
    var name = ""
    var status:EXHostStatus = .none
    var host = ""
    var responseTimeStr = ""
    var selected:Bool = false
    
    func statusStr() ->String {
        switch status {
        case .testing:
            return LanguageTools.getString(key: "customSetting_action_testing")
        case .success:
            return "\(LanguageTools.getString(key: "customSetting_action_response"))\(responseTimeStr)"
        case .unusable:
            return LanguageTools.getString(key: "customSetting_action_unusable")
        default:
           return ""
        }
    }
}
