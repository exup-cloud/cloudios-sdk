//
//  BTContractTextView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BTContractTextMarketPrice = 1, // 市价价格框
    BTContractTextBuyOnePrice,     // 买一价
    BTContractTextSellOnePrice,    // 卖一价
    BTContractTextLimitPrice,      // 限价价格框
    BTContractTextVolume,          // 数量框
    BTContractTextTrigger,         // 触发价格
    BTContractTextPerform,          // 执行价格
    BTContractTextMarketPerform     // 市价执行
} BTContractTextFieldType;

@class BTContractTextView, BTTextField;
@protocol BTContractTextViewDelegate <NSObject>
- (void)contractTextViewValuehasChange:(BTContractTextView *)contractTextView;
- (void)contractTextViewDidClickMarketPriceBtn:(UIButton *)sender;
@end

@interface BTContractTextView : UIView

@property (nonatomic, weak) id <BTContractTextViewDelegate>delegate;
@property (nonatomic, strong) BTTextField *defineView;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BTContractTextFieldType type;
@property (nonatomic, copy) NSString *currentValue;

@property (nonatomic, copy) NSString *unitStr;

@end
