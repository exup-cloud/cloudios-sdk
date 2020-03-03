//
//  SLMarketDetailChartSegment.m
//  BTTest
//
//  Created by wwly on 2019/9/10.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMarketDetailChartSegment.h"

@interface SLMarketDetailChartSegment ()

@property (nonatomic, weak) SLSegmentButton * moreSegmentButton;
@property (nonatomic, strong) UIView * moreSegmentView;
@property (nonatomic, strong) UIView * indicatorLineView;

@property (nonatomic, weak) SLSegmentButton * currentSelectedButton;

@property (nonatomic, weak) NSArray * segmentButtonArray;

@end

@implementation SLMarketDetailChartSegment

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            // 判断触摸的位置是否存在自己的子控件，即便这个子控件超出了父视图的范围
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                for (UIView *subSubView in subView.subviews) {
                    CGPoint subPoint = [subSubView convertPoint:myPoint fromView:subView];
                    // 判断触摸的位置是否存在自己的子控件，即便这个子控件超出了父视图的范围
                    if (CGRectContainsPoint(subSubView.bounds, subPoint)) {
                        return subSubView;
                    }
                }
            }
        }
    }
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.indicatorLineView.sl_centerX = self.currentSelectedButton.sl_centerX;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSDictionary *> *)titles selectedDataType:(SLStockLineDataType)dataType {
    if (self = [super initWithFrame:frame]) {
        [self initUIWithTitles:titles selectedDataType:dataType];
        self.indicatorLineView.sl_centerX = self.currentSelectedButton.sl_centerX;
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    NSArray *titleArr = @[@{@"分时": @(SLStockLineDataTypeTimely)}, @{@"5分": @(SLStockLineDataTypeFiveMinutes)}, @{@"15分": @(SLStockLineDataTypeFifteenMinutes)}, @{@"60分": @(SLStockLineDataTypeOneHour)}, @{@"1天": @(SLStockLineDataTypeOneDay)}, @{@"更多": @(-1)}, @{@"": @(-1)}];
    int i = 0;
    CGFloat w = self.sl_width / titleArr.count;
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in titleArr) {
        SLSegmentButton *button = [SLSegmentButton buttonExtensionWithTitle:dict.allKeys.firstObject TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:13] target:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
        button.frame = CGRectMake(i * w, 0, w, self.sl_height);
        button.dataType = [dict.allValues.firstObject integerValue];
        [self insertSubview:button belowSubview:self.indicatorLineView];
        
        [mArr addObject:button];
        
        // 最后一个是展开为横屏的图片
        if (i == titleArr.count - 1) {
            [button setImage:[UIImage imageWithName:@"icon-full"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeToLandscapeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        // 倒数第二个是更多
        else if (i == titleArr.count - 2) {
            self.moreSegmentButton = button;
            [button addTarget:self action:@selector(showMoreSegmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(segmentDidClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // 默认选中 5 分
        if (i == 1) {
            button.selected = YES;
            self.currentSelectedButton = button;
        }
        ++i;
    }
    self.segmentButtonArray = mArr.copy;
}

- (void)initUIWithTitles:(NSArray <NSDictionary *> *)titles selectedDataType:(SLStockLineDataType)selectedDataType {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    int i = 0;
    CGFloat w = self.sl_width / titles.count;
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dict in titles) {
        SLSegmentButton *button = [SLSegmentButton buttonExtensionWithTitle:dict.allKeys.firstObject TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:13] target:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
        button.frame = CGRectMake(i * w, 0, w, self.sl_height);
        button.dataType = [dict.allValues.firstObject integerValue];
        [self insertSubview:button belowSubview:self.indicatorLineView];
        if (button.dataType == selectedDataType) {
            button.selected = YES;
            self.currentSelectedButton = button;
        }
        [mArr addObject:button];
        [button addTarget:self action:@selector(segmentDidClick:) forControlEvents:UIControlEventTouchUpInside];
        ++i;
    }
    self.segmentButtonArray = mArr.copy;
}


#pragma mark - Public

- (void)changeSelectedDataType:(SLStockLineDataType)dataType {
    for (SLSegmentButton *button in self.segmentButtonArray) {
        if (button.dataType == dataType) {
            button.selected = YES;
        }
    }
}


#pragma mark - Click Events

/// 选择不同的数据类型
- (void)segmentDidClick:(SLSegmentButton *)sender {
    self.currentSelectedButton.selected = NO;
    sender.selected = !sender.isSelected;
    self.currentSelectedButton = sender;
    [self.moreSegmentButton setTitle:@"更多" forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(chartSegment_segmentDidClick:)]) {
        self.indicatorLineView.sl_centerX = sender.sl_centerX;
        [self.delegate chartSegment_segmentDidClick:sender];
    }
}

/// 从更多中选择不同的数据类型
- (void)segmentDidClickFromMoreSegmentView:(SLSegmentButton *)sender {
    self.currentSelectedButton.selected = NO;
    self.moreSegmentButton.selected = YES;
    self.indicatorLineView.sl_centerX = self.moreSegmentButton.sl_centerX;
    self.currentSelectedButton = self.moreSegmentButton;
    self.moreSegmentView.hidden = YES;
    // 更新按钮文字
    [self.moreSegmentButton setTitle:sender.currentTitle forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(chartSegment_segmentDidClick:)]) {
        [self.delegate chartSegment_segmentDidClick:sender];
    }
}

/// 点击查看更多数据类型
- (void)showMoreSegmentButtonClick:(SLSegmentButton *)sender {
    [self.superview bringSubviewToFront:self];
//    self.indicatorLineView.sl_centerX = sender.sl_centerX;
//    sender.selected = YES;
    if (self.moreSegmentView.isHidden) {
        self.moreSegmentView.hidden = NO;
    } else {
        self.moreSegmentView.hidden = YES;
    }
}

/// 点击切换至横屏
- (void)changeToLandscapeButtonClick:(SLSegmentButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chartSegment_fullScreenClick)]) {
        [self.delegate chartSegment_fullScreenClick];
    }
}


#pragma mark - lazy laod

- (UIView *)moreSegmentView {
    if (_moreSegmentView == nil) {
        _moreSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height, self.sl_width, self.sl_height * 2)];
        _moreSegmentView.backgroundColor = self.backgroundColor;
        NSArray *titleArr = @[@{@"1分": @(SLStockLineDataTypeOneMinute)}, @{@"30分": @(SLStockLineDataTypeThirtyMinutes)}, @{@"2时": @(SLStockLineDataTypeTwoHours)}, @{@"4时": @(SLStockLineDataTypeFourHours)}, @{@"6时": @(SLStockLineDataTypeSixHours)}, @{@"12时": @(SLStockLineDataTypeTwelveHours)}, @{@"1周": @(SLStockLineDataTypeOneWeek)}];
        // 一行放 6 个
        int count = 6;
//        int lineCount = ceil(titleArr.count / count);
        CGFloat w = _moreSegmentView.sl_width / count;
        CGFloat h = self.sl_height;
        int col = 0;
        int row = 0;
        for (NSDictionary *dict in titleArr) {
            SLSegmentButton *button = [SLSegmentButton buttonExtensionWithTitle:dict.allKeys.firstObject TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:13] target:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[SLConfig defaultConfig].blueTextColor forState:UIControlStateSelected];
            if (col >= count) {
                row += 1;
                col = 0;
            }
            button.frame = CGRectMake(col * w, row * h, w, h);
            button.dataType = [dict.allValues.firstObject integerValue];
            [_moreSegmentView addSubview:button];
            [button addTarget:self action:@selector(segmentDidClickFromMoreSegmentView:) forControlEvents:UIControlEventTouchUpInside];
            col += 1;
        }
        _moreSegmentView.hidden = YES;
        [self addSubview:_moreSegmentView];
    }
    return _moreSegmentView;
}

- (UIView *)indicatorLineView {
    if (_indicatorLineView == nil) {
        _indicatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height - 2, 50, 2)];
        _indicatorLineView.layer.cornerRadius = 1;
        _indicatorLineView.backgroundColor = [SLConfig defaultConfig].blueTextColor;
        [self addSubview:_indicatorLineView];
    }
    return _indicatorLineView;
}

@end


@implementation SLSegmentButton

@end
