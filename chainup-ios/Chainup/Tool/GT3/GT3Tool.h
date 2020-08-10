//
//  GT3Tool.h
//  GT3Example
//
//  Created by xue on 2018/11/5.
//  Copyright © 2018 Xniko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GT3Captcha/GT3Captcha.h>

@interface GT3Tool : NSObject

@property (nonatomic, strong) GT3CaptchaButton *captchaButton;
//+(GT3Tool *) sharedInstance;

-(void)start;

@property (nonatomic,strong) NSString *geetest_challenge;
@property (nonatomic,strong) NSString *geetest_seccode;
@property (nonatomic,strong) NSString *geetest_validate;
@property (nonatomic,copy) void(^validationSuccessBlock)(void);

@end

