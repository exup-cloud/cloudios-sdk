//
//  BTMainButton.m
//  BTStore
//
//  Created by 健 王 on 2018/3/29.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTMainButton.h"

#define VALUE 0.5

@interface BTMainButton ()
@property (nonatomic, strong) UIImage *blueImage;
@property (nonatomic, strong) UIImage *grayImage;
@property (nonatomic, strong) UIImage *highImage;

@property (nonatomic, strong) UIImage *orangeImage;
@property (nonatomic, strong) UIImage *orangeHigh;

@property (nonatomic, strong) UIImage *cyanImage;
@property (nonatomic, strong) UIImage *cyanHigh;

@property (nonatomic, strong) UIImage *redImage;
@property (nonatomic, strong) UIImage *redHigh;
@end

@implementation BTMainButton

+ (instancetype)sbBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setSBImage];
    [mainBtn setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)openBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setOpenImage];
    [mainBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [mainBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)closeBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setCloseImage];
    [mainBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [mainBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)boardBtnWithBoardColor:(UIColor *)color Title:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = (BTMainButton *)[[UIButton alloc] init];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [mainBtn setTitleColor:MAIN_BTN_COLOR forState:UIControlStateNormal];
    [mainBtn setBackgroundColor:MAIN_COLOR];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (color) {
        mainBtn.layer.borderWidth = 1;
        mainBtn.layer.borderColor = color.CGColor;
    }
    mainBtn.layer.cornerRadius = 4;
    mainBtn.layer.masksToBounds = YES;
    return mainBtn;
}

+ (instancetype)buyBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
     [mainBtn setUpAttribute];
    [mainBtn setBuyImage];
    [mainBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [mainBtn setTitleColor:UP_WARD_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)sellBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setUpAttribute];
    [mainBtn setSellImage];
    [mainBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [mainBtn setTitleColor:DOWN_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)bbAccountWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setUpAttribute];
    [mainBtn setBackgroundImage:mainBtn.blueImage forState:UIControlStateSelected];
    [mainBtn setBackgroundImage:mainBtn.blueImage forState:UIControlStateHighlighted];
    [mainBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [mainBtn setTitleColor:GARY_BG_TEXT_COLOR forState:UIControlStateNormal];
    [mainBtn setTitleColor:MAIN_BTN_TITLE_COLOR forState:UIControlStateSelected];
    mainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    mainBtn.layer.cornerRadius = 2;
    mainBtn.layer.masksToBounds = YES;
    mainBtn.layer.borderWidth = 0.6;
    mainBtn.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)blueBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setBackImage];
    [mainBtn setUpAttribute];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    mainBtn.titleLabel.numberOfLines = 0;
    return mainBtn;
}

+ (instancetype)orangeBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setOrangeImage];
    [mainBtn setUpAttribute];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)cyanBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setCyanImage];
    [mainBtn setUpAttribute];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

+ (instancetype)redBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    BTMainButton *mainBtn = [[BTMainButton alloc] init];
    [mainBtn setRedImage];
    [mainBtn setUpAttribute];
    if (title) {
        [mainBtn setTitle:title forState:UIControlStateNormal];
    }
    if (target) {
        [mainBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return mainBtn;
}

- (instancetype)init {
    if (self = [super init]) {
//        [self setBackImage];
//        [self setUpAttribute];
    }
    return self;
}

- (void)setSBImage {
    [self setBackgroundImage:self.grayImage forState:UIControlStateNormal];
    [self setBackgroundImage:self.grayImage forState:UIControlStateDisabled];
    [self.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [self.layer setBorderWidth:0.8];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)setOpenImage {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [self.layer setBorderWidth:0.6];
    self.layer.cornerRadius = 1;
    self.layer.masksToBounds = YES;
}

- (void)setCloseImage {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self.layer setBorderColor:GARY_BG_TEXT_COLOR.CGColor];
    [self.layer setBorderWidth:0.6];
    self.layer.cornerRadius = 1;
    self.layer.masksToBounds = YES;
}


- (void)setBuyImage {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self.layer setBorderColor:UP_WARD_COLOR.CGColor];
    [self.layer setBorderWidth:0.8];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)setSellImage {
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self.layer setBorderColor:DOWN_COLOR.CGColor];
    [self.layer setBorderWidth:0.8];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

