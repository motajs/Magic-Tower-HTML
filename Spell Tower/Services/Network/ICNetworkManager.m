//
//  ICNetworkManager.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/24.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICNetworkManager.h"
#import "ICDeviceIDManager.h"

@implementation ICNetworkManager

+ (void)requestApiPath:(NSString *)api method:(NSString *)method params:(NSDictionary *)params withCompletionBlock:(void (^)(BOOL, NSDictionary *, NSError *))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setValue:[ICDeviceIDManager deviceID] ?: @"" forHTTPHeaderField:@"IC-Device-ID"];
    if ([method.lowercaseString isEqualToString:@"get"]) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSMutableArray<NSURLQueryItem *> *items = comps.queryItems.mutableCopy;
        if (!items) {
            items = [NSMutableArray array];
        }
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [items addObject:[NSURLQueryItem queryItemWithName:key value:[obj isKindOfClass:NSString.class] ? obj : [obj stringValue]]];
        }];
        comps.queryItems = items;
        request.URL = comps.URL;
    } else {
        if (params && [params isKindOfClass:[NSDictionary class]]) {
            NSError *error;
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:&error]];
        }
    }
    [request setHTTPMethod:method];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!completionBlock) {
            return;
        }
        if (data && !error) {
            NSError *jsonError;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (result && [result isKindOfClass:[NSDictionary class]] && !jsonError) {
                completionBlock(YES, result, nil);
            } else {
                completionBlock(NO, nil, jsonError);
            }
        } else {
            completionBlock(NO, nil, error);
        }
    }] resume];
}

@end
