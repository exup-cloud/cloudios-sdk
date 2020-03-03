//
//  BTKLineSegment.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/1/7.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import "BTKLineSegment.h"

@interface BTKLineSegment ()
@property (nonatomic, copy) void (^segmentAction)(UIButton *,NSInteger index);
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) BOOL noFull;
@end

@implementation BTKLineSegment

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font noFull:(BOOL)noFull didClickAction:(void(^)(UIButton *,NSInteger))segmentAction {
    if (self = [super initWithFrame:frame])  {
        self.backgroundColor = MAIN_COLOR;
        self.noFull = noFull;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self segmentButtonWithTitle:titles andIndex:i];
            [self addSubview:button];
            [self.titlesArr addObject:button];
        }
//        self.moreBtn = [self segmentMoreBtnWithTag:titles.count];
        self.segmentAction = segmentAction;
        [self addSubview:self.indicatorLine];
        [self didClickSegmentAction:self.titlesArr[0]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *,NSInteger))segmentAction {
    if (self = [super initWithFrame:frame])  {
        self.backgroundColor = MAIN_COLOR;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self segmentButtonWithTitle:titles andIndex:i];
            [self addSubview:button];
            [self.titlesArr addObject:button];
        }
        self.moreBtn = [self segmentMoreBtnWithTag:titles.count];
        if (!self.noFull) {
            self.fullScreenBtn = [self segmentFullScreenBtnWithTag:titles.count + 1];
        }
        self.segmentAction = segmentAction;
        [self addSubview:self.indicatorLine];
        [self didClickSegmentAction:self.titlesArr[0]];
        [self addSubview:self.topView];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)setMoreTitle:(NSString *)moreTitle {
    _moreTitle = moreTitle;
    if (moreTitle) {
        self.selectedSegmentButton = self.moreBtn;
        [self.moreBtn setTitle:moreTitle forState:UIControlStateNormal];
        __weak BTKLineSegment *weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.indicatorLine.sl_centerX = weakSelf.moreBtn.sl_centerX;
        }];
        [self.moreBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
        for (UIButton *btn in self.titlesArr) {
            btn.selected = NO;
        }
    } else {
        [self.moreBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    if (!self.noFull) {
        if (index < 5) {
            for (UIButton *btn in self.titlesArr) {
                if (btn.tag == index) {
                    btn.selected = YES;
                    __weak BTKLineSegment *weakSelf = self;
                    [UIView animateWithDuration:0.1 animations:^{
                        weakSelf.indicatorLine.sl_centerX = btn.sl_centerX;
                    }];
                } else {
                    btn.selected = NO;
                }
            }
        } else {
            __weak BTKLineSegment *weakSelf = self;
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.indicatorLine.sl_centerX = weakSelf.moreBtn.sl_centerX;
            }];
        }
    } else {
        for (UIButton *btn in self.titlesArr) {
            if (btn.tag == index) {
                btn.selected = YES;
                __weak BTKLineSegment *weakSelf = self;
                [UIView animateWithDuration:0.1 animations:^{
                    weakSelf.indicatorLine.sl_centerX = btn.sl_centerX;
                }];
            } else {
                btn.selected = NO;
            }
        }
    }
}

#pragma mark - action

- (void)didClickSegmentAction:(UIButton *)sender {
    if (self.moreBtn.selected) {
        [self didClickMoreBtnAction:self.moreBtn];
    }
//    __weak BTKLineSegment *weakSelf = self;
    if (sender.selected) {
        return;
    }
    [self setSelectedIndex:sender.tag];
//    self.selectedSegmentButton.selected = NO;
//    sender.selected = YES;
    self.selectedSegmentButton = sender;
//    [UIView animateWithDuration:0.1 animations:^{
//        weakSelf.indicatorLine.sl_centerX = sender.sl_centerX;
//    }];
    if (self.segmentAction) {
        self.segmentAction(sender,sender.tag);
    }
}

- (void)didClickFullScreenBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(kLineSegmentDidClickFullScreenAction:)]) {
        [self.delegate kLineSegmentDidClickFullScreenAction:sender];
    }
}

- (void)didClickMoreBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(kLineSegmentDidClickMoreAction:)]) {
        [self.delegate kLineSegmentDidClickMoreAction:sender];
    }
}

#pragma mark - create

- (UIButton *)segmentButtonWithTitle:(NSArray *)titles andIndex:(NSInteger)index {
    UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.noFull) {
        segmentBtn.frame = CGRectMake(((self.sl_width)/titles.count) * index, 0, (self.sl_width)/titles.count, self.sl_height);
    } else {
        segmentBtn.frame = CGRectMake(((self.sl_width - SL_getWidth(100))/titles.count) * index, 0, (self.sl_width - SL_getWidth(100))/titles.count, self.sl_height);
    }
    [segmentBtn setTitle:titles[index] forState:UIControlStateNormal];
    [segmentBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [segmentBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    [segmentBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected | UIControlStateHighlighted];
    segmentBtn.tag = index;
    segmentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [segmentBtn addTarget:self action:@selector(didClickSegmentAction:) forControlEvents:UIControlEventTouchUpInside];
    return segmentBtn;
}

- (UIButton *)segmentMoreBtnWithTag:(NSInteger)tag {
    UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    segmentBtn.tag = 13;
    CGFloat w = self.noFull?SL_getWidth(100):SL_getWidth(50);
    segmentBtn.frame = CGRectMake(self.sl_width - SL_getWidth(100), 0, w, self.sl_height);
    [segmentBtn setTitle:@"更多" forState:UIControlStateNormal];
    segmentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [segmentBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [segmentBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    [segmentBtn setBackgroundImage:[UIImage imageWithName:@"icon-more_nor"] forState:UIControlStateNormal];
    [segmentBtn setBackgroundImage:[UIImage imageWithName:@"icon-more_sel"] forState:UIControlStateSelected];
    [segmentBtn addTarget:self action:@selector(didClickMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:segmentBtn];
    return segmentBtn;
}

- (UIButton *)segmentFullScreenBtnWithTag:(NSInteger)tag {
    UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    segmentBtn.frame = CGRectMake(self.sl_width - SL_getWidth(50), 0, SL_getWidth(50), self.sl_height);
    [segmentBtn setImage:[UIImage imageWithName:@"icon-full"] forState:UIControlStateNormal];
    [segmentBtn addTarget:self action:@selector(didClickFullScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:segmentBtn];
    return segmentBtn;
}

- (UIView *)indicatorLine {
    if (_indicatorLine == nil) {
        _indicatorLine = [[UIView alloc] init];
        NSInteger i = self.noFull?0:2;
        _indicatorLine.frame = CGRectMake(15, SL_getWidth(40) - 2,(self.sl_width / (self.titlesArr.count + i)) * 0.7, 2);
        _indicatorLine.backgroundColor = MAIN_BTN_COLOR;
    }
    return _indicatorLine;
}

- (NSMutableArray *)titlesArr {
    if (_titlesArr == nil) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height -1, self.sl_width, 1)];
        _bottomLine.backgroundColor = DARK_BARKGROUND_COLOR;
    }
    return _bottomLine;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 1)];
        _topView.backgroundColor = DARK_BARKGROUND_COLOR;
    }
    return _topView;
}
@end
