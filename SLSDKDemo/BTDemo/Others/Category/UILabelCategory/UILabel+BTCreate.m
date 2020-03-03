//
//  UILabel+BTCreate.m
//  BTStore
//
//  Created by 健 王 on 2018/4/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "UILabel+BTCreate.h"

@implementation UILabel (BTCreate)

+ (instancetype)createLabelWithBackgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font line:(NSInteger)line {
    UILabel *label = [[UILabel alloc] init];
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (line >= 0) {
        label.numberOfLines = line;
    }
    if (font > 0) {
        label.font = [UIFont systemFontOfSize:font];
    }
    return label;
}

@end
