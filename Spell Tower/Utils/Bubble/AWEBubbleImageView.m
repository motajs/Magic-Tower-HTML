//
//  AWEBubbleImageView.m
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleImageView.h"
#import "AWEBubbleManager.h"

@interface AWEBubbleImageView ()

@property (nonatomic, assign) AWEBubbleManagerDirection direction;
@property (nonatomic, assign) CGPoint anchorAdjustment;

@end

@implementation AWEBubbleImageView

- (instancetype)initWithImage:(UIImage *)image direction:(AWEBubbleManagerDirection)direction {
    self = [self initWithImage:image];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image direction:(AWEBubbleManagerDirection)direction anchorAdjustment:(CGPoint)anchorDelta {
    self = [self initWithImage:image];
    if (self) {
        self.direction = direction;
        self.anchorAdjustment = anchorDelta;
    }
    return self;
}

- (CGPoint)anchorPositionRelatedToLeftTop {
    CGSize size = self.frame.size;
    CGPoint anchorPoint = CGPointZero;
    switch (self.direction) {
        case AWEBubbleManagerDirectionUp:
            anchorPoint = CGPointMake(0.5 * size.width, 1 * size.height);
            break;
        case AWEBubbleManagerDirectionLeft:
            anchorPoint = CGPointMake(1 * size.width, 0.5 * size.height);
            break;
        case AWEBubbleManagerDirectionDown:
            anchorPoint = CGPointMake(0.5 * size.width, 0 * size.height);
            break;
        case AWEBubbleManagerDirectionRight:
            anchorPoint = CGPointMake(0 * size.width, 0.5 * size.height);
            break;
            
        default:
            break;
    }
    return CGPointMake(anchorPoint.x + self.anchorAdjustment.x, anchorPoint.y + self.anchorAdjustment.y);
}

@end
