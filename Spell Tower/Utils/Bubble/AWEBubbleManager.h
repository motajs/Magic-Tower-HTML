//
//  AWEBubbleManager.h
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWEBubble.h"
#import "AWEBubbleAnimation.h"
#import "AWEBubbleDefinition.h"
#import "AWEBubbleImageView.h"

@interface AWEBubbleManager : NSObject

+ (instancetype)sharedManager;

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
               completion:(void(^)())completion;

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
                         completion:(void(^)())completion;

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
          inContainerView:(UIView *)containerView
               fromAnchor:(CGPoint)anchor
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
           withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
               completion:(void(^)())completion;

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
               fromAnchor:(CGPoint)anchor
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
           withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
               completion:(void(^)())completion;

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
           withAnimations:(void(^)(AWEBubbleAnimation * animation))animations
               completion:(void(^)())completion;

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
              inDirection:(AWEBubbleManagerDirection)bubbleDirection
               completion:(void(^)())completion;

- (AWEBubble *)showBubble:(NSString *)content
                  forView:(UIView *)view
              inDirection:(AWEBubbleManagerDirection)bubbleDirection;

- (void)removeBubble:(AWEBubble *)bubble;

@end
