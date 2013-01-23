//
//  SecretHelper.h
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

@interface SecretHelper : NSObject

+ (NSString *) md5:(NSString *)str;
+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;

+ (NSString *) encryptStr:(NSString *) str key:(NSString *)_key;
+ (NSString *) decryptStr:(NSString	*) str key:(NSString *)_key;

#pragma mark Based64
+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;

@end
