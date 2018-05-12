//
//  ICMacros.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/4.
//  Copyright © 2018年 熊典. All rights reserved.
//

#ifndef ICMacros_h
#define ICMacros_h

#import <objc/runtime.h>

#define ICEncode(aCoder, selectorName) {\
    if ([self respondsToSelector:@selector(selectorName)]) [aCoder encodeObject:_##selectorName forKey:NSStringFromSelector(@selector(selectorName))];\
}

#define ICEncodeInteger(aCoder, selectorName) {\
    if ([self respondsToSelector:@selector(selectorName)]) [aCoder encodeInteger:_##selectorName forKey:NSStringFromSelector(@selector(selectorName))];\
}

#define ICEncodeFloat(aCoder, selectorName) {\
    if ([self respondsToSelector:@selector(selectorName)]) [aCoder encodeFloat:_##selectorName forKey:NSStringFromSelector(@selector(selectorName))];\
}

#define ICDecode(aCoder, selectorName) {\
    if ([self respondsToSelector:@selector(selectorName)]) _##selectorName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(selectorName))];\
}

#define ICDecodeInteger(aCoder, selectorName) {\
    if ([self respondsToSelector:@selector(selectorName)]) _##selectorName = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(selectorName))];\
}

#define ICDecodeFloat(aCoder, selectorName) {\
if ([self respondsToSelector:@selector(selectorName)]) _##selectorName = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(selectorName))];\
}

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define BOTTOM_OFFSET ([UIScreen mainScreen].bounds.size.height == 812 ? 34 : 0)

#ifndef keywordify
#if DEBUG
#define keywordify autoreleasepool {}
#else
#define keywordify try {} @catch (...) {}
#endif
#endif

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) keywordify __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) keywordify __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) keywordify __typeof__(object) object = weak##_##object;
#else
#define strongify(object) keywordify __typeof__(object) object = block##_##object;
#endif
#endif

#define dispatch_ensure_main(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_async(dispatch_get_main_queue(), block); \
}

#define ICSwizzle(class, oriMethod, newMethod) {Method originalMethod = class_getInstanceMethod(class, @selector(oriMethod));\
Method swizzledMethod = class_getInstanceMethod(class, @selector(newMethod));\
if (class_addMethod(class, @selector(oriMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {\
class_replaceMethod(class, @selector(newMethod), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));\
} else {\
method_exchangeImplementations(originalMethod, swizzledMethod);\
}}

#endif /* ICMacros_h */
