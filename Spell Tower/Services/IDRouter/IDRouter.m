//
//  IDRouter.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "IDRouter.h"
#import "IDResponder.h"

NSString * const IDRouterParamCompletionBlockKey = @"IDRouterParamCompletionBlockKey";

@interface IDRouterPattern : NSObject

@property (nonatomic, strong) Class classItem;
@property (nonatomic, copy) void (^handler)(NSDictionary *params);
@property (nonatomic, copy) void (^beforeEnter)(void (^completionBlock)(BOOL canEnter));
@property (nonatomic, assign) IDRouterTransferType transferType;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

- (instancetype)initWithHandler:(void(^)(NSDictionary *))handler;
- (instancetype)initWithClassItem:(Class)classItem type:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle;

@end

@implementation IDRouterPattern

- (instancetype)initWithClassItem:(Class)classItem type:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle
{
    self = [super init];
    if (self) {
        self.classItem = classItem;
        self.transferType = type;
        self.presentationStyle = presentationStyle;
    }
    return self;
}

- (instancetype)initWithHandler:(void (^)(NSDictionary *))handler
{
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

@end

static NSMutableDictionary<NSString *, IDRouterPattern *> *registeredPatterns;
static NSMutableDictionary<NSString *, NSURLComponents *> *patternComponents;

@implementation IDRouter

+ (void)registerHandler:(void (^)(NSDictionary *))handler forURLPattern:(NSString *)pattern
{
    [self initContainers];
    registeredPatterns[pattern] = [[IDRouterPattern alloc] initWithHandler:handler];
}

+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern
{
    [self registerViewControllerClass:classItem forURLPattern:pattern transferType:IDRouterTransferTypePush];
}

+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type
{
    [self registerViewControllerClass:classItem forURLPattern:pattern transferType:type presentationStyle:UIModalPresentationFullScreen];
}

+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle
{
    [self registerViewControllerClass:classItem forURLPattern:pattern transferType:type presentationStyle:presentationStyle beforeEnter:nil];
}

+ (void)registerViewControllerClass:(Class)classItem forURLPattern:(NSString *)pattern transferType:(IDRouterTransferType)type presentationStyle:(UIModalPresentationStyle)presentationStyle beforeEnter:(void (^)(void(^completionBlock)(BOOL)))beforeEnterBlock
{
    [self initContainers];
    IDRouterPattern *patternObj = [[IDRouterPattern alloc] initWithClassItem:classItem type:type presentationStyle:presentationStyle];
    patternObj.beforeEnter = beforeEnterBlock;
    registeredPatterns[pattern] = patternObj;
}

+ (void)initContainers
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registeredPatterns = [NSMutableDictionary dictionary];
        patternComponents = [NSMutableDictionary dictionary];
    });
}

+ (void)transferToURL:(NSString *)url
{
    [self transferToURL:url withParams:nil];
}

+ (void)transferToURL:(NSString *)url withParams:(NSDictionary *)params
{
    IDRouterPattern *pattern;
    UIViewController *viewController = [self viewControllerForURL:url pattern:&pattern additionalParams:params];
    if (!viewController) {
        NSMutableDictionary *resultParams = params.mutableCopy ?: [NSMutableDictionary dictionary];
        NSURLComponents *urlComps = [NSURLComponents componentsWithString:url];
        [urlComps.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            resultParams[obj.name] = obj.value;
        }];
        if (pattern && pattern.handler) {
            pattern.handler(resultParams);
        }
        return;
    }
    UIViewController *topViewController = [IDResponder topViewController];
    while (topViewController) {
        if ([topViewController conformsToProtocol:@protocol(IDRouterCustomTransfer)]) {
            UIViewController *newTopViewController = [(UIViewController<IDRouterCustomTransfer> *)topViewController willTransferToViewController:viewController withURL:url];
            if (!newTopViewController) {
                return;
            } else if (newTopViewController == topViewController) {
                break;
            } else {
                topViewController = newTopViewController;
            }
        } else {
            break;
        }
    }
    
    void (^enterRouter)(void) = ^{
        if (pattern.transferType == IDRouterTransferTypePush) {
            if ([topViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)topViewController pushViewController:viewController animated:YES];
            } else {
                [topViewController.navigationController pushViewController:viewController animated:YES];
            }
        } else if (pattern.transferType == IDRouterTransferTypePresent) {
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                viewController.modalPresentationStyle = UIModalPresentationFormSheet;
                [topViewController presentViewController:viewController animated:YES completion:nil];
            } else {
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
                navi.modalPresentationStyle = pattern.presentationStyle;
                [topViewController presentViewController:navi animated:YES completion:nil];
            }
        }
    };
    
    void (^wrappedEnter)(void) = ^{
        if ([viewController respondsToSelector:@selector(prepareEnterRouterWithCompletionBlock:)]) {
            [(id<IDRouterTransferrable>)viewController prepareEnterRouterWithCompletionBlock:^(BOOL canEnter) {
                if (canEnter) {
                    enterRouter();
                }
            }];
        } else {
            enterRouter();
        }
    };
    
    if (pattern.beforeEnter) {
        pattern.beforeEnter(^(BOOL canEnter) {
            if (canEnter) {
                wrappedEnter();
            }
        });
    } else {
        wrappedEnter();
    }
}

