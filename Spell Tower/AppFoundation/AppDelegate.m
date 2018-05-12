//
//  AppDelegate.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "AppDelegate.h"
#import "IDRouter.h"
#import "STLocalGameManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[IDRouter viewControllerForURL:@"tower://offline-games"]];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    [[STLocalGameManager sharedInstance] installOfflinePackagesIfNeeded];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return YES;
}

@end
