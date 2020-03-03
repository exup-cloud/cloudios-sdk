//
//  Common.m
//  BTStore
//
//  Created by 健 王 on 2018/3/12.
//  Copyright © 2018年 Karl. All rights reserved.
//


#import "YKLineChartViewBase.h"
#import "YKLineDataSet.h"

@interface YKTimeLineView : YKLineChartViewBase


@property (nonatomic,assign)CGFloat offsetMaxPrice;
@property (nonatomic,assign)NSInteger countOfTimes;

@property (nonatomic,assign)BOOL endPointShowEnabled;
@property (nonatomic,assign)BOOL isDrawAvgEnabled;
@property (nonatomic,assign)BOOL isShowHorScreen;

- (void)setupData:(YKTimeDataset *)dataSet;

@end
