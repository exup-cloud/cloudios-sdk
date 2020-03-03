//
//  YKTimeDataset.h
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YKTimeDataset : NSObject
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *dateArr;
@property (nonatomic,assign) CGFloat highlightLineWidth;
@property (nonatomic,strong) UIColor  *highlightLineColor;
@property (nonatomic,assign) CGFloat  lineWidth;
@property (nonatomic,strong) UIColor *priceLineCorlor;
@property (nonatomic,strong) UIColor *avgLineCorlor;

@property (nonatomic,strong) UIColor *volumeRiseColor;
@property (nonatomic,strong) UIColor *volumeFallColor;
@property (nonatomic,strong) UIColor *volumeTieColor;

@property (nonatomic,assign) BOOL drawFilledEnabled;
@property (nonatomic,strong) UIColor *fillStartColor;
@property (nonatomic,strong) UIColor *fillStopColor;
@property (nonatomic,assign) CGFloat fillAlpha;


@end
