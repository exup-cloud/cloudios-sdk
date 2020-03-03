//
//  SLMineRecordHeaderView.m
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineRecordHeaderView.h"
#import "SLButton.h"

@interface SLMineRecordHeaderView ()

@property (nonatomic, strong) SLButton *coinBtn;
@property (nonatomic, strong) SLButton *typeBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end

@implementation SLMineRecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews {
    self.backgroundColor = MAIN_COLOR;
    self.coinBtn = [self createBtn];
    self.coinBtn.tag = 1;
    self.typeBtn = [self createBtn];
    self.typeBtn.tag = 2;
    
    self.coinBtn.frame = CGRectMake(0, 0, SL_getWidth(90), SL_getWidth(40));
    self.typeBtn.frame = CGRectMake(0, 0, SL_getWidth(90), SL_getWidth(40));
    
    self.coinBtn.sl_centerY = self.typeBtn.sl_centerY = self.sl_height * 0.5;
    self.coinBtn.sl_centerX = self.sl_width * 0.26;
    self.typeBtn.sl_centerX = self.sl_width * 0.74;
    
    self.line1 = [self createLine];
    self.line2 = [self createLine];
    self.line1.frame = CGRectMake(0, 0, self.sl_width, 1);
    self.line2.frame = CGRectMake(0, self.sl_height - 1, SL_SCREEN_WIDTH, 1);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coinBtn.frame = CGRectMake(0, 0, SL_getWidth(90), SL_getWidth(40));
    self.typeBtn.frame = CGRectMake(0, 0, SL_getWidth(90), SL_getWidth(40));
    
    self.coinBtn.sl_centerY = self.typeBtn.sl_centerY = self.sl_height * 0.5;
    self.coinBtn.sl_centerX = self.sl_width * 0.26;
    self.typeBtn.sl_centerX = self.sl_width * 0.74;
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    [self.coinBtn setTitle:leftStr forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    [self.typeBtn setTitle:rightStr forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)reset {
    self.coinBtn.selected = NO;
    self.typeBtn.selected = NO;
}

- (void)didClickBtn:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
    } else {
        sender.selected = YES;
        if (sender == self.coinBtn) {
            self.typeBtn.selected = NO;
        } else if (sender == self.typeBtn) {
            self.coinBtn.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(mineRecordsHeaderView_DidClick:)]) {
        if (self.coinBtn.selected) {
            [self.delegate mineRecordsHeaderView_DidClick:SLMineRecordHeaderTypeCoin];
        } else if (self.typeBtn.selected) {
            [self.delegate mineRecordsHeaderView_DidClick:SLMineRecordHeaderTypeRecordType];
        } else {
            [self.delegate mineRecordsHeaderView_DidClick:SLMineRecordHeaderTypeNone];
        }
    }
}

- (SLButton *)createBtn {
    SLButton * btn = [[SLButton alloc] initWithContentFrameType:BTTiTleLabelInFontType];
    [btn setImage:[UIImage imageWithName:@"btn-drop-down_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:@"btn-drop-down_sel"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    
    [self addSubview:btn];
    return btn;
}

- (UIView *)createLine {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = DARK_BARKGROUND_COLOR;
    [self addSubview:v];
    return v;
}

@end
