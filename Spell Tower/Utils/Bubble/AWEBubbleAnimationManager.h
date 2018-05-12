//
//  AWEBubbleAnimationManager.h
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWEBubbleAnimation.h"
#import "UIView+BubbleAnimation.h"

@interface AWEBubbleAnimationManager : NSObject

+ (instancetype)sharedManager;

- (AWEBubbleAnimation *)runAnimationWithBubble:(UIView *)bubble
                                    animations:(void(^)(AWEBubbleAnimation * animation))animations
                                    completion:(void(^)())completion;

- (void)removeAnimationsForBubble:(UIView *)bubble;

@end
