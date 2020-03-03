//
//  BTAssetPasswordView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/6/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTAssetPasswordView.h"
#import "BTMainButton.h"
//#import "BTPasswordTextView.h"

#define BTPASSWORD_LENGTH 6

@interface BTAssetPasswordView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel1;
@property (nonatomic, strong) UITextField *textView1;
@property (nonatomic, strong) UILabel *tipsLabel2;
@property (nonatomic, strong) UITextField *textView2;
@property (nonatomic, strong) BTMainButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BTAssetPasswordViewType type;

@property (nonatomic, copy) NSString *pwd1;
@property (nonatomic, copy) NSString *pwd2;

@end

@implementation BTAssetPasswordView

- (instancetype)initWithFrame:(CGRect)frame type:(BTAssetPasswordViewType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.backgroundColor = [DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.6];
        if (self.type == BTAssetPasswordSettingType) {
            [self settingPasswordUI];
        } else if (self.type == BTAssetPasswordVerifyType) {
            [self verifyPasswordUI];
        } else if (self.type == BTAssetPasswordGoogleType) {
            [self googleVerifyCodeUI];
        }
    }
    return self;
}

- (void)settingPasswordUI {
    __weak BTAssetPasswordView *weakSelf = self;
    self.mainView.frame = CGRectMake(SL_getWidth(25), 0, SL_SCREEN_WIDTH - SL_getWidth(50), SL_getWidth(290));
    self.mainView.center = CGPointMake(SL_SCREEN_WIDTH * 0.5, SL_SCREEN_HEIGHT * 0.45);
    self.titleLabel = [self createLabelWithTextColor:DARK_BARKGROUND_COLOR font:[UIFont systemFontOfSize:18]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 2, SL_getWidth(25));
    self.titleLabel.text = @"设置资金密码";
    self.cancelBtn.frame = CGRectMake(self.mainView.sl_width - SL_MARGIN - SL_getWidth(20), SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
    
    self.tipsLabel1 = [self createLabelWithTextColor:GARY_BG_TEXT_COLOR font:[UIFont systemFontOfSize:14]];
    self.tipsLabel1.frame = CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 0.5, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(25));
    self.tipsLabel1.text = @"设置6位资金密码，交易、提现更安全";
    self.textView1 = [[UITextField alloc] initWithFrame:CGRectMake(self.tipsLabel1.sl_x, CGRectGetMaxY(self.tipsLabel1.frame) + SL_MARGIN * 0.5, self.tipsLabel1.sl_width, SL_getWidth(50))];
//    self.textView1.elementCount = BTPASSWORD_LENGTH;
//    self.textView1.elementBorderColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.5];
    [self.mainView addSubview: self.textView1];
//    self.textView1.passwordDidChangeBlock = ^(NSString *password) {
//        SLLog(@"---%@",password);
//        weakSelf.pwd1 = password;
//    };
    
    self.tipsLabel2 = [self createLabelWithTextColor:GARY_BG_TEXT_COLOR font:[UIFont systemFontOfSize:14]];
    self.tipsLabel2.frame = CGRectMake(self.tipsLabel1.sl_x, CGRectGetMaxY(self.textView1.frame) + SL_MARGIN * 0.5, self.tipsLabel1.sl_width, self.tipsLabel1.sl_height);
    self.tipsLabel2.text = @"再次输入密码";
    self.textView2 = [[UITextField alloc] initWithFrame:CGRectMake( self.tipsLabel2.sl_x, CGRectGetMaxY(self.tipsLabel2.frame) + SL_MARGIN * 0.5, self.textView1.sl_width, self.textView1.sl_height)];
//    self.textView2.elementCount = BTPASSWORD_LENGTH;
//    self.textView2.elementBorderColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.5];
    [self.mainView addSubview: self.textView2];
//    self.textView2.passwordDidChangeBlock = ^(NSString *password) {
//        SLLog(@"---%@",password);
//        weakSelf.pwd2 = password;
//    };
    self.confirmBtn.frame = CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(self.textView2.frame) + SL_MARGIN, self.textView2.sl_width, SL_getWidth(50));
}

