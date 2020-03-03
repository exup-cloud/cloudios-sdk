//
//  UIColor+XQColor.h
//  AppHelperXQ
//
//  Created by Mike on 15/7/25.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

// Method Macro
#define ColorRGB(r, g, b) ([UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f])

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

// Constants
// listColor 正常：白底 篮筐 蓝字 进度色;  安装中，连接中，下载中：蓝底，白字，篮筐 进度色
// detailColor 正常： 蓝底 篮框 白字 进度色  安装中，下载中，连接中： 蓝底 篮框 白字 进度色
// 有缓存：篮筐 白底 高亮蓝色

#define LOGIN_TITLE_COLOR [UIColor colorWithHex:@"#CDD5DF"]
#define MAIN_COLOR [UIColor colorWithHex:@"#161F24"]
#define MAIN_TEXT_COLOR [UIColor colorWithHex:@"#20A4C0"]
#define LIGHT_GARY_COLOR [UIColor colorWithHex:@"#F4F4F5"]
#define TIPS_BG_COLOR [UIColor colorWithHex:@"#B9EDE7"]
#define LIGHT_BG_TEXT_COLOR [UIColor colorWithHex:@"9E9EA1"]
#define GARY_BG_TEXT_COLOR [UIColor colorWithHex:@"#85A2B2"]
#define BOTTOM_LINE [UIColor colorWithHex:@"152E40"]

#define MAIN_GARY_TEXT_COLOR [UIColor colorWithHex:@"#cdd5df"]

#define MAIN_BTN_TITLE_COLOR [UIColor colorWithHex:@"#FFFFFF"]
#define MAIN_BTN_COLOR [UIColor colorWithHex:@"#20A4C0"]
#define IMPORT_BTN_COLOR [UIColor colorWithHex:@"#D9A959"]
#define MAIN_BTN_DISENABLE [UIColor colorWithHex:@"#2EBEDD"] // 按钮高亮状态

//1A2837
#define MAIN_LINE [UIColor colorWithHex:@"#10131C"]

#define BGTRADE_CELL [UIColor colorWithHex:@"#eaf6fe"]

#define DARK_BARKGROUND_COLOR [UIColor colorWithHex:@"#141A1D"]//

#define BORDER_COLOR [UIColor colorWithHex:@"#8ed0f9"] // 边框颜色
#define DRAW_BORDER_COLOR [UIColor colorWithHex:@"#1c364c"] // 绘制边框
#define UP_WARD_COLOR [UIColor colorWithHex:@"#2eb564"] // 上升
#define DOWN_COLOR [UIColor colorWithHex:@"#fd3a3a"] // 下降

#define DETAIL_BODER [UIColor colorWithHex:@"1c364c"]
#define SELECT_BODER [UIColor colorWithHex:@"#383E47"]  // 白色（安装，打开，更新）
#define BANGTEXT_COLOR [UIColor colorWithHex:@"#999999"]
#define TLTIPS_COLOR [UIColor colorWithHex:@"#f84943"]
#define BACKGROUND_COLOR [UIColor colorWithHex:@"1889c9"] //连接中，安装中，下载中的背景色
#define INSCOMPLETEBACKGROUND_COLOR [UIColor colorWithHex:@"88eaf5"] // 下载完成，未安装的应用背景色为此颜色
#define BACKGROUNDCOLOR [UIColor colorWithHex:@"#f5f5f5"]
#define BOTTOM_BACKGROUNDCOLOR [UIColor colorWithHex:@"#f2f2f2"]

// Class
@interface UIColor (GetColor)

// 根据0~255的数字获取color
// 根据labelName获取color

// 根据十六进制获取color 是十六进制的数字 带#号的
+ (UIColor *)colorWithHex:(NSString *)hexColor;
+ (UIColor *)colorWithRandom6;
+ (UIColor *)colorWithRandom;

@end
