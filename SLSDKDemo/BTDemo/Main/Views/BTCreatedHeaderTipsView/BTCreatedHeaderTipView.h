//
//  BTCreatedHeaderTipView.h
//  BTStore
//
//  Created by 健 王 on 2018/3/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCreatedHeaderTipView : UIView
@property (nonatomic, strong) UILabel *tipsLabel;

- (void)setupContent:(NSString *)content highStr:(NSArray *)array;

@end
