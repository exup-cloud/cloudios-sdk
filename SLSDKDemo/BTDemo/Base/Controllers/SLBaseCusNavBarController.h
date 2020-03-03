//
//  SLBaseCusNavBarController.h
//  ColorfulClouds
//
//  Created by  on 2019/3/21.
//  Copyright © 2019 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义导航栏 (隐藏系统导航栏)
@interface SLBaseCusNavBarController : UIViewController

- (void)changeLineHiddenStatus:(BOOL)isHidden;

- (void)setCustomLeftView:(UIView *)customView;
- (void)setCustomTitleView:(UIView *)customView;
- (void)setCustomRightView:(UIView *)customView;

/// 设置导航栏标题
- (void)updateNavTitle:(NSString *)title;

/// 设置导航栏背景色
- (void)updateNavBackgroundColor:(UIColor *)color;

/// 导航栏左边按钮方法
- (void)preAction;

@end

NS_ASSUME_NONNULL_END
