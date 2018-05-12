//
//  ICNetworkManager.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/24.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ICNetworkRequestTypeJSON,
    ICNetworkRequestTypeFormData,
} ICNetworkRequestType;

@interface ICNetworkManager : NSObject

+ (void)requestApiPath:(NSString *)api
                method:(NSString *)method
                params:(NSDictionary *)params
           requestType:(ICNetworkRequestType)type
   withCompletionBlock:(void (^)(BOOL success, NSDictionary *data, NSError *error))completionBlock;

+ (void)requestRawApiPath:(NSString *)api
                   method:(NSString *)method
                   params:(NSDictionary *)params
              requestType:(ICNetworkRequestType)type
      withCompletionBlock:(void (^)(BOOL, NSData *, NSError *))completionBlock;

@end
