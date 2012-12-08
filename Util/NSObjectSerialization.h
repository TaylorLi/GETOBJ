//
//  NSObject+Serialization.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/25.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SqliteORMDelegate
-(NSString *) primaryKey;
-(NSDictionary*) proxyForSqlite;
-(id)bindingWithDictionary:(NSDictionary *) dictionary;
@end
@interface NSObjectSerialization : NSObject<NSCoding>
-(NSDictionary*) proxyForJson;
-(id)initWithDictionary:(NSDictionary *) dictionary;
-(NSDictionary*) proxyForSqlite;
-(id)bindingWithDictionary:(NSDictionary *) dictionary;
@end
