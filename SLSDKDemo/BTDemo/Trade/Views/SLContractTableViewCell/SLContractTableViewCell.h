//
//  SLContractTableViewCell.h
//  BTTest
//
//  Created by 健 王 on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define SL_CONTRACTSETTING_CELL     @"ContractSetting"
#define SL_CONTRACTTRADERULE_CELL   @"ContractTradeRule"
#define SL_CONTRACTTURNOVER_CELL    @"ContractTurnover"

@interface SLContractTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL noIcon;
@property (nonatomic, assign) BOOL hasSelect;
@end

NS_ASSUME_NONNULL_END
