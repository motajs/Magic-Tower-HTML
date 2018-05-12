//
//  AWEBubbleAnimationTimingFunction.h
//  Aweme
//
//  Created by 熊典 on 2017/7/18.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef NSString kAWEBubbleAnimationTimingFunctionName;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionDefault;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionLinear;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuadraticEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionCubicEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuarticEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionQuinticEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionSineEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionSineEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionSineEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionExpoEaseInEaseOut;

FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionBackEaseIn;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionBackEaseOut;
FOUNDATION_EXPORT NSString * const kAWEBubbleAnimationTimingFunctionBackEaseInEaseOut;


@interface AWEBubbleAnimationTimingFunction : NSObject

+ (CAMediaTimingFunction *)timingFunctionWithName:(kAWEBubbleAnimationTimingFunctionName *)name;

@end
