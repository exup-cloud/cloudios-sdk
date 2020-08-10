//
//  GT3Tool.m
//  GT3Example
//
//  Created by xue on 2018/11/5.
//  Copyright © 2018 Xniko. All rights reserved.
//

#import "GT3Tool.h"
#import "Chainup-Swift.h"
//网站主部署的用于验证登录的接口 (api_1)
//#define api_1 @"https://rd1appapi.chaindown.com/common/tartCaptcha"
//网站主部署的二次验证的接口 (api_2)
//#define api_2 @"https://rd1appapi.chaindown.com/user/login_in"

@interface GT3Tool()<GT3CaptchaManagerDelegate, GT3CaptchaButtonDelegate>

@end

@implementation GT3Tool

//+(id)allocWithZone:(NSZone *)zone{
//    return [GT3Tool sharedInstance];
//}
//+(GT3Tool *) sharedInstance{
//    static GT3Tool * s_instance_dj_singleton = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        s_instance_dj_singleton = [[super allocWithZone:nil] init];
//    });
//    return s_instance_dj_singleton;
//}
//-(id)copyWithZone:(NSZone *)zone{
//    return [GT3Tool sharedInstance];
//}
//-(id)mutableCopyWithZone:(NSZone *)zone{
//    return [GT3Tool sharedInstance];
//}
    
- (void)start{
    [self.captchaButton startCaptcha];
}
- (GT3CaptchaButton *)captchaButton {
    if (!_captchaButton) {
        //创建验证管理器实例
        
        
        GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:NetDefine.api_1  API2:nil timeout:5.0];
        captchaManager.delegate = self;
        captchaManager.maskColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
//        if ([BasicParameter isHan]){
            [captchaManager useLanguage:GT3LANGTYPE_ZH_CN];
//
//        }else{
//
            [captchaManager useLanguage:GT3LANGTYPE_EN];
//        }

        //debug mode
        //        [captchaManager enableDebugMode:YES];
        //创建验证视图的实例
        _captchaButton = [[GT3CaptchaButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40) captchaManager:captchaManager];
        NSMutableDictionary *mu = [NSMutableDictionary dictionary];
        
        NSString *inactive = @"";
        NSString *active = @"";
        NSString *initial = @"";
        NSString *waiting = @"";
        NSString *collecting = @"";
        NSString *computing = @"";
        NSString *success = @"";
        NSString *fail = @"";
        NSString *error = @"";
        NSString *cancel = @"";
//        waiting = @"智能检测中";
//        collecting = @"智能检测中";
//        computing = @"智能检测中";
//        waiting = @"Analysing...";
//        collecting = @"Analysing...";
//        computing = @"Analysing...";
        if ([BasicParameter isHan]){
            inactive = @"请点击按钮进行验证";
            active = @"请点击按钮进行验证";
            initial = @"请点击按钮进行验证";
            waiting = @"请点击按钮进行验证";
            collecting = @"请点击按钮进行验证";
            computing = @"请点击按钮进行验证";
            success = @"验证成功";
            fail = @"验证失败";
            error = @"验证错误";
            cancel = @"验证已取消";
            [captchaManager useLanguage:GT3LANGTYPE_ZH_CN];
        }else{
            
            inactive = @"Please click captcha button";
            active = @"Please click captcha button";
            initial = @"Please click captcha button";
            waiting = @"Please click captcha button";
            collecting = @"Please click captcha button";
            computing = @"Please click captcha button";
            success = @"Success";
            fail = @"Fail";
            error = @"Error";
            cancel = @"Cancel";
            [captchaManager useLanguage:GT3LANGTYPE_EN];

        }
        
        mu[@"inactive"] = [self generate:inactive fontSize:15 color:nil];
        mu[@"active"] = [self generate:active fontSize:15  color:nil];
        mu[@"initial"] = [self generate:initial fontSize:15  color:nil];
        mu[@"waiting"] = [self generate:waiting fontSize:15  color:nil];
        mu[@"collecting"] = [self generate:collecting fontSize:15  color:nil];
        mu[@"computing"] = [self generate:computing fontSize:15  color:nil];
        mu[@"success"] = [self generate:success fontSize:15  color:[UIColor colorWithRed:46/255.0 green:184/255.0 blue:88/255.0 alpha:1.0]];
        mu[@"fail"] = [self generate:fail fontSize:15  color:[UIColor colorWithRed:229/255.0 green:83/255.0 blue:71/255.0 alpha:1.0]];
        mu[@"error"] = [self generate:error fontSize:15  color:[UIColor colorWithRed:229/255.0 green:83/255.0 blue:71/255.0 alpha:1.0]];
        mu[@"cancel"] = [self generate:cancel fontSize:15 color:[UIColor colorWithRed:229/255.0 green:83/255.0 blue:71/255.0 alpha:1.0]];

        _captchaButton.tipsDict = mu;
    }
    return _captchaButton;
}
#pragma MARK - CaptchaButtonDelegate
- (void)disableBackgroundUserInteraction:(BOOL)disable{
        
  
}

//- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
//    if (self.emailTextField.text.length >= 8 && self.passwordTextField.text.length >= 8) {
//        return YES;
//    }
//    else {
//        [TipsView showTipOnKeyWindow:@"DEMO: 请输入正确的邮箱或密码"];
//    }
//    return NO;
//}
//
//- (void)captcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error {
//    //演示中全部默认为成功, 不对返回做判断
//    [TipsView showTipOnKeyWindow:@"DEMO: 登录成功"];
//}
    
#pragma MARK - GT3CaptchaManagerDelegate
    
- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
}
    
- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}
    
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    decisionHandler(GT3SecondaryCaptchaPolicyAllow);
    _validationSuccessBlock();

}
    
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
    
    self.geetest_challenge = result[@"geetest_challenge"];
    self.geetest_seccode = result[@"geetest_seccode"];
    self.geetest_validate = result[@"geetest_validate"];

    }

    // 处理API1返回的数据并将验证初始化数据解析给管理器
- (NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    dict[@"challenge"] = dictionary[@"data"][@"captcha"][@"challenge"];
    dict[@"gt"] = dictionary[@"data"][@"captcha"][@"gt"];
    dict[@"success"] = dictionary[@"data"][@"captcha"][@"success"];
    dict[@"new_captcha"] = dictionary[@"data"][@"captcha"][@"new_captcha"];
    
    return dict;
}
    
    
    /** 修改API1的请求 */
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    __block NSMutableString *postResult = [[NSMutableString alloc] init];
    
    NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
    NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:NetDefine.api_1] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    secondaryRequest.HTTPMethod = @"POST";
    secondaryRequest.allHTTPHeaderFields = headerFields;
    secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
    

    replacedHandler(secondaryRequest);
}

    
- (NSAttributedString *)generate:(NSString *)aString fontSize:(CGFloat)fontSize color:(UIColor *)color{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;
//    style.paragraphSpacingBefore = 4.0;
//    style.minimumLineHeight = 10.0;
    if (color == nil){
        color = [UIColor blackColor];
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:aString attributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style,NSForegroundColorAttributeName:color}];
    
    return attrString;
}
@end
