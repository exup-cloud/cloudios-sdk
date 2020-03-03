//
//  BTSettingBingTool.m
//  BTStore
//
//  Created by 健 王 on 2018/1/31.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTSettingBingTool.h"
#import "NSString+URLFormat.h"


@implementation BTSettingBingTool

+ (void)sendVerifyCodeWithType:(NSString *)type account:(NSDictionary *)parames success:(void (^)(id))success failure:(void (^)(id))failure {
    
    NSString *key = [parames allKeys][0];
    NSString *url = [NSString stringWithFormat:@"%@?%@=%@&type=%@",[BTBasePath sharedBasePath].verifyCode,key,[NSString urlEncodedString:parames[key]],type];
    [BTSecureHttp AuthGET:url parameters:nil success:^(id responseHeader, id responseObject) {
        if ([responseObject[@"errno"] isEqualToString:@"OK"]) {
            success(responseObject);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
    }];
}

+ (void)bingWithUrl:(NSString *)url parames:(NSDictionary *)parames success:(void (^)(id response))success failure:(void (^)(id))failure {
    [BTSecureHttp  KAuthPOST:url parameters:parames success:^(id responseHeader, id responseObject) {
        if ([responseObject[@"errno"] isEqualToString:@"OK"]) {
            success(responseObject);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
    }];
}

+ (void)POSTGetVerifyCodeWithType:(NSString *)type paramers:(NSDictionary *)paramers validata:(NSString *)validate success:(void (^)(id response))success failure:(void (^)(id))failure {
    NSString *url = [BTBasePath sharedBasePath].verifyCode;
    if (!url) {
        failure(nil);
    }
    NSString *key = [paramers allKeys][0];
    url = [NSString stringWithFormat:@"%@?%@=%@&type=%@",url,key,[NSString urlEncodedString:paramers[key]],type];
    NSDictionary *res = nil;
    if (validate) {
        res = @{@"validate":validate};
    } else {
        res = @{@"validate":@""};
    }
    [BTSecureHttp KAuthPOST:url parameters:res success:^(id responseHeader, id responseObject) {
        if ([responseObject[@"errno"] isEqualToString:@"OK"]) {
            success(responseObject);
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
    }];
}

+ (void)captchCheckShowImageWithType:(NSString *)action success:(void (^)(BOOL result))success failure:(void (^)(id))failure{
    NSString *url = [BTBasePath sharedBasePath].captchCheck;
    if (!url) {
        failure(nil);
    }
    url = [NSString stringWithFormat:@"%@%@",url,action];
    [BTSecureHttp AuthGET:url parameters:nil success:^(id responseHeader, id responseObject) {
        if (responseObject[@"data"] && [responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = responseObject[@"data"];
            BOOL res = [data[@"need"] boolValue];
            success(res);
            return;
        }
        failure(responseObject[@"message"]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
