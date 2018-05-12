//
//  AWEBubbleAnimation.m
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleAnimation.h"
#import <pthread.h>
#import <POP.h>
#ifndef AWEBLOCK_INVOKE
#define AWEBLOCK_INVOKE(block, ...) block ? block(__VA_ARGS__) : 0
#endif

@interface AWEBubbleAnimation ()

@property (nonatomic, strong) AWEBubbleAnimation *nextAnimation;
@property (nonatomic, weak) AWEBubbleAnimation *previousAnimation;
@property (nonatomic, strong) void (^animationBlock)(UIView *bubble, void(^completion)());

//Loop
@property (nonatomic, assign) NSInteger loopRepeat;
@property (nonatomic, assign) BOOL loopStartFlag;
@property (nonatomic, assign) BOOL loopModeFlag;

//Parallels
@property (nonatomic, assign) NSInteger parallelsCount;
@property (nonatomic, assign) pthread_mutex_t lock;

//Status
@property (nonatomic, assign) BOOL shouldStop;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@end

@implementation AWEBubbleAnimation

- (instancetype)initWithBubble:(UIView *)bubble {
    self = [self init];
    if (self) {
        self.bubble = bubble;
        self.timingFunction = [AWEBubbleAnimationTimingFunction timingFunctionWithName:kAWEBubbleAnimationTimingFunctionEaseInEaseOut];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc{
    pthread_mutex_destroy(&_lock);
}


- (AWEBubbleAnimation *)nextAnimationWithCurrentConfig {
    AWEBubbleAnimation *nextAnimation = [[AWEBubbleAnimation alloc] initWithBubble:self.bubble];
    nextAnimation.loopModeFlag = self.loopModeFlag;
    nextAnimation.previousAnimation = self;
    nextAnimation.timingFunction = self.timingFunction;
    return nextAnimation;
}

- (AWEBubbleAnimation *(^)(CGFloat, CGFloat, CGFloat))move {
    return ^id(CGFloat tx, CGFloat ty, CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(bubble.center.x + tx, bubble.center.y + ty)];
            animation.duration = duration;
            animation.timingFunction = self.timingFunction;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                AWEBLOCK_INVOKE(completion);
            };
            [bubble pop_addAnimation:animation forKey:@"center"];
            
            self.bubble = bubble;
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(CGFloat))sleep {
    return ^id(CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            self.bubble = bubble;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AWEBLOCK_INVOKE(completion);
            });
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(CGFloat, CGFloat))rotateTo {
    return ^id(CGFloat degree, CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
            animation.toValue = @(degree / 180.0f * M_PI);
            animation.duration = duration;
            animation.timingFunction = self.timingFunction;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                AWEBLOCK_INVOKE(completion);
            };
            [bubble pop_addAnimation:animation forKey:@"rotation"];
            
            self.bubble = bubble;
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(CGFloat))reveal {
    return ^id(CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.duration = duration;
            animation.timingFunction = self.timingFunction;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                AWEBLOCK_INVOKE(completion);
            };
            [bubble pop_addAnimation:animation forKey:@"alpha"];
            
            self.bubble = bubble;
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(CGFloat))dismiss {
    return ^id(CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            animation.fromValue = @1;
            animation.toValue = @0;
            animation.duration = duration;
            animation.timingFunction = self.timingFunction;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                AWEBLOCK_INVOKE(completion);
            };
            [bubble pop_addAnimation:animation forKey:@"alpha"];
            
            self.bubble = bubble;
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(CGFloat, CGFloat))scale {
    return ^id(CGFloat scale, CGFloat duration) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scale, scale)];
            animation.duration = duration;
            animation.timingFunction = self.timingFunction;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                AWEBLOCK_INVOKE(completion);
            };
            [bubble pop_addAnimation:animation forKey:@"scaleXY"];
            
            self.bubble = bubble;
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(NSInteger))loop {
    return ^id(NSInteger repeat) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            if (!self.loopModeFlag) {
                self.loopRepeat = repeat - 1;
            }
            self.bubble = bubble;
            
            AWEBLOCK_INVOKE(completion);
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)())loopStart {
    return ^id() {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            self.loopStartFlag = YES;
            self.bubble = bubble;
            
            AWEBLOCK_INVOKE(completion);
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (AWEBubbleAnimation *(^)(NSInteger))parallel {
    return ^id(NSInteger count) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            self.parallelsCount = count;
            self.bubble = bubble;
            
            AWEBLOCK_INVOKE(completion);
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
}

- (void (^)())run {
    return [self run:nil];
}

- (void (^)())run:(void (^)())completion {
    return [self run:completion inLoopMode:NO noForward:NO];
}

- (void (^)())run:(void (^)())completion inLoopMode:(BOOL)loopMode noForward:(BOOL)noForward{
    return ^{
        self.loopModeFlag = loopMode;
        if (!noForward && self.previousAnimation && (!loopMode || !self.loopStartFlag)) {
            [self.previousAnimation run:completion inLoopMode:loopMode noForward:noForward]();
        } else {
            [self _run:completion];
        }
    };
}

- (void)_run:(void (^)())completion {
    if (self.shouldStop) {
        AWEBLOCK_INVOKE(completion);
        return;
    }
    if (self.animationBlock) {
        self.animationBlock(self.bubble, ^{
            if (self.loopRepeat) {
                self.loopRepeat--;
                [self run:completion inLoopMode:YES noForward:NO]();
            } else {
                if (self.parallelsCount > 1) {
                    NSMutableArray *animations = [NSMutableArray arrayWithCapacity:self.parallelsCount];
                    AWEBubbleAnimation *currentAnimation = self;
                    for (NSInteger i = 0; i < self.parallelsCount; i++) {
                        currentAnimation = currentAnimation.nextAnimation;
                        if (currentAnimation) {
                            [animations addObject:currentAnimation];
                        } else {
                            break;
                        }
                    }
                    [self _runParallel:animations
                            afterwards:^{
                                AWEBubbleAnimation *nextAnimation = currentAnimation.nextAnimation;
                                if (nextAnimation) {
                                    [nextAnimation _run:completion];
                                } else {
                                    AWEBLOCK_INVOKE(completion);
                                }
                            }];
                } else {
                    if (self.nextAnimation) {
                        self.nextAnimation.timingFunction = self.timingFunction;
                        [self.nextAnimation _run:completion];
                    } else {
                        AWEBLOCK_INVOKE(completion);
                    }
                }
            }
        });
    } else {
        AWEBLOCK_INVOKE(completion);
    }
}

- (void)_runParallel:(NSArray<AWEBubbleAnimation *> *)animations
          afterwards:(void(^)())afterwards{
    NSMutableArray *completed = [NSMutableArray array];
    void (^checkFinish)() = ^{
        for (NSInteger i = 0; i < completed.count; i++) {
            if ([completed[i] integerValue] == 0) {
                return;
            }
        }
        AWEBLOCK_INVOKE(afterwards);
    };
    for (NSInteger i = 0; i < animations.count; i++) {
        [completed addObject:@0];
        animations[i].animationBlock(animations[i].bubble, ^{
            completed[i] = @1;
            pthread_mutex_lock(&_lock);
            checkFinish();
            pthread_mutex_unlock(&_lock);
        });
    }
}

- (AWEBubbleAnimation *(^)(NSString *))timing {
    return ^id(NSString *functionName) {
        __weak typeof(self) weakSelf = self;
        self.animationBlock = ^(UIView *bubble, void(^completion)()) {
            __strong typeof(self) self = weakSelf;
            self.timingFunction = [AWEBubbleAnimationTimingFunction timingFunctionWithName:functionName];
            self.bubble = bubble;
            
            AWEBLOCK_INVOKE(completion);
        };
        self.nextAnimation = [self nextAnimationWithCurrentConfig];
        return self.nextAnimation;
    };
};

- (void (^)())stop {
    return ^{
        [self.bubble pop_removeAllAnimations];
        AWEBubbleAnimation *animation = self;
        while (animation) {
            animation.shouldStop = YES;
            animation = animation.nextAnimation;
        }
    };
}

@end
