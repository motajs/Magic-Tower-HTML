//
//  AWEBubble.m
//  Aweme
//
//  Created by 熊典 on 2017/7/6.
//  Copyright © 2017年 Bytedance. All rights reserved.
//

#import "AWEBubble.h"
#import "AWEBubbleView.h"

@interface AWEBubble ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView<AWEBubbleAnchor> *bubbleView;
@property (nonatomic, assign) AWEBubbleManagerDirection direction;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) BOOL attributedBubble;
@property (nonatomic, assign) CGSize fixedSize;

@end

@implementation AWEBubble

+ (instancetype)bubbleWithContent:(NSString *)content
                        direction:(AWEBubbleManagerDirection)bubbleDirection {
    AWEBubble *bubble = [[AWEBubble alloc] init];
    [bubble initWithContent:content
                  direction:bubbleDirection];
    return bubble;
}

+ (instancetype)bubbleWithContent:(NSString *)content
                        direction:(AWEBubbleManagerDirection)bubbleDirection
                 anchorAdjustment:(CGPoint)adjustment
                  bubbleImageName:(NSString *)imageName
                image9ScaleInsets:(UIEdgeInsets)imageInsets
                       edgeInsets:(UIEdgeInsets)insets
                             font:(UIFont *)font
                            color:(UIColor *)fontColor
                        fixedSize:(CGSize)fixedSize {
    AWEBubble *bubble = [[AWEBubble alloc] init];
    [bubble initWithContent:content
                  direction:bubbleDirection
           anchorAdjustment:adjustment
            bubbleImageName:imageName
          image9ScaleInsets:imageInsets
                 edgeInsets:insets
                       font:font
                      color:fontColor
                  fixedSize:fixedSize];
    return bubble;
}

+ (instancetype)bubbleWithAttributedContent:(NSAttributedString *)content
                                  direction:(AWEBubbleManagerDirection)bubbleDirection
                           anchorAdjustment:(CGPoint)adjustment
                            bubbleImageName:(NSString *)imageName
                          image9ScaleInsets:(UIEdgeInsets)imageInsets
                                 edgeInsets:(UIEdgeInsets)insets
                                  fixedSize:(CGSize)fixedSize{
    AWEBubble *bubble = [[AWEBubble alloc] init];
    [bubble initWithAttributedContent:content
                            direction:bubbleDirection
                     anchorAdjustment:adjustment
                      bubbleImageName:imageName
                    image9ScaleInsets:imageInsets
                           edgeInsets:insets
                            fixedSize:fixedSize];
    return bubble;
}

- (void)initWithContent:(NSString *)content
              direction:(AWEBubbleManagerDirection)bubbleDirection {
    CGFloat up = 0;
    CGFloat down = 0;
    CGFloat left = 0;
    CGFloat right = 0;
    switch (bubbleDirection) {
        case AWEBubbleManagerDirectionUp:
            down = 9;
            break;
        case AWEBubbleManagerDirectionLeft:
            right = 9;
            break;
        case AWEBubbleManagerDirectionDown:
            up = 9;
            break;
        case AWEBubbleManagerDirectionRight:
            left = 9;
            break;
            
        default:
            break;
    }
    [self initWithContent:content
                direction:bubbleDirection
               bubbleView:[[AWEBubbleView alloc] initWithDirection:bubbleDirection]
               edgeInsets:UIEdgeInsetsMake(10 + up, 12 + left, 10 + down, 12 + right)
                     font:[UIFont systemFontOfSize:14]
                    color:[UIColor whiteColor]
                fixedSize:CGSizeZero];
}

- (void)initWithAttributedContent:(NSAttributedString *)content
                        direction:(AWEBubbleManagerDirection)bubbleDirection
                 anchorAdjustment:(CGPoint)adjustment
                  bubbleImageName:(NSString *)imageName
                image9ScaleInsets:(UIEdgeInsets)imageInsets
                       edgeInsets:(UIEdgeInsets)insets
                        fixedSize:(CGSize)fixedSize {
    self.attributedBubble = YES;
    UIImage *resizableImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:imageInsets
                                                                             resizingMode:UIImageResizingModeStretch];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.attributedText = content;
    
    [self initWithLabel:textLabel
              direction:bubbleDirection
             bubbleView:[[AWEBubbleImageView alloc] initWithImage:resizableImage
                                                        direction:bubbleDirection
                                                 anchorAdjustment:adjustment]
             edgeInsets:insets
              fixedSize:fixedSize];
}

- (void)initWithContent:(NSString *)content
              direction:(AWEBubbleManagerDirection)bubbleDirection
       anchorAdjustment:(CGPoint)adjustment
        bubbleImageName:(NSString *)imageName
      image9ScaleInsets:(UIEdgeInsets)imageInsets
             edgeInsets:(UIEdgeInsets)insets
                   font:(UIFont *)font
                  color:(UIColor *)fontColor
              fixedSize:(CGSize)fixedSize {
    UIImage *resizableImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:imageInsets
                                                                             resizingMode:UIImageResizingModeStretch];
    [self initWithContent:content
                direction:bubbleDirection
               bubbleView:[[AWEBubbleImageView alloc] initWithImage:resizableImage
                                                          direction:bubbleDirection
                                                   anchorAdjustment:adjustment]
               edgeInsets:insets
                     font:font
                    color:fontColor
                fixedSize:fixedSize];
}

