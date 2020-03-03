//
//  Common.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipBoardView : UIView

@property (nonatomic, strong) UIColor *strockColor;

@property (nonatomic, strong) UIColor *fillColor;

/**
 *  三角形宽度
 */
@property (nonatomic, assign) CGFloat triangleWidth;

/**
 *  圆角弧度
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *  字体， 默认系统字体，大小 10
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  隐藏时间, 默认3s
 */
@property (nonatomic, assign) CGFloat hideDuration;

/**
 *  画背景图
 */
- (void)drawInContext;

- (void)showWithTipPoint:(CGPoint)point;

- (void)hide;

@end
