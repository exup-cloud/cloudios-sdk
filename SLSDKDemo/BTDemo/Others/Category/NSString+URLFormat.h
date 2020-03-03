//
//  NSString+URLFormat.h
//  URLHandle
//
//  Created by Mike on 15/11/20.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLFormat)
+ (NSString *)modifyJsonStr:(NSString *)string;
- (NSDictionary *)parseReturnParamsAndBaseURL:(NSString **)baseURL;

+ (NSString*)urlEncodedString:(NSString *)string;

@end