- (void)initWithContent:(NSString *)content
              direction:(AWEBubbleManagerDirection)bubbleDirection
             bubbleView:(UIView<AWEBubbleAnchor> *)bubbleView
             edgeInsets:(UIEdgeInsets)insets
                   font:(UIFont *)font
                  color:(UIColor *)fontColor
              fixedSize:(CGSize)fixedSize {
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.font = font;
    textLabel.textColor = fontColor;
    textLabel.text = content;
    
    [self initWithLabel:textLabel
              direction:bubbleDirection
             bubbleView:bubbleView
             edgeInsets:insets
              fixedSize:fixedSize];
}

- (void)initWithLabel:(UILabel *)label
            direction:(AWEBubbleManagerDirection)bubbleDirection
           bubbleView:(UIView<AWEBubbleAnchor> *)bubbleView
           edgeInsets:(UIEdgeInsets)insets
            fixedSize:(CGSize)fixedSize{
    
    self.textLabel = label;
    self.bubbleView = bubbleView;
    self.edgeInsets = insets;
    self.fixedSize = fixedSize;
    
    self.direction = bubbleDirection;
    
    switch (bubbleDirection) {
        case AWEBubbleManagerDirectionUp:
            self.layer.anchorPoint = CGPointMake(0.5, 1);
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case AWEBubbleManagerDirectionLeft:
            self.layer.anchorPoint = CGPointMake(1, 0.5);
            self.textLabel.textAlignment = NSTextAlignmentRight;
            break;
        case AWEBubbleManagerDirectionDown:
            self.layer.anchorPoint = CGPointMake(0.5, 0);
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case AWEBubbleManagerDirectionRight:
            self.layer.anchorPoint = CGPointMake(0, 0.5);
            self.textLabel.textAlignment = NSTextAlignmentLeft;
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.bubbleView];
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize textSize = [self currentTextSize];
    [self.textLabel setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    CGRect bubbleFrame = self.bounds;
    self.bubbleView.frame = bubbleFrame;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = bubbleFrame.origin.x + self.edgeInsets.left;
    textFrame.origin.y = bubbleFrame.origin.y + self.edgeInsets.top;
    self.textLabel.frame = textFrame;
}

- (CGSize)currentTextSize {
    CGFloat textMaxWidth = self.fixedSize.width == 0 ? 200 : self.fixedSize.width;
    textMaxWidth -= self.edgeInsets.left - self.edgeInsets.right;
    if (self.attributedBubble) {
        return [self.textLabel.attributedText boundingRectWithSize:CGSizeMake(textMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else {
        return [self.textLabel.text boundingRectWithSize:CGSizeMake(textMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil].size;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize labelSize = [self currentTextSize];
    return CGSizeMake(labelSize.width + self.edgeInsets.left + self.edgeInsets.right,
                      labelSize.height + self.edgeInsets.top + self.edgeInsets.bottom);
}

- (CGPoint)anchorPositionRelatedToLeftTop {
    if ([self.bubbleView respondsToSelector:@selector(anchorPositionRelatedToLeftTop)]) {
        return [self.bubbleView anchorPositionRelatedToLeftTop];
    }
    return CGPointZero;
}

- (void)redoLayout {
    [self sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGPoint defaultAnchorPosition = CGPointZero;
    switch (self.direction) {
        case AWEBubbleManagerDirectionUp:
            defaultAnchorPosition = CGPointMake(self.anchorView.frame.size.width / 2, 0);
            break;
        case AWEBubbleManagerDirectionLeft:
            defaultAnchorPosition = CGPointMake(0, self.anchorView.frame.size.height / 2);
            break;
        case AWEBubbleManagerDirectionDown:
            defaultAnchorPosition = CGPointMake(self.anchorView.frame.size.width / 2, self.anchorView.frame.size.height);
            break;
        case AWEBubbleManagerDirectionRight:
            defaultAnchorPosition = CGPointMake(self.anchorView.frame.size.width, self.anchorView.frame.size.height / 2);
            break;
            
        default:
            break;
    }
    
    CGPoint anchor = self.anchorPoint;
    
    if (CGPointEqualToPoint(anchor, AWEBubbleAnchorAutomaticDimension)) {
        anchor = defaultAnchorPosition;
    }
    
    UIView *sizingView = [[UIView alloc] initWithFrame:self.anchorView.frame];
    [self.anchorView.superview addSubview:sizingView];
    CGPoint absolutePosition = [self.superview convertPoint:anchor fromView:sizingView];
    [sizingView removeFromSuperview];
    
    CGRect frame = self.frame;
    
    frame.origin.x = absolutePosition.x - self.anchorPositionRelatedToLeftTop.x;
    frame.origin.y = absolutePosition.y - self.anchorPositionRelatedToLeftTop.y;
    
    self.frame = frame;
}

@end
