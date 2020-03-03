//
//  BTAlertView.m
//  BTStore
//
//  Created by 健 王 on 2018/1/18.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTAlertView.h"
#import "BTMainButton.h"
#import "UIButton+Extension.h"
#import "BTTextField.h"

@interface BTAlertView ()

@property (copy, nonatomic) dispatch_block_t cancelBlock;
@property (copy, nonatomic) dispatch_block_t otherBlock;
@property (copy, nonatomic) dispatch_block_t besurnBlock;
@property (copy, nonatomic) dispatch_block_t confirmBlock;

@property (copy, nonatomic) void (^comfirmPwd)(NSString *);

@property (nonatomic, weak) UIView *dummyView;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UIView *ellipsView;
@property (nonatomic, weak) BTTextField *textField;

@end

@implementation BTAlertView
static BTAlertView *instance;
+ (instancetype)sharedBTAlertViewFactory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (void)showGifLoadWithTitle:(NSString *)title Content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock {
    
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_getWidth(50) , SL_SCREEN_HEIGHT * 0.3, SL_SCREEN_WIDTH - SL_getWidth(50) * 2, SL_SCREEN_HEIGHT * 0.4)];
    [dummyView addSubview:mainView];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 10;
    mainView.layer.masksToBounds = YES;
    mainView.clipsToBounds = YES;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN, SL_MARGIN, mainView.sl_width - 2 * SL_MARGIN, SL_getWidth(30))];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    titleLabel.textColor = MAIN_TEXT_COLOR;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(titleLabel.frame) + SL_MARGIN, mainView.sl_width - 2 * SL_MARGIN, SL_getHeight(100));
    [mainView addSubview:contentLabel];
    contentLabel.text = content;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel sizeToFit];
    
    UIButton *cancelBtn = [UIButton buttonExtensionWithTitle:@"Back To Home" TitleColor:nil backgroundImage:nil font: [UIFont systemFontOfSize:18] target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceCancleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0,mainView.sl_height - SL_getWidth(50),mainView.sl_width,SL_getWidth(50));
    [cancelBtn setBackgroundColor:MAIN_BTN_COLOR];
    [mainView addSubview:cancelBtn];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(SL_getWidth(40), CGRectGetMaxY(contentLabel.frame), cancelBtn.sl_y - CGRectGetMaxY(contentLabel.frame), cancelBtn.sl_y - CGRectGetMaxY(contentLabel.frame));
    imageView.sl_centerX = mainView.sl_width * 0.5;
    [mainView addSubview:imageView];
    imageView.backgroundColor = [UIColor redColor];
    
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
}

