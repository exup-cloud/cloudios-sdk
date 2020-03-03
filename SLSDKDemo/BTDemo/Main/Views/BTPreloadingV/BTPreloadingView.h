//
//  BTPreloadingView.h
//  BTStore
//
//  Created by 健 王 on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTPreloadingView : UIView
+ (void)showPreloadingViewToView:(UIView *)view;
+ (void)hidePreloadingViewToView:(UIView *)view;
+ (BOOL)isPreloadingViewShow:(UIView *)view;
+ (void)showPreloadingViewToView:(UIView *)view BackGroundColor:(UIColor *)color;
+ (void)showPreloadingViewToView:(UIView *)view frame:(CGRect)frame;

+ (void)showPreloadView;

+ (void)hidePreloadView;

@end
