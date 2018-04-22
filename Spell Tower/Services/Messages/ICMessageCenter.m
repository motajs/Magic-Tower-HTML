//
//  ICMessageCenter.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/6.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICMessageCenter.h"

@interface ICMessageCenter()

@end

@implementation ICMessageCenter

+ (instancetype)sharedInstance
{
    static ICMessageCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[ICMessageCenter alloc] init];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.registeredObjects = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerMessage:(Protocol *)protocol forObject:(id)object
{
    NSString *protocolString = NSStringFromProtocol(protocol);
    if (!self.registeredObjects[protocolString]) {
        self.registeredObjects[protocolString] = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    }
    [self.registeredObjects[protocolString] addPointer:(void *)object];
}

- (void)unregisterMessage:(Protocol *)protocol forObject:(id)object
{
    NSString *protocolString = NSStringFromProtocol(protocol);
    NSPointerArray *pointerArray = self.registeredObjects[protocolString];
    for (NSInteger i = 0; i < pointerArray.count; i++) {
        if ([pointerArray pointerAtIndex:i] == (__bridge void *)object) {
            [pointerArray removePointerAtIndex:i];
            break;
        }
    }
}

@end
