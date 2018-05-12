//
//  UIView+BubbleAnimation.h
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWEBubbleAnimation.h"

@interface UIView (BubbleAnimation)

- (void)bubbleAnimate:(void (^)(AWEBubbleAnimation * animation))animations
           completion:(void(^)())completion;

- (void)bubbleAnimate:(void (^)(AWEBubbleAnimation * animation))animations;

- (void)removeBubbleAnimates;

@end
