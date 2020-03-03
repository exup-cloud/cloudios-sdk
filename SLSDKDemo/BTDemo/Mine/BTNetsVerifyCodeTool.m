//
//  BTNetsVerifyCodeTool.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTNetsVerifyCodeTool.h"
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface BTNetsVerifyCodeTool ()<NTESVerifyCodeManagerDelegate>

@property(nonatomic, strong) NTESVerifyCodeManager *manager;

@end

@implementation BTNetsVerifyCodeTool

+ (instancetype)defaultNetsVerifyCodeTool {
    static BTNetsVerifyCodeTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        instance.manager = [NTESVerifyCodeManager getInstance];
    });
    return instance;
}

- (void)showNetsVerifyCodeOnView:(UIView *)view {
    if (self.manager) {
        self.manager.delegate = self;
        NSString *captchaid = @"44d4d523f10440c89d373aee03bd7aeb";
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        // 设置语言
//        if ([[[BTLanguageTool sharedInstance] getCurrentLanguage] isEqualToString:EN]) {
//            self.manager.lang = NTESVerifyCodeLangEN;
//        } else {
            self.manager.lang = NTESVerifyCodeLangCN;
//        }
        // 设置透明度
        self.manager.alpha = 0.3;
        // 设置颜色
        self.manager.color = DARK_BARKGROUND_COLOR;
        // 设置frame
        self.manager.frame = CGRectNull;
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    SLLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    SLLog(@"收到初始化失败的回调:%@",message);
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message {
    if (self.validateFinish) {
        self.validateFinish(result, validate, message);
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow {
    //用户关闭验证后执行的方法
    if (self.cancelVerifyCode) {
        self.cancelVerifyCode();
    }
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    SLLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}


@end