+ (void)showContrntTipsWithContent:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock {
    
    
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
//    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_MARGIN * 2 , SL_SCREEN_HEIGHT * 0.33, SL_SCREEN_WIDTH - SL_MARGIN * 4, SL_SCREEN_HEIGHT * 0.33)];
    [dummyView addSubview:mainView];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 10;
    mainView.layer.masksToBounds = YES;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(SL_MARGIN * 2, SL_getWidth(20), mainView.sl_width - 4 * SL_MARGIN, SL_getWidth(50));
    [mainView addSubview:contentLabel];
    contentLabel.text = content;
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *cancelBtn = [UIButton buttonIExtensionWithTitle:@"取消" TitleColor:MAIN_BTN_COLOR Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceCancleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(contentLabel.frame) + SL_MARGIN * 3, mainView.sl_width * 0.5 - 2.5 * SL_MARGIN, SL_getWidth(40));
    [mainView addSubview:cancelBtn];
    [cancelBtn.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [cancelBtn.layer setBorderWidth:1.0];
    [cancelBtn.layer setCornerRadius:2];
    cancelBtn.layer.masksToBounds = YES;
    
    
    UIButton *confirm = [UIButton buttonIExtensionWithTitle:@"确定" TitleColor:[UIColor whiteColor] Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceConfirmBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundColor:MAIN_BTN_COLOR];
    confirm.frame = CGRectMake(mainView.sl_width * 0.5 + 0.5 * SL_MARGIN, cancelBtn.sl_y, cancelBtn.sl_width, cancelBtn.sl_height);
    [mainView addSubview:confirm];
    [confirm.layer setCornerRadius:2];
    confirm.layer.masksToBounds = YES;
    
    
//    [contentLabel sizeToFit];
    mainView.frame = CGRectMake(SL_MARGIN * 2 , 0, SL_SCREEN_WIDTH - 4 * SL_MARGIN, CGRectGetMaxY(confirm.frame) + SL_MARGIN * 2);
    mainView.center = window.center;
    
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
    [BTAlertView sharedBTAlertViewFactory].confirmBlock = confirmBlock;
}


+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock {
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
    //    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;//[self getLastAvailabelWindow];
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_MARGIN * 2 , 0, SL_SCREEN_WIDTH - 4 * SL_MARGIN, SL_getWidth(260))];
    mainView.center = window.center;
    mainView.sl_centerY = SL_SCREEN_HEIGHT * 0.45;
    [dummyView addSubview:mainView];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN, SL_MARGIN * 1.5, mainView.sl_width  - SL_MARGIN * 2, SL_getWidth(30))];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = MAIN_BTN_COLOR;
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN*2, CGRectGetMaxY(titleLabel.frame), mainView.sl_width - 4 * SL_MARGIN, mainView.sl_height - CGRectGetMaxY(titleLabel.frame) - SL_MARGIN  * 3 - SL_getWidth(40))];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = GARY_BG_TEXT_COLOR;
    
    if ([content rangeOfString:@"\n"].location != NSNotFound) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:content];
        NSArray *arr = [content componentsSeparatedByString:@"\n"];
        if (arr.count == 2) {
            NSRange range = [content rangeOfString:arr[1]];
            if (range.location != NSNotFound) {
                [str addAttribute:NSForegroundColorAttributeName value:DOWN_COLOR range:range];
            }
        }
        contentLabel.attributedText = str;
    } else {
        contentLabel.text = content;
    }
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [mainView addSubview:contentLabel];
    [contentLabel sizeToFit];
    contentLabel.sl_x = SL_MARGIN*2;
    contentLabel.sl_y = CGRectGetMaxY(titleLabel.frame) + SL_MARGIN * 2;
    contentLabel.sl_width = mainView.sl_width - 4 * SL_MARGIN;
    
    
    UIButton *cancelBtn = [UIButton buttonIExtensionWithTitle:@"取消" TitleColor:MAIN_BTN_COLOR Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceCancleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(contentLabel.frame) + SL_MARGIN * 3, mainView.sl_width * 0.5 - 2.5 * SL_MARGIN, SL_getWidth(40));
    [mainView addSubview:cancelBtn];
    [cancelBtn.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [cancelBtn.layer setBorderWidth:1.0];
    [cancelBtn.layer setCornerRadius:2];
    cancelBtn.layer.masksToBounds = YES;
    
    
    UIButton *confirm = [UIButton buttonIExtensionWithTitle:@"确定" TitleColor:[UIColor whiteColor] Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceConfirmBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundColor:MAIN_BTN_COLOR];
    confirm.frame = CGRectMake(mainView.sl_width * 0.5 + 0.5 * SL_MARGIN, cancelBtn.sl_y, cancelBtn.sl_width, cancelBtn.sl_height);
    [mainView addSubview:confirm];
    [confirm.layer setCornerRadius:2];
    confirm.layer.masksToBounds = YES;
    
    mainView.frame = CGRectMake(SL_MARGIN * 2 , 0, SL_SCREEN_WIDTH - 4 * SL_MARGIN, CGRectGetMaxY(confirm.frame) + SL_MARGIN * 2);
    mainView.center = window.center;
    
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
    [BTAlertView sharedBTAlertViewFactory].confirmBlock = confirmBlock;
}

+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content WithCancelBlock:(void (^)(void))cancelBlock {
    
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
//    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self getLastAvailabelWindow];
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_getWidth(40), 0, SL_SCREEN_WIDTH - SL_getWidth(80), SL_getWidth(240))];
    mainView.center = window.center;
    [dummyView addSubview:mainView];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainView.sl_width* 0.2, SL_MARGIN * 1.5, mainView.sl_width * 0.6, SL_getWidth(30))];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = MAIN_BTN_COLOR;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    BTMainButton *button = [BTMainButton blueBtnWithTitle:@"OK" target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceIKnowBtnDidClicked:)];
    button.frame = CGRectMake(0, mainView.sl_height - SL_getWidth(45), mainView.sl_width, SL_getWidth(50));
    [mainView addSubview:button];

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN, CGRectGetMaxY(titleLabel.frame)+SL_MARGIN * 0.5, mainView.sl_width - 2* SL_MARGIN, mainView.sl_height - SL_getWidth(45) - CGRectGetMaxY(titleLabel.frame) - SL_MARGIN * 1.5)];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = GARY_BG_TEXT_COLOR;
    contentLabel.text = content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
    
    CGFloat textH = [contentLabel.text boundingRectWithSize:CGSizeMake(contentLabel.sl_width - SL_MARGIN * 3, mainView.sl_height - SL_MARGIN * 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}                                context:nil].size.height;
    if (textH < SL_getWidth(70)) {
        textH = SL_getWidth(70);
    }
    mainView.frame = CGRectMake(SL_getWidth(40), 0, SL_SCREEN_WIDTH - SL_getWidth(80), textH + SL_getWidth(110));
    mainView.center = window.center;
    button.frame = CGRectMake(0, mainView.sl_height - SL_getWidth(45), mainView.sl_width, SL_getWidth(45));
    contentLabel.frame = CGRectMake(SL_MARGIN, CGRectGetMaxY(titleLabel.frame)+SL_MARGIN * 0.5, mainView.sl_width - 2* SL_MARGIN, mainView.sl_height - SL_getWidth(45) - CGRectGetMaxY(titleLabel.frame) - SL_MARGIN * 1.5);
    [mainView addSubview:contentLabel];
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
}

