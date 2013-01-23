//
//  RequestHelper.m
//  Marry
//
//  Created by EagleDu on 12/2/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestHelper.h"
#import "AppConfig.h"

@implementation RequestHelper

#pragma mark - Get Request
+(ASIHTTPRequest*)grabInBackground:(NSString*)url funCompleted: (FuncResultBlock) onCompleted
{
    NSURL *urlObj = [NSURL URLWithString:url];
    __block ASIHTTPRequest __weak *request = [ASIHTTPRequest requestWithURL:urlObj];
    [request setTimeOutSeconds:[AppConfig getInstance].requestTimeout];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        // Use when fetching binary data
        //NSData *responseData = [request responseData];
       RequestResult *result=[[RequestResult alloc] init:YES error:nil errorMsg:nil extraData:responseString httpRequest:request];
        onCompleted(result);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        RequestResult *result=[[RequestResult alloc] init:NO error:error errorMsg:[error localizedDescription] extraData:nil httpRequest:request];
        onCompleted(result);
    }];
    [request startAsynchronous];  
    return request;
}

+ (void)grabSynchronous:(NSString*)url funCompleted: (FuncResultBlock) onCompleted
{
    NSURL *urlObj = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlObj];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *responseStr;
    RequestResult *result;
    if (!error) {
        responseStr = [request responseString];
        result=[[RequestResult alloc] init:YES error:error errorMsg:nil extraData:responseStr httpRequest:request]; 
    }
    else{
        result=[[RequestResult alloc] init:NO error:error errorMsg:[error localizedDescription] extraData:responseStr httpRequest:request];
    }
    onCompleted(result);
}

+(ASIHTTPRequest*)getJsonInBackground:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted
{
    url=[NSString stringWithFormat:@"%@%@",url ,[self getParamsByDictionay:params]];
    NSLog(@"getJsonSynchronous,url:%@",url);
    NSURL *urlObj = [NSURL URLWithString:url];
    __block ASIHTTPRequest __weak *request = [ASIHTTPRequest requestWithURL:urlObj];
    [request setTimeOutSeconds:[AppConfig getInstance].requestTimeout];
    [request setCompletionBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *responseString = [request responseString];
        RequestResult *result=[RequestHelper parseResult:responseString error:nil httpRequest:request];
        onCompleted(result);
          NSLog(@"request completed:%@,response:%@",url,responseString);
    }];
    [request setFailedBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError *error = [request error];
        RequestResult *result=[[RequestResult alloc] init:NO error:error errorMsg:[error localizedDescription] extraData:nil httpRequest:request];
        onCompleted(result);
          NSLog(@"request completed:%@,response:%@",url,error);
    }];
    [request startAsynchronous]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return request;
}

+ (ASIHTTPRequest*)getJsonSynchronous:(NSString*)url parameters:(NSDictionary *)params  funCompleted: (FuncJsonResultBlock) onCompleted
{
    url=[NSString stringWithFormat:@"%@%@",url ,[self getParamsByDictionay:params]];
    NSLog(@"getJsonSynchronous,url:%@",url);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlObj = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlObj];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *responseString;
    responseString = [request responseString];
    NSLog(@"request completed:%@,response:%@",url,responseString);
    RequestResult *result=[RequestHelper parseResult:responseString error:error httpRequest:request];    
    onCompleted(result);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return request;
}

#pragma remark Post Form

+(ASIFormDataRequest*)postJsonInBackgroundOrg:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted
{
    NSLog(@"postJsonInBackground,url:%@,parameters:%@",url,[RequestHelper getParamsByDictionay:params]);
    NSURL *urlObj = [NSURL URLWithString:url];
    __block ASIFormDataRequest __weak *request = [ASIFormDataRequest requestWithURL:urlObj];
    for (NSString * pKey in params.allKeys) {
        [request setPostValue:[params valueForKey:pKey] forKey:pKey];
    }
    [request setTimeOutSeconds:[AppConfig getInstance].requestTimeout];
    [request setCompletionBlock:^{        
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *responseString = [request responseString];
        RequestResult *result=[RequestHelper parseResult:responseString error:nil httpRequest:request];
        NSLog(@"request completed:%@,response:%@",url,responseString);
        onCompleted(result);
    }];
    [request setFailedBlock:^{         
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError *error = [request error];
        RequestResult *result=[[RequestResult alloc] init:NO error:error errorMsg:[error localizedDescription] extraData:nil httpRequest:request];
        NSLog(@"request failed:%@,response:%@",url,error);
        onCompleted(result);
    }];
    [request startAsynchronous]; 
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return request;
}

