//
//  ICMessageCenter.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/6.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IC_REGISTER_MESSAGE(obj, protocolName) {\
    [[ICMessageCenter sharedInstance] registerMessage:@protocol(protocolName) forObject:obj];\
}

#define IC_UNREGISTER_MESSAGE(obj, protocolName) {\
    [[ICMessageCenter sharedInstance] unregisterMessage:@protocol(protocolName) forObject:obj];\
}

#define IC_SEND_MESSAGE(protocolName, sel, func) {\
    NSString *protocolString = NSStringFromProtocol(@protocol(protocolName));\
    NSPointerArray *pointerArray = [ICMessageCenter sharedInstance].registeredObjects[protocolString];\
    for (NSInteger i = 0; i < pointerArray.count; i++) {\
        NSObject<protocolName> *obj = (NSObject<protocolName> *)[pointerArray pointerAtIndex:i];\
        if ([obj respondsToSelector:@selector(sel)]) {\
            [obj func];\
        }\
    }\
}

@interface ICMessageCenter : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSPointerArray *> *registeredObjects;

+ (instancetype)sharedInstance;

- (void)registerMessage:(Protocol *)protocol forObject:(id)object;

- (void)unregisterMessage:(Protocol *)protocol forObject:(id)object;

@end
