
#import "SMProgressHUD+YY.h"

#define kKeyWindowView [UIApplication sharedApplication].keyWindow
#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height
#define kSystemFontOfSize(size) [UIFont systemFontOfSize:size]
#define WidthRateBase6P(a) HYScreenW/1080*a
#define HeightRatebase6P(a) HYScreenH/1920*a

#define AnimationImgsArr @[[UIImage imageNamed:@"YYHUD.bundle/loading_1"],[UIImage imageNamed:@"YYHUD.bundle/loading_2"]]

@implementation SMProgressHUD (YY)

# pragma mark - 菊花动画
// 需要手动隐藏
+ (void)showHUD {
    [SMProgressHUD showHUDWithMessage:nil];
}

// 需要手动隐藏
+ (void)showHUDWithMessage:(NSString *)message {
    [SMProgressHUD showHUDWithMessage:message hideAfterDelay:0];
}

// 当 delay == 0 时需要手动隐藏
+ (void)showHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.removeFromSuperViewOnHide = YES;
        if (delay != 0) {
            [hud hideAnimated:YES afterDelay:delay];
        }
    });
}

+ (void)showBlackHUD {
    [SMProgressHUD showBlackHUDWithMessage:nil];
}

+ (void)showBlackHUDWithMessage:(NSString *)message {
    [SMProgressHUD showBlackHUDWithMessage:message hideAfterDelay:0];
}

// 当 delay == 0 时需手动隐藏
+ (void)showBlackHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [self showBlackHUDWithMessage:message hideAfterDelay:delay isTouchEnbale:NO];
}

// 当 delay == 0 时需手动隐藏, isTouchEnable: 是否拦截底部视图事件
+ (void)showBlackHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay isTouchEnbale:(BOOL)isTouchEnable {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        // 主线程异步执行, 防止崩溃
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.bezelView.color = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.removeFromSuperViewOnHide = YES;
        if (isTouchEnable) {
            hud.userInteractionEnabled = NO;
        }
        if (delay != 0) {
            [hud hideAnimated:YES afterDelay:delay];
        }
    });
}

# pragma mark - 纯提示语
+ (void)showText {
    [SMProgressHUD showTextWithMessage:@"请稍等..."];
}

+ (void)showTextWithMessage: (NSString *)message {
    [self showTextWithMessage:message hideAfterDelay:1.5];
}

+ (void)showTextWithMessage: (NSString *)message hideAfterDelay:(CGFloat)delay {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.mode = SMProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:delay];
    });
}

+ (void)showBlackText {
    [SMProgressHUD showBlackTextWithMessage: nil];
}

+ (void)showBlackTextWithMessage: (NSString *)message {
    [SMProgressHUD showBlackTextWithMessage:message hideAfterDelay:1.5];
}

+ (void)showBlackTextWithMessage: (NSString *)message hideAfterDelay:(CGFloat)delay {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.bezelView.color = SLColor(51, 51, 51);
//        hud.bezelView.alpha = 1.0;
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.mode = SMProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:delay];
    });
}

+ (void)showBlackTextIfNotExistWithMessage: (NSString *)message {
    
}

# pragma mark - 错误提示
+ (void)showError{
    [SMProgressHUD showErrorWithMessage:nil];
}

+ (void)showErrorWithMessage:(NSString *)message {
    [SMProgressHUD showErrorWithMessage:message hideAfterDelay:1.5];
}

+ (void)showErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"error" hideAfterDelay:delay bgColor: nil];
}

+ (void)showBlackError {
    [SMProgressHUD showBlackErrorWithMessage:nil];
}

+ (void)showBlackErrorWithMessage:(NSString *)message {
    [SMProgressHUD showBlackErrorWithMessage:message hideAfterDelay:1.5];
}

+ (void)showBlackErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"error" hideAfterDelay:delay bgColor:[UIColor blackColor]];
}

# pragma mark - 成功提示
+ (void)showSuccess {
    [SMProgressHUD showSuccessWithMessage:nil];
}

+ (void)showSuccessWithMessage: (NSString *)message {
    [SMProgressHUD showSuccessWithMessage:message hideAfterDelay:1.5];
}

+ (void)showSuccessWithMessage: (NSString *)message hideAfterDelay: (CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"success" hideAfterDelay:delay bgColor:nil];
}

+ (void)showBlackSuccess {
    [SMProgressHUD showBlackSuccessWithMessage:nil];
}

+ (void)showBlackSuccessWithMessage:(NSString *)message {
    [SMProgressHUD showBlackSuccessWithMessage:message hideAfterDelay:1.5];
}

+ (void)showBlackSuccessWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"success" hideAfterDelay:delay bgColor:[UIColor blackColor]];
}

