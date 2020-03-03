//
//  SLPrivateConfig.h
//  SLContractSDK
//
//  Created by WWLY on 2019/9/4.
//  Copyright © 2019 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPrivateConfig : NSObject

@property (nonatomic, copy) NSString *PRIVATE_KEY;
@property (nonatomic, copy) NSString *base_host;
@property (nonatomic, copy) NSString *host_Header;

+ (instancetype)sharedConfig;
@end

NS_ASSUME_NONNULL_END
