//
//  DefinedUIApplication.m
//  TKD Score
//
//  Created by Eagle Du on 12/9/6.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "DefinedUIApplication.h"
#import "AppConfig.h"


@interface UIInternalEvent : UIEvent @end
@interface UIPhysicalButtonsEvent : UIInternalEvent @end

@interface UIPhysicalKeyboardEvent : UIPhysicalButtonsEvent
@property(retain, nonatomic) NSString *_unmodifiedInput;
@end

@interface UIApplication ()
- (void)handleKeyUIEvent:(UIPhysicalKeyboardEvent *)event;
@end


@implementation DefinedUIApplication

#pragma mark -
#pragma mark 蓝牙键盘事件

// Calculation of offsets for traversing GSEventRef:
// Count the size of types inside CGEventRecord struct
// https://github.com/kennytm/iphone-private-frameworks/blob/master/GraphicsServices/GSEvent.h

// typedef struct GSEventRecord {
// GSEventType type; // 0x8 //2
// GSEventSubType subtype; // 0xC //3
// CGPoint location; // 0x10 //4
// CGPoint windowLocation; // 0x18 //6
// int windowContextId; // 0x20 //8
// uint64_t timestamp; // 0x24, from mach_absolute_time //9
// GSWindowRef window; // 0x2C //
// GSEventFlags flags; // 0x30 //12
// unsigned senderPID; // 0x34 //13
// CFIndex infoSize; // 0x38 //14
// } GSEventRecord;

// typedef struct GSEventKey {
// GSEvent _super;
// UniChar keycode, characterIgnoringModifier, character; // 0x38, 0x3A, 0x3C // 15 and start of 16
// short characterSet; // 0x3E // end of 16
// Boolean isKeyRepeating; // 0x40 // start of 17
// } GSEventKey;

#define GSEVENT_TYPE 2
//#define GSEVENT_SUBTYPE 3
//#define GSEVENT_LOCATION 4
//#define GSEVENT_WINLOCATION 6
//#define GSEVENT_WINCONTEXTID 8
//#define GSEVENT_TIMESTAMP 9
//#define GSEVENT_WINREF 11
#define GSEVENT_FLAGS 12 //Ctrl,Command,Alt键标识
//#define GSEVENT_SENDERPID 13
//#define GSEVENT_INFOSIZE 14

#define GSEVENTKEY_KEYCODE_CHARIGNORINGMOD 15
//#define GSEVENTKEY_CHARSET_CHARSET 16
//#define GSEVENTKEY_ISKEYREPEATING 17 // ??

#define GSEVENT_TYPE_KEYDOWN 10
#define GSEVENT_TYPE_KEYUP 11



NSString *const UIEventGSEventKeyUpNotification = @"UIEventGSEventKeyUpNotification";

