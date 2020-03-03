//
//  SLContractCurrentHaveCell.h
//  BTTest
//
//  Created by wwly on 2019/9/8.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLContractCurrentHaveCellDelegate <NSObject>

/// 调整保证金
- (void)currentHaveCell_adjustMarginWithPositionModel:(BTPositionModel *)positionModel;
/// 平仓
- (void)currentHaveCell_sellAllWithPositionModel:(BTPositionModel *)positionModel;

@end

/// 当前持仓
@interface SLContractCurrentHaveCell : UITableViewCell

@property (nonatomic, weak) id <SLContractCurrentHaveCellDelegate> delegate;

- (void)updateViewWithPositionModel:(BTPositionModel *)positionModel;

@end

NS_ASSUME_NONNULL_END
