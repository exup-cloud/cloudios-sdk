//
//  UIButton+Extension.h
//  BTStore
//
//  Created by 健 王 on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+ (instancetype)buttonIExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color Image:(UIImage *)image highLightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (instancetype)buttonExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color Image:(UIImage *)image font:(UIFont *)font target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+ (instancetype)buttonExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color backgroundImage:(UIImage *)image font:(UIFont *)font target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
