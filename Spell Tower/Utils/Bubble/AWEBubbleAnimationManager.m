//
//  AWEBubbleAnimationManager.m
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleAnimationManager.h"

#ifndef AWEBLOCK_INVOKE
#define AWEBLOCK_INVOKE(block, ...) block ? block(__VA_ARGS__) : 0
#endif

static AWEBubbleAnimationManager * AWEBubbleAnimationManagerSharedInstance;

@interface AWEBubbleAnimationManager ()

@property (nonatomic, strong) NSMutableArray *animations;

@end

@implementation AWEBubbleAnimationManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AWEBubbleAnimationManagerSharedInstance = [[[self class] alloc] init];
    });
    return AWEBubbleAnimationManagerSharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animations = [NSMutableArray array];
    }
    return self;
}

- (AWEBubbleAnimation *)runAnimationWithBubble:(UIView *)bubble
                                    animations:(void (^)(AWEBubbleAnimation *))animations
                                    completion:(void (^)())completion{
    AWEBubbleAnimation *animation = [[AWEBubbleAnimation alloc] initWithBubble:bubble];
    AWEBLOCK_INVOKE(animations, animation);
    [self.animations addObject:animation];
    [self runAnimation:animation completion:completion];
    return animation;
}

- (void)runAnimation:(AWEBubbleAnimation *)animation
          completion:(void (^)())completion{
    [animation run:^{
        [self.animations removeObject:animation];
        AWEBLOCK_INVOKE(completion);
    }]();
}

- (void)removeAnimationsForBubble:(UIView *)bubble {
    NSMutableArray *animationsToBeRemoved = [NSMutableArray array];
    for (AWEBubbleAnimation *animation in self.animations) {
        if (animation.bubble == bubble) {
            [animationsToBeRemoved addObject:animation];
        }
    }
    
    for (AWEBubbleAnimation *animation in animationsToBeRemoved) {
        animation.stop();
        [self.animations removeObject:animation];
    }
    
}

@end
