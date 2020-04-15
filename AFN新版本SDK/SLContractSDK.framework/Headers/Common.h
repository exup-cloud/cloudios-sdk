//
//  Common.h
//  SLContractSDK
//
//  Created by WWLy on 2018/4/25.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTContractOrderModel.h"
#import "BTContractsModel.h"
#import "BTFormat.h"
#import "MyAppInfo.h"

@interface Common : NSObject

/**
 *  根据精度合并深度列表数据
 *
 *  @param dataArray    当前的深度数组
 *  @param decimalType  精度
 */
+ (NSMutableArray <BTContractOrderModel *> *)loadDataWithArray:(NSArray <BTContractOrderModel *> *)dataArray decimalType:(BTDepthPriceDecimalType)decimalType Way:(BTOrderWay)way;

/**
 *  对深度数组进行排序买盘卖盘都是降序
 *
 *  @param arr          需要排序的数组
 *  @param way          买卖单类型
 */
+ (NSMutableArray *)sequenceWithDepthPriceArr:(NSMutableArray *)arr Way:(BTOrderWay)way;

// 判断越狱——2 （1表示不正常， 0表示正常）
+ (CGFloat)checkSf;

// 判断越狱——3 (1：表示正常， 0表示不正常) // 在iOS 11上越狱不管用，没有用到
+ (int)currEnvNor;

// 判断越狱——4 (1:表示正常， 0表示不正常)
+ (int)checkStart;

// 比较版本号
+ (BOOL)compareVesionWithServerVersion:(NSString *)version;

+ (NSString *)carculateCNY:(NSString *)price;
+ (NSString *)currentPriceWithCoin:(NSString *)coin currentPrice:(NSString *)currentPrice;
+ (BOOL)hasCollect;
+ (UIViewController *)getCurrentViewController:(UIView *)view;
@end
