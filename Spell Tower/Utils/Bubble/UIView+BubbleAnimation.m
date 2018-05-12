//
//  UIView+BubbleAnimation.m
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "UIView+BubbleAnimation.h"
#import "AWEBubbleAnimationManager.h"

@implementation UIView (BubbleAnimation)

- (void)bubbleAnimate:(void (^)(AWEBubbleAnimation *))animations
           completion:(void (^)())completion{
    [[AWEBubbleAnimationManager sharedManager] runAnimationWithBubble:self
                                                           animations:animations
                                                           completion:completion];
}

- (void)removeBubbleAnimates {
    [[AWEBubbleAnimationManager sharedManager] removeAnimationsForBubble:self];
}

- (void)bubbleAnimate:(void (^)(AWEBubbleAnimation *))animations {
    [self bubbleAnimate:animations completion:nil];
}

@end