- (void)sendEvent:(UIEvent *)event
{
    @try {        
        
        [super sendEvent:event];
        if(![AppConfig getInstance].isIPAD || ![AppConfig getInstance].hasValidActive)
            return;
        if ([self isEditingText]) return;
        if ([event respondsToSelector:@selector(_gsEvent)]) {
            // Hardware Key events are of kind UIInternalEvent which are a wrapper of GSEventRef which is wrapper of GSEventRecord
            int *eventMemory = (int *)[event performSelector:@selector(_gsEvent)];
            if (eventMemory) {
                
                int eventType = eventMemory[GSEVENT_TYPE];
                //NSLog(@"event type = %d", eventType);
                if (eventType == GSEVENT_TYPE_KEYDOWN) {
                    
                    // Since the event type is key up we can assume is a GSEventKey struct
                    // Get flags from GSEvent
                    int eventFlags = eventMemory[GSEVENT_FLAGS];
                    //if (eventFlags) {
                    // Only post notifications when Shift, Ctrl, Cmd or Alt key were pressed.
                    
                    // Get keycode from GSEventKey
                    int tmp = eventMemory[15];
                    UniChar *keycode = (UniChar *)&tmp; // Cast to silent warning
                    //tmp = (tmp & 0xFF00);
                    //tmp = tmp >> 16;
                    //UniChar keycode = tmp;
                    //tmp = eventMemory[16];
                    //tmp = (tmp & 0x00FF);
                    //tmp = tmp << 16;
                    //UniChar keycode = tmp;
                    //NSLog(@"keycode char %d", keycode[0]);
                    BOOL shift=(eventFlags&(1<<17))?YES:NO;
                    BOOL command=(eventFlags&(1<<18))?YES:NO;
                    BOOL option=(eventFlags&(1<<19))?YES:NO;
                    BOOL control=(eventFlags&(1<<20))?YES:NO;
                    if (keycode==0) {
                        return;
                    }
                    printf("Shift Ctrl Alt Cmd %i %i %i %d\n ",shift, control,option,command);
                    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithShort:keycode[0]], @"keycode", [NSNumber numberWithInt:eventFlags], @"eventFlags",[NSNumber numberWithBool:shift],@"shift",[NSNumber numberWithBool:command],@"command",[NSNumber numberWithBool:option],@"option",[NSNumber numberWithBool:control],@"control", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UIEventGSEventKeyUpNotification object:nil userInfo:userInfo];
                    
                    /*
                     Some Keycodes found
                     ===================
                     
                     Alphabet
                     a = 4
                     b = 5
                     c = ...
                     z = 29
                     
                     Numbers
                     1 = 30
                     2 = 31
                     3 = ...
                     9 = 38
                     
                     Arrows
                     Right = 79
                     Left = 80
                     Down = 81
                     Up = 82
                     
                     Flags found (Differ from Kenny's header)
                     ========================================
                     
                     Shift = 1 << 17
                     Command = 1 << 18
                     Option = 1 << 19
                     Control = 1 << 20
                     
                     */
                    //}
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

/*
- (void)handleKeyUIEvent:(UIEvent *)event
{
 
     size_t s = malloc_size((__bridge const void *)(event));
     NSLog(@"%s enter... %ld", __func__, s);
     //    unsigned char *ptr = (unsigned char *)(__bridge void *)event;
     
     unsigned long *ptr = (unsigned long *)(__bridge void *)event;
     //
     //#define OFF_KEY_MASK 12
     //#define OFF_KEY_SCANCODE 15
     //#define OFF_KEY_CHAR 17
     
     //    NSLog(@"type: %lx off: %d", *(ptr + 2), 2);
     //    NSLog(@"MASK: %lx off: %d", *(ptr + OFF_KEY_MASK), OFF_KEY_MASK);
     //    NSLog(@"SCAN: %lx off: %d", *(ptr + OFF_KEY_SCANCODE), OFF_KEY_SCANCODE);
     //    NSLog(@"CHAR: %lx off: %d", *(ptr + OFF_KEY_CHAR), OFF_KEY_CHAR);
     
     NSLog(@"sizeof unsigned long: %lx", sizeof(unsigned long));
     
     for (int i = 0; i < s / 4; ++i) {
     //        NSLog(@"... [%d] = %x", i, *(unsigned char *)(ptr + i));
     NSLog(@"... [%d] = %lx", i, *(unsigned long *)(ptr + i));
     }
     
     #define OFF_DUMP 8
     
     unsigned long *dump = (unsigned long *) *(ptr + OFF_DUMP);
     s = malloc_size((const void *)*(ptr + OFF_DUMP));
     
     NSLog(@"... *[%d] size: %ld", OFF_DUMP, malloc_size((const void *)*(ptr + OFF_DUMP)));
     
     for (int i = 0; i < s / 4; ++i) {
     NSLog(@"..... [%d] = %lx", i, *(unsigned long *)(dump + i));
     }
     
     struct objc_super super_data = { self, [UIApplication class] };
     objc_msgSendSuper(&super_data, @selector(handleKeyUIEvent:), event);
 
    [super handleKeyUIEvent:event];
}
*/

/*for ios 7 and above*/
- (void)handleKeyUIEvent:(UIPhysicalKeyboardEvent *)event {
   
    if(![AppConfig getInstance].isIPAD || ![AppConfig getInstance].hasValidActive)
        return;
    if([super respondsToSelector:@selector(handleKeyUIEvent:)])
        [super handleKeyUIEvent:event];
    if([super respondsToSelector:@selector(isEditingText)])
    {
        if ([self isEditingText]) return;
    }
   
    short keyCode=[Definition getKeyCodeByKeyCodeString:event._unmodifiedInput];
     NSLog(@"key char:%@,short:%i",event._unmodifiedInput,keyCode);
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithShort:keyCode], @"keycode", [NSNumber numberWithInt:0], @"eventFlags",[NSNumber numberWithBool:NO],@"shift",[NSNumber numberWithBool:NO],@"command",[NSNumber numberWithBool:NO],@"option",[NSNumber numberWithBool:NO],@"control", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIEventGSEventKeyUpNotification object:nil userInfo:userInfo];
}

- (BOOL)isEditingText {
//#if (TARGET_IPHONE_SIMULATOR)
    // If you're writing text into a textfield, we shouldn't try run commands.
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if (firstResponder) return YES;
//#endif
    
    return NO;
}

@end
