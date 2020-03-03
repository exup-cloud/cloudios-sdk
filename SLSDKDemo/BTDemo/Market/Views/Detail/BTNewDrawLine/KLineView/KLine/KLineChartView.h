//
//  KlineChartView.h
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLineChartViewBase.h"
@class KLineChartView;
@protocol KLineChartViewdelegate <NSObject>
@optional
- (void)moveToPointWithKLineChartView:(KLineChartView*)chartView lineArr:(NSArray*)arr;

- (void)endToPointWithKLineChartView:(KLineChartView*)chartView lineArr:(NSArray*)arr;

- (void)scrollVerticallyWithOffsetY:(CGFloat)offsetY isEnd:(BOOL)isEnd;

@end

@interface KLineChartView : YKLineChartViewBase

/************************************************************************************/
/*                                          |                                       */
/*                                      topMargin                                   */
/*                                          |                                       */
/*                    *------------------------------------------*                  */
/*                    |                                          |                  */
/*                    |                                          |                  */
/* <-  leftMargin   ->|                    k线图                  | <- leftMargin -> */
/*                    |                                          |                  */
/*                    |                                          |                  */
/*                    *------------------------------------------*      -           */
/*                                                                      |           */
/*                                                                      |           */
/*                                                                      |           */
/***********************************************************************|************/
/*                                   showBarChart = YES                 |           */
/****************************************************************** bottomMargin ****/
/*                    *------------------------------------------*      |           */
/*                    |                                          |      |           */
/*                    |                    柱形图                 |      |           */
/*                    |                                          |      |           */
/*                    *------------------------------------------*      _           */
/************************************************************************************/
    
@property (nonatomic, weak) id <KLineChartViewdelegate> proxy;

/**
 *  内容距离父试图顶部高度
 */
@property (nonatomic, assign) CGFloat topMargin;

/**
 *  内容距离父试图左边距离
 */
@property (nonatomic, assign) CGFloat leftMargin;

/**
 *  内容距离父试图右边距离
 */
@property (nonatomic, assign) CGFloat rightMargin;

/**
 *  内容距离父试图底部距离
 */
@property (nonatomic, assign) CGFloat bottomMargin;

/**
 *  k线图宽度
 */
@property (nonatomic, assign) CGFloat kLineWidth;

/**
 *  k线图间距
 */
@property (nonatomic, assign) CGFloat kLinePadding;

/**
 *  均线宽度
 */
@property (nonatomic, assign) CGFloat movingAvgLineWidth;

/**
 *  阳线颜色(negative line)
 */
@property (nonatomic, strong) UIColor *positiveLineColor;

/**
 *  阴线颜色
 */
@property (nonatomic, strong) UIColor *negativeLineColor;

/**
 *  上影线
 */
@property (nonatomic, strong) UIColor *upperShadowColor;

/**
 *  下影线
 */
@property (nonatomic, strong) UIColor *lowerShadowColor;

/**
 *  最小均线颜色（默认：5日）
 */
@property (nonatomic, strong) UIColor *minMALineColor;

/**
 *  中间均线颜色（默认：顿号10）
 */
@property (nonatomic, strong) UIColor *midMALineColor;

/**
 *  最大均线值（默认：日顿号20）
 */
@property (nonatomic, strong) UIColor *maxMALineColor;

/**
 *  交易量阳线颜色
 */
@property (nonatomic, strong) UIColor *positiveVolColor;

/**
 *  交易量阴线颜色
 */
@property (nonatomic, strong) UIColor *negativeVolColor;

/**
 *  y坐标轴字体
 */
@property (nonatomic, strong) UIFont *yAxisTitleFont;

/**
 *  y坐标轴标题颜色
 */
@property (nonatomic, strong) UIColor *yAxisTitleColor;

/**
 *  x坐标轴字体
 */
@property (nonatomic, strong) UIFont *xAxisTitleFont;

/**
 *  x坐标轴标题颜色
 */
@property (nonatomic, strong) UIColor *xAxisTitleColor;

/**
 *   时间轴高度（默认20.0f）
 */
@property (nonatomic, assign) CGFloat timeAxisHeight;

/**
 *  坐标轴边框颜色
 */
@property (nonatomic, strong) UIColor *axisShadowColor;

/**
 *  坐标轴边框宽度
 */
@property (nonatomic, assign) CGFloat axisShadowWidth;

