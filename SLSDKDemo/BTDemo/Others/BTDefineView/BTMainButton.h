//
//  BTMainButton.h
//  BTStore
//
//  Created by 健 王 on 2018/3/29.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTMainButton : UIButton

+ (instancetype)blueBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)orangeBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)cyanBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)redBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)boardBtnWithBoardColor:(UIColor *)color Title:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)buyBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)sellBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)openBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)closeBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)bbAccountWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)sbBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
