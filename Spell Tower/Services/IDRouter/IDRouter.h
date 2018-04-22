//
//  IDRouter.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDResponder.h"
#import "UIViewController+IDDismiss.h"

typedef enum : NSUInteger {
    IDRouterTransferTypePush,
    IDRouterTransferTypePresent,
} IDRouterTransferType;

FOUNDATION_EXPORT NSString * const IDRouterParamCompletionBlockKey;

@protocol IDRouterTransferrable <NSObject>

- (instancetype)initWithRouterParams:(NSDictionary<NSString *, id> *)params;

@optional
- (void)prepareEnterRouterWithCompletionBlock:(void (^)(BOOL canEnter))completionBlock;

@end

@protocol IDRouterCustomTransfer <NSObject>

@required
// return the view controller to handle this transfer；
// return self to indicate that this transfer cannot be handled;
// return nil to indicate that this transfer has been handled;
- (UIViewController *)willTransferToViewController:(__kindof UIViewController *)viewController withURL:(NSString *)urlString;

@end


@interface IDRouter : NSObject

+ (void)registerHandler:(void (^)(NSDictionary *params))handler forURLPattern:(NSString *)pattern;
+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern;
+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type;
+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle;
+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle beforeEnter:(void (^)(void(^completionBlock)(BOOL)))beforeEnterBlock;

+ (__kindof UIViewController *)viewControllerForURL:(NSString *)url;
+ (__kindof UIViewController *)viewControllerForURL:(NSString *)url additionalParam:(NSDictionary *)params;

+ (void)transferToURL:(NSString *)url;

+ (void)transferToURL:(NSString *)url withParams:(NSDictionary *)params;

@end
