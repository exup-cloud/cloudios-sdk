//
//  SLContractListHeaderView.h
//  BTTest
//
//  Created by WWLy on 2019/9/6.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 委托列表类型
typedef enum : NSUInteger {
    /// 当前委托
    SLContractListTypeCurrent,
    /// 历史委托
    SLContractListTypeHistory,
    /// 当前计划委托
    SLContractListTypePlanCurrent,
    /// 历史计划委托
    SLContractListTypePlanHistory,
    /// 当前持仓
    SLContractListTypeCurrentHave,
    /// 成交记录
    SLContractListTypeDoneRecord,
    /// 仓位历史
    SLContractListTypePositionsHistory
} SLContractListType;

@protocol SLContractListHeaderViewDelegate <NSObject>

- (void)headerView_buttonClick:(SLContractListType)contractListType;

@end

@interface SLContractListHeaderView : UIView

@property (nonatomic, weak) id <SLContractListHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
