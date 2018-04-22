//
//  UIViewController+IDDismiss.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/4.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "UIViewController+IDDismiss.h"

@implementation UIViewController (IDDismiss)

- (void)closeAnimated
{
    if (self.navigationController && self.navigationController.viewControllers.count >= 2) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIBarButtonItem *)closeBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeAnimated)];
}

- (UIBarButtonItem *)imageCloseBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"project_icon_exit"] style:UIBarButtonItemStyleDone target:self action:@selector(closeAnimated)];
}

@end
