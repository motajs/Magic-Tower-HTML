//
//  ICSwizzle.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/4.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICSwizzle.h"
#import <objc/runtime.h>

@implementation ICSwizzle

+ (void)updateImplementationOfClass:(Class)classItem method:(SEL)selector newImplementation:(id (^)(id, id, id (*)(id, SEL, id)))block
{
    if (!classItem) {
        return;
    }
    Method method = class_getInstanceMethod(classItem, selector);
    if (!method) {
        return;
    }
    IMP implementation = method_getImplementation(method);
    if (!implementation) {
        return;
    }
    id (*func)(id, SEL selector, id);
    func = (void *)implementation;
    method_setImplementation(method, imp_implementationWithBlock(^(NSObject *self, id param) {
        return block(self, param, func);
    }));
}

@end
