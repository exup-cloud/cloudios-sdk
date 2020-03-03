//
//  SLContractCalculatorController.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/9/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "SLBaseCusNavBarController.h"

typedef NS_ENUM(NSInteger, BTCalculatorType) {
    BTCalculatorLoseGain = 0, // 盈亏计算
    BTCalculatorForceClose,   // 强平计算
    BTCalculatorTargetPrice   // 目标价计算
};

@class BTItemModel;

/// 合约计算器
@interface SLContractCalculatorController : SLBaseCusNavBarController

@property (nonatomic, strong) BTItemModel *itemModel;

@end
