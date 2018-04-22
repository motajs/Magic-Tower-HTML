//
//  UIButton+FixedSizeToFit.m
//  Aweme
//
//  Created by 熊典 on 2017/7/16.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "UIButton+FixedSizeToFit.h"
#import <objc/runtime.h>

@implementation UIButton (FixedSizeToFit)

+ (void)load {
    id block = ^(UIButton *self){
        CGSize size = [self sizeThatFits:CGSizeZero];
        size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right + self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        CGRect rect = self.frame;
        rect.size.width = size.width;
        rect.size.height = size.height;
        self.frame = rect;
    };
    
    SEL selctor = @selector(sizeToFit);
    IMP newSizeToFit = imp_implementationWithBlock(block);
    Method origMethod = class_getInstanceMethod(self, selctor);
    
    if(!class_addMethod(self, selctor, newSizeToFit, method_getTypeEncoding(origMethod))){
        method_setImplementation(origMethod, newSizeToFit);
    }
    
    CGSize (^block_intrinsicContentSize)() = ^CGSize(UIButton *self){
        CGSize size = [self sizeThatFits:CGSizeZero];
        size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right + self.imageEdgeInsets.left + self.imageEdgeInsets.right;
        return size;
    };
    
    SEL selctor_intrinsicContentSize = @selector(intrinsicContentSize);
    IMP new_intrinsicContentSize = imp_implementationWithBlock(block_intrinsicContentSize);
    Method origMethod_intrinsicContentSize = class_getInstanceMethod(self, selctor_intrinsicContentSize);
    
    if(!class_addMethod(self, selctor_intrinsicContentSize, new_intrinsicContentSize, method_getTypeEncoding(origMethod_intrinsicContentSize))){
        method_setImplementation(origMethod_intrinsicContentSize, new_intrinsicContentSize);
    }
}

@end
