//
//  BTIndexDetailView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/1.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTIndexDetailView.h"
#import "BTOrderViewInfoView.h"

@interface BTIndexDetailView ()
@property (nonatomic, copy) NSString *headerStr;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UILabel *headerLabel;
@end

@implementation BTIndexDetailView

- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number hasHeader:(NSString *)header {
    if (self = [super initWithFrame:frame]) {
        self.headerStr = header;
        self.number = number;
        [self addChileViews];
    }
    return self;
}

- (void)addChileViews {
    self.backgroundColor = MAIN_COLOR;
    CGFloat top = SL_MARGIN;
    if (self.headerStr) {
        self.headerLabel.text = self.headerStr;
        top = CGRectGetMaxY(self.headerLabel.frame) + SL_MARGIN * 0.5;
    }
    for (int i = 0; i < self.number; i++) {
        BTOrderViewInfoView *viewInfo = [self createInfoViewWithframe:CGRectMake(SL_MARGIN, top + i * SL_getWidth(35), SL_SCREEN_WIDTH - SL_MARGIN * 2, SL_getWidth(35))];
        [self.viewArray addObject:viewInfo];
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    for (int i = 0 ; i < self.number; i++) {
        NSDictionary *dict = dataArr[i];
        BTOrderViewInfoView *viewInfo = self.viewArray[i];
        NSString *title = dict[@"first"];
        NSString *content = dict[@"last"];
        NSString *unit = dict[@"unit"];
        viewInfo.color = MAIN_COLOR;
        [viewInfo loadInfoWithTitle:title mainColor:MAIN_GARY_TEXT_COLOR number:content numColor:MAIN_GARY_TEXT_COLOR endLabel:unit];
    }
}

#pragma mark - 控件
- (BTOrderViewInfoView *)createInfoViewWithframe:(CGRect)frame {
    BTOrderViewInfoView *infoView = [[BTOrderViewInfoView alloc] initWithFrame:frame];
    [self addSubview:infoView];
    infoView.backgroundColor = MAIN_COLOR;
    return infoView;
}

- (NSMutableArray *)viewArray {
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray arrayWithCapacity:self.number];
    }
    return _viewArray;
}

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN, SL_MARGIN, SL_SCREEN_WIDTH * 0.5, SL_getWidth(20))];
        _headerLabel.textColor = GARY_BG_TEXT_COLOR;
        _headerLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_headerLabel];
    }
    return _headerLabel;
}

@end
