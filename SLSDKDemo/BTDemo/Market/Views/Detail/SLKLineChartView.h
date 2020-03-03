//
//  SLKLineChartView.h
//  BTTest
//
//  Created by WWLy on 2019/9/11.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMarketDetailChartSegment.h"
#import "BTHorScreenView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SLKLineChartViewDelegate <NSObject>

- (void)lineChartView_didClickSegmentWithKLineDataType:(SLStockLineDataType)dataType;

- (void)lineChartView_scrollVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd;

@end

/// 详情页图表视图
@interface SLKLineChartView : UIView

@property (nonatomic, strong) NSMutableArray *timeLineDataArr;
@property (nonatomic, strong) NSMutableArray *fiveKLineDataArr;
@property (nonatomic, strong) NSMutableArray *thirtyKLineDataArr;
@property (nonatomic, strong) NSMutableArray *HourKLineDataArr;
@property (nonatomic, strong) NSMutableArray *KlineDataArr;
@property (nonatomic, strong) NSMutableArray *KWeekLineDataArr;
@property (nonatomic, assign) BOOL hasShowScreen;
//@property (nonatomic, assign) NSInteger selecIndex; // topbar 的索引
@property (nonatomic, weak) id <SLKLineChartViewDelegate, BTHorScreenViewDelegate> delegate;
@property (nonatomic, strong) BTItemModel *itemModel;
/// 如果显示的不是最新的数据就不更新数据
@property (nonatomic, assign) BOOL notUpdateData;


- (void)changeDataType:(SLStockLineDataType)dataType;

/// 更新分时数据
- (BOOL)updataTimeLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新一分钟K线
- (BOOL)updataOneKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新15分钟K线
- (BOOL)updataFifteenKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新五分钟数据
- (BOOL)updataFiveKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新三十分钟数据
- (BOOL)updataThirtyKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新六十钟数据
- (BOOL)updataHourKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新两小时数据
- (BOOL)updataTwoHourKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新四小时数据
- (BOOL)updataFourHourKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新六小时数据
- (BOOL)updataSixHourKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新12时数据
- (BOOL)updataTwelveHourKLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新日K数据
- (BOOL)updataKDayLine:(NSArray *)data hasChange:(BOOL)change;
/// 更新周K数据
- (BOOL)updataKWeekLine:(NSArray *)data hasChange:(BOOL)change;

@end

NS_ASSUME_NONNULL_END