+ (void)showTipsInfoWithTitle:(NSString *)title content:(NSString *)content WithConfirmBlock:(void (^)(void))confirmBlock {
    
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
//    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;//[self getLastAvailabelWindow];
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_getWidth(40), 0, SL_SCREEN_WIDTH - SL_getWidth(80), SL_getWidth(240))];
    mainView.center = window.center;
    [dummyView addSubview:mainView];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainView.sl_width* 0.2, SL_MARGIN * 1.5, mainView.sl_width * 0.6, SL_getHeight(30))];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = MAIN_TEXT_COLOR;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    BTMainButton *button = [BTMainButton blueBtnWithTitle:@"确定" target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceIKnowBtnDidClicked:)];
    button.frame = CGRectMake(0, 0.8 * mainView.sl_height, mainView.sl_width,mainView.sl_height * 0.2);
    [mainView addSubview:button];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN, CGRectGetMaxY(titleLabel.frame)+SL_MARGIN * 0.5, mainView.sl_width - 2* SL_MARGIN, mainView.sl_height * 0.8 - CGRectGetMaxY(titleLabel.frame) - SL_MARGIN)];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = GARY_BG_TEXT_COLOR;
    contentLabel.text = content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [mainView addSubview:contentLabel];
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = confirmBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
}

