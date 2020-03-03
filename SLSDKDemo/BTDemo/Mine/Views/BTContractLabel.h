//
//  BTContractLabel.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/7/12.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTContractLabel : UILabel

@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *markColor;

- (void)layoutStringArr:(NSArray *)array;

@end