# pragma mark - 信息提示
+ (void)showInfo {
    [SMProgressHUD showInfoWithMessage:nil];
}

+ (void)showInfoWithMessage:(NSString *)message {
    [SMProgressHUD showInfoWithMessage:message hideAfterDelay:1.5];
}

+ (void)showInfoWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"info" hideAfterDelay:delay bgColor:nil];
}

+ (void)showBlackInfo {
    [SMProgressHUD showBlackInfoWithMessage:nil];
}

+ (void)showBlackInfoWithMessage:(NSString *)message {
    [SMProgressHUD showBlackInfoWithMessage:message hideAfterDelay:1.5];
}

+ (void)showBlackInfoWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"info" hideAfterDelay:delay bgColor:[UIColor blackColor]];
}

# pragma mark - 网络错误
+ (void)showNetworkError {
    [self showNetworkErrorWithMessage:nil];
}

+ (void)showNetworkErrorWithMessage:(NSString *)message {
    [self showNetworkErrorWithMessage:message hideAfterDelay:1.5];
}

+ (void)showNetworkErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"no-wifi" hideAfterDelay:delay bgColor:nil];
}

+ (void)showBlackNetworkError {
    [self showBlackNetworkErrorWithMessage:nil];
}

+ (void)showBlackNetworkErrorWithMessage:(NSString *)message {
    [self showBlackNetworkErrorWithMessage:message hideAfterDelay:1.5];
}

+ (void)showBlackNetworkErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay {
    [SMProgressHUD showCustomWithMessage:message imgName:@"no-wifi" hideAfterDelay:delay bgColor:[UIColor blackColor]];
}

# pragma mark - 自定义图片和文字
+ (void)showCustomWithMessage: (NSString *)message imgName: (NSString *)imgName hideAfterDelay: (CGFloat)delay bgColor: (UIColor *)bgColor {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        
        if (bgColor != nil) {
            hud.bezelView.color = bgColor;
            hud.contentColor = [UIColor whiteColor];
        }
        hud.label.text = message;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"YYHUD.bundle/%@", imgName]]];
        hud.mode = SMProgressHUDModeCustomView;
        hud.label.font = kSystemFontOfSize(13);
        hud.label.numberOfLines = 0;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:delay];
    });
}

/// 显示加载动画
+ (void)showNetWorkAnimaltionHUD {
    [SMProgressHUD showAnimaltionHUDWithImages:nil message:nil bgColor:nil];
}

+ (void)showBlackNetWorkAnimaltionHUD {
    [SMProgressHUD showAnimaltionHUDWithImages:nil message:nil bgColor:[UIColor blackColor]];
}


/// 显示加载动画
/// 此方法需要手动结束
/// @param images 动画来源数组
/// @param title  提示
+ (void)showAnimaltionHUDWithImages: (NSArray *)images message:(NSString *)message bgColor: (UIColor *)bgColor {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *actionImage = [[UIImageView alloc] init];
        actionImage.frame = CGRectMake(0, 0, WidthRateBase6P(338), HeightRatebase6P(345));
        images ? [actionImage setAnimationImages:images] : [actionImage setAnimationImages:AnimationImgsArr];
        
        [actionImage setAnimationDuration:images.count * 1];
        [actionImage startAnimating];
        
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.customView = actionImage;
        
        if (bgColor != nil) {
            hud.bezelView.color = bgColor;
            hud.contentColor = [UIColor whiteColor];
        }
        
        hud.label.text = message == nil ? @"努力加载中..." : message;
        
        hud.label.font = kSystemFontOfSize(18);
        hud.label.numberOfLines = 0;
        hud.label.textColor = [UIColor darkGrayColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = SMProgressHUDModeCustomView;
        hud.animationType = SMProgressHUDAnimationZoomOut;
    });
}

# pragma mark - 隐藏提示
+ (void)hideHUD {
    for (UIView *cview in kKeyWindowView.subviews) {
        if ([cview isKindOfClass:self]) {
            SMProgressHUD *hud = (SMProgressHUD *)cview;
            hud.removeFromSuperViewOnHide = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }
}

# pragma mark - 点击交互
+ (void)showBlackTextWithMessage:(NSString *)message buttonTitle:(NSString *)title {
    // 主线程异步执行, 防止崩溃
    dispatch_async(dispatch_get_main_queue(), ^{
        SMProgressHUD *hud = [SMProgressHUD showHUDAddedTo:kKeyWindowView animated:YES];
        hud.bezelView.color = [UIColor blackColor];
        hud.bezelView.alpha = 0.9;
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.mode = SMProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        [hud.button setTitle:title forState:UIControlStateNormal];
        hud.button.layer.cornerRadius = 3;
        [hud.button addTarget:self action:@selector(hideHUD) forControlEvents:UIControlEventTouchUpInside];
    });
}

@end
