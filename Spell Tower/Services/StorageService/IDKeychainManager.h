//
//  IDKeychainManager.h
//  Iodine MYSQL
//
//  Created by 熊典 on 2016/11/16.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kIDKeychainProjectPasswordKey,
    kIDKeychainMasterPasswordKey,
    kIDKeychainDeviceIDKey,
    kIDKeychainTrailDateKey,
} IDKeychainDomain;

@interface IDKeychainManager : NSObject

+ (BOOL)setItem:(NSString*)obj ForKey:(NSString*)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share;
+ (NSString*)getItemForKey:(NSString*)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share;
+ (BOOL)removeItemForKey:(NSString*)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share;

@end
