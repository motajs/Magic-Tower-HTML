//
//  LWStorageManager.h
//  Living Word
//
//  Created by 熊典 on 2016/10/14.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWStorageManager : NSObject

+ (void)storageSet:(id)data forKey:(NSString*)key;
+ (void)storageRemoveKey:(NSString*)key;
+ (id)storageDataOfKey:(NSString*)key;
+ (Boolean)storageKeyExists:(NSString*)key;

+ (void)preferenceSet:(id)data forKey:(NSString*)key;
+ (void)preferenceRemoveKey:(NSString*)key;
+ (id)preferenceDataOfKey:(NSString*)key;
+ (Boolean)preferenceKeyExists:(NSString*)key;

+ (void)iCloudSet:(id)data forKey:(NSString*)key;
+ (void)iCloudRemoveKey:(NSString*)key;
+ (id)iCloudDataOfKey:(NSString*)key;
+ (Boolean)iCloudKeyExists:(NSString*)key;
+ (id)iCloudDataOfDictionaryKey:(NSString*)key inStorageKey:(NSString*)storageKey;
+ (void)iCloudSetData:(id)data forDictionaryKey:(NSString*)key inStorageKey:(NSString*)storageKey;

+ (BOOL)synchronizeiCloud;

@end
