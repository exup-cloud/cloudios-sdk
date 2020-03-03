//
//  BTSlider.h
//  BTStore
//
//  Created by 健 王 on 2018/3/5.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BTStepSizeSliderTypeNormal,
    BTStepSizeSliderTypeStep,
    
} BTStepSizeSliderType;

@interface BTSlider : UIControl
/**
 滑块的颜色
 */
@property (strong, nonatomic) UIColor *thumbColor;

/**
 滑块图片
 */
@property (strong, nonatomic) UIImage *thumbImage;

/**
 滑块的大小
 */
@property (assign, nonatomic) CGSize thumbSize;

/**
 滑块的点击范围，默认是2倍
 */
@property (assign, nonatomic) CGFloat thumbTouchRate;

/**
 滑块边框颜色
 */
@property (strong, nonatomic) UIColor *thumbBordColor;

/**
 滑块当前 value
 */
@property (assign, nonatomic) CGFloat value;

/**
 最大值
 */
@property (assign, nonatomic) CGFloat maximumValue;

/**
 最小值
 */
@property (assign, nonatomic) CGFloat minimumValue;

/**
 最大值的滑动颜色
 */
@property (strong, nonatomic) UIColor *maxTrackColor;
/**
 最小值的滑动颜色
 */
@property (strong, nonatomic) UIColor *minTrackColor;

/**
 步长的step数 默认是5级,最低是2级
 */
@property (assign, nonatomic) NSInteger numberOfStep;

/**
 step点击范围，默认是step大小的2倍 stepTouchRate ＝ 2
 */
@property (assign, nonatomic) CGFloat stepTouchRate;

/**
 设置step的颜色
 */
@property (strong, nonatomic) UIColor *stepColor;
/**
 设置step的图片
 */
@property (strong, nonatomic) UIImage *stepImage;
/**
 设置step的大小
 */
@property (assign, nonatomic) CGFloat stepWidth;
/**
 已选step的图片
 */
@property (strong, nonatomic) UIImage *selectedStepImage;
/**
 已选step的颜色
 */
@property (strong, nonatomic) UIColor *selectedStepColor;

/**
 设置slider的左右间隔
 */
@property (assign, nonatomic) CGFloat margin;

/**
 滑条的颜色
 */
@property (strong, nonatomic) UIColor *lineColor;
/**
 设置滑条图片来显示
 */
@property (strong, nonatomic) UIImage *lineImage;
/**
 滑条滑过部分的颜色
 */
@property (strong, nonatomic) UIColor *selectedLineColor;
/**
 滑条滑过部分的图片
 */
@property (strong, nonatomic) UIImage *selectedLineImage;
/**
 设置滑条的粗细程度
 */
@property (assign, nonatomic) CGFloat lineWidth;

/**
 滑条y偏移量，默认是0
 */
@property (assign, nonatomic) CGFloat sliderOffset;

/**
 标题y偏移,默认是向下偏移20 正数向下，负数向上
 */
@property (assign, nonatomic) CGFloat titleOffset;

/**
 设置step下的标题
 */
@property (copy, nonatomic) NSArray *titleArray;

/**
 标题字体
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
 标题颜色
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
 文字的属性
 */
@property (copy, nonatomic) NSDictionary *titleAttributes;


- (void)changeValue:(CGFloat)value;

@end
