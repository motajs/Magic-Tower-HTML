//
//  ICUIUtils.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/5.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICUIUtils : NSObject

+ (void)alert:(NSString *)title content:(NSString *)content;
+ (void)alert:(NSString *)title content:(NSString *)content completionBlock:(void (^)(void))completionBlock;
+ (void)toast:(NSString *)content;

+ (void)loading;
+ (void)loadingWithStatus:(NSString *)status;
+ (void)loadingWithProgress:(CGFloat)progress;
+ (void)loadingWithProgress:(CGFloat)progress status:(NSString *)status;
+ (void)endLoading;

@end
