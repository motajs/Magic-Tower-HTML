//
//  AWEBubbleView.h
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWEBubbleManager.h"
#import "AWEBubbleAnchor.h"

@interface AWEBubbleView : UIView <AWEBubbleAnchor>

- (instancetype)initWithDirection:(AWEBubbleManagerDirection)direction;

@end
