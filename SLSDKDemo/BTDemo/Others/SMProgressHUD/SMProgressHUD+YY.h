
#import "SMProgressHUD.h"

@interface SMProgressHUD (YY)

# pragma mark - showHUD

/// 显示图标, 需要手动关闭
+ (void)showHUD;

/// 显示图标和提示语, 需要手动关闭
///
/// @param message 提示语
+ (void)showHUDWithMessage:(NSString *)message;

/// 显示图标和提示语, delay == 0 时需要手动关闭
///
/// @param message 提示语
/// @param delay   显示时长
+ (void)showHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark showBlackHUD

+ (void)showBlackHUD;

+ (void)showBlackHUDWithMessage:(NSString *)message;

+ (void)showBlackHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

/// 当 delay == 0 时需手动隐藏, isTouchEnable: 是否拦截底部视图事件
+ (void)showBlackHUDWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay isTouchEnbale:(BOOL)isTouchEnable;

# pragma mark - showText

/// 只显示提示语
+ (void)showText;

/// 只显示提示语
///
/// 提示语
+ (void)showTextWithMessage:(NSString *)message;

+ (void)showTextWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark showBlackText

/// 只显示提示语
+ (void)showBlackText;

/// 只显示提示语
///
/// 提示语
+ (void)showBlackTextWithMessage:(NSString *)message;

+ (void)showBlackTextWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark - showError

+ (void)showError;

+ (void)showErrorWithMessage:(NSString *)message;

+ (void)showErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark showBlackError

+ (void)showBlackError;

+ (void)showBlackErrorWithMessage:(NSString *)message;

+ (void)showBlackErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark - showSuccess

+ (void)showSuccess;

+ (void)showSuccessWithMessage:(NSString *)message;

+ (void)showSuccessWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark showBlackSuccess

+ (void)showBlackSuccess;

+ (void)showBlackSuccessWithMessage:(NSString *)message;

+ (void)showBlackSuccessWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;


# pragma mark - showInfo

+ (void)showInfo;

+ (void)showInfoWithMessage:(NSString *)message;

+ (void)showInfoWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

# pragma mark showBlackInfo

+ (void)showBlackInfo;

+ (void)showBlackInfoWithMessage:(NSString *)message;

+ (void)showBlackInfoWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

+ (void)showNetworkError;

+ (void)showNetworkErrorWithMessage:(NSString *)message;

+ (void)showNetworkErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;

+ (void)showBlackNetworkError;

+ (void)showBlackNetworkErrorWithMessage:(NSString *)message hideAfterDelay:(CGFloat)delay;


/// 显示自定义图片和提示语
///
/// @param message 提示语
/// @param imgName 图片名称, 需要存在bundle中
/// @param delay   显示时长
+ (void)showCustomWithMessage:(NSString *)message imgName:(NSString *)imgName hideAfterDelay:(CGFloat)delay bgColor:(UIColor *) bgColor;


/// 显示加载动画和提示语
+ (void)showNetWorkAnimaltionHUD;

+ (void)showBlackNetWorkAnimaltionHUD;

/// 显示加载动画
/// 此方法需要手动结束
/// @param images 动画来源数组
/// @param message  提示语
+ (void)showAnimaltionHUDWithImages:(NSArray *)images message:(NSString *)message bgColor:(UIColor *)bgColor;

/// 隐藏当前的HUD
+ (void)hideHUD;

/// 交互点击
+ (void)showBlackTextWithMessage:(NSString *)message buttonTitle:(NSString *)title;


@end
