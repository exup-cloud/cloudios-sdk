//
//  SLConfig.m
//  SLContractSDK
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLConfig.h"

@implementation SLConfig

static SLConfig *instance = nil;
+ (instancetype)defaultConfig {
    static dispatch_once_t onceToKen;
    dispatch_once(&onceToKen,^{
        instance = [[SLConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initDefaultConfig];
    }
    return self;
}

- (void)initDefaultConfig {
    self.navBarBackgroundColor = SLColor(24, 26, 34);
    self.navTitleColor = [UIColor whiteColor];
    self.marginLineColor = SLColor(16, 19, 28);
    self.contentViewColor = SLColor(24, 26, 34);
    self.darkGrayTextColor = SLColor(24, 26, 34);
    
    self.darkTextColor = SLColor(51, 51, 51);
    self.lightTextColor = SLColor(244, 244, 245);
    
    self.darkGrayTextColor = SLColor(102, 102, 102);
    self.lightGrayTextColor = SLColor(158, 158, 161);
    
    self.blueTextColor = SLColor(32, 164, 192);
    self.greenColorForBuy = SLColor(46, 181, 100);
    self.redColorForSell = SLColor(253, 58, 58);
}

@end
