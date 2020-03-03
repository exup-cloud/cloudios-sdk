//
//  BTHorScreenView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/6/4.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMarketDetailChartSegment.h"

@class BTHorScreenView, BTItemModel;
@protocol BTHorScreenViewDelegate <NSObject>

- (void)horScreenView_didCickSegmentWithDataType:(SLStockLineDataType)dataType;

- (void)scrollHorScreenViewVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd;

- (void)horScreenViewDidClickCancelView:(BTHorScreenView *)screenView;

@end

@interface BTHorScreenView : UIView

@property (nonatomic, copy) void (^toCancel)(BTHorScreenView *);

@property (nonatomic, weak) id <BTHorScreenViewDelegate> delegate;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, strong) UIView *loadView;
@property (nonatomic, strong) BTItemModel *itemModel;
/// 如果显示的不是最新的数据就不更新数据
@property (nonatomic, assign) BOOL notUpdateData;

@property (nonatomic, assign) NSInteger tlineType;
@property (nonatomic, assign) NSInteger blineType;

- (instancetype)initWithFrame:(CGRect)frame seletedDataType:(SLStockLineDataType)dataType;

// 绘制
- (void)showHorScreenViewKLineDataDict:(NSDictionary *)lineDataDict;


@end
