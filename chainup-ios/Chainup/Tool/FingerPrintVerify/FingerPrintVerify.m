
#import "FingerPrintVerify.h"
#import "Chainup-Swift.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation FingerPrintVerify



#pragma mark 调用系统指纹验证
+ (void)fingerPrintLocalAuthenticationFallBackTitle:(NSString *)fallBackTitle localizedReason:(NSString *)reasonTitle callBack:(void(^)(BOOL isSuccess,NSError *_Nullable error,NSString *referenceMsg))fingerBlock
{
    //创建LAContext
    LAContext *context = [LAContext new]; //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = fallBackTitle;
    NSError *error = nil;
    if (@available(iOS 9.0, *)) {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication
                                 error:&error]) {
            NSLog(@"开始识别");
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
                    localizedReason:reasonTitle reply:^(BOOL success, NSError * _Nullable error) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            fingerBlock(success,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
                        }];
                    }];
        }else{
            NSLog(@"不支持");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                fingerBlock(false,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
            }];
            
            NSLog(@"[MHD_FingerPrintVerify]错误是:%@",error.localizedDescription);
        }
    } else {
        // Fallback on earlier versions
    }
}

+ (void)fingerIsSupportCallBack:(void (^)(NSString *))fingerBlock{
    
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 9.0, *)) {
        LAContext *context = [LAContext new]; //这个属性是设置指纹输入失败之后的弹出框的选项
        
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError];
        
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                fingerBlock(@"0");
            }];
            
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (context.biometryType) {
                        case LABiometryNone:
                        {
                            NSLog(@"该设备支持不支持FaceID和TouchID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"0");
                            }];
                            
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            NSLog(@"该设备支持TouchID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"1");
                            }];
                            
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            NSLog(@"该设备支持Face ID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"2");
                            }];
                            
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    NSLog(@"该设备支持TouchID");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        fingerBlock(@"1");
                    }];
                    
                }
                
            } else {
                NSLog(@"该设备支持不支持FaceID和TouchID");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    fingerBlock(@"0");
                }];
                
            }
        }
        
    } else {
        // Fallback on earlier versions
        NSLog(@"该设备支持不支持FaceID和TouchID");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            fingerBlock(@"0");
        }];
        
    }
    
    
    
    
}
+ (void)fingerIsSupportCallBack1:(void (^)(NSString *))fingerBlock{
    
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 9.0, *)) {
        LAContext *context = [LAContext new]; //这个属性是设置指纹输入失败之后的弹出框的选项
        
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        
//        if (authError) {
//            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                fingerBlock(@"0");
//            }];
//
//        } else {
//            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (context.biometryType) {
                        case LABiometryNone:
                        {
                            NSLog(@"该设备支持不支持FaceID和TouchID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"0");
                            }];
                            
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            NSLog(@"该设备支持TouchID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"1");
                            }];
                            
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            NSLog(@"该设备支持Face ID");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                fingerBlock(@"2");
                            }];
                            
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    NSLog(@"该设备支持TouchID");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        fingerBlock(@"1");
                    }];
                    
                }
                
//            } else {
//                NSLog(@"该设备支持不支持FaceID和TouchID");
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    fingerBlock(@"0");
//                }];
//
//            }
//        }
        
    } else {
        // Fallback on earlier versions
        NSLog(@"该设备支持不支持FaceID和TouchID");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            fingerBlock(@"0");
        }];
    }
}
    
#pragma mark 返回错误参考信息
+ (NSString *)referenceErrorCode:(NSInteger)errorCode fallBack:(NSString *)fallBackStr
{
    switch (errorCode) {
        case LAErrorAuthenticationFailed:
            
            return [LanguageTools getStringWithKey:@"login_tip_authFail"];
            break;
        case LAErrorUserCancel:
            return [LanguageTools getStringWithKey:@"login_tip_userCancelAuth"];
            break;
        case LAErrorUserFallback:
            return fallBackStr;
            break;
        case LAErrorSystemCancel:
            return [LanguageTools getStringWithKey:@"login_tip_systemCancelAuth"];
            break;
        case LAErrorPasscodeNotSet:
            return [LanguageTools getStringWithKey:@"login_tip_systemNoPassword"];
            break;
        case LAErrorTouchIDNotAvailable:
            return [LanguageTools getStringWithKey:@"login_tip_deviceNotAvailable"];
            break;
        case LAErrorTouchIDNotEnrolled:
            return [LanguageTools getStringWithKey:@"login_tip_deviceNotAvailable"];
            break;
        case LAErrorTouchIDLockout:
            return [LanguageTools getStringWithKey:@"login_tip_authCompleteFail"];
            break;
        case LAErrorAppCancel:
            return [LanguageTools getStringWithKey:@"login_tip_authAppCancel"];
            break;
        case LAErrorInvalidContext:
            return [LanguageTools getStringWithKey:@"login_tip_authUserLoseEfficacy"];
            break;
        case LAErrorNotInteractive:
            return [LanguageTools getStringWithKey:@"login_tip_authAppStillending"];
            break;
            
        default:
            return [LanguageTools getStringWithKey:@"login_tip_authSuccess"];
            break;
    }
}
@end
