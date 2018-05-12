//
//  AWEBubbleAnimation.h
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWEBubbleAnimationTimingFunction.h"

@interface AWEBubbleAnimation : NSObject

@property (nonatomic, strong) UIView *bubble;

// Initializations
- (instancetype)initWithBubble:(UIView *)bubble;


// Animations
- (AWEBubbleAnimation * (^)(CGFloat offsetX, CGFloat offsetY, CGFloat duration))move;

- (AWEBubbleAnimation * (^)(CGFloat duration))reveal;

- (AWEBubbleAnimation * (^)(CGFloat scale, CGFloat duration))scale;

- (AWEBubbleAnimation * (^)(CGFloat duration))dismiss;

- (AWEBubbleAnimation * (^)(CGFloat duration))sleep;

- (AWEBubbleAnimation * (^)(CGFloat degree, CGFloat duration))rotateTo;

- (AWEBubbleAnimation * (^)(NSInteger repeat))loop;

- (AWEBubbleAnimation *(^)())loopStart;

- (AWEBubbleAnimation * (^)(NSInteger count))parallel;

- (AWEBubbleAnimation *(^)(kAWEBubbleAnimationTimingFunctionName *timingFunctionName))timing;
   
// Run
- (void(^)())run;

- (void(^)())run:(void(^)())completion;

- (void(^)())stop;

@end
