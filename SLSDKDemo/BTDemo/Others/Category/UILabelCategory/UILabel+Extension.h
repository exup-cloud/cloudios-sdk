//
//  UILabel+Extension.h
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

- (instancetype)initWithText:(NSString *)text
               textAlignment:(NSTextAlignment)textAlignment
                   textColor:(UIColor *)textColor
                        font:(UIFont *)font
               numberOfLines:(NSUInteger)numberOfLines
                       frame:(CGRect)frame
                   superview:(UIView *)superview;

+ (instancetype)labelWithText:(NSString *)text
                textAlignment:(NSTextAlignment)textAlignment
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font
                numberOfLines:(NSUInteger)numberOfLines
                        frame:(CGRect)frame
                    superview:(UIView *)superview;


- (CGFloat)textWidth;

- (CGFloat)textHeight;

@end
