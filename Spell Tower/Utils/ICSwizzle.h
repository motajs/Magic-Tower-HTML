//
//  ICSwizzle.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/4.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICSwizzle : NSObject

+ (void)updateImplementationOfClass:(Class)classItem method:(SEL)selector newImplementation:(id(^)(id self, id param, id (*originalFunc)(id, SEL, id)))block;

@end
