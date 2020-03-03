//
//  BTMarketHeaderView.m
//  SLContractSDK
//
//  Created by WWLy on 2019/8/14.
//  Copyright © 2019 Karl. All rights reserved.
//

#import "BTMarketHeaderView.h"

@implementation BTMarketHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = DARK_BARKGROUND_COLOR;
    
    UILabel *nameLabel = [UILabel labelWithText:Launguage(@"BT_MK") textAlignment:NSTextAlignmentLeft textColor:GARY_BG_TEXT_COLOR font:[UIFont systemFontOfSize:15] numberOfLines:1 frame:CGRectMake(70, 0, 60, self.sl_height) superview:self];
    
    UIButton *currentPriceButton = [UIButton buttonExtensionWithTitle:Launguage(@"str_last") TitleColor:GARY_BG_TEXT_COLOR Image:nil font:[UIFont systemFontOfSize:15] target:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    currentPriceButton.frame = CGRectMake(nameLabel.sl_maxX + 40, nameLabel.sl_y, 60, nameLabel.sl_height);
    [currentPriceButton addTarget:self action:@selector(currentPriceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:currentPriceButton];
    
    UIButton *gainButton = [UIButton buttonExtensionWithTitle:Launguage(@"BT_MAR_CH") TitleColor:GARY_BG_TEXT_COLOR Image:nil font:[UIFont systemFontOfSize:15] target:self action:@selector(gainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    gainButton.frame = CGRectMake(self.sl_width - 120, currentPriceButton.sl_y, 90, currentPriceButton.sl_height);
    [self addSubview:gainButton];
}


/// 点击当前价格
- (void)currentPriceButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.currentSortType = BTSortTypePriceAscending;
    } else {
        self.currentSortType = BTSortTypePriceDescending;
    }
    if ([self.delegate respondsToSelector:@selector(headerView_sortTypeChanged:)]) {
        [self.delegate headerView_sortTypeChanged:self.currentSortType];
    }
}

/// 点击涨跌幅
- (void)gainButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.currentSortType = BTSortTypeGainAscending;
    } else {
        self.currentSortType = BTSortTypeGainDescending;
    }
    if ([self.delegate respondsToSelector:@selector(headerView_sortTypeChanged:)]) {
        [self.delegate headerView_sortTypeChanged:self.currentSortType];
    }
}

@end
