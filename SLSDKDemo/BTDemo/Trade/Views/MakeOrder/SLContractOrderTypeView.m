//
//  SLContractOrderTypeView.m
//  BTTest
//
//  Created by wwly on 2019/9/7.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractOrderTypeView.h"

@interface SLContractOrderTypeView ()


@end

@implementation SLContractOrderTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    NSArray *titleArr = @[Launguage(@"str_normalOrder"), Launguage(@"str_planOrder")];
    int i = 0;
    CGFloat itemH = 35;
    for (NSString *title in titleArr) {
        UIButton *button = [UIButton buttonExtensionWithTitle:title TitleColor:[SLConfig defaultConfig].lightTextColor Image:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(changeOrderType:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [SLConfig defaultConfig].contentViewColor;
        button.frame = CGRectMake(0, itemH * i, self.sl_width, itemH);
        button.tag = i;
        [self addSubview:button];
        ++i;
    }
    self.sl_height = itemH * titleArr.count;
}


/// 点击切换委托类型
- (void)changeOrderType:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderTypeView_orderTypeChanged:)]) {
        BTContractOrderCategory type = BTContractOrderCategoryUnkown;
        if (sender.tag == 0) {
            type = BTContractOrderCategoryNormal;
        } else if (sender.tag == 1) {
            type = BTContractOrderCategoryPlan;
        }
        [self.delegate orderTypeView_orderTypeChanged:type];
    }
}

@end
