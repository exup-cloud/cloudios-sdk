//
//  BTOrderViewInfoView.h
//  BTStore
//
//  Created by 健 王 on 2018/5/8.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTOrderViewInfoView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL isOTC;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)loadInfoWithTitle:(NSString *)title mainColor:(UIColor *)Color number:(NSString *)number numColor:(UIColor *)numColor endLabel:(NSString *)endText;

@end
