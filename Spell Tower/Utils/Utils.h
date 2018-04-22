//
//  Utils.h
//  Living Word
//
//  Created by 熊典 on 16/8/17.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWStorageManager.h"

@interface Utils : NSObject

+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5Data:(NSData *)data;
+ (NSInteger)currentTime;
+ (NSString *)heal:(NSString *)str to:(NSInteger)n;
+ (NSArray *)keyValueArrayFromDictionary:(NSDictionary*)dic usingFormat:(NSArray*)lines;
+ (NSString*)formatTime:(NSInteger)timestamp;
+ (NSString*)appVersion;
+ (NSString*)deviceInfo;
+ (NSString*)osVersion;
+ (NSString*)createRandom:(NSInteger)length;
+ (NSString*)formatedSize:(size_t)size;

@end

static NSString * const notificationSystemConfigChanged = @"notification_system_config_changed";
