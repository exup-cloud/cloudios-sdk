//
//  BTAssetPasswordView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/6/19.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTAssetPasswordViewType) {
    BTAssetPasswordSettingType = 1,
    BTAssetPasswordVerifyType,
    BTAssetPasswordGoogleType
};

@protocol BTAssetPasswordViewDelegate <NSObject>
@optional
- (void)assetPasswordViewDidClickConfirmWithType:(BTAssetPasswordViewType)type password:(NSString *)pwd;

- (void)assetPasswordViewDidClickCancel;

@end
@interface BTAssetPasswordView : UIView
@property (nonatomic, weak) id <BTAssetPasswordViewDelegate>delegate;
+ (void)showAssetPasswordViewToView:(UIView *)view delegate:(id<BTAssetPasswordViewDelegate>)delegate type:(BTAssetPasswordViewType)type;
+ (void)hideAssetViewFromView:(UIView *)view;

// 显示验证码输入错误
+ (void)showPasswordErrorFromView:(UIView *)view;

@end
