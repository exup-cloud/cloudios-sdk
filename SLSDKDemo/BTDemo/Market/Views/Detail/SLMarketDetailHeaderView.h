//
//  SLMarketDetailHeaderView.h
//  BTTest
//
//  Created by wwly on 2019/9/10.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTItemModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SLMarketDetailHeaderViewDelegate <NSObject>

- (void)headerView_rightArrowButtonClick;

@end

/// 详情页顶部价格视图
@interface SLMarketDetailHeaderView : UIControl

@property (nonatomic, weak) id <SLMarketDetailHeaderViewDelegate> delegate;

- (void)updateViewWithItemModel:(BTItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