+ (void)showVerifyPasswordWithTitle:(NSString *)title placeholder:(NSString *)placeholder withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(NSString *password))confirmBlock {
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    
    UIButton *dummyView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
//    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
    [dummyView setBackgroundColor:[color colorWithAlphaComponent:0.5]];
//    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    [dummyView addTarget:[BTAlertView sharedBTAlertViewFactory] action:@selector(didClickdummyView:) forControlEvents:UIControlEventTouchUpInside];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_getWidth(30), 0, SL_SCREEN_WIDTH - SL_getWidth(60), SL_getWidth(200))];
    mainView.center = window.center;
    [dummyView addSubview:mainView];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainView.sl_width* 0.1, SL_MARGIN * 1.5, mainView.sl_width * 0.8, SL_getWidth(30))];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    UIButton *cancelBtn = [UIButton buttonIExtensionWithTitle:@"取消" TitleColor:MAIN_BTN_COLOR Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceCancleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(SL_MARGIN * 2, mainView.sl_height - 2 * SL_MARGIN - SL_getWidth(40), mainView.sl_width * 0.5 - 2.5 * SL_MARGIN, SL_getWidth(40));
    [mainView addSubview:cancelBtn];
    [cancelBtn.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [cancelBtn.layer setBorderWidth:1.0];
    [cancelBtn.layer setCornerRadius:2];
    cancelBtn.layer.masksToBounds = YES;
    
    UIButton *confirm = [UIButton buttonIExtensionWithTitle:@"确定" TitleColor:[UIColor whiteColor] Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(verifyPasswordConfirmBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setBackgroundColor:MAIN_BTN_COLOR];
    confirm.frame = CGRectMake(mainView.sl_width * 0.5 + 0.5 * SL_MARGIN, cancelBtn.sl_y, cancelBtn.sl_width, cancelBtn.sl_height);
    [mainView addSubview:confirm];
    [confirm.layer setCornerRadius:2];
    confirm.layer.masksToBounds = YES;
    
    BTTextField *textField = [[BTTextField alloc] initWithFrame:CGRectMake(SL_MARGIN * 2, CGRectGetMaxY(titleLabel.frame) + SL_MARGIN * 2.5, mainView.sl_width - 4 * SL_MARGIN, SL_getWidth(40))];
    [mainView addSubview:textField];
    [textField.layer setCornerRadius:2];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.secureTextEntry = YES;
    textField.placeholder = @"请输入登录密码";
    textField.layer.borderColor = GARY_BG_TEXT_COLOR.CGColor;
    
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
    [BTAlertView sharedBTAlertViewFactory].textField = textField;
    [BTAlertView sharedBTAlertViewFactory].comfirmPwd = confirmBlock;
}

// 展示第一次
+ (void)openPortableLoginWayWithTitle:(NSString *)title content:(NSString *)content withCancelBlock:(void (^)(void))cancelBlock andConfirmBlock:(void (^)(void))confirmBlock {
    [[BTAlertView sharedBTAlertViewFactory] tipInstanceCancleBtnDidClicked:nil];
    UIView *dummyView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIColor *color = [UIColor blackColor];
    dummyView.backgroundColor = [color colorWithAlphaComponent:0.5];
    UIView *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return;
    }
    [window addSubview:dummyView];
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(SL_getWidth(40), 0, SL_SCREEN_WIDTH - SL_getWidth(80), SL_getWidth(200))];
    mainView.center = window.center;
    [dummyView addSubview:mainView];
    mainView.layer.cornerRadius = 8;
    mainView.clipsToBounds = YES;
    mainView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainView.sl_width* 0.2, SL_MARGIN * 1.5, mainView.sl_width * 0.6, SL_getWidth(30))];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = DARK_BARKGROUND_COLOR;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:titleLabel];
    
    UIButton *cancelBtn = [UIButton buttonIExtensionWithTitle:@"暂不开启" TitleColor:MAIN_BTN_COLOR Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceCancleBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(SL_MARGIN * 2, mainView.sl_height - 2 * SL_MARGIN - SL_getWidth(40), mainView.sl_width * 0.5 - 2.5 * SL_MARGIN, SL_getWidth(40));
    [mainView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn.layer setBorderColor:MAIN_BTN_COLOR.CGColor];
    [cancelBtn.layer setBorderWidth:1.0];
    [cancelBtn.layer setCornerRadius:2];
    cancelBtn.layer.masksToBounds = YES;
    
    UIButton *confirm = [UIButton buttonIExtensionWithTitle:@"立即开启" TitleColor:[UIColor whiteColor] Image:nil highLightedImage:nil target:[BTAlertView sharedBTAlertViewFactory] action:@selector(tipInstanceConfirmBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirm.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirm setBackgroundColor:MAIN_BTN_COLOR];
    confirm.frame = CGRectMake(mainView.sl_width * 0.5 + 0.5 * SL_MARGIN, cancelBtn.sl_y, cancelBtn.sl_width, cancelBtn.sl_height);
    [mainView addSubview:confirm];
    [confirm.layer setCornerRadius:2];
    confirm.layer.masksToBounds = YES;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SL_MARGIN*2, CGRectGetMaxY(titleLabel.frame), mainView.sl_width - 4 * SL_MARGIN, mainView.sl_height - CGRectGetMaxY(titleLabel.frame) - SL_MARGIN  * 3 - SL_getWidth(40))];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = GARY_BG_TEXT_COLOR;
    [mainView addSubview:contentLabel];
    contentLabel.text = content;
    
    [BTAlertView sharedBTAlertViewFactory].cancelBlock = cancelBlock;
    [BTAlertView sharedBTAlertViewFactory].mainView = mainView;
    [BTAlertView sharedBTAlertViewFactory].dummyView = dummyView;
    [BTAlertView sharedBTAlertViewFactory].confirmBlock = confirmBlock;
}

#pragma mark - action;

- (void)tipInstanceCancleBtnDidClicked:(UIButton *)sender {
    if (self.dummyView) {
        [self.dummyView removeFromSuperview];
    }
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    if (sender != nil) {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

- (void)tipInstanceConfirmBtnDidClicked:(UIButton *)sender {
    if (self.dummyView) {
        [self.dummyView removeFromSuperview];
    }
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    if (sender != nil) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
    }
}

- (void)verifyPasswordConfirmBtnDidClicked:(UIButton *)sender {
    if (self.dummyView) {
        [self.dummyView removeFromSuperview];
    }
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    if (sender != nil) {
        if (self.comfirmPwd) {
            self.comfirmPwd(self.textField.text);
        }
    }
    if (self.textField) {
        [self.textField removeFromSuperview];
    }
}

- (void)tipInstanceIKnowBtnDidClicked:(UIButton *)sender {
    if (self.dummyView) {
        [self.dummyView removeFromSuperview];
    }
    if (self.mainView) {
        [self.mainView removeFromSuperview];
    }
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)didClickdummyView:(UIView *)dummyView {
    [self.textField resignFirstResponder];
}

+ (UIWindow *)getLastAvailabelWindow {
    int count = (int)[UIApplication sharedApplication].windows.count;
    for (int i = count - 1; i >= 0; i--) {
        UIWindow *window = [UIApplication sharedApplication].windows[i];
        if (window.windowLevel != UIWindowLevelAlert) {
            return window;
        }
    }
    return nil;
}

@end
