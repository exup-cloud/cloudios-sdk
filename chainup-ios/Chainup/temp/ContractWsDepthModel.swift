//
//  ContractWsDepthModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/24.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class TickValue:NSObject {
    @objc var value:String = ""
}

class TickModel:NSObject {
    @objc var asks:[[Any]]=[]
    @objc var buys:[[Any]]=[]
}

class ContractWsDepthModel: NSObject {
    
    @objc var channel :String=""
    @objc var data :String=""
    @objc var eventRep :String=""
    @objc var status :String=""
    @objc var tick :TickModel?
    @objc var ts :String=""
}
