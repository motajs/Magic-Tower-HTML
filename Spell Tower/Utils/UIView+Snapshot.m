//
//  UIView+Snapshot.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/19.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)awe_snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImageView *)awe_snapshotImageView
{
    UIImage *image = [self awe_snapshotImage];
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.frame;
        return imageView;
    }
    return nil;
}

@end
