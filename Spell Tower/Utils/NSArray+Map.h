//
//  NSArray+Map.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/9.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapWithBlock:(id (^)(id item, NSInteger index))mappingBlock;

@end
