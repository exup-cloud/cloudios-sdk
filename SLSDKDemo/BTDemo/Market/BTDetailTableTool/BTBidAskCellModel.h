//
//  BTBidAskCellModel.h
//  BTStore
//
//  Created by 健 王 on 2018/1/20.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBidAskCellModel : NSObject

@property (nonatomic, assign) int64_t instrument_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, copy) NSString *bidPrice;
@property (nonatomic, copy) NSString *bidNum;
@property (nonatomic, assign) CGFloat bidLength;

@property (nonatomic, copy) NSString *askPrice;
@property (nonatomic, copy) NSString *askNum;
@property (nonatomic, assign) CGFloat askLength;

@end
