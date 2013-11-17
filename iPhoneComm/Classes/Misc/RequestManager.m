//
//  RequestManager.m
//  Marry
//
//  Created by EagleDu on 12/2/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*Login
 http://gzuat.vicp.net/Wedding/App/User.ashx?operation=login&email=wedding-app@qq.com&pwd=111111
 */
/*
 Rigister user sample
 http://gzuat.vicp.net/Wedding/App/User.ashx?operation=register&RG_LoginEmail=wedding@qq.com&RG_LoginPassword=111111&RG_CroomName=Andy&RG_BrideName=Cnady&RG_BigDateName=CAN%20Party
 */

#import "RequestManager.h"
#import "RequestHelper.h"
#import "RequestResult.h"
#import "Definition.h"
#import "AppConfig.h"

@implementation RequestManager

-(id)init
{
    self=[super init];
    if(self)
    {
    }
    return  self;
}

-(void)dealloc
{
    
}


#pragma mark Login 

/*
+(ASIHTTPRequest *) loginWithAccount:(NSString *)eamil password:(NSString *)password funCompleted: (FuncJsonResultBlock) onCompleted;
{    
    NSString *url=[NSString stringWithFormat:@"http://gzuat.vicp.net/Wedding/App/User.ashx?operation=login&email=%@&pwd=%@",[RequestHelper encodeURIComponent:eamil],[RequestHelper encodeURIComponent:password]];
    return [RequestHelper getJsonInBackground:url funCompleted:onCompleted]; 
}

+(ASIHTTPRequest *) registerAccount:(NSString *)email password:(NSString *)password
                          groomName:(NSString *)groomName
                          brideName:(NSString *) brideName
                        BigDateName:(NSString *) bigDateName
                       funCompleted: (FuncJsonResultBlock) onCompleted
{
    NSString *url=[NSString stringWithFormat:@"http://gzuat.vicp.net/Wedding/App/User.ashx?operation=register&RG_LoginEmail=%@&RG_LoginPassword=%@&RG_CroomName=%@&RG_BrideName=%@&RG_BigDateName=%@",[RequestHelper encodeURIComponent:email],[RequestHelper encodeURIComponent:password],[RequestHelper encodeURIComponent:groomName],[RequestHelper encodeURIComponent:brideName],[RequestHelper encodeURIComponent:bigDateName]];
    return [RequestHelper getJsonInBackground:url funCompleted:onCompleted]; 
}
*/ 


//通过验证保存在程序中的序列码规则：TKD|序列号|四位预留校验码,默认值为0000|uuid，第一次使用必须进行注册，每天联网时进行一次校验，如果没有联网时，则不进行验证，可以继续使用，每天只进行一次校验
//本逻辑包括首次验证及再次绑定验证
+(ASIHTTPRequest *)registerAndActiveWithUserName:(NSString *)username andPwd:(NSString *) pwd andEmail:(NSString *) email andProductSN:(NSString *)productSn funCompleted: (FuncJsonResultBlock) onCompleted

{    
    
    NSDictionary *params=[[NSDictionary alloc] initWithObjectsAndKeys:email,@"email",username,@"username",[AppConfig getInstance].uuid,@"uuid",productSn,@"productsn",pwd,@"pwd", @"tkdscore",@"requestkey",[[UIDevice currentDevice] name],@"deviceName",nil];
   return [RequestHelper postJsonInBackground:[NSString stringWithFormat:@"%@?type=5",SERVER_URL_ROOT] parameters:params funCompleted:onCompleted];
}

+(BOOL)isActiveCurrentDeviceWithProductSN:(NSString *)productSn
{    
   __block BOOL success=NO;
    NSDictionary *params=[[NSDictionary alloc] initWithObjectsAndKeys:[AppConfig getInstance].uuid,@"uuid",productSn,@"productsn",nil];
   [RequestHelper postJsonInBackground:[NSString stringWithFormat:@"%@?type=6",SERVER_URL_ROOT] parameters:params funCompleted:^(RequestResult *result) {
       success=result.success;
   }];
   return success;
}
#pragma mark Guest

@end
