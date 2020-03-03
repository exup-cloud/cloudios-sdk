//
//  BTSelectCoinButton.h
//  BTStore
//
//  Created by 健 王 on 2018/3/30.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTSelectCoinButtonType) {
    BTSelectCoinButtonDefault = 0,
    BTSelectCoinButtonContract,
    BTSelectCoinButtonCalculator
};

@interface BTSelectCoinButton : UIButton

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign) BTSelectCoinButtonType type;

@property (nonatomic, assign) NSInteger addressType;
@end
