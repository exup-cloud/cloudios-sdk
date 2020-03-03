//
//  UILabel+Extension.m
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (instancetype)initWithText:(NSString *)text
               textAlignment:(NSTextAlignment)textAlignment
                   textColor:(UIColor *)textColor
                        font:(UIFont *)font
               numberOfLines:(NSUInteger)numberOfLines
                       frame:(CGRect)frame
                   superview:(UIView *)superview {
    if (self = [super init]) {
        if (text.length) {
            self.text = text;
        }
        if (font) {
            self.font = font;
        }
        self.textAlignment = textAlignment;
        self.textColor = textColor;
        self.numberOfLines = numberOfLines;
        self.frame = frame;
        [superview addSubview:self];
    }
    return self;
}

+ (instancetype)labelWithText:(NSString *)text
                textAlignment:(NSTextAlignment)textAlignment
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                numberOfLines:(NSUInteger)numberOfLines
                        frame:(CGRect)frame
                    superview:(UIView *)superview {
    
    return [[self alloc] initWithText:text
                        textAlignment:textAlignment
                            textColor:textColor
                                 font:font
                        numberOfLines:numberOfLines
                                frame:frame
                            superview:superview];
}

- (CGFloat)textWidth {
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(999, self.sl_height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:self.font}
                                        context:nil];
    return rect.size.width;
}

- (CGFloat)textHeight {
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.sl_width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:self.font}
                                        context:nil];
    return rect.size.height;
}

@end
