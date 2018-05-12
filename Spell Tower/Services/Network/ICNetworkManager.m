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

+ (void)requestApiPath:(NSString *)api method:(NSString *)method params:(NSDictionary *)params requestType:(ICNetworkRequestType)type withCompletionBlock:(void (^)(BOOL, NSDictionary *, NSError *))completionBlock
{
    [self requestRawApiPath:api method:method params:params requestType:type withCompletionBlock:^(BOOL success, NSData *data, NSError *error) {
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (result && [result isKindOfClass:[NSDictionary class]] && !jsonError) {
            completionBlock(YES, result, nil);
        } else {
            completionBlock(NO, nil, jsonError);
        }
    }];
}

+ (void)requestRawApiPath:(NSString *)api method:(NSString *)method params:(NSDictionary *)params requestType:(ICNetworkRequestType)type withCompletionBlock:(void (^)(BOOL, NSData *, NSError *))completionBlock
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
            if (type == ICNetworkRequestTypeJSON) {
                [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:&error]];
            } else {
                NSMutableArray *bodyContent = [NSMutableArray array];
                [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [bodyContent addObject:[NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
                }];
                [request setHTTPBody:[[bodyContent componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    [request setHTTPMethod:method];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!completionBlock) {
            return;
        }
        if (data && !error) {
            completionBlock(YES, data, nil);
        } else {
            completionBlock(NO, nil, error);
        }
    }] resume];
}

@end
