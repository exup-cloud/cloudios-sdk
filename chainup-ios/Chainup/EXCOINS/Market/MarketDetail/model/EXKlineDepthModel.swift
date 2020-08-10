//
//  EXKlineDepthModel.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class TickDepth : NSObject {
    @objc var asks:[[Any]]=[]
    @objc var buys:[[Any]]=[]
}

class EXKlineDepthModel: NSObject {
    @objc var tick : TickDepth?

}
