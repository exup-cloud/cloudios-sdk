//
//  BTFuturesBottomHeaderView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/27.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTFuturesBottomHeaderView.h"

@implementation BTFuturesBottomHeaderView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    if (self = [super initWithFrame:frame]) {
        [self addSubViewsWithArray:titleArr];
    }
    return self;
}

- (void)addSubViewsWithArray:(NSArray *)titleArr {
    self.backgroundColor = DARK_BARKGROUND_COLOR;
    for (int i = 0; i < titleArr.count; i++) {
        NSString *title = titleArr[i];
        UILabel *label = [self createLabel];
        label.text = title;
        if (i != 0) {
            label.textAlignment = NSTextAlignmentRight;
        }
        label.frame = CGRectMake(SL_MARGIN + (self.sl_width - SL_MARGIN * 2) / titleArr.count * i, SL_MARGIN, (self.sl_width - SL_MARGIN * 2) / titleArr.count, 20);
    }
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = GARY_BG_TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    return label;
}

@end
