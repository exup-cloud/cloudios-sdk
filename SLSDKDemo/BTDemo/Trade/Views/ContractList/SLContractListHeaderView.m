//
//  SLContractListHeaderView.m
//  BTTest
//
//  Created by WWLy on 2019/9/6.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractListHeaderView.h"

@interface SLContractListHeaderView ()

@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, weak) UIButton * currentSelectedButton;

@end

@implementation SLContractListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    NSArray *titleArray = @[Launguage(@"TD_OP_OR"), Launguage(@"ME_OR_HI"), Launguage(@"str_planOrder"), Launguage(@"str_holdings_now")];
    int i = 0;
    CGFloat w = self.sl_width / titleArray.count;
    for (NSString *title in titleArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(w * i, 0, w, self.sl_height);
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        [button setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
        [button setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            button.selected = YES;
            self.currentSelectedButton = button;
            self.lineView.sl_width = button.sl_width;
            self.lineView.sl_centerX = button.sl_centerX;
        }
        ++i;
    }
}

- (void)buttonClick:(UIButton *)sender {
    if (self.currentSelectedButton == sender) {
        return;
    }
    
    self.currentSelectedButton.selected = NO;
    sender.selected = YES;
    self.currentSelectedButton = sender;
    
    if ([self.delegate respondsToSelector:@selector(headerView_buttonClick:)]) {
        if (sender.tag == 0) {
            [self.delegate headerView_buttonClick:SLContractListTypeCurrent];
        } else if (sender.tag == 1) {
            [self.delegate headerView_buttonClick:SLContractListTypeHistory];
        } else if (sender.tag == 2) {
            [self.delegate headerView_buttonClick:SLContractListTypePlanCurrent];
        } else if (sender.tag == 3) {
            [self.delegate headerView_buttonClick:SLContractListTypeCurrentHave];
        }
    }
    
    self.lineView.sl_width = sender.sl_width;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.sl_centerX = sender.sl_centerX;
    }];
}


#pragma mark - lazy load

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height - 2, 60, 2)];
        _lineView.layer.cornerRadius = 2;
        _lineView.backgroundColor = [SLConfig defaultConfig].blueTextColor;
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
