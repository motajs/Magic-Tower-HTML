//
//  STLocalGameManager.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STGameModel.h"

@interface STLocalGameManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray<STGameModel *> *)localGames;
- (void)deleteGame:(STGameModel *)game;
- (void)moveGameAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)downloadGame:(STGameModel *)game
            progress:(void(^)(float progress))progressUpdateBlock
 withCompletionBlock:(void(^)(void))completionBlock;

- (void)installOfflinePackagesIfNeeded;

@end
