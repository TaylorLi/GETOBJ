//
//  Definition.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Definition.h"

@implementation Definition

+(NSString *)getWinTypeDesc:(WinType)type{
    switch (type) {
        case kWinByPoint:            
            return @"Win By Point";
        case kWinByPointGap:
            return @"Win By Point Gap";
        case  kWinByByWarning:
            return @"Win By Warning";
        default:
            return @"";
    }
}

+(NSString *)getKeyCodeDesc:(short)keyCode
{
    if(keyCode>=GSEVENTKEY_KEYCODE_ALP_A&&keyCode<=GSEVENTKEY_KEYCODE_ALP_Z)
    {
        short c=(short)'A';
        c=keyCode-GSEVENTKEY_KEYCODE_ALP_A+c;
        return [NSString stringWithFormat:@"Alpha %c",(char)c];
    }
    else if(keyCode==GSEVENTKEY_KEYCODE_NUM_0)
    {
        return @"Num 0";
    }
    else if(keyCode>=GSEVENTKEY_KEYCODE_NUM_1&&keyCode<=GSEVENTKEY_KEYCODE_NUM_9)
    {
        short c=(short)'1';
        c=keyCode-GSEVENTKEY_KEYCODE_NUM_1+c;
        return [NSString stringWithFormat:@"Num %c",(char)c];
    }
    else
    {
        NSDictionary *codeDesc=[[NSDictionary alloc] initWithObjectsAndKeys:
                                @"~",@"53",
                                @"-",@"45",
                                @"+",@"46",
                                @"\\",@"49",
                                @"[",@"47",
                                @"]",@"48",
                                @";",@"51",
                                @"'",@"52",
                                @",",@"54",
                                @".",@"55",
                                @"/",@"56",
                                @"ARROW RIGHT",@"79",
                                @"ARROW LEFT",@"80",
                                @"ARROW DOWN",@"81",
                                @"ARROW UP",@"82",
                                nil];
        if([codeDesc containKey:[NSString stringWithFormat:@"%i",keyCode]])
        {
            return [codeDesc objectForKey:[NSString stringWithFormat:@"Char %i",keyCode]];
        }
        else
            return [NSString stringWithFormat:@"Unmatch code %i",keyCode];
    }
}
@end
