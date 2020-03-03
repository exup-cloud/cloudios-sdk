//
//  MATipView.h
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MATipView : UIView

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *minAvgPriceColor;

@property (nonatomic, strong) UIColor *midAvgPriceColor;

@property (nonatomic, strong) UIColor *maxAvgPriceColor;

@property (nonatomic, copy) NSString *minAvgPrice;

@property (nonatomic, copy) NSString *midAvgPrice;

@property (nonatomic, copy) NSString *maxAvgPrice;

@property (nonatomic, copy) NSString *avg_px;

- (instancetype)initWithFrame:(CGRect)frame Type:(NSInteger)type;

@end
