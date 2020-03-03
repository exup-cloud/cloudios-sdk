//
//  SLContractTradeController.h
//  BTTest
//
//  Created by wwly on 2019/8/28.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBaseCusNavBarController.h"

NS_ASSUME_NONNULL_BEGIN

/// 合约交易
@interface SLContractTradeController : SLBaseCusNavBarController

/// 对应某个币种, 初始化控制器的时候赋值
@property (nonatomic, strong) BTItemModel * itemModel;

@end

NS_ASSUME_NONNULL_END
