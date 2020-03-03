//
//  BTCreatedHeaderTipView.m
//  BTStore
//
//  Created by 健 王 on 2018/3/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTCreatedHeaderTipView.h"

#define CREATE_TIPS_COLOR [UIColor colorWithHex:@"#be944f"]

@interface BTCreatedHeaderTipView ()

@property (nonatomic, strong) UILabel *tips;
@end

@implementation BTCreatedHeaderTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [CREATE_TIPS_COLOR colorWithAlphaComponent:0.2];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = CREATE_TIPS_COLOR.CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupContent:(NSString *)content highStr:(NSArray *)array {
    if (content == nil) {
        return;
    }
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    for (NSString *redStr in array) {
        NSRange range = [content rangeOfString:redStr];
        if (range.location != NSNotFound) {
            [str addAttribute:NSForegroundColorAttributeName value:DOWN_COLOR range:range];
        }
    }
    self.tipsLabel.attributedText = str;
    CGFloat textH = [self.tipsLabel.text boundingRectWithSize:CGSizeMake(self.sl_width - SL_MARGIN * 3, self.sl_height - SL_MARGIN * 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                      context:nil].size.height;
    self.sl_height = SL_getWidth(textH + 20);
    self.tipsLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN, self.sl_width - SL_MARGIN *2, self.sl_height - SL_MARGIN * 2);
}

- (UILabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.textColor = CREATE_TIPS_COLOR;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 0;
        [self addSubview:_tipsLabel];
    }
    return _tipsLabel;
}

- (UILabel *)tips {
    if (_tips == nil) {
        _tips = [[UILabel alloc] init];
        _tips.backgroundColor = CREATE_TIPS_COLOR;
        _tips.textColor = [UIColor whiteColor];
        _tips.font = [UIFont systemFontOfSize:15];
        _tips.layer.cornerRadius = 2;
        _tips.layer.masksToBounds = YES;
        _tips.text = @"提示";
        _tips.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tips];
    }
    return _tips;
}

@end
