//
//  AWEBubbleManager.m
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleManager.h"
#import "AWEBubbleAnimationManager.h"

static AWEBubbleManager * AWEBubbleManagerSharedInstance;

@implementation AWEBubbleManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AWEBubbleManagerSharedInstance = [[[self class] alloc] init];
    });
    return AWEBubbleManagerSharedInstance;
}

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
               fromAnchor:(CGPoint)anchor
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
           withAnimations:(void (^)(AWEBubbleAnimation *))animations
               completion:(void (^)())completion{
    return [self showBubble:content
                    forView:view
            inContainerView:view.superview
                 fromAnchor:anchor
                inDirection:bubbleDirection
             withAnimations:animations
                 completion:completion];
}

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
          inContainerView:(UIView *)containerView
               fromAnchor:(CGPoint)anchor
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
           withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
               completion:(void(^)())completion {

    AWEBubble *bubble = [AWEBubble bubbleWithContent:content direction:bubbleDirection];
    
    return [self showBubbleView:bubble
                        forView:view
                inContainerView:containerView
                     fromAnchor:anchor
                    inDirection:bubbleDirection
                 withAnimations:animations
                     completion:completion];
}

- (AWEBubble *)showBubbleView:(AWEBubble *)bubble
                      forView:(UIView *)view
              inContainerView:(UIView *)containerView
                   fromAnchor:(CGPoint)anchor
                  inDirection:(AWEBubbleManagerDirection)bubbleDirection
               withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
                   completion:(void(^)())completion {
    [containerView addSubview:bubble];
    
    bubble.anchorView = view;
    bubble.anchorPoint = anchor;
    
    [bubble redoLayout];
    
    [bubble bubbleAnimate:animations completion:completion];
    
    return bubble;
}

- (AWEBubble *)showBubble:(NSString *)content
          withCustomImage:(NSString *)imageName
              imageInsets:(UIEdgeInsets)imageEdgeInsets
               textInsets:(UIEdgeInsets)textInsets
                     font:(UIFont *)font
                fontColor:(UIColor *)fontColor
                fixedSize:(CGSize)fixedSize
                  forView:(UIView *)view
          inContainerView:(UIView *)containerView
               fromAnchor:(CGPoint)anchor
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
         anchorAdjustment:(CGPoint)adjustment
           withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
               completion:(void(^)())completion {
    AWEBubble *bubble = [AWEBubble bubbleWithContent:content
                                           direction:bubbleDirection
                                    anchorAdjustment:adjustment
                                     bubbleImageName:imageName
                                   image9ScaleInsets:imageEdgeInsets
                                          edgeInsets:textInsets
                                                font:font
                                               color:fontColor
                                           fixedSize:fixedSize];
    
    return [self showBubbleView:bubble
                        forView:view
                inContainerView:containerView
                     fromAnchor:anchor
                    inDirection:bubbleDirection
                 withAnimations:animations
                     completion:completion];
}

- (AWEBubble *)showAttributedBubble:(NSAttributedString *)content
                    withCustomImage:(NSString *)imageName
                        imageInsets:(UIEdgeInsets)imageEdgeInsets
                         textInsets:(UIEdgeInsets)textInsets
                          fixedSize:(CGSize)fixedSize
                            forView:(UIView *)view
                    inContainerView:(UIView *)containerView
                         fromAnchor:(CGPoint)anchor
                        inDirection:(AWEBubbleManagerDirection)bubbleDirection
                   anchorAdjustment:(CGPoint)adjustment
                     withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
                         completion:(void(^)())completion {
    AWEBubble *bubble = [AWEBubble bubbleWithAttributedContent:content
                                                     direction:bubbleDirection
                                              anchorAdjustment:adjustment
                                               bubbleImageName:imageName
                                             image9ScaleInsets:imageEdgeInsets
                                                    edgeInsets:textInsets
                                                     fixedSize:fixedSize];
    
    return [self showBubbleView:bubble
                        forView:view
                inContainerView:containerView
                     fromAnchor:anchor
                    inDirection:bubbleDirection
                 withAnimations:animations
                     completion:completion];
}

- (AWEBubble *)showBubble:(NSString *)content forView:(UIView *)view inDirection:(AWEBubbleManagerDirection)bubbleDirection withAnimations:(void (^)(AWEBubbleAnimation *))animations completion:(void (^)())completion {
    return [self showBubble:content
                    forView:view
                 fromAnchor:AWEBubbleAnchorAutomaticDimension
                inDirection:bubbleDirection
             withAnimations:animations
                 completion:completion];
}

- (AWEBubble *)showBubble:(NSString *)content forView:(UIView *)view inDirection:(AWEBubbleManagerDirection)bubbleDirection completion:(void (^)())completion {
    return [self showBubble:content
                    forView:view
                inDirection:bubbleDirection
             withAnimations:^(AWEBubbleAnimation *animation) {
                 animation
                 .timing(kAWEBubbleAnimationTimingFunctionQuadraticEaseOut)
                 .scale(0, 0)
                 .parallel(2)
                   .reveal(0.3)
                   .scale(1.04, 0.3)
                 .scale(1, 0.5)
                 
                 .timing(kAWEBubbleAnimationTimingFunctionQuadraticEaseInEaseOut)
                 .loopStart()
                   .scale(1, 1)
                   .scale(1.04, 1)
                 .loop(3)
                 
                 .timing(kAWEBubbleAnimationTimingFunctionQuadraticEaseIn)
                 .parallel(2)
                   .dismiss(0.2)
                   .scale(0, 0.2);
             } completion:completion];
}

- (AWEBubble *)showBubble:(NSString *)content forView:(UIView *)view inDirection:(AWEBubbleManagerDirection)bubbleDirection {
    return [self showBubble:content
                    forView:view
                inDirection:bubbleDirection
                 completion:nil];
}

- (void)removeBubble:(AWEBubble *)bubble {
    [bubble removeBubbleAnimates];
    [bubble removeFromSuperview];
}

@end
