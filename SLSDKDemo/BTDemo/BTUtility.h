//
//  BTUtility.h
//  BTStore
//
//  Created by 健 王 on 2018/1/26.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VERIFY_OUT_TIME                     @"60"

typedef NS_ENUM(NSUInteger, DisplayTimeType) {
    DisplayTimeType1 = 6000,    //yyyy-MM-dd HH:mm:ss
    DisplayTimeType2,           //yyyy-MM-dd
    DisplayTimeType3,           //yyyy
};

@interface BTUtility : NSObject

+ (instancetype)sharedInstance;

// 手机号码验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 用户密码验证6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;

// 邮箱验证4
+ (BOOL)validateEmail:(NSString *)email;

// 用户名验证中文及英文大小写
+ (BOOL)validateUserName:(NSString *)userName;

// 判断账号格式是否正确
+ (BOOL)validateAccountWith:(NSString *)account target:(id)target;

- (void)uSimpleAlert:(id)target Msg:(NSString *)msg;
- (void)uSimpleAlert2:(id)target Msg:(NSString *)msg;

+ (BOOL)hasChinese:(NSString *)str;
// 查找出字符串中 数字
+ (NSString *)searchNumber:(NSString *)content;
// 判断是否越狱
+ (BOOL)isJaBe;
+ (UIImage *)setCheckCodeWithContent:(NSString *)content;

/// 屏幕截图
+ (UIImage *)doScreenShotWithView:(UIView *)view;

@end
