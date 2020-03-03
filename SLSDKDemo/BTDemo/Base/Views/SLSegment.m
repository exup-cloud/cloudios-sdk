//
//  SLSegment.m
//  BTTestChart
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018 Karl. All rights reserved.
//

#import "SLSegment.h"

@interface SLSegment ()
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIView * indicatorLine;
@property (nonatomic, strong) UIButton * selectedSegmentButton;
@property (nonatomic, copy) void (^leftSegmentAction)(void);
@property (nonatomic, copy) void (^rightSegmentAction)(void);

@property (nonatomic, copy) void (^segmentAction)(UIButton *,NSInteger index);
@property (nonatomic, strong) UIFont *font;
@end

static CGFloat const segmentHeight = 60;

@implementation SLSegment

- (instancetype)initWithTitles:(NSArray *)titles height:(CGFloat)height didClickAction:(void(^)(UIButton *,NSInteger))segmentAction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, height > 0 ? height : segmentHeight)])  {
        self.backgroundColor = MAIN_COLOR;
        CGFloat maxX = 0;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self segmentButtonWithTitle:titles andIndex:i];
            [self addSubview:button];
            [self.titlesArr addObject:button];
            maxX = button.sl_maxX;
        }
        self.showsHorizontalScrollIndicator = NO;
        self.segmentAction = segmentAction;
        self.topLine.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, 0.5);
        self.bottomLine.frame = CGRectMake(0, (height > 0 ? height : segmentHeight) - 0.5, SL_SCREEN_WIDTH, 0.5);
        [self addSubview:self.indicatorLine];
        [self didClickSegmentAction:self.titlesArr[0]];
        self.contentSize = CGSizeMake(maxX, 0);
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *,NSInteger))segmentAction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, height > 0 ? height : segmentHeight)])  {
        self.font = font;
        self.backgroundColor = MAIN_COLOR;
        CGFloat maxX = 0;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self segmentButtonWithTitle:titles andIndex:i];
            button.tag = i;
            [self addSubview:button];
            [self.titlesArr addObject:button];
            maxX = button.sl_maxX;
        }
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(maxX, 0);
        self.segmentAction = segmentAction;
        [self addSubview:self.indicatorLine];
        if (self.titlesArr.count > 0) {
            [self didClickSegmentAction:self.titlesArr[0]];
        }
        if (self.titlesArr.count > 4) {
            self.contentSize = CGSizeMake(self.titlesArr.count * (SL_SCREEN_WIDTH /4), height);
            self.showsHorizontalScrollIndicator = NO;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles height:(CGFloat)height font:(UIFont *)font didClickAction:(void(^)(UIButton *,NSInteger))segmentAction {
    if (self = [super initWithFrame:frame])  {
        self.font = font;
        self.backgroundColor = MAIN_COLOR;
        CGFloat maxX = 0;
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self segmentButtonWithTitle:titles andIndex:i];
            [self addSubview:button];
            [self.titlesArr addObject:button];
            maxX = button.sl_maxX;
        }
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(maxX, 0);
        self.segmentAction = segmentAction;
        [self addSubview:self.indicatorLine];
        [self didClickSegmentAction:self.titlesArr[0]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topLine.frame = CGRectMake(0, 0, self.sl_width, 0.5);
    self.bottomLine.frame = CGRectMake(0, (self.sl_height > 0 ? self.sl_height : segmentHeight) - 0.5, self.sl_width, 0.5);
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self didClickSegmentAction:self.titlesArr[selectedIndex]];
}

- (void)didClickSegmentAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (sender.selected) {
        return;
    }
    self.selectedSegmentButton.selected = NO;
    sender.selected = YES;
    self.selectedSegmentButton = sender;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.indicatorLine.sl_centerX = sender.sl_centerX;
    }];
    if (self.segmentAction) {
        self.segmentAction(sender,sender.tag);
    }
}

- (UIButton *)segmentButtonWithTitle:(NSArray *)titles andIndex:(NSInteger)index {
    UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (titles.count <= 4) {
        segmentBtn.frame = CGRectMake((self.sl_width/titles.count) * index, 0, self.sl_width/titles.count, self.sl_height);
    } else {
        segmentBtn.frame = CGRectMake((self.sl_width/4) * index, 0, self.sl_width/4, self.sl_height);
    }
    [segmentBtn setTitle:titles[index] forState:UIControlStateNormal];
    [segmentBtn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
    [segmentBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    [segmentBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected | UIControlStateHighlighted];
    segmentBtn.tag = index;
    if (self.font) {
        segmentBtn.titleLabel.font = self.font;
    } else {
         segmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    [segmentBtn addTarget:self action:@selector(didClickSegmentAction:) forControlEvents:UIControlEventTouchUpInside];
    return segmentBtn;
}

- (UIView *)indicatorLine {
    if (_indicatorLine == nil) {
        _indicatorLine = [[UIView alloc] init];
        _indicatorLine.frame = CGRectMake(15, SL_getWidth(40) - 2,(self.sl_width / self.titlesArr.count) * 0.7, 2);
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

- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = DARK_BARKGROUND_COLOR;
        [self addSubview:_topLine];
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = DARK_BARKGROUND_COLOR;
         [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

@end
