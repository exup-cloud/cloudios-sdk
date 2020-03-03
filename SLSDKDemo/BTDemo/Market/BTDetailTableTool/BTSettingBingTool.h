//
//  BTSettingBingTool.h
//  BTStore
//
//  Created by 健 王 on 2018/1/31.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ResetPasswordVerifyCode         @"ResetPasswordVerifyCode"
#define WithdrawVerifyCode              @"WithdrawVerifyCode"
#define ActiveVerifyCode                @"ActiveVerifyCode"
#define RegistVerifyCode                @"RegisterVerifyCode"
#define BindPhoneVerifyCode             @"BindPhoneVerifyCode"
#define BindEmailVerifyCode             @"BindEmailVerifyCode"
#define ResetAssetPasswordVerifyCode    @"ResetAssetPasswordVerifyCode"
#define OTCAccountVerifyCode            @"OTCAccountVerifyCode"
#define LOGINVerifyCode                 @"login"

@interface BTSettingBingTool : NSObject

+ (void)sendVerifyCodeWithType:(NSString *)type account:(NSDictionary *)parames success:(void (^)(id response))success failure:(void (^)(id))failure;

+ (void)bingWithUrl:(NSString *)url parames:(NSDictionary *)parames success:(void (^)(id response))success failure:(void (^)(id))failure;

+ (void)captchCheckShowImageWithType:(NSString *)action success:(void (^)(BOOL result))success failure:(void (^)(id))failure;

+ (void)POSTGetVerifyCodeWithType:(NSString *)type paramers:(NSDictionary *)paramers validata:(NSString *)validate success:(void (^)(id response))success failure:(void (^)(id))failure;

@end
