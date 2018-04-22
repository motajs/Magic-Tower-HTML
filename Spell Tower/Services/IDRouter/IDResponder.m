//
//  IDResponder.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "IDResponder.h"

@implementation IDResponder

+ (UIViewController *)topViewController
{
    return [self topViewControllerForController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerForController:(UIViewController *)viewController
{
    if (viewController.presentedViewController) {
        return [self topViewControllerForController:viewController.presentedViewController];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerForController:((UITabBarController *)viewController).selectedViewController];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerForController:((UINavigationController *)viewController).topViewController];
    } else {
        return viewController;
    }
}

+ (UINavigationController *)topNavigationViewController
{
    return [self topViewController].navigationController;
}

+ (UIViewController *)nearestViewControllerForView:(UIView *)view
{
    UIResponder *responder = view.nextResponder;
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

@end
