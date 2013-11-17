//
//  RequestHelper.h
//  Marry
//
//  Created by EagleDu on 12/2/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"

#if NS_BLOCKS_AVAILABLE
typedef void (^FuncJsonResultBlock)(RequestResult *result);
#endif

@interface RequestHelper : NSObject

+(ASIHTTPRequest*)grabInBackground:(NSString*)url funCompleted: (FuncResultBlock) onCompleted;
+(void)grabSynchronous:(NSString*)url funCompleted: (FuncResultBlock) onCompleted;

+(ASIHTTPRequest*)getJsonInBackground:(NSString*)url parameters:(NSDictionary *)params  funCompleted: (FuncJsonResultBlock) onCompleted;
+(ASIHTTPRequest*)getJsonSynchronous:(NSString*)url parameters:(NSDictionary *)params  funCompleted: (FuncJsonResultBlock) onCompleted;

+(ASIFormDataRequest*)postJsonInBackground:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted;

+(ASIFormDataRequest*)postJsonInBackgroundOrg:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted;

+ (ASIFormDataRequest*)postJsonSynchronous:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted;

+(RequestResult*)parseResult:(NSString*)result error:(NSError*)error httpRequest:(ASIHTTPRequest*)request;

+ (NSString*)encodeURIComponent:(NSString *)string;

+(ASIHTTPRequest *) getListWithUrl:(NSString *) url byPost:(BOOL) byPost async:(BOOL) async params:(NSDictionary *)params pageIndex:(NSInteger) pageIndex pageSize:(NSInteger) pageSize sortBy:(NSString *) sortBy asc:(BOOL) asc funCompleted: (FuncJsonResultBlock) onCompleted;
+(NSString *)getParamsByDictionay:(NSDictionary *)params;
@end
