//
//  ICDeviceIDManager.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/24.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICDeviceIDManager.h"
#import "IDKeychainManager.h"
#import "Utils.h"

static NSString * const ICDeviceIDKeychainKey = @"AWEClientDeviceIDKeychainKey";

@implementation ICDeviceIDManager

+ (NSString *)deviceID
{
    static NSString *cdid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cdid = [IDKeychainManager getItemForKey:ICDeviceIDKeychainKey inDomain:kIDKeychainDeviceIDKey allowSharing:NO];
        if (!cdid) {
            cdid = [Utils createRandom:32];
            [IDKeychainManager setItem:cdid ForKey:ICDeviceIDKeychainKey inDomain:kIDKeychainDeviceIDKey allowSharing:NO];
        }
    });
    return cdid;
}

@end
