//
//  AWEBubbleView.m
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubbleView.h"

@interface AWEBubbleView ()

@property (nonatomic, assign) AWEBubbleManagerDirection direction;
@property (nonatomic, strong) UIImageView *bodyImageView;
@property (nonatomic, strong) UIImageView *cornerImageView;
@end

@implementation AWEBubbleView

- (instancetype)initWithDirection:(AWEBubbleManagerDirection)direction {
    self = [self init];
    if (self) {
        self.direction = direction;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSString *imageName = nil;
    switch (self.direction) {
        case AWEBubbleManagerDirectionUp:
            imageName = @"bg_bubble_down";
            break;
        case AWEBubbleManagerDirectionLeft:
            imageName = @"bg_bubble_right";
            break;
        case AWEBubbleManagerDirectionDown:
            imageName = @"bg_bubble_up";
            break;
        case AWEBubbleManagerDirectionRight:
            imageName = @"bg_bubble_left";
            break;
            
        default:
            break;
    }
    self.bodyImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_bubble1"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13) resizingMode:UIImageResizingModeStretch]];
    self.cornerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    [self addSubview:self.bodyImageView];
    [self addSubview:self.cornerImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cornerViewLength = 12;
    CGFloat cornerViewHeight = 6;
    
    switch (self.direction) {
        case AWEBubbleManagerDirectionDown: {
            self.cornerImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - cornerViewLength / 2, 0, cornerViewLength, cornerViewHeight);
            self.bodyImageView.frame = CGRectMake(0, CGRectGetMaxY(self.cornerImageView.frame), self.frame.size.width, self.frame.size.height - cornerViewHeight);
        }
            break;
        case AWEBubbleManagerDirectionLeft: {
            self.bodyImageView.frame = CGRectMake(0, 0, self.frame.size.width - cornerViewHeight, self.frame.size.height);
            self.cornerImageView.frame = CGRectMake(CGRectGetMaxX(self.bodyImageView.frame), CGRectGetMidY(self.frame) - cornerViewLength / 2, cornerViewHeight, cornerViewLength);
        }
            break;
        case AWEBubbleManagerDirectionUp: {
            self.bodyImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - cornerViewHeight);
            self.cornerImageView.frame = CGRectMake(CGRectGetMidX(self.frame)  - cornerViewLength / 2, CGRectGetMaxY(self.bodyImageView.frame), cornerViewLength, cornerViewHeight);
            
        }
            break;
        case AWEBubbleManagerDirectionRight: {
            self.cornerImageView.frame = CGRectMake(0, CGRectGetMidY(self.frame) - cornerViewLength / 2, cornerViewHeight, cornerViewLength);
            self.bodyImageView.frame = CGRectMake(CGRectGetMaxX(self.cornerImageView.frame), 0, self.frame.size.width - cornerViewHeight, self.frame.size.height);
        }
            break;
            
        default:
            break;
    }
}

- (CGPoint)anchorPositionRelatedToLeftTop {
    switch (self.direction) {
        case AWEBubbleManagerDirectionUp:
            return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
            break;
        case AWEBubbleManagerDirectionLeft:
            return CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
            break;
        case AWEBubbleManagerDirectionDown:
            return CGPointMake(CGRectGetMidX(self.bounds), 0);
            break;
        case AWEBubbleManagerDirectionRight:
            return CGPointMake(0, CGRectGetMidY(self.bounds));
            break;
            
        default:
            break;
    }
    return CGPointZero;
}

@end