- (void)verifyPasswordUI {
    __weak BTAssetPasswordView *weakSelf = self;
    self.mainView.frame = CGRectMake(SL_getWidth(25), 0, SL_SCREEN_WIDTH - SL_getWidth(50), SL_getWidth(170));
    self.mainView.center = CGPointMake(SL_SCREEN_WIDTH * 0.5, SL_SCREEN_HEIGHT * 0.45);
    self.titleLabel = [self createLabelWithTextColor:DARK_BARKGROUND_COLOR font:[UIFont systemFontOfSize:18]];
    self.titleLabel.text = @"输入资金密码";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 2, SL_getWidth(25));
    self.cancelBtn.frame = CGRectMake(self.mainView.sl_width - SL_MARGIN - SL_getWidth(20), SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
    self.textView1 = [[UITextField alloc] initWithFrame:CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(50))];
//    self.textView1.elementCount = BTPASSWORD_LENGTH;
//    self.textView1.elementBorderColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.5];
    [self.mainView addSubview: self.textView1];
//    self.textView1.passwordDidChangeBlock = ^(NSString *password) {
//        SLLog(@"---%@",password);
//        weakSelf.pwd1 = password;
//        if (password.length == BTPASSWORD_LENGTH) {
//            if (weakSelf.type == BTAssetPasswordVerifyType) {
//                if ([weakSelf.delegate respondsToSelector:@selector(assetPasswordViewDidClickConfirmWithType:password:)]) {
//                    [weakSelf.delegate assetPasswordViewDidClickConfirmWithType:weakSelf.type password:weakSelf.pwd1];
//                }
//            }
//        }
//    };
    self.tipsLabel1 = [self createLabelWithTextColor:GARY_BG_TEXT_COLOR font:[UIFont systemFontOfSize:15]];
    self.tipsLabel1.text = @"密码有效时间:";
    [self.tipsLabel1 sizeToFit];
    self.tipsLabel1.sl_x = self.textView1.sl_x;
    self.tipsLabel1.sl_y = CGRectGetMaxY(self.textView1.frame) + SL_MARGIN;
    
    self.tipsLabel2 = [self createLabelWithTextColor:MAIN_BTN_COLOR font:[UIFont systemFontOfSize:15]];
    NSInteger effectTime = 0;
    switch (effectTime) {
        case 0:
            self.tipsLabel2.text = @"单次有效";
            break;
        case 60 * 15:
            self.tipsLabel2.text = @"15分钟有效";
            break;
        case 60 * 2 * 60:
            self.tipsLabel2.text = @"2小时有效";
            break;
        default:
            break;
    }
    [self.tipsLabel2 sizeToFit];
    self.tipsLabel2.sl_x = CGRectGetMaxX(self.tipsLabel1.frame) + SL_MARGIN * 0.5;
    self.tipsLabel2.sl_y = self.tipsLabel1.sl_y;
    self.tipsLabel2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabGesture:)];
    [self.tipsLabel2 addGestureRecognizer:tap];
}

- (void)googleVerifyCodeUI {
    __weak BTAssetPasswordView *weakSelf = self;
    self.mainView.frame = CGRectMake(SL_getWidth(25), 0, SL_SCREEN_WIDTH - SL_getWidth(50), SL_getWidth(170));
    self.mainView.center = CGPointMake(SL_SCREEN_WIDTH * 0.5, SL_SCREEN_HEIGHT * 0.45);
    self.titleLabel = [self createLabelWithTextColor:DARK_BARKGROUND_COLOR font:[UIFont systemFontOfSize:18]];
    self.titleLabel.text = @"请输入Google验证码";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(SL_MARGIN, SL_MARGIN * 2, self.mainView.sl_width - SL_MARGIN * 2, SL_getWidth(25));
    self.cancelBtn.frame = CGRectMake(self.mainView.sl_width - SL_MARGIN - SL_getWidth(20), SL_MARGIN, SL_getWidth(20), SL_getWidth(20));
    self.textView1 = [[UITextField alloc] initWithFrame:CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(self.titleLabel.frame) + SL_MARGIN * 2, self.mainView.sl_width - SL_getWidth(40), SL_getWidth(50))];
