//
//  BTHorScreenListView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/1/8.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import "BTHorScreenListView.h"
#import "UILabel+BTCreate.h"
#import "UIButton+Extension.h"

@interface BTHorScreenListView ()
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *dupLabel;
@property (nonatomic, strong) NSArray *mainBtnArr;
@property (nonatomic, strong) NSArray *dupBtnArr;
@property (nonatomic, strong) NSArray *dupTitleArr;
@property (nonatomic, strong) UILabel *volLabel;
@property (nonatomic, strong) UIButton *targetBtn;
@property (nonatomic, strong) NSArray *mainTitleArr;
@end

@implementation BTHorScreenListView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    CGFloat height = self.sl_height / 13.0;
    self.mainLabel = [UILabel createLabelWithBackgroundColor:DARK_BARKGROUND_COLOR textColor:MAIN_BTN_COLOR font:14 line:1];
    [self addSubview:self.mainLabel];
    self.mainLabel.frame = CGRectMake(0, 0, self.sl_width, height);
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.mainLabel.text = @"主图";
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonExtensionWithTitle:self.mainTitleArr[i] TitleColor:GARY_BG_TEXT_COLOR backgroundImage:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(didClickMainTargetBtn:) forControlEvents:UIControlEventTouchUpInside];
         [btn setTitleColor:MAIN_BTN_TITLE_COLOR forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, CGRectGetMaxY(self.mainLabel.frame)+i*height, self.sl_width, height);
        btn.tag = i;
        [self addSubview:btn];
        [arrM addObject:btn];
    }
    self.mainBtnArr = arrM;
    self.dupLabel = [UILabel createLabelWithBackgroundColor:DARK_BARKGROUND_COLOR textColor:MAIN_BTN_COLOR font:14 line:1];
    self.dupLabel.frame = CGRectMake(0, CGRectGetMaxY(self.mainLabel.frame) + height * 4, self.sl_width, height);
    self.dupLabel.text = @"副图";
    self.dupLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dupLabel];
    
    self.volLabel = [UILabel createLabelWithBackgroundColor:DARK_BARKGROUND_COLOR textColor:MAIN_GARY_TEXT_COLOR font:13 line:1];
    self.volLabel.textAlignment = NSTextAlignmentCenter;
    self.volLabel.text = @"VOL";
    self.volLabel.frame = CGRectMake(0, CGRectGetMaxY(self.dupLabel.frame), self.sl_width, height);
    [self addSubview:self.volLabel];
    NSMutableArray *arrMB = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [UIButton buttonExtensionWithTitle:self.dupTitleArr[i] TitleColor:GARY_BG_TEXT_COLOR backgroundImage:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(didClickDupTargetBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:MAIN_BTN_TITLE_COLOR forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, CGRectGetMaxY(self.volLabel.frame)+i*height, self.sl_width, height);
        btn.tag = i;
        [self addSubview:btn];
        [arrMB addObject:btn];
    }
    self.dupBtnArr = arrMB.copy;
}

#pragma mark - action

- (void)didClickMainTargetBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(horScreenListViewDidClickMainType:andIndex:)]) {
        [self.delegate horScreenListViewDidClickMainType:0 andIndex:sender.tag - 1];
    }
}

- (void)didClickDupTargetBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(horScreenListViewDidClickMainType:andIndex:)]) {
        [self.delegate horScreenListViewDidClickMainType:1 andIndex:sender.tag-1];
    }
}

#pragma mark - 对外接口

- (void)setMainTargetType:(NSInteger)type {
    for (UIButton *btn in self.mainBtnArr) {
        if (btn.tag == type) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)setDupliTargetType:(NSInteger)type {
    for (UIButton *btn in self.dupBtnArr) {
        if (btn.tag == type) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (NSArray *)mainTitleArr {
    if (_mainTitleArr == nil) {
        _mainTitleArr = @[@"MA",@"EMA",@"BOLL",@"SAR"];
    }
    return _mainTitleArr;
}

- (NSArray *)dupTitleArr {
    if (_dupTitleArr == nil) {
        _dupTitleArr = @[@"MACD",@"KDJ",@"RSI",@"WR",@"MTM",@"CCI"];
    }
    return _dupTitleArr;
}

@end
