//
//  BTNetsVerifyCodeTool.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTNetsVerifyCodeTool : NSObject

/**
 * 关闭验证码窗口后的回调
 */
@property (nonatomic, copy) void (^cancelVerifyCode)(void);

// 完成验证之后回调
@property (nonatomic, copy) void (^validateFinish)(BOOL result,NSString * validate, NSString *message);

+ (instancetype)defaultNetsVerifyCodeTool;

- (void)showNetsVerifyCodeOnView:(UIView *)view;

@end
