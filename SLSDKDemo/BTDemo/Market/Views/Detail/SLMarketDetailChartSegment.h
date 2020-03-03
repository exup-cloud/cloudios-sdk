//
//  SLMarketDetailChartSegment.h
//  BTTest
//
//  Created by wwly on 2019/9/10.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLSegmentButton;

NS_ASSUME_NONNULL_BEGIN

@protocol SLMarketDetailChartSegmentDelegate <NSObject>

- (void)chartSegment_segmentDidClick:(SLSegmentButton *)segmentButton;

@optional
- (void)chartSegment_fullScreenClick;

@end


@interface SLSegmentButton : UIButton

@property (nonatomic, assign) SLStockLineDataType dataType;

@end

/// 选取 k 线图类型
@interface SLMarketDetailChartSegment : UIView

@property (nonatomic, weak) id <SLMarketDetailChartSegmentDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSDictionary *> *)titles selectedDataType:(SLStockLineDataType)dataType;

- (void)changeSelectedDataType:(SLStockLineDataType)dataType;

@end

NS_ASSUME_NONNULL_END
