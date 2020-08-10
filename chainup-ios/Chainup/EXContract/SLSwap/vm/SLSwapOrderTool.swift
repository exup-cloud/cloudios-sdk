//
//  SLSwapOrderTool.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/16.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

class SLSwapOrderTool : NSObject {
    func getDetailType(model: BTContractOrderModel) -> BTContractTransactionDetailType? {
        if (model.category == .trigger || model.category == .break) {
            return .force
        } else if (model.category == .detail) {
            if BasicParameter.handleDouble(model.take_fee) > 0 {
                return .force
            } else {
                return .reduce
            }
        }
        return nil
    }
}
