//
//  CommandMsg.h
//  Chatty
//
//  Created by Eagle Du on 12/7/7.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@interface CommandMsg : NSObject
{
    NSNumber *type;
    NSString *from;
    NSString *desc;
    id data;
}
@property (nonatomic,retain) NSNumber *type;
@property (copy,nonatomic)NSString *from;
@property (copy,nonatomic)NSString *desc;
@property (nonatomic,retain)id data;

-(id)initWithType:(PacketCodes)_type andFrom:(NSString *)_from andDesc:(NSString *)_desc andData:(id)_data;
-(id)initWithDictionary:(NSDictionary *) disc;

@end
