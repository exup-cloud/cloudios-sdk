//
//  SLContractListCell.h
//  BTTest
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLContractListHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLContractListCellDelegate <NSObject>

/// 取消当前委托
- (void)contractListCell_cancelButtonClickWithOrderModel:(BTContractOrderModel *)contractOrderModel;

@end

@interface SLContractListCell : UITableViewCell

@property (nonatomic, weak) id <SLContractListCellDelegate> delegate;

@property (nonatomic, assign) SLContractListType contractListType;


- (void)updateViewWithContractOrderModel:(BTContractOrderModel *)contractOrderModel;

@end

NS_ASSUME_NONNULL_END
