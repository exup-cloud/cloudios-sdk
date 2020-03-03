//
//  SLBaseTableView.m
//  BTTest
//
//  Created by 健 王 on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLBaseTableView.h"

@interface SLBaseTableView ()
@property (nonatomic, strong) UIView * gradientView;
@end

@implementation SLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.gradientView = [[UIView alloc] initWithFrame:self.bounds];
        [self setBackgroundView:self.gradientView];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(id)MAIN_COLOR.CGColor, (id)[UIColor colorWithHex:@"#444554"].CGColor];
        [self.gradientView.layer addSublayer:gradientLayer];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.gradientView = [[UIView alloc] initWithFrame:self.bounds];
        [self setBackgroundView:self.gradientView];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(id)MAIN_COLOR.CGColor, (id)[UIColor colorWithHex:@"#444554"].CGColor];
        [self.gradientView.layer addSublayer:gradientLayer];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end
