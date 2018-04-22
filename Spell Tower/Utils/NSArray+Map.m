//
//  NSArray+Map.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/9.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)mapWithBlock:(id (^)(id item, NSInteger index))mappingBlock {
    NSMutableArray *result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:mappingBlock(obj, idx)];
    }];
    return result.copy;
}

@end
