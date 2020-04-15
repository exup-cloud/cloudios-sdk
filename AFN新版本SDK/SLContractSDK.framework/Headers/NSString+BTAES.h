//
//  NSString+BTAES.h
//  BTStore
//
//  Created by WWLy on 2018/1/29.
//  Copyright © 2018年 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BTAES)
/**< 加密方法 */
- (NSString*)bt_encryptWithAES; // 128

/**< 解密方法 */
- (NSString*)bt_decryptWithAES;

- (NSString *)aes256_encrypt:(NSString *)key nonce:(NSString *)nonce;
- (NSString *)aes256_decrypt:(NSString *)key;

@end