/**
 *  分割线个数
 */
@property (nonatomic, assign) NSInteger separatorNum;

/**
 *  分割线大小
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 *  分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  十字线颜色
 */
@property (nonatomic, strong) UIColor *crossLineColor;

/**
 *   默认可以放大缩小
 */
@property (nonatomic, assign) BOOL zoomEnable;

/**
 *  默认可以滑动
 */
@property (nonatomic, assign) BOOL scrollEnable;

/**
 *  默认显示均线
 */
@property (nonatomic, assign) BOOL showAvgLine;
/**
 *  默认不显示EMA
 */
@property (nonatomic, assign) BOOL showEMALine;
/**
 *  默认不显示BOLL
 */
@property (nonatomic, assign) BOOL showBOLLLine;
/**
 *  默认不显示SAR
 */
@property (nonatomic, assign) BOOL showSARLine;
/**
 *  显示柱形图，默认显示
 */
@property (nonatomic, assign) BOOL showBarChart;
/**
 *  显示RSI，默认不显示
 */
@property (nonatomic, assign) BOOL showRSIChart;

/**
 *  显示KDJ，默认不显示
 */
@property (nonatomic, assign) BOOL showKDJChart;

/**
 *  显示MACD，默认不显示
 */
@property (nonatomic, assign) BOOL showMACDChart;

/**
 *  显示WR，默认不显示
 */
@property (nonatomic, assign) BOOL showWRChart;

/**
 *  显示MTM，默认不显示
 */
@property (nonatomic, assign) BOOL showMTMChart;

/**
 *  显示CCI，默认不显示
 */
@property (nonatomic, assign) BOOL showCCIChart;

/**
 *  YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标是所有数据中的最大值最小值，不管k线图呈现如何都不会变化。默认YES
 */
@property (nonatomic, assign) BOOL yAxisTitleIsChange;

/**
 *  保留小数点位数，默认保留两位(最多两位)
 */
@property (nonatomic, assign) NSInteger  saveDecimalPlaces;

/**
 *  k线最大宽度
 */
@property (nonatomic, assign) CGFloat maxKLineWidth;

/**
 *  k线最小宽度
 */
@property (nonatomic, assign) CGFloat minKLineWidth;

/**
 *  时间和价格提示的字体颜色
 */
@property (nonatomic, strong) UIColor *timeAndPriceTextColor;

/**
 *  时间和价格提示背景颜色
 */
@property (nonatomic, strong) UIColor *timeAndPriceTipsBackgroundColor;

/**
 *  支持手势（默认支持）
 */
@property (nonatomic, assign) BOOL supportGesture;

/**
 *  动态更新显示最新, 默认不开启。
 *
 *  注意⚠️
 1. 有新数据过来，新数据会呈现高亮状态提示为最新数据
 2. 开启，有新数据过来，会以最新数据显示为准绘制在UI；优先级优于用户操作；忽略用户操作的结果。
 3. 不开启，优先级低于手势，处理完手势，才会处理最新数据，用户的操作为准。
 */
@property (nonatomic, assign) BOOL dynamicUpdateIsNew;

@property (nonatomic, assign) BOOL needUpdata;


@property (nonatomic, assign) BOOL notUpdateKLineData;


@property (nonatomic, assign) BOOL isHorScreen; // 是横屏

/*
 * self.data 的格式为 @{kCandlerstickChartsDate:dates,             // 日期 @[@"date", @"date", ...]
                         kCandlerstickChartsContext:context,      // 内容数据 @[NSArray, NSArray, ...]; NSArray = @["开盘价,最高价,最低价,收盘价,成交量, 调整收盘价"]
                        kCandlerstickChartsMaxHigh:@(maxHigh),    // 最高价
                        kCandlerstickChartsMinLow:@(minLow),      // 最低价
                        kCandlerstickChartsMaxVol:@(maxVol),      // 最大交易量
                        kCandlerstickChartsMinVol:@(minVol)       // 最小交易量
                     };
 *
 *  注意：传输的数据格式是可以修改，具体可看 KLineListTransformer ； 使用NSDictionary 还是 Entity 按照自己需求配置。
 */

@property (nonatomic, assign) BOOL isTimeLine;

- (void)drawChartWithData:(NSDictionary *)data;

- (void)updateChartWithData:(NSDictionary *)data;

- (void)clear;

@end


