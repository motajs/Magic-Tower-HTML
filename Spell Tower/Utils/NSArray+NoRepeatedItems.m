//
//  NSArray+NoRepeatedItems.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/19.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "NSArray+NoRepeatedItems.h"
#import "ICMacros.h"
#import <objc/runtime.h>

@implementation NSMutableArray (NoRepeatedItems)

+ (void)load
{
    ICSwizzle(NSClassFromString(@"__NSArrayM"), addObject:, ic_addObject:);
}

- (void)ic_addObject:(id)anObject
{
    if (self.enableNoRepeated && [self indexOfObject:anObject] != NSNotFound) {
        return;
    }
    [self ic_addObject:anObject];
}

- (void)setEnableNoRepeated:(BOOL)enableNoRepeated
{
    objc_setAssociatedObject(self, @selector(enableNoRepeated), @(enableNoRepeated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enableNoRepeated
{
    return [objc_getAssociatedObject(self, @selector(enableNoRepeated)) boolValue];
}

@end
