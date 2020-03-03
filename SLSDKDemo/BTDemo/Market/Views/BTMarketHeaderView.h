//
//  BTMarketHeaderView.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BTSortTypeDefault,         // 默认排序 (接口排序)
    BTSortTypePriceAscending,  // 价格升序
    BTSortTypePriceDescending, // 价格降序
    BTSortTypeGainAscending,   // 涨跌幅升序
    BTSortTypeGainDescending,  // 涨跌幅降序
} BTSortType;

@protocol BTMarketHeaderViewDelegate <NSObject>

- (void)headerView_sortTypeChanged:(BTSortType)sortType;

@end

@interface BTMarketHeaderView : UIView

@property (nonatomic, weak) id <BTMarketHeaderViewDelegate> delegate;

@property (nonatomic, assign) BTSortType currentSortType;

@end

NS_ASSUME_NONNULL_END
