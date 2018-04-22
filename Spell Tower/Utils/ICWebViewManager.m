//
//  ICWebViewManager.m
//  Iodine Code
//
//  Created by 熊典 on 2018/3/20.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICWebViewManager.h"
#import "IDRouter.h"
#import <SafariServices/SafariServices.h>

@implementation ICWebViewManager

+ (void)load
{
    [IDRouter registerHandler:^(NSDictionary *params) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:params[@"url"]]];
        [[IDResponder topViewController] presentViewController:safariVC animated:YES completion:nil];
    } forURLPattern:@"icode://webview"];
}

@end
