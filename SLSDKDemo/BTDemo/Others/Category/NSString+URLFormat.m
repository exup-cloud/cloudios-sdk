//
//  NSString+URLFormat.m
//  URLHandle
//
//  Created by Mike on 15/11/20.
//  Copyright © 2015年 Mike. All rights reserved.
//

#import "NSString+URLFormat.h"

@implementation NSString (URLFormat)

+ (NSString*)urlEncodedString:(NSString *)string {
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

+(NSString *)modifyJsonStr:(NSString *)string
{
    NSString *modifyStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    modifyStr = [string stringByReplacingOccurrencesOfString:@"|" withString:@""];
    modifyStr = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    modifyStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return modifyStr;
}

- (NSDictionary *)parseReturnParamsAndBaseURL:(NSString **)baseURL {
    if (self == nil || [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) { // 没有判断合法的url
        return nil;
    }
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        *baseURL = self;
        return nil;
    }
    NSArray *array = [self componentsSeparatedByString:@"?"];
    *baseURL = array[0];
    if (array.count == 1) {
        return nil;
    }
    NSString *queries = array[1];
    if ([queries stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return nil;
    }
    NSArray *queryArray = [queries componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < queryArray.count; i++) {
        NSString *keyAndValue = queryArray[i];
        NSArray *keyValueArray = [keyAndValue componentsSeparatedByString:@"="];
        if (keyValueArray.count >= 2) {
            NSString *trimmedKeyString = [keyValueArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSUInteger location = [keyAndValue rangeOfString:@"="].location;
            if (trimmedKeyString.length > 0 && location + 1 < keyAndValue.length) {
                NSString *value = [keyAndValue substringWithRange:NSMakeRange(location + 1, keyAndValue.length - (location + 1))];
                [dictM setValue:value forKey:trimmedKeyString];
            }
        }
    }
    return dictM.copy;
}

@end
