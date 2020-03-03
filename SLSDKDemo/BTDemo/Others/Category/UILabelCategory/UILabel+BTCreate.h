//
//  UILabel+BTCreate.h
//  BTStore
//
//  Created by 健 王 on 2018/4/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BTCreate)

+ (instancetype)createLabelWithBackgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font line:(NSInteger)line;

@end
