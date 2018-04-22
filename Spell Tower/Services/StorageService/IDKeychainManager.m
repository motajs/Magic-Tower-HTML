//
//  IDKeychainManager.m
//  Iodine MYSQL
//
//  Created by 熊典 on 2016/11/16.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import "IDKeychainManager.h"

@implementation IDKeychainManager

+ (BOOL)setItem:(NSString *)obj ForKey:(NSString *)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share{
    NSDictionary *query=@{
                          (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                          (__bridge id)kSecAttrService:[NSString stringWithFormat:@"%ld", domain],
                          (__bridge id)kSecAttrAccount:key,
                          (__bridge id)kSecReturnData:@YES,
                          (__bridge id)kSecAttrSynchronizable:@(share)
                          };
    CFDataRef data;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&data)==noErr) {
        NSData *passdata=[obj dataUsingEncoding:NSUTF8StringEncoding];
        query=@{
                (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService:[NSString stringWithFormat:@"%ld", domain],
                (__bridge id)kSecAttrAccount:key,
                (__bridge id)kSecAttrSynchronizable:@(share)
                };
        NSDictionary *changes=@{(__bridge id)kSecValueData:passdata};
        OSStatus status=SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
        if (status!=noErr && status!=errSecDuplicateItem) {
            return NO;
        }
    }else{
        NSData *passdata=[obj dataUsingEncoding:NSUTF8StringEncoding];
        query=@{
                (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService:[NSString stringWithFormat:@"%ld", domain],
                (__bridge id)kSecAttrAccount:key,
                (__bridge id)kSecValueData:passdata,
                (__bridge id)kSecAttrSynchronizable:@(share)
                };
        OSStatus status=SecItemAdd((__bridge CFDictionaryRef)query, nil);
        if (status!=noErr && status!=errSecDuplicateItem) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)getItemForKey:(NSString *)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share{
    NSDictionary *query=@{
                          (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                          (__bridge id)kSecAttrService:[NSString stringWithFormat:@"%ld", domain],
                          (__bridge id)kSecAttrAccount:key,
                          (__bridge id)kSecReturnData:@YES,
                          (__bridge id)kSecAttrSynchronizable:@(share)
                          };
    CFDataRef data;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&data)==noErr) {
        NSData *passdata=(__bridge NSData*)data;
        return [[NSString alloc] initWithData:passdata encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

+ (BOOL)removeItemForKey:(NSString *)key inDomain:(IDKeychainDomain)domain allowSharing:(BOOL)share{
    NSDictionary *query=@{
                          (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                          (__bridge id)kSecAttrService:[NSString stringWithFormat:@"%ld", domain],
                          (__bridge id)kSecAttrAccount:key,
                          (__bridge id)kSecAttrSynchronizable:@(share)
                          };
    OSStatus status=SecItemDelete((__bridge CFDictionaryRef)(query));
    return status==noErr || status==errSecItemNotFound;
}

@end
