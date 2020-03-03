//
//  BTDefinePickView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2019/4/9.
//  Copyright © 2019年 Karl. All rights reserved.
//

#import "BTDefinePickView.h"
#import "UILabel+BTCreate.h"

@interface BTDefinePickView ()
@property (nonatomic, assign) NSInteger type; // 1.顶部; 2.底部
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSMutableArray *btnItemArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BTDefinePickView

- (instancetype)initWithItems:(NSArray *)items frame:(CGRect)frame type:(NSInteger)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.items = items;
        [self addChildViewsWithFrame];
    }
    return self;
}

- (void)addChildViewsWithFrame {
    if (self.type == 1) {
        self.backgroundColor = [DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.7];
        CGFloat height;
        if (self.items.count > 5) {
            height = SL_getWidth(300);
        } else {
            height = self.items.count * SL_getWidth(50);
        }
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SL_SCREEN_HEIGHT - SL_getWidth(65) - height, SL_SCREEN_WIDTH, height)];
        [self addSubview:self.scrollView ];
        self.cancelBtn.frame = CGRectMake(0 , SL_SCREEN_HEIGHT - SL_getWidth(60), SL_SCREEN_WIDTH, SL_getWidth(50));
        self.titleLabel.frame = CGRectMake(0, self.scrollView.sl_y - SL_getWidth(50), SL_SCREEN_WIDTH, SL_getWidth(50));
    } else if (self.type == 2) {
        CGFloat height;
        if (self.items.count > 5) {
            height = SL_getWidth(300);
        } else {
            height = self.items.count * SL_getWidth(50);
        }
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, height)];
        self.cancelBtn.frame = CGRectMake(0 , CGRectGetMaxY(self.scrollView.frame), SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT - CGRectGetMaxY(self.scrollView.frame));
        self.scrollView.bounces = NO;
        [self.cancelBtn setTitle:@"" forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundColor:[DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.4]];
        [self addSubview:self.scrollView];
        if (self.items.count > 5) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentSize = CGSizeMake(SL_SCREEN_WIDTH, self.items.count * SL_getWidth(50));
        } else {
            self.scrollView.scrollEnabled = NO;
        }
    }
    for (int i = 0; i < self.items.count; i++) {
        NSString *title = self.items[i];
        UIButton *btn = [self createBtnWithTitle:title tag:i];
        [self.btnItemArr addObject:btn];
        btn.frame = CGRectMake(0, SL_getWidth(50) * i, self.sl_width, SL_getWidth(50));
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDefaultItem:(NSString *)defaultItem {
    _defaultItem = defaultItem;
    for (UIButton *btn in self.btnItemArr) {
        if ([btn.titleLabel.text isEqualToString:defaultItem]) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

#pragma mark - action

- (void)didClickItemBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(definePickViewDidClickBtnItem:pickView:)]) {
        [self.delegate definePickViewDidClickBtnItem:sender.tag pickView:self];
    }
}

#pragma mark - lazy

- (NSArray *)items {
    if (_items == nil) {
        _items = [NSArray array];
    }
    return _items;
}

- (NSMutableArray *)btnItemArr {
    if (_btnItemArr == nil) {
        _btnItemArr = [NSMutableArray array];
    }
    return _btnItemArr;
}

- (UIButton *)createBtnWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setBackgroundColor:MAIN_COLOR];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = DARK_BARKGROUND_COLOR.CGColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(didClickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    return btn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.tag = 10001;
        [_cancelBtn setBackgroundColor:MAIN_COLOR];
        _cancelBtn.layer.borderWidth = 0.5;
        _cancelBtn.layer.borderColor = DARK_BARKGROUND_COLOR.CGColor;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:MAIN_GARY_TEXT_COLOR forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
        [_cancelBtn addTarget:self action:@selector(didClickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = MAIN_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = GARY_BG_TEXT_COLOR;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark - 对外接口

- (void)didViewDismissPickView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end
