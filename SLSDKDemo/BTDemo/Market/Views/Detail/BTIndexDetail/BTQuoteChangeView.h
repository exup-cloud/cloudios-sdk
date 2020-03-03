//
//  BTQuoteChangeView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/1.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTQuoteChangeView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)loadDataWithHigh:(NSString *)high low:(NSString *)low open:(NSString *)open close:(NSString *)close currentPrice:(NSString *)currentPrice;

@end
