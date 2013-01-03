//
//  RequestManager.h
//  Marry
//
//  Created by EagleDu on 12/2/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestHelper.h"

@interface RequestManager : NSObject
{
}

-(id)init;

+(ASIHTTPRequest *)registerAndActiveWithUserName:(NSString *)username andPwd:(NSString *) pwd andEmail:(NSString *) email andProductSN:(NSString *)productSn funCompleted: (FuncJsonResultBlock) onCompleted;

+(BOOL)isActiveCurrentDeviceWithProductSN:(NSString *)productSn;

@end
