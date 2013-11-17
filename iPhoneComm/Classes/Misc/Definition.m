//
//  Definition.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Definition.h"

NSString *ORUpKey = @"UP";
NSString *ORDownKey = @"DOWN";
NSString *ORLeftKey = @"LEFT";
NSString *ORRightKey = @"RIGHT";
NSString *OREnterKey = @"\r";
NSString *OREscapeKey = @"ESCAPE";
NSString *ORDeleteKey = @"";
NSString *ORSpaceKey = @" ";
NSString *ORTabKey = @"	";
NSString *ORTildeKey = @"`";
NSString *ORCommaKey = @",";

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

+(short)getKeyCodeByKeyCodeString:(NSString *)keyCode
{
    if(keyCode==nil||[keyCode isEqualToString:@""])
        return 0;
    else{
        
        if ([keyCode isEqualToString:ORTabKey]) return GSEVENTKEY_KEYCODE_SNL_TAB;
        if ([keyCode isEqualToString:ORSpaceKey]) return GSEVENTKEY_KEYCODE_SNL_SPACE;
        
        if ([keyCode isEqualToString:ORDeleteKey]) return GSEVENTKEY_KEYCODE_SNL_DEL;
        if ([keyCode isEqualToString:OREnterKey]) return GSEVENTKEY_KEYCODE_SNL_RETURN;
        if ([keyCode isEqualToString:OREscapeKey]) return GSEVENTKEY_KEYCODE_SNL_ESCAPE;
        if ([keyCode isEqualToString:ORCommaKey]) return GSEVENTKEY_KEYCODE_SNL_COMMA;
        
        
        if ([keyCode isEqualToString:ORUpKey]) return GSEVENTKEY_KEYCODE_ARROW_UP;
        if ([keyCode isEqualToString:ORDownKey]) return GSEVENTKEY_KEYCODE_ARROW_DOWN;
        if ([keyCode isEqualToString:ORLeftKey]) return GSEVENTKEY_KEYCODE_ARROW_LEFT;
        if ([keyCode isEqualToString:ORRightKey]) return GSEVENTKEY_KEYCODE_ARROW_RIGHT;
        //-=[]\;'`  45-49 51-53
        if ([keyCode isEqualToString:@"-"]) return GSEVENTKEY_KEYCODE_SNL_HYPHENS;
        if ([keyCode isEqualToString:@"="]) return GSEVENTKEY_KEYCODE_SNL_HYPHENS+1;
        if ([keyCode isEqualToString:@"["]) return GSEVENTKEY_KEYCODE_SNL_HYPHENS+2;
        if ([keyCode isEqualToString:@"]"]) return GSEVENTKEY_KEYCODE_SNL_HYPHENS+3;
        
        if ([keyCode isEqualToString:@"\\"]) return GSEVENTKEY_KEYCODE_SNL_REVSLASH;
        if ([keyCode isEqualToString:@";"]) return GSEVENTKEY_KEYCODE_SNL_SEMICOLON;
        
        if ([keyCode isEqualToString:@"'"]) return GSEVENTKEY_KEYCODE_SNL_SEMICOLON+1;
        if ([keyCode isEqualToString:ORTildeKey]) return GSEVENTKEY_KEYCODE_SNL_Wave;
        if ([keyCode isEqualToString:@"/"]) return  GSEVENTKEY_KEYCODE_SNL_SLASH;
        if ([keyCode isEqualToString:@"0"]) return GSEVENTKEY_KEYCODE_NUM_0;
        else{
            unichar c= [keyCode characterAtIndex:0];
            short v=(short)c;
            if(v>=GSEVENTKEY_KEYCODE_CHARCODE_A&&v<=GSEVENTKEY_KEYCODE_CHARCODE_A+25)
                return GSEVENTKEY_KEYCODE_ALP_A+v-GSEVENTKEY_KEYCODE_CHARCODE_A;
            else if(v>=GSEVENTKEY_KEYCODE_CHARCODE_1&&v<=GSEVENTKEY_KEYCODE_CHARCODE_1+8)
                return GSEVENTKEY_KEYCODE_NUM_1+v-GSEVENTKEY_KEYCODE_CHARCODE_1;
            return 0;
        }
    }
}

+ (NSString *)stringFromKeycode:(UniChar *)code {
    NSInteger keyCode = code[0];
    
    // Just to speed up the loading WRT the amount of ifs.
    
    if (keyCode== 4) return @"a";
    if (keyCode== 5) return @"b";
    if (keyCode== 6) return @"c";
    if (keyCode== 7) return @"d";
    if (keyCode== 8) return @"e";
    if (keyCode== 9) return @"f";
    if (keyCode==10) return @"g";
    if (keyCode==11) return @"h";
    if (keyCode==12) return @"i";
    if (keyCode==13) return @"j";
    if (keyCode==15) return @"k";
    if (keyCode==14) return @"l";
    if (keyCode==16) return @"m";
    if (keyCode==17) return @"n";
    if (keyCode==18) return @"o";
    if (keyCode==19) return @"p";
    if (keyCode==20) return @"q";
    if (keyCode==21) return @"r";
    if (keyCode==22) return @"s";
    if (keyCode==23) return @"t";
    if (keyCode==24) return @"u";
    if (keyCode==25) return @"w";
    if (keyCode==26) return @"x";
    if (keyCode==27) return @"y";
    if (keyCode==28) return @"z";
    
    
    if (keyCode==30) return @"1";
    if (keyCode==31) return @"2";
    if (keyCode==32) return @"3";
    if (keyCode==33) return @"4";
    if (keyCode==34) return @"5";
    if (keyCode==35) return @"6";
    if (keyCode==36) return @"7";
    if (keyCode==37) return @"8";
    if (keyCode==38) return @"9";
    if (keyCode==39) return @"0";
    
    if (keyCode==43) return ORTabKey;
    if (keyCode==44) return ORSpaceKey;
    if (keyCode==53) return ORTildeKey;
    if (keyCode==42) return ORDeleteKey;
    if (keyCode==40) return OREnterKey;
    if (keyCode==41) return OREscapeKey;
    if (keyCode==54) return ORCommaKey;
    
    
    if (keyCode==82) return ORUpKey;
    if (keyCode==81) return ORDownKey;
    if (keyCode==80) return ORLeftKey;
    if (keyCode==79) return ORRightKey;
    
    return nil;
}

@end




