//
//  UIButton+Extension.m
//  BTStore
//
//  Created by 健 王 on 2018/1/9.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "UIButton+Extension.h"
#import "BTMainButton.h"

@implementation UIButton (Extension)

+ (instancetype)buttonIExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color Image:(UIImage *)image highLightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    BTMainButton *button = [BTMainButton buttonWithType:UIButtonTypeCustom];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image != nil) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (highlightedImage != nil) {
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 2;
    [button.layer masksToBounds];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    if (target!= nil) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
    [button sizeToFit];
    return button;
}

+ (instancetype)buttonExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color Image:(UIImage *)image font:(UIFont *)font target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image != nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (font != nil) {
        button.titleLabel.font = font;
    }
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button sizeToFit];
    return button;
}

+ (instancetype)buttonExtensionWithTitle:(NSString *)title TitleColor:(UIColor *)color backgroundImage:(UIImage *)image font:(UIFont *)font target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    if (title != nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (image != nil) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (font != nil) {
        button.titleLabel.font = font;
    }
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button sizeToFit];
    return button;
}

@end
