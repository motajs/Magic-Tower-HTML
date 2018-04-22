//
//  IDResponder.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDResponder : NSObject

+ (__kindof UIViewController *)topViewController;

+ (__kindof UINavigationController *)topNavigationViewController;

+ (__kindof UIViewController *)nearestViewControllerForView:(UIView *)view;

@end
