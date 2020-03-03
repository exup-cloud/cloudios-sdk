//
//  BTDetailLabel.m
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTDetailLabel.h"

@interface BTDetailLabel ()

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL hasButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberlabel;
@property (nonatomic, strong) UIButton *tipsButton;
@end

@implementation BTDetailLabel

- (instancetype)initWithFrame:(CGRect)frame andType:(NSUInteger)type {
    BTDetailLabel * detailLabel = [self initWithFrame:frame];
    [self addChildViewsWithType:type];
    return detailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame hasButton:(BOOL)hasButton {
    BTDetailLabel * detailLabel = [self initWithFrame:frame];
    [self addChildWithHasButton:hasButton];
    return detailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.numberlabel];
    }
    return self;
}

- (void)setNameColor:(UIColor *)nameColor {
    _nameColor = nameColor;
    self.nameLabel.textColor = nameColor;
}

- (void)setNumberColor:(UIColor *)numberColor {
    _numberColor = numberColor;
    self.numberlabel.textColor = numberColor;
}

- (void)setNumber:(NSString *)number {
    _number = number;
    self.numberlabel.text = number;
}

- (void)addChildWithHasButton:(BOOL)hasButton {
    self.type = 10001;
    self.hasButton = hasButton;
    self.backgroundColor = MAIN_COLOR;
}

- (void)addChildViewsWithType:(NSUInteger)type {
    self.type = type;
    [self addSubview:self.nameLabel];
    [self addSubview:self.numberlabel];
    if (type == 1) {
        self.nameLabel.frame = CGRectMake(0, SL_MARGIN * 0.5, self.sl_width, self.sl_height * 0.5 - SL_MARGIN * 0.5);
        self.numberlabel.frame = CGRectMake(0, self.sl_height * 0.5, self.sl_width, self.sl_height * 0.5 - SL_MARGIN * 0.5);
        self.backgroundColor = [UIColor clearColor];
    } else if (type == 2) {
        self.nameLabel.frame = CGRectMake(0, 0, self.sl_width * 0.42, self.sl_height);
        self.numberlabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + SL_MARGIN * 0.5, 0, self.sl_width - CGRectGetMaxX(self.nameLabel.frame) - SL_MARGIN * 0.5, self.sl_height);
        self.numberlabel.textAlignment = NSTextAlignmentRight;
        self.backgroundColor = DARK_BARKGROUND_COLOR;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height - 1, self.sl_width, 1)];
        line.backgroundColor = MAIN_LINE;
        [self addSubview:line];
    } else if (type == 3) {
        self.nameLabel.frame = CGRectMake(0, 0, self.sl_width * 0.4, self.sl_height);
        self.numberlabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + SL_MARGIN * 0.5, 0, self.sl_width - CGRectGetMaxX(self.nameLabel.frame) - SL_MARGIN * 0.5, self.sl_height);
//        self.numberlabel.textAlignment = NSTextAlignmentRight;
        self.backgroundColor = DARK_BARKGROUND_COLOR;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.numberlabel.font = font;
}

- (void)setNameFont:(UIFont *)nameFont {
    _nameFont = nameFont;
    self.nameLabel.font = nameFont;
}

- (void)setName:(NSString *)name andNumber:(NSString *)number {
    self.nameLabel.text = name?name:@"--";
    self.numberlabel.text = number?number:@"--";
}

- (void)setAlignment:(NSTextAlignment)alignment {
    self.nameLabel.textAlignment = alignment;
    self.numberlabel.textAlignment = alignment;
}

- (void)layoutSubviews {
    if (self.type == 10001) {
        self.numberlabel.frame = CGRectMake(0, self.sl_height - SL_getWidth(20), self.sl_width, SL_getWidth(20));
        if (self.hasButton) {
            [self.nameLabel sizeToFit];
            self.nameLabel.sl_height = self.sl_height - SL_getWidth(20);
            self.nameLabel.sl_x = 0;
            self.tipsButton.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + SL_MARGIN * 0.5, 0, SL_getWidth(20), SL_getWidth(20));
            self.tipsButton.sl_centerY = self.nameLabel.sl_centerY;
            [self addSubview:self.tipsButton];
        } else {
            self.nameLabel.frame = CGRectMake(0, 0, self.sl_width, self.sl_height - SL_getWidth(20));
            self.numberlabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), self.sl_width, SL_getWidth(20));
        }
    } else if (self.type == 1) {
        self.nameLabel.frame = CGRectMake(0, SL_MARGIN * 0.5, self.sl_width, self.sl_height * 0.5 - SL_MARGIN * 0.5);
        self.numberlabel.frame = CGRectMake(0, self.sl_height * 0.5, self.sl_width, self.sl_height * 0.5 - SL_MARGIN * 0.5);
        self.backgroundColor = [UIColor clearColor];
    } else if (self.type == 2 ){
        self.nameLabel.frame = CGRectMake(0, 0, self.sl_width * 0.42, self.sl_height);
        self.numberlabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + SL_MARGIN * 0.3, 0, self.sl_width - CGRectGetMaxX(self.nameLabel.frame) - SL_MARGIN * 0.5, self.sl_height);
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        self.numberlabel.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = MAIN_COLOR;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sl_height - 1, self.sl_width, 1)];
        line.backgroundColor = MAIN_LINE;
        [self addSubview:line];
    } else if (self.type == 3) {
        self.nameLabel.frame = CGRectMake(0, 0, self.sl_width * 0.42, self.sl_height);
        self.numberlabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + SL_MARGIN * 0.3, 0, self.sl_width - CGRectGetMaxX(self.nameLabel.frame) - SL_MARGIN * 0.5, self.sl_height);
        self.numberlabel.textAlignment = NSTextAlignmentRight;
    }
    if (self.isDetail) {
        [self.tipsButton setImage:[UIImage imageWithName:@"icon-Q"] forState:UIControlStateNormal];
    }
}

#pragma mark - action

- (void)didClickTispBtn {
    if ([self.delegate respondsToSelector:@selector(detailLabelDidClickTipsWith:)]) {
        [self.delegate detailLabelDidClickTipsWith:self];
    }
}


#pragma mark - UI

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, self.sl_height - SL_getWidth(20))];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textColor = GARY_BG_TEXT_COLOR;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)numberlabel {
    if (_numberlabel == nil) {
        _numberlabel = [[UILabel alloc] init];
        _numberlabel.font = [UIFont systemFontOfSize:12];
        _numberlabel.textColor = MAIN_GARY_TEXT_COLOR;
        _numberlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_numberlabel];
    }
    return _numberlabel;
}

- (UIButton *)tipsButton {
    if (_tipsButton == nil) {
        _tipsButton = [[UIButton alloc] init];
        [_tipsButton setImage:[UIImage imageWithName:@"icon-Q-white"] forState:UIControlStateNormal];
        [_tipsButton addTarget:self action:@selector(didClickTispBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipsButton;
}

@end
