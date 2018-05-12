//
//  AWEBubbleImageView.h
//  Aweme
//
//  Created by 熊典 on 2017/7/7.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWEBubbleAnchor.h"
#import "AWEBubbleDefinition.h"

@interface AWEBubbleImageView : UIImageView <AWEBubbleAnchor>

- (instancetype)initWithImage:(UIImage *)image direction:(AWEBubbleManagerDirection)direction;

- (instancetype)initWithImage:(UIImage *)image direction:(AWEBubbleManagerDirection)direction anchorAdjustment:(CGPoint)anchorDelta;

@end
