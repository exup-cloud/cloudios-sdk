//
//  BTPreloadingView.m
//  BTStore
//
//  Created by 健 王 on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTPreloadingView.h"
#import "UIImage+SLGetImage.h"

@interface BTPreloadingView ()
@property (nonatomic, weak) UIImageView *preloadingView;
@end

@implementation BTPreloadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
        UIColor *color = DARK_BARKGROUND_COLOR;
        self.backgroundColor = [color colorWithAlphaComponent:0.6];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DARK_BARKGROUND_COLOR;
        [self addGifImageWithName:imageName];
    }
    return self;
}

#pragma mark - 设置子控件

- (void)addGifImageWithName:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SL_getWidth(375), SL_getWidth(667))];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 1; i < 45; i++) {
        [arrM addObject:[UIImage imageWithName:[NSString stringWithFormat:@"st_image_%d",i]]];
    }
    [imageView setAnimationImages:arrM];
    imageView.animationDuration = 2.5;
    imageView.animationRepeatCount = 1;
    imageView.center = CGPointMake(self.sl_width * 0.5, self.sl_height * 0.5);
//    NSData *imageData = [UIImage GIFImageWithName:name];
//    imageView.image = [UIImage sd_animatedGIFWithData:imageData];
    [self addSubview:imageView];
    imageView .center = self.center;
    self.preloadingView = imageView;
    [imageView startAnimating];
}

- (void)addChildViews {
    [self addPreLoadingImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)addPreLoadingImageView {
    CGFloat gifW = SL_getWidth(60);
    CGFloat gifH = SL_getWidth(60);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(gifW * 2, (self.sl_height - gifH) * 0.5, gifW, gifH)];
    imageView.center = CGPointMake(self.sl_width * 0.5, self.sl_height * 0.5);
    NSData *imageData = [UIImage GIFImageWithName:@"preloading"];
    imageView.image = [UIImage imageWithSmallGIFData:imageData scale:1.f];
    [self addSubview:imageView];
    _preloadingView = imageView;
}

#pragma mark - 对外接口

+ (void)showPreloadView {
//    NSString *name = [NSString stringWithFormat:@"%.f-%.f.gif",SL_SCREEN_WIDTH * 2,SL_SCREEN_HEIGHT * 2];
//    if (SL_SCREEN_HEIGHT == 812.0) {// iPhone X
//        name = @"1125-2436.gif";
//    }
    BTPreloadingView *preloadingView = [[BTPreloadingView alloc] initWithFrame:[UIScreen mainScreen].bounds imageName:nil];
    preloadingView.backgroundColor = MAIN_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:preloadingView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:preloadingView];
}

+ (void)hidePreloadView {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    if (view) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:self]) {
                BTPreloadingView *preloadingView = (BTPreloadingView *)subView;
                [preloadingView.preloadingView stopAnimating];
                [subView removeFromSuperview];
                break;
            }
        }
    }
}

+ (void)showPreloadingViewToView:(UIView *)view BackGroundColor:(UIColor *)color {
    if (view) {
        BTPreloadingView *preloadingView = [[BTPreloadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        preloadingView.backgroundColor = color;
        [view addSubview:preloadingView];
        [preloadingView bringSubviewToFront:view];
    }
}

+ (void)showPreloadingViewToView:(UIView *)view frame:(CGRect)frame {
    if (view) {
        BTPreloadingView *preloadingView = [[BTPreloadingView alloc] initWithFrame:frame];
        [view addSubview:preloadingView];
        [preloadingView bringSubviewToFront:view];
    }
}

+ (void)showPreloadingViewToView:(UIView *)view {
    if (view) {
        BTPreloadingView *preloadingView = [[BTPreloadingView alloc] initWithFrame:view.bounds];
        [view addSubview:preloadingView];
        [preloadingView bringSubviewToFront:view];
    }
}

+ (BOOL)isPreloadingViewShow:(UIView *)view{
    if (view) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:self]) {
                return !subView.isHidden;
            }
        }
    }
    return FALSE;
}

+ (void)hidePreloadingViewToView:(UIView *)view {
    if (view) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:self]) {
                [subView removeFromSuperview];
                break;
            }
        }
    }
}

@end
