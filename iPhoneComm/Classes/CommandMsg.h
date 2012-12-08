//
//  CommandMsg.h
//  Chatty
//
//  Created by Eagle Du on 12/7/7.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@interface CommandMsg : NSObjectSerialization<SqliteORMDelegate>
{
    NSNumber *type;
    NSString *from;
    NSString *desc;
    NSDate *date;
    
    id data;
}
@property (nonatomic,strong) NSNumber *type;
@property (copy,nonatomic)NSString *from;
@property (copy,nonatomic)NSString *desc;
@property (nonatomic,strong)id data;
@property (nonatomic,strong)NSDate *date;
@property (copy,nonatomic)NSString *gameId;
@property (copy,nonatomic)NSString *msgId;

-(id)initWithType:(PacketCodes)_type andFrom:(NSString *)_from andDesc:(NSString *)_desc andData:(id)_data andDate:(NSDate *)_date;
-(id)initWithDictionary:(NSDictionary *) disc;

@end
