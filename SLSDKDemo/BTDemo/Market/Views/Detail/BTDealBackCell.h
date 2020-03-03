//
//  BTDealBackCell.h
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTDealBackCellModel;
@interface BTDealBackCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) BTDealBackCellModel *model;
@end
