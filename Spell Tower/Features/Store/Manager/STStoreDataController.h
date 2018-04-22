//
//  STStoreDataController.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STGameModel.h"

@interface STStoreDataController : NSObject

@property (nonatomic, strong) NSMutableArray<STGameModel *> *games;
@property (nonatomic, assign) BOOL isRequestOnAir;

- (void)initFetchWithCompletion:(void (^)(NSArray<STGameModel *> *result, NSError *error))completionBlock;
- (void)loadMoreWithCompletion:(void (^)(NSArray<STGameModel *> *result, NSError *error))completionBlock;

@end
