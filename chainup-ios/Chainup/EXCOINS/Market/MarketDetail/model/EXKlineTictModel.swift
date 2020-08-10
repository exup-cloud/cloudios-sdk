//
//  EXKlineTictModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/18.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class TickItem :NSObject {
    @objc var amount :String = ""
    @objc var open :String = "--"
    @objc var high :String = "--"
    @objc var vol :String = "--"
    @objc var low :String = "--"
    @objc var close :String = "--"
    var riseorfail = true//true上升 false下降
    @objc var rose :String = "--" {
        didSet {
            if rose.hasPrefix("-") {
                rose = rose.replacingOccurrences(of: "-", with: "")
                rose = "-" + NSString.init(string: rose).multiplying(by: "100", decimals: 2)
                if let r = Int(rose) , r == 0{
                    rose = rose.replacingOccurrences(of: "-", with: "")
                }
            }else {
                rose = NSString.init(string: rose).multiplying(by: "100", decimals: 2)
            }
            riseorfail = rose.contains("-") ? false : true
        }
    }
    var precision = 2
    {
        didSet{
            close = (close as NSString).decimalString1(precision)
        }
    }
    var rmb = ""
    
}

class EXKlineTictModel: NSObject {
    
    @objc var tick : TickItem?
    @objc var ts : String?

}
