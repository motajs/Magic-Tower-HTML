//
//  LWStorageManager.m
//  Living Word
//
//  Created by 熊典 on 2016/10/14.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import "LWStorageManager.h"
#import "Utils.h"

@implementation LWStorageManager

+ (NSString*)storagePathForKey:(NSString *)key{
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    return [cachesPath stringByAppendingPathComponent:[Utils md5:key]];
}

+ (void)storageSet:(id)data forKey:(NSString*)key{
    NSString *path=[self storagePathForKey:key];
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

+ (id)storageDataOfKey:(NSString *)key{
    NSString *path=[self storagePathForKey:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSData alloc] initWithContentsOfFile:path]];
    }else{
        return nil;
    }
}
+ (Boolean)storageKeyExists:(NSString *)key{
    NSString *path=[self storagePathForKey:key];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)storageRemoveKey:(NSString *)key{
    NSString *path=[self storagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (id)preferenceDataOfKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (Boolean)preferenceKeyExists:(NSString *)key{
    return [self preferenceDataOfKey:key]!=nil;
}

+ (void)preferenceSet:(id)data forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

+ (void)preferenceRemoveKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (id)iCloudDataOfKey:(NSString *)key{
    NSUbiquitousKeyValueStore *iCloudStorage=[NSUbiquitousKeyValueStore defaultStore];
    return [iCloudStorage objectForKey:key];
}

+ (Boolean)iCloudKeyExists:(NSString *)key{
    return [self iCloudDataOfKey:key]!=nil;
}

+ (void)iCloudRemoveKey:(NSString *)key{
    NSUbiquitousKeyValueStore *iCloudStorage=[NSUbiquitousKeyValueStore defaultStore];
    [iCloudStorage removeObjectForKey:key];
}

+ (BOOL)synchronizeiCloud{
    return [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

+ (void)iCloudSet:(id)data forKey:(NSString *)key{
    NSUbiquitousKeyValueStore *iCloudStorage=[NSUbiquitousKeyValueStore defaultStore];
    [iCloudStorage setObject:data forKey:key];
}

+ (void)iCloudSetData:(id)data forDictionaryKey:(NSString *)key inStorageKey:(NSString *)storageKey{
    NSMutableDictionary *dictionaryContent=[[self iCloudDataOfKey:storageKey] mutableCopy];
    if (!dictionaryContent || ![dictionaryContent isKindOfClass:[NSDictionary class]]) {
        dictionaryContent=[NSMutableDictionary dictionary];
    }
    dictionaryContent[key]=data;
    [self iCloudSet:dictionaryContent forKey:storageKey];
}

+ (id)iCloudDataOfDictionaryKey:(NSString *)key inStorageKey:(NSString *)storageKey{
    NSDictionary *dictionaryContent=[self iCloudDataOfKey:storageKey];
    if (dictionaryContent && [dictionaryContent isKindOfClass:[NSDictionary class]]) {
        return dictionaryContent[key];
    }else{
        return nil;
    }
}
@end
