//
//  EXMenuSelectionModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/23.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

let klineScaleKey = "ExKlineScaleKey"

class EXMenuSelectionModel: NSObject {
    var scaleKey:String {
        get {
            let df = UserDefaults.standard
            if let scaleKey = df.string(forKey: klineScaleKey) {
                return scaleKey
            }else {
                return "15min"
            }
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:klineScaleKey)
        }
        
    }
    var masterType:MasterAlgorithmType = .MA
    var assitantType:AssistantAlgorithmType = .Hides
}
