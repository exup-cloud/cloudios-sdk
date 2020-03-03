//
//  BTCommTableView.h
//  Bbx_Appstore
//
//  Created by 健 王 on 2018/11/2.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCommTableView : UITableView

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSString *unit;

- (void)loadWithDataArray:(NSArray *)dataArr;

@end
