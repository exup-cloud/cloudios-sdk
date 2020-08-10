//
//  URLCookie.h
//  Chainup
//
//  Created by zewu wang on 2019/2/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLCookie : NSObject

    -(void)addCookiesWithAppDomain;
    
    -(void)clearCookiesWithAppDomain;
    
    -(void)addCookiesInDomain:(NSString *)domain;
    
    -(void) clearCookie:(NSString *)domain;
@end

NS_ASSUME_NONNULL_END
