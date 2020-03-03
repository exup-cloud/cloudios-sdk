//
//  SLConfig.h
//  SLContractSDK
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 一些初始化配置, 该类需要在初始化视图之前完成配置
@interface SLConfig : NSObject

/// 导航栏背景色
@property (nonatomic, strong) UIColor * navBarBackgroundColor;
/// 导航栏标题颜色
@property (nonatomic, strong) UIColor * navTitleColor;
/// 分隔线颜色
@property (nonatomic, strong) UIColor * marginLineColor;
/// 视图的背景色
@property (nonatomic, strong) UIColor * contentViewColor;
/// 深色视图背景色
@property (nonatomic, strong) UIColor * darkContentViewColor;
/// 一些深色字体的颜色
@property (nonatomic, strong) UIColor * darkTextColor;
/// 一些浅色字体的颜色
@property (nonatomic, strong) UIColor * lightTextColor;
/// 一些深灰色字体的颜色
@property (nonatomic, strong) UIColor * darkGrayTextColor;
/// 一些浅灰色字体的颜色
@property (nonatomic, strong) UIColor * lightGrayTextColor;
/// 界面中一些蓝色字体的颜色
@property (nonatomic, strong) UIColor * blueTextColor;
/// 买单颜色
@property (nonatomic, strong) UIColor * greenColorForBuy;
/// 卖单颜色
@property (nonatomic, strong) UIColor * redColorForSell;


+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