//    self.textView1.elementCount = BTPASSWORD_LENGTH;
//    self.textView1.elementBorderColor = [GARY_BG_TEXT_COLOR colorWithAlphaComponent:0.5];
    [self.mainView addSubview: self.textView1];
//    self.textView1.passwordDidChangeBlock = ^(NSString *password) {
//        SLLog(@"---%@",password);
//        weakSelf.pwd1 = password;
//        if (password.length == BTPASSWORD_LENGTH) {
//            if (weakSelf.type == BTAssetPasswordGoogleType) {
//                if ([weakSelf.delegate respondsToSelector:@selector(assetPasswordViewDidClickConfirmWithType:password:)]) {
//                    [weakSelf.delegate assetPasswordViewDidClickConfirmWithType:weakSelf.type password:weakSelf.pwd1];
//                }
//            }
//        }
//    };
    self.tipsLabel1 = [self createLabelWithTextColor:DOWN_COLOR font:[UIFont systemFontOfSize:15]];
    self.tipsLabel1.frame = CGRectMake(self.textView1.sl_x, CGRectGetMaxY(self.textView1.frame) + SL_MARGIN, self.textView1.sl_width, SL_getWidth(20));
    self.tipsLabel1.text = @"验证码错误，请重新输入";
    self.tipsLabel1.hidden = YES;
}

#pragma mark - action

- (void)tabGesture:(UITapGestureRecognizer *)recognizer {
    if (recognizer.view == self.tipsLabel2) {
        // 选择密码有效时长
    }
}

- (void)didClickConfirmBtn {
    if (![self.pwd1 isEqualToString:self.pwd2]) {
        self.tipsLabel2.text = @"两次输入的密码不相同";
        self.tipsLabel2.textColor = [UIColor redColor];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(assetPasswordViewDidClickConfirmWithType:password:)]) {
        [self.delegate assetPasswordViewDidClickConfirmWithType:self.type password:self.pwd1];
    }
}

- (void)didClickCancelBtn {
    if ([self.delegate respondsToSelector:@selector(assetPasswordViewDidClickCancel)]) {
        [self.delegate assetPasswordViewDidClickCancel];
    }
}

#pragma mark - lazy

- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 8;
        _mainView.layer.masksToBounds = YES;
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (BTMainButton *)confirmBtn {
    if (_confirmBtn == nil) {
        _confirmBtn = [BTMainButton blueBtnWithTitle:@"确认" target:self action:@selector(didClickConfirmBtn)];
        [self.mainView addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

- (UILabel *)createLabelWithTextColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    [self.mainView addSubview:label];
    return label;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [self.mainView addSubview:_cancelBtn];
        [_cancelBtn setImage:[UIImage imageWithName:@"icon-close2"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

#pragma mark - 对外接口
+ (void)showAssetPasswordViewToView:(UIView *)view delegate:(id<BTAssetPasswordViewDelegate>)delegate type:(BTAssetPasswordViewType)type {
    if (view) {
        BTAssetPasswordView *assetView = [[BTAssetPasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds type:type];
//        [assetView.textView1 showKeyboard];
        if ([delegate respondsToSelector:@selector(assetPasswordViewDidClickConfirmWithType:password:)]) {
            assetView.delegate = delegate;
        }
        [view addSubview:assetView];
    }
}

+ (void)hideAssetViewFromView:(UIView *)view {
    if (view) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:self]) {
                [subView removeFromSuperview];
                break;
            }
        }
    }
}

+ (void)showPasswordErrorFromView:(UIView *)view {
    if (view) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:self]) {
                BTAssetPasswordView *assetView = (BTAssetPasswordView *)subView;
                assetView.tipsLabel1.hidden = NO;
                break;
            }
        }
    }
}

@end
