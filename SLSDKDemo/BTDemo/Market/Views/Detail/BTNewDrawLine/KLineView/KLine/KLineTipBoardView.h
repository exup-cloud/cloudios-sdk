//
//  KLineTipBoardView.h
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "TipBoardView.h"

@interface KLineTipBoardView : UIView

/**
 *  开盘价
 */
@property (nonatomic, copy) NSString *open;

/**
 *  收盘价
 */
@property (nonatomic, copy) NSString *close;

/**
 *  最高价
 */
@property (nonatomic, copy) NSString *high;

/**
 *  最低价
 */
@property (nonatomic, copy) NSString *low;

/**
 *  变化
 */
@property (nonatomic, copy) NSString *change;

/**
 *  数量
 */
@property (nonatomic, copy) NSString *volume;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

/**
 *  最低价
 */
@property (nonatomic, copy) NSString *time;


@property (nonatomic, strong) UIColor *trendColor;


/**************************************************/
/*                     字体颜色                    */
/**************************************************/
//提供不一样的字体颜色可供选择， 默认都｛白色｝

/**
 *  开盘价颜色
 */
@property (nonatomic, strong) UIColor *openColor;

/**
 *  收盘价颜色
 */
@property (nonatomic, strong) UIColor *closeColor;

/**
 *  最高价颜色
 */
@property (nonatomic, strong) UIColor *highColor;

/**
 *  最低价颜色
 */
@property (nonatomic, strong) UIColor *lowColor;


@property (nonatomic, assign) BOOL isScreen;

@end
