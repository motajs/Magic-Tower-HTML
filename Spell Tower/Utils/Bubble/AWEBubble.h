//
//  AWEBubble.h
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWEBubbleDefinition.h"
#import "AWEBubbleAnchor.h"

@interface AWEBubble : UIView <AWEBubbleAnchor>

@property (nonatomic, strong) UIView *anchorView;
@property (nonatomic, assign) CGPoint anchorPoint;

+ (instancetype)bubbleWithContent:(NSString *)content
                        direction:(AWEBubbleManagerDirection)bubbleDirection;

+ (instancetype)bubbleWithContent:(NSString *)content
                        direction:(AWEBubbleManagerDirection)bubbleDirection
                 anchorAdjustment:(CGPoint)adjustment
                  bubbleImageName:(NSString *)imageName
                image9ScaleInsets:(UIEdgeInsets)imageInsets
                       edgeInsets:(UIEdgeInsets)insets
                             font:(UIFont *)font
                            color:(UIColor *)fontColor
                        fixedSize:(CGSize)fixedSize;

+ (instancetype)bubbleWithAttributedContent:(NSAttributedString *)content
                                  direction:(AWEBubbleManagerDirection)bubbleDirection
                           anchorAdjustment:(CGPoint)adjustment
                            bubbleImageName:(NSString *)imageName
                          image9ScaleInsets:(UIEdgeInsets)imageInsets
                                 edgeInsets:(UIEdgeInsets)insets
                                  fixedSize:(CGSize)fixedSize;

- (void)redoLayout;

@end
