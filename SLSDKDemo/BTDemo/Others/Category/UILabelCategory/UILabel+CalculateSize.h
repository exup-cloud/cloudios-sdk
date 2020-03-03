//
//  UILabel+CalculateSize.h
//  Label的宽和高计算
//
//  Created by Mike on 15/12/9.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CalculateSize)

- (void)adjustsSizeDependOn_text_font_preferredMaxLayoutWidth;

- (void)adjustsSizeDependOn_text_font_withWidth:(CGFloat)width;

- (CGSize)labelSizeWithStr:(NSString *)str font:(UIFont *)font limitSize:(CGSize)size;

- (void)setfrontFont:(UIFont *)font1 backFont:(UIFont *)font2 frontColor:(UIColor *)color1 backColor:(UIColor *)color2  symbol:(NSString *)symbol;

@end