+(ASIFormDataRequest*)postJsonInBackground:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted
{
    __block ASIFormDataRequest* request;
    [NSTimer scheduledTimerWithTimeInterval:0.1 block:^{
         request = [RequestHelper postJsonSynchronous:url parameters:params funCompleted:onCompleted];
    } repeats:NO];
    return request;
}
+ (ASIFormDataRequest*)postJsonSynchronous:(NSString*)url parameters:(NSDictionary *)params funCompleted: (FuncJsonResultBlock) onCompleted
{
    
    NSLog(@"postJsonSynchronous,url:%@,parameters:%@",url,[RequestHelper getParamsByDictionay:params]);
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlObj = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlObj];
    for (NSString * pKey in params.allKeys) {
        [request setPostValue:[params valueForKey:pKey] forKey:pKey];
    }
    /*该做法会传递一个key为null的form值到服务器端
    SBJsonWriter *sbJson = [[SBJsonWriter alloc] init];
    NSString*jsonBody = [sbJson stringWithObject:params];
    NSData *bodyData = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *md=[[NSMutableData alloc] initWithData:bodyData];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request setPostBody:md];
    */
     [request startSynchronous];
    NSError *error = [request error];
    NSString *responseString;
    responseString = [request responseString];
    RequestResult *result=[RequestHelper parseResult:responseString error:error httpRequest:request];    
    NSLog(@"request completed:%@,response:%@",url,responseString);
    onCompleted(result);    
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return request;
}

#pragma remark Parse Result
+(RequestResult*)parseResult:(NSString*)responseString error:(NSError *)error httpRequest:(ASIHTTPRequest*)request
{
    RequestResult *result=nil;
    if (!error) {
        SBJsonParser *parser=[[SBJsonParser alloc] init];        
        if(responseString==nil||[responseString length]==0){
            result=[[RequestResult alloc] init:NO error:nil errorMsg:@"No result return." extraData:responseString httpRequest:request];  
        }
        else
        {
            NSMutableDictionary *resultObj = (NSMutableDictionary*)[parser objectWithString:responseString];
            if(resultObj!=nil){
                result=[[RequestResult alloc] init];
                result.error=error;
                result.errorMsg= [resultObj objectForKey:@"message"];
                result.success=[[resultObj objectForKey:@"success"] intValue]==1;
                result.extraData=[resultObj objectForKey:@"data"];
                result.requestXHR=request;
            }
            else
            {
                result=[[RequestResult alloc] init:NO error:error errorMsg:@"Json parse error." extraData:resultObj httpRequest:request];        
            } 
        }
    }
    else{
        result=[[RequestResult alloc] init:NO error:error errorMsg:[error localizedDescription] extraData:responseString httpRequest:request];
    }
    return result;
}

#pragma mark utilities
+ (NSString*)encodeURIComponent:(NSString *)string
{   
	return [[[ASIFormDataRequest alloc] init] encodeURIComponent:string];
}

#pragma GetList

+(ASIHTTPRequest *) getListWithUrl:(NSString *) url byPost:(BOOL) byPost async:(BOOL) async params:(NSDictionary *)params pageIndex:(NSInteger) pageIndex pageSize:(NSInteger) pageSize sortBy:(NSString *) sortBy asc:(BOOL) asc funCompleted: (FuncJsonResultBlock) onCompleted
{    
    NSMutableDictionary *pars=[[NSMutableDictionary alloc] initWithDictionary:params];
    [pars setObject:asc==YES?@"1":@"0" forKey:@"IsAsc"];
    if (pageIndex>0) {
        [pars setObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
    }
    if(pageSize>0){
         [pars setObject:[NSNumber numberWithInt:pageSize] forKey:@"PageSize"];
    }
    if(sortBy!=nil&&sortBy.length>0)
    {
        [pars setObject:sortBy forKey:@"SortBy"];
    } 
    if(byPost){
        if(async){
            return [RequestHelper postJsonInBackground:url parameters:params funCompleted:onCompleted]; 
        }
        else{
            return [RequestHelper postJsonSynchronous:url parameters:params funCompleted:onCompleted]; 
        }
    }
    else{
        if(async){
            return [RequestHelper getJsonInBackground:url parameters:pars funCompleted:onCompleted]; 
        }
        else{
            return [RequestHelper getJsonSynchronous:url parameters:pars funCompleted:onCompleted]; 
        }
    }
}

+(NSString *)getParamsByDictionay:(NSDictionary *)params
{
    ASIFormDataRequest *form = [ASIFormDataRequest requestWithURL:nil];
    NSMutableString *pars=[[NSMutableString alloc] init];
    if (params!=nil) {
        for (NSString *key in params.allKeys) {
            [pars appendString:[NSString stringWithFormat:@"&%@=%@",key,[form
                                                                         encodeURIComponent:[params objectForKey:key]]]];            
        }
    }
    return pars;
}

@end
