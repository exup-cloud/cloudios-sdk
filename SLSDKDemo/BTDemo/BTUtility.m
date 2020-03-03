//
//  BTUtility.m
//  BTStore
//
//  Created by 健 王 on 2018/1/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTUtility.h"
#include <string.h>

@implementation BTUtility

+ (instancetype)sharedInstance {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNumbel {
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNumbel];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNumbel];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNumbel];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)checkPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9._]{8,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (BOOL)validateEmail:(NSString *)email {
    if (email == nil || [email isEqualToString:@""]) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,5}" ;
    NSPredicate  *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return  [emailTest evaluateWithObject:email];
}

+ (BOOL)validateUserName:(NSString *)userName {
    if (userName == nil || [userName isEqualToString:@""]) {
        return NO;
    }
    NSString * regex = @"^[a-zA-z][a-zA-Z0-9_]{5,19}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

+ (BOOL)validateAccountWith:(NSString *)account  target:(id)target{
    if (account == nil || [account isEqualToString:@""]) {
        return NO;
    }
    NSString *str = [account substringToIndex:1];
    if ([str isEqualToString:@"1"]) {
        // 使用手机号码登录
        if (account.length != 11) {
            [[self sharedInstance] uSimpleAlert2:target Msg:@"手机号长度只能是11位"];
            return NO;
        } else if (![[self sharedInstance] isMobileNumber:account]) {
            [[self sharedInstance] uSimpleAlert2:target Msg:@"请输入正确的手机号码"];
            return NO;
        }
    } else {
        // 使用用户名登录
        if (![self validateUserName:account]) {
            [[self sharedInstance] uSimpleAlert2:target Msg:@"用户名由1-15位的中文或英文大小写组成"];
            return NO;
        }
    }
    return YES;
}

- (void)uSimpleAlert:(id)target Msg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)uSimpleAlert2:(id)target Msg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+ (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

// 查找字符串中数字的位置
+ (NSString *)searchNumber:(NSString *)content {
    NSScanner *scanner = [NSScanner scannerWithString:content];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSString *num= [NSString stringWithFormat:@"%d",number];
    return num;
}

// 通过URL判断越狱——1
+ (BOOL)isJaBe {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}

// 设置二维码
+ (UIImage *)setCheckCodeWithContent:(NSString *)content {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    UIImage *result = [UIImage imageWithCIImage:image];
    return result;
}

/// 屏幕截图
+ (UIImage *)doScreenShotWithView:(UIView *)view {
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [view.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 保存相册
    return image;
}

@end
