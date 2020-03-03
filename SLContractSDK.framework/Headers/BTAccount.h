//
//  BTAccount.h
//  BTStore
//
//  Created by WWLy on 2018/1/14.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BTAccountStatusType) {
    BTAccountStatusNotActive = 1,
    BTAccountStatusActive
};

@class BTItemCoinModel;
@interface BTAccount : NSObject

#pragma mark - request
@property (nonatomic, copy) NSString *Ssid;     // Ssenion_ID
@property (nonatomic, copy) NSString *Token;    // Token
@property (nonatomic, copy) NSString *Uid;      // Uid
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *deposit_address;
@property (nonatomic, copy) NSString *withdraw_address;
@property (nonatomic, copy) NSString *ga_key;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger account_type;
@property (nonatomic, assign) BTAccountStatusType status;
@property (nonatomic, copy) NSNumber *account_id;

@end
