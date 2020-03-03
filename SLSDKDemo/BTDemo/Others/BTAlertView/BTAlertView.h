//
//  BTAlertView.h
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTAlertView : NSObject
+ (instancetype)sharedBTAlertViewFactory;

+ (void)showContrntTipsWithContent:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock;

+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content WithCancelBlock:(void (^)(void))cancelBlock;

+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content WithConfirmBlock:(void (^)(void))confirmBlock;

+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock;

+ (void)showGifLoadWithTitle:(NSString *)title Content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock;

// 验证密码弹框
+ (void)showVerifyPasswordWithTitle:(NSString *)title placeholder:(NSString *)placeholder withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(NSString *password))confirmBlock;

+ (void)openPortableLoginWayWithTitle:(NSString *)title content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock;

@end
