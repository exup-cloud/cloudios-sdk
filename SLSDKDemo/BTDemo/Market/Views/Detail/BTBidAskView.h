//
//  BTBidAskView.h
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBidAskView : UITableView

@property (nonatomic, strong) BTItemModel *itemModel;

- (void)updataBidAskDataArr:(NSMutableArray *)dataArr;

@end
