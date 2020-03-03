//
//  SLContractTableViewController.h
//  BTTest
//
//  Created by 健 王 on 2019/9/18.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLNewTableViewType) {
    SLNewTableViewContractSetting = 501,       // 合约设置
    SLNewTableViewContractTradeRule,            // 合约交易规则
    SLNewTableViewSpotTradeRule,                // 现货交易规则
    SLNewTableViewContractTurnover,             // 资金流水
    SLNewTableViewContractLever,                // 杠杆倍数
};

@interface SLContractTableViewController : SLBaseCusNavBarController

@property (nonatomic, copy) void (^toSelectCell)(UITableViewCell *);

@property (nonatomic, copy) NSString *currentCellTitle;
@property (nonatomic, strong) NSMutableArray *leverArr;
@property (nonatomic, copy) NSString *currentLever;

- (instancetype)initWithTableViewType:(SLNewTableViewType)type;

@end
