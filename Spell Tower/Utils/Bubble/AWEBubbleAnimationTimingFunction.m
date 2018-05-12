//
//  AWEBubbleAnimationTimingFunction.m
//  Aweme
//
//  Created by 熊典 on 2017/7/18.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleAnimationTimingFunction.h"

static NSMutableDictionary *AWEBubbleAnimationTimingFunctionAnimations;

NSString * const kAWEBubbleAnimationTimingFunctionDefault = @"kAWEBubbleAnimationTimingFunctionDefault";
NSString * const kAWEBubbleAnimationTimingFunctionLinear = @"kAWEBubbleAnimationTimingFunctionLinear";

NSString * const kAWEBubbleAnimationTimingFunctionEaseIn = @"kAWEBubbleAnimationTimingFunctionEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionEaseOut = @"kAWEBubbleAnimationTimingFunctionEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseIn = @"kAWEBubbleAnimationTimingFunctionQuadraticEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseOut = @"kAWEBubbleAnimationTimingFunctionQuadraticEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionQuadraticEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseIn = @"kAWEBubbleAnimationTimingFunctionCubicEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseOut = @"kAWEBubbleAnimationTimingFunctionCubicEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionCubicEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseIn = @"kAWEBubbleAnimationTimingFunctionQuarticEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseOut = @"kAWEBubbleAnimationTimingFunctionQuarticEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionQuarticEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseIn = @"kAWEBubbleAnimationTimingFunctionQuinticEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseOut = @"kAWEBubbleAnimationTimingFunctionQuinticEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionQuinticEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionSineEaseIn = @"kAWEBubbleAnimationTimingFunctionSineEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionSineEaseOut = @"kAWEBubbleAnimationTimingFunctionSineEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionSineEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionSineEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionCircularEaseIn = @"kAWEBubbleAnimationTimingFunctionCircularEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionCircularEaseOut = @"kAWEBubbleAnimationTimingFunctionCircularEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionCircularEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionCircularEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseIn = @"kAWEBubbleAnimationTimingFunctionExpoEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseOut = @"kAWEBubbleAnimationTimingFunctionExpoEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionExpoEaseInEaseOut";

NSString * const kAWEBubbleAnimationTimingFunctionBackEaseIn = @"kAWEBubbleAnimationTimingFunctionBackEaseIn";
NSString * const kAWEBubbleAnimationTimingFunctionBackEaseOut = @"kAWEBubbleAnimationTimingFunctionBackEaseOut";
NSString * const kAWEBubbleAnimationTimingFunctionBackEaseInEaseOut = @"kAWEBubbleAnimationTimingFunctionBackEaseInEaseOut";

@implementation AWEBubbleAnimationTimingFunction

+ (void)setupAnimationsIfNeeded {
    if (!AWEBubbleAnimationTimingFunctionAnimations) {
        AWEBubbleAnimationTimingFunctionAnimations = [NSMutableDictionary dictionary];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionDefault] = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionLinear] = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionEaseIn] = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionEaseOut] = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionEaseInEaseOut] = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuadraticEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.26 :0 :0.6 :0.2];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuadraticEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.4 :0.8 :0.74 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuadraticEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.48 :0.04 :0.52 :0.96];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCubicEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.4 :0 :0.68 :0.06];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCubicEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.32 :0.94 :0.6 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCubicEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.66 :0 :0.34 :1];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuarticEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.52 :0 :0.74 :0];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuarticEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.26 :1 :0.48 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuarticEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.76 :0 :0.24 :1];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuinticEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.64 :0 :0.78 :0];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuinticEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.22 :1 :0.36 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionQuinticEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.84 :0 :0.16 :1];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionSineEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.47 :0 :0.745 :0.715];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionSineEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.39 :0.575 :0.565 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionSineEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.445 :0.05 :0.55 :0.95];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCircularEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.54 :0 :1 :0.44];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCircularEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0 :0.56 :0.46 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionCircularEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.88 :0.14 :0.12 :0.86];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionExpoEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.66 :0 :0.86 :0];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionExpoEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.14 :1 :0.34 :1];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionExpoEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.9 :0 :0.1 :1];
        
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionBackEaseIn] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.6 :-0.28 :0.73 :0.04];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionBackEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.17 :0.89 :0.32 :1.27];
        AWEBubbleAnimationTimingFunctionAnimations[kAWEBubbleAnimationTimingFunctionBackEaseInEaseOut] = [[CAMediaTimingFunction alloc] initWithControlPoints:0.68 :-0.55 :0.27 :1.55];
    }
}

+ (CAMediaTimingFunction *)timingFunctionWithName:(kAWEBubbleAnimationTimingFunctionName *)name {
    [self setupAnimationsIfNeeded];
    return AWEBubbleAnimationTimingFunctionAnimations[name];
}

@end
