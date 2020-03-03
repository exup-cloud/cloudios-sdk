//
//  SLContractListView.h
//  BTTest
//
//  Created by WWLy on 2019/9/6.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLContractListViewDelegate <NSObject>

- (void)contractListView_scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface SLContractListView : UIView

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, weak) id <SLContractListViewDelegate> delegate;

- (void)updateViewWithItemModel:(BTItemModel *)itemModel;

/// 更新当前账户和委托列表信息
- (void)refreshContractInfo;

@end

NS_ASSUME_NONNULL_END
