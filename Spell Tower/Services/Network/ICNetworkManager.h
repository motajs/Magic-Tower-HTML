//
//  ICNetworkManager.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/24.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNetworkManager : NSObject

+ (void)requestApiPath:(NSString *)api
                method:(NSString *)method
                params:(NSDictionary *)params
   withCompletionBlock:(void (^)(BOOL success, NSDictionary *data, NSError *error))completionBlock;

@end