+ (UIViewController *)viewControllerForURL:(NSString *)url
{
    return [self viewControllerForURL:url additionalParam:nil];
}

+ (UIViewController *)viewControllerForURL:(NSString *)url additionalParam:(NSDictionary *)params
{
    return [self viewControllerForURL:url pattern:nil additionalParams:params];
}

+ (UIViewController *)viewControllerForURL:(NSString *)url pattern:(IDRouterPattern **)pattern additionalParams:(NSDictionary *)additionalParams;
{
    NSURLComponents *urlComps = [NSURLComponents componentsWithString:url];
    if (!urlComps) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __block Class matchedClassItem;
    for (NSString *key in registeredPatterns.allKeys) {
        IDRouterPattern *obj = registeredPatterns[key];
        if (!patternComponents[key]) {
            NSURLComponents *comps = [NSURLComponents componentsWithString:key];
            if (comps) {
                patternComponents[key] = comps;
            }
        }
        NSURLComponents *patternComps = patternComponents[key];
        if (!patternComps) {
            continue;
        }
        if (![patternComps.host isEqualToString:urlComps.host]) {
            continue;
        }
        NSString *patternCompsPath = patternComps.path;
        NSString *urlCompsPath = urlComps.path;
        if ([patternCompsPath hasPrefix:@"/"]) {
            patternCompsPath = [patternCompsPath substringFromIndex:1];
        }
        if ([urlCompsPath hasPrefix:@"/"]) {
            urlCompsPath = [urlCompsPath substringFromIndex:1];
        }
        NSArray<NSString *> *patternPathComponents = [@[patternComps.host] arrayByAddingObjectsFromArray:[patternCompsPath componentsSeparatedByString:@"/"]];
        NSArray<NSString *> *urlPathComponents = [@[urlComps.host] arrayByAddingObjectsFromArray:[urlCompsPath componentsSeparatedByString:@"/"]];
        if (patternPathComponents.count != urlPathComponents.count) {
            continue;
        }
        BOOL failedToMatch = NO;
        for (NSInteger i = 0; i < patternPathComponents.count; i++) {
            if ([patternPathComponents[i] hasPrefix:@":"]) {
                params[[patternPathComponents[i] substringFromIndex:1]] = urlPathComponents[i];
            } else {
                if (![patternPathComponents[i] isEqualToString:urlPathComponents[i]]) {
                    failedToMatch = YES;
                    break;
                }
            }
        }
        if (failedToMatch) {
            [params removeAllObjects];
            continue;
        }
        matchedClassItem = obj.classItem;
        if (pattern) {
            *pattern = obj;
        }
        [urlComps.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            params[obj.name] = obj.value;
        }];
        break;
    }
    
    if (!matchedClassItem) {
        return nil;
    }
    if ([matchedClassItem conformsToProtocol:@protocol(IDRouterTransferrable)]) {
        if (additionalParams) {
            [params addEntriesFromDictionary:additionalParams];
        }
        UIViewController<IDRouterTransferrable> *viewController = [(UIViewController<IDRouterTransferrable> *)[matchedClassItem alloc] initWithRouterParams:params];
        return viewController;
    } else {
        UIViewController *viewController = [[matchedClassItem alloc] init];
        return viewController;
    }
}

@end
