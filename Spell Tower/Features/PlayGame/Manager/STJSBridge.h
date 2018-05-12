//
//  STJSBridge.h
//  Spell Tower
//
//  Created by 熊典 on 2018/5/12.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STJSBridge : NSObject

- (instancetype)initWithWebView:(UIWebView *)webView;
- (BOOL)handleOpenURL:(NSURLRequest *)urlRequest;

@end
