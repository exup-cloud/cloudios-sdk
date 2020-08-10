//
//  UITextView+OTCTextViewPH.h
//  Chainup
//
//  Created by xue on 2018/10/11.
//  Copyright © 2018年 zewu wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (OTCTextViewPH)

/** 占位文字 */
@property (copy, nonatomic) NSString *placeHoldString;
/** 占位文字颜色 */
@property (strong, nonatomic) UIColor *placeHoldColor;
/** 占位文字字体 */
@property (strong, nonatomic) UIFont *placeHoldFont;



@end

NS_ASSUME_NONNULL_END
