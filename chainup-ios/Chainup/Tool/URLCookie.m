//
//  URLCookie.m
//  Chainup
//
//  Created by zewu wang on 2019/2/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

#import "URLCookie.h"
#import "Chainup-Swift.h"

@implementation URLCookie
    
    //添加cookie
    -(void)addCookiesWithAppDomain{
        [self addCookiesInDomain:[NetDefine domain_host_url]];
    }
    
    //清理cookie
    -(void)clearCookiesWithAppDomain{
        [self clearCookie:[NetDefine domain_host_url]];
    }

    - (void)addCookiesInDomain:(NSString *)domain
    {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[NSHTTPCookieDomain] = domain;
        properties[NSHTTPCookiePath] = @"/";
        properties[NSHTTPCookieVersion] = @"0";
//        properties[NSHTTPCookieExpires] = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
        [storage setCookie:cookie];
        
        NSDictionary *allCookies = [[NetManager sharedInstance] getHeaderParams];
        for (id key  in [allCookies keyEnumerator]) {
            properties[NSHTTPCookieName] = key;
            properties[NSHTTPCookieValue] = allCookies[key];
            cookie = [NSHTTPCookie cookieWithProperties:properties];
            [storage setCookie:cookie];
        }
    }
    
    -(void) clearCookie:(NSString *)domain{
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            if ( [cookie.domain isEqualToString:domain]) {
                [cookieJar deleteCookie:cookie];
            }
        }
    }
    
@end
