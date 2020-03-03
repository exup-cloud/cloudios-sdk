//
//  BTIndexDetailView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/1.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTIndexDetailView : UIView

@property (nonatomic, strong) NSArray *dataArr;

- (instancetype)initWithFrame:(CGRect)frame number:(NSInteger)number hasHeader:(NSString *)header;

@end
