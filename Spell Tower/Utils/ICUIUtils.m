//
//  ICUIUtils.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/5.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICUIUtils.h"
#import "IDResponder.h"
#import <UIView+Toast.h>
#import <SVProgressHUD.h>

@implementation ICUIUtils

+ (void)alert:(NSString *)title content:(NSString *)content
{
    [self alert:title content:content completionBlock:nil];
}

+ (void)alert:(NSString *)title content:(NSString *)content completionBlock:(void (^)(void))completionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionBlock) {
            completionBlock();
        }
    }]];
    [[IDResponder topViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void)toast:(NSString *)content
{
    [[IDResponder topViewController].view makeToast:content duration:2 position:CSToastPositionCenter];
}

+ (void)loading
{
    [self loadingWithStatus:nil];
}

+ (void)loadingWithStatus:(NSString *)status
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    });
    if (status) {
        [SVProgressHUD showWithStatus:status];
    } else {
        [SVProgressHUD show];
    }
}

+ (void)endLoading
{
    [SVProgressHUD dismiss];
}

+ (void)loadingWithProgress:(CGFloat)progress
{
    [SVProgressHUD showProgress:progress];
}

+ (void)loadingWithProgress:(CGFloat)progress status:(NSString *)status
{
    [SVProgressHUD showProgress:progress status:status];
}

@end
