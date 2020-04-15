//
//  HTTPTool.h
//  Project
//
//  Created by Jason_Mac on 15/11/17.
//  Copyright (c) 2015年 Jason. All rights reserved.
//  用来处理网络请求

#import <Foundation/Foundation.h>
#import "BTUrlDef.h"

@interface HTTPTool : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

/**
 *  自定义请求头发送get请求
 *  @parem requestHeader 自定义请求头
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)HTTPHeader:(NSDictionary *)requestHeader GET:(NSString *)URLString
        parameters:(id)parameters
           success:(void (^)(id responseHeader, id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 *  自定义请求头发送post请求
 *  @parem requestHeader 自定义请求头
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)HTTPHeader:(NSDictionary *)requestHeader POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseHeader, id responseObject))success
     failure:(void (^)(NSError *error))failure;


+ (void)HTTPHeader:(NSDictionary *)requestHeader upload:(NSString *)URLstring data:(NSData *)data name:(NSString *)name parameters:(NSDictionary *)params success:(void (^)(id responseHeader, id responseObject))success
       failure:(void (^)(NSError *error))failure;

+ (BOOL)isNetStatusCanRequset;
+ (BOOL)isNetStatusWWAN;
+ (BOOL)isNetStatusWIFI;
@end