- (void)setBackImage {
    [self setBackgroundImage:self.blueImage forState:UIControlStateNormal];
    [self setBackgroundImage:self.highImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:self.grayImage forState:UIControlStateDisabled];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
}

- (void)setOrangeImage {
    [self setBackgroundImage:self.orangeImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:self.orangeHigh forState:UIControlStateNormal];
    [self setBackgroundImage:self.grayImage forState:UIControlStateDisabled];
}

- (void)setCyanImage {
    [self setBackgroundImage:self.cyanImage forState:UIControlStateNormal];
    [self setBackgroundImage:self.cyanHigh forState:UIControlStateHighlighted];
    [self setBackgroundImage:self.grayImage forState:UIControlStateDisabled];
}

- (void)setRedImage {
    [self setBackgroundImage:self.redImage forState:UIControlStateNormal];
    [self setBackgroundImage:self.redHigh forState:UIControlStateHighlighted];
    [self setBackgroundImage:self.grayImage forState:UIControlStateDisabled];
}

- (void)setUpAttribute {
    [self setTitleColor:MAIN_BTN_TITLE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}

- (UIImage *)redHigh {
    if (_redHigh == nil) {
        _redHigh = [UIImage imageWithName:@"cornersRed-highlight"];
        _redHigh = [_redHigh stretchableImageWithLeftCapWidth:_redHigh.size.width * VALUE topCapHeight:_redHigh.size.height * VALUE];
    }
    return _redHigh;
}

- (UIImage *)redImage {
    if (_redImage == nil) {
        _redImage = [UIImage imageWithName:@"cornersRed-normal"];
        _redImage = [_redImage stretchableImageWithLeftCapWidth:_redImage.size.width * VALUE topCapHeight:_redImage.size.height * VALUE];
    }
    return _redImage;
}

- (UIImage *)cyanHigh {
    if (_cyanHigh == nil) {
        _cyanHigh = [UIImage imageWithName:@"cornersGreen-highlight"];
        _cyanHigh = [_cyanHigh stretchableImageWithLeftCapWidth:_cyanHigh.size.width * VALUE topCapHeight:_cyanHigh.size.height * VALUE];
    }
    return _cyanHigh;
}

- (UIImage *)cyanImage {
    if (_cyanImage == nil) {
        _cyanImage = [UIImage imageWithName:@"cornersGreen-normal"];
        _cyanImage = [_cyanImage stretchableImageWithLeftCapWidth:_cyanImage.size.width * VALUE topCapHeight:_cyanImage.size.height * VALUE];
    }
    return _cyanImage;
}

- (UIImage *)orangeHigh {
    if (_orangeHigh == nil) {
        _orangeHigh = [UIImage imageWithName:@"cornersYellow-highlight"];
        _orangeHigh = [_orangeHigh stretchableImageWithLeftCapWidth:_orangeHigh.size.width * VALUE topCapHeight:_orangeHigh.size.height * VALUE];
    }
    return _orangeHigh;
}

- (UIImage *)orangeImage {
    if (_orangeImage == nil) {
        _orangeImage = [UIImage imageWithName:@"cornersYellow-normal"];
        _orangeImage = [_orangeImage stretchableImageWithLeftCapWidth:_orangeImage.size.width * VALUE topCapHeight:_orangeImage.size.height * VALUE];
    }
    return _orangeImage;
}


- (UIImage *)highImage {
    if (_highImage == nil) {
        _highImage = [UIImage imageWithName:@"cornersBule-highlight"];
        _highImage = [_highImage stretchableImageWithLeftCapWidth:_highImage.size.width * VALUE topCapHeight:_highImage.size.height * VALUE];
    }
    return _highImage;
}
- (UIImage *)blueImage {
    if (_blueImage == nil) {
        _blueImage = [UIImage imageWithName:@"cornersBule-normal"];
        _blueImage = [_blueImage stretchableImageWithLeftCapWidth:_blueImage.size.width * VALUE topCapHeight:_blueImage.size.height * VALUE];
    }
    return _blueImage;
}
- (UIImage *)grayImage {
    if (_grayImage == nil) {
        _grayImage = [UIImage imageWithName:@"cornersGray-disEnabled"];
        _grayImage = [_grayImage stretchableImageWithLeftCapWidth:_grayImage.size.width * VALUE topCapHeight:_grayImage.size.height * VALUE];
    }
    return _grayImage;
}


@end
