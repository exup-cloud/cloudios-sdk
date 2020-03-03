//
//  SLContractTextField.m
//  BTTest
//
//  Created by wwly on 2019/9/8.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractTextField.h"

@interface SLContractTextField ()

@end

@implementation SLContractTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [[SLConfig defaultConfig].blueTextColor colorWithAlphaComponent:0.1];
    self.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [SLConfig defaultConfig].lightTextColor;
    
    self.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    // 计算占位文字的 Size
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName : self.font}];
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:@{NSForegroundColorAttributeName : GARY_BG_TEXT_COLOR, NSFontAttributeName : self.font}];
}

- (void)updateRightViewText:(NSString *)text {
    UILabel *rightLabel = [UILabel labelWithText:text textAlignment:NSTextAlignmentCenter textColor:[SLConfig defaultConfig].lightGrayTextColor font:self.font numberOfLines:1 frame:CGRectMake(0, 0, 50, self.sl_height) superview:nil];
    rightLabel.sl_width = [rightLabel textWidth] + 6;
    self.rightView = rightLabel;
}

@end
