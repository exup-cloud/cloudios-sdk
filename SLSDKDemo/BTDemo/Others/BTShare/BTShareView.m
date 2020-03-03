//
//  BTShareView.m
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/6.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import "BTShareView.h"
#import "OTScreenshotHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "BTUtility.h"

@interface BTShareView ()
@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *titleView;
@property (nonatomic, strong) UILabel *dec;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *qrCodeImage;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation BTShareView

+ (instancetype)shareViewWithImage:(UIImage *)image frame:(CGRect)frame {
    BTShareView *shareView = [[BTShareView alloc] initWithFrame:frame];
    [shareView addChildViewsWithImage:image];
    return shareView;
}

+ (instancetype)shareMinePositionImage:(UIImage *)image frame:(CGRect)frame {
     BTShareView *shareView = [[BTShareView alloc] initWithFrame:frame];
    [shareView addChildViewsWithSharePositionImage:image];
    return shareView;
}

- (void)addChildViewsWithSharePositionImage:(UIImage *)image {
    self.backgroundColor = [DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.7];
    self.contentImage = [self createImageViewWithImage:image];
    [self addSubview:self.contentImage];
    CGFloat width = self.sl_height * SL_SCREEN_WIDTH / (SL_SCREEN_HEIGHT - SL_getWidth(125));
    self.contentImage.frame = CGRectMake((self.sl_width - width) * 0.5, 0, width, self.sl_height);
    self.bottomView.backgroundColor = MAIN_COLOR;
    self.bottomView.frame = CGRectMake(0, self.contentImage.sl_height - SL_getWidth(90), self.contentImage.sl_width, SL_getWidth(90));
    self.iconImage = [self createImageViewWithImage:[UIImage imageWithName:@"切片1"]];
    [self.contentImage addSubview:self.iconImage];
    [self.iconImage setBackgroundColor:[UIColor clearColor]];
    self.iconImage.frame = CGRectMake(SL_MARGIN, self.bottomView.sl_y + SL_MARGIN * 1.5, SL_getWidth(60), SL_getWidth(60));
    self.titleView = [self createImageViewWithImage:[UIImage imageWithName:@"bbx-icon-word"]];
    self.titleView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame), self.iconImage.sl_y, SL_getWidth(60), SL_getWidth(20));
    self.dec = [self createLabelWithFont:[UIFont systemFontOfSize:10]];
    self.dec.numberOfLines = 0;
    self.dec.frame = CGRectMake(self.titleView.sl_x, CGRectGetMaxY(self.titleView.frame), self.contentImage.sl_width - self.titleView.sl_x - SL_getWidth(90) , SL_getWidth(30));
    self.dec.text = [NSString stringWithFormat:@"%@ %@", @"领先的指数合约交易平台", @"现在注册最高领10USDT赠金"];
    self.timeLabel = [self createLabelWithFont:[UIFont systemFontOfSize:10]];
    self.timeLabel.textColor = [UIColor colorWithHex:@"#666666"];
    self.timeLabel.frame = CGRectMake(self.titleView.sl_x, CGRectGetMaxY(self.dec.frame), self.dec.sl_width , SL_getWidth(15));
    self.timeLabel.text = [BTFormat timeOnlyDateFromDateStr:[[MyAppInfo getCurrentTimestamp] stringValue]];

    NSString *lan = EN;
    if (![[[BTLanguageTool sharedInstance]getCurrentLanguage]isEqualToString:EN]) {
        lan = CNS;
    }
    UIImage *qrImg = [BTUtility setCheckCodeWithContent:[NSString stringWithFormat:@"https://www.bbx.com/rebate/%@/register.html?inviter=%@", lan, [SLPlatformSDK sharedInstance].activeAccount.Uid]];
    self.qrCodeImage = [self createImageViewWithImage:qrImg];
    [self.contentImage addSubview:self.qrCodeImage];;
    self.qrCodeImage.frame = CGRectMake(self.contentImage.sl_width - SL_getWidth(80), self.bottomView.sl_y + SL_MARGIN, SL_getWidth(70), SL_getWidth(70));
    [self.contentImage addSubview:self.qrCodeImage];
}

