//
//  SLContractPlanTypeCell.h
//  BTTest
//
//  Created by wwly on 2019/9/8.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SLContractPlanTypeCurrent,
    SLContractPlanTypeHistory,
} SLContractPlanType;

@protocol SLContractPlanTypeCellDelegate <NSObject>

- (void)contractPlanTypeCell_selectedContractPlanType:(SLContractPlanType)contractPlanType;

@end

/// 计划委托里的数据类型 (当前计划 / 历史计划)
@interface SLContractPlanTypeCell : UITableViewCell

@property (nonatomic, weak) id <SLContractPlanTypeCellDelegate> delegate;

- (void)updateViewWithContractPlanType:(SLContractPlanType)contractPlanType;

@end

NS_ASSUME_NONNULL_END
