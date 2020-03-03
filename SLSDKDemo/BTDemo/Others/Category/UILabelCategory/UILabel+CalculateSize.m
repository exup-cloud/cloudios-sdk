//
//  UILabel+CalculateSize.m
//  Label的宽和高计算
//
//  Created by Mike on 15/12/9.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "UILabel+CalculateSize.h"

@implementation UILabel (CalculateSize)

- (void)setfrontFont:(UIFont *)font1 backFont:(UIFont *)font2 frontColor:(UIColor *)color1 backColor:(UIColor *)color2  symbol:(NSString *)symbol {
    NSRange rande = [self.text rangeOfString:symbol];
    if (self.text == nil) {
        return;
    }
    if (rande.location == NSNotFound) {
        return;
    }
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSDictionary *dict = @{
                           NSFontAttributeName : font1,
                           NSForegroundColorAttributeName:color1
                           };
    NSDictionary *dict2 = @{
                            NSFontAttributeName : font2,
                            NSForegroundColorAttributeName:color2
                            };
    [str setAttributes:dict range:NSMakeRange(0, rande.location)];
    [str setAttributes:dict2 range:NSMakeRange(rande.location , str.length - rande.location)];
    self.attributedText = str;
}

/**
 *  使用前需要将text、font、preferredMaxLayoutWidth正确赋值,同时numberOfLines=0
 */
- (void)adjustsSizeDependOn_text_font_preferredMaxLayoutWidth {
    NSString *text = self.text;
    UIFont *font = self.font;
    CGFloat maxWidth = self.preferredMaxLayoutWidth;
    [self adjustsSizeWithText:text font:font maxWidth:maxWidth];
}

- (void)adjustsSizeDependOn_text_font_withWidth:(CGFloat)width {
    NSString *text = self.text;
    UIFont *font = self.font;
    CGFloat maxWidth = width;
    [self adjustsSizeWithText:text font:font maxWidth:maxWidth];
}

- (void)adjustsSizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    CGSize size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)labelSizeWithStr:(NSString *)str font:(UIFont *)font limitSize:(CGSize)size {
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing=12;
    NSDictionary *attrDic= @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize lastSize= [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine) attributes:attrDic context:nil].size;
    
    return lastSize;
    
}

@end