- (void)addChildViewsWithImage:(UIImage *)image {
    self.backgroundColor = [DARK_BARKGROUND_COLOR colorWithAlphaComponent:0.7];
    self.contentImage = [self createImageViewWithImage:image];
    [self addSubview:self.contentImage];
    CGFloat width = self.sl_height * SL_SCREEN_WIDTH / SL_SCREEN_HEIGHT;
    self.contentImage.frame = CGRectMake((self.sl_width - width) * 0.5, 0, width, self.sl_height);
    self.bottomView.backgroundColor = MAIN_BTN_TITLE_COLOR;
    self.iconImage = [self createImageViewWithImage:[UIImage imageWithName:@"切片1"]];
    [self.contentImage addSubview:self.iconImage];
    self.iconImage.frame = CGRectMake(SL_MARGIN * 0.5, self.bottomView.sl_y + SL_MARGIN * 0.5, SL_getWidth(50), SL_getWidth(50));
    self.titleView = [self createImageViewWithImage:[UIImage imageWithName:@"bbx-icon-word"]];
    [self.contentImage addSubview:self.titleView];
    self.titleView.frame =
    self.titleView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame) - SL_getWidth(3), self.iconImage.sl_y, SL_getWidth(65), SL_getWidth(25));
    self.dec = [self createLabelWithFont:[UIFont systemFontOfSize:10]];
    self.dec.frame = CGRectMake(self.titleView.sl_x + SL_getWidth(4), CGRectGetMaxY(self.titleView.frame)-SL_getWidth(5), self.contentImage.sl_width - self.titleView.sl_x - SL_getWidth(55) , SL_getWidth(15));
    self.dec.text = @"领先的指数合约交易平台";
    self.timeLabel = [self createLabelWithFont:[UIFont systemFontOfSize:9]];
    self.timeLabel.textColor = [UIColor colorWithHex:@"#666666"];
    self.timeLabel.frame = CGRectMake(self.titleView.sl_x+ SL_getWidth(5), CGRectGetMaxY(self.dec.frame), self.contentImage.sl_width - self.titleView.sl_x - SL_getWidth(55) , SL_getWidth(15));
    self.timeLabel.text = [BTFormat timeOnlyDateFromDateStr:[[MyAppInfo getCurrentTimestamp] stringValue]];
    NSString *lan = EN;
    if (![[[BTLanguageTool sharedInstance]getCurrentLanguage]isEqualToString:EN]) {
        lan = CNS;
    }
    UIImage *qrImg = [BTUtility setCheckCodeWithContent:[NSString stringWithFormat:@"https://www.bbx.com/mobile/download?lang=%@",lan]];
    self.qrCodeImage = [self createImageViewWithImage:qrImg];
    [self.contentImage addSubview:self.qrCodeImage];
    self.qrCodeImage.frame = CGRectMake(self.contentImage.sl_width - SL_getWidth(55), self.bottomView.sl_y + SL_MARGIN * 0.5 , SL_getWidth(50), SL_getWidth(50));
}

+ (UIImage *)shortScreen {
    UIImage *image = [OTScreenshotHelper screenshot];
    return image;
}

- (UIImage *)screenShotWithFrame {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.sl_width, self.sl_height), YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

- (UIImage *)screenShotWithFrameContentImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.contentImage.sl_width, self.contentImage.sl_height), YES, 0.0);
    [self.contentImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}


#pragma mark - create

- (UIImageView *)createImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentImage.sl_height - SL_getWidth(60), self.contentImage.sl_width, SL_getWidth(60))];
        [self.contentImage addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    [self.contentImage addSubview:label];
    label.textColor = [UIColor colorWithHex:@"#333333"];
    return label;
}

@end
