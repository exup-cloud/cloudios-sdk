//
//  BTShareView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/6.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTShareView : UIView

- (UIImage *)screenShotWithFrame;

+ (UIImage *)shortScreen;

- (UIImage *)screenShotWithFrameContentImage;

+ (instancetype)shareViewWithImage:(UIImage *)image frame:(CGRect)frame;

+ (instancetype)shareMinePositionImage:(UIImage *)image frame:(CGRect)frame;

@end
