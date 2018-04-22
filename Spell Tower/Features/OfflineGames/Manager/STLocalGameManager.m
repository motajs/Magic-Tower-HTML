//
//  STLocalGameManager.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STLocalGameManager.h"
#import "LWStorageManager.h"

static NSString * const ICProjectConfigsStorageKey = @"ICProjectConfigsStorageKey";

@interface STLocalGameManager()

@property (nonatomic, strong) NSMutableArray<STGameModel *> *storedGames;

@end

@implementation STLocalGameManager

+ (instancetype)sharedInstance
{
    static STLocalGameManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STLocalGameManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.storedGames = [[LWStorageManager storageDataOfKey:ICProjectConfigsStorageKey] mutableCopy];
        if (!self.storedGames) {
            self.storedGames = [NSMutableArray array];
        }
    }
    return self;
}

- (NSArray<STGameModel *> *)localGames
{
    return self.storedGames.copy;
}

- (void)deleteGame:(STGameModel *)game
{
    [self.storedGames removeObject:game];
    [[NSFileManager defaultManager] removeItemAtURL:game.localRootURL error:nil];
    [self sync];
}

- (void)sync
{
    [LWStorageManager storageSet:self.localGames forKey:ICProjectConfigsStorageKey];
}

- (void)moveGameAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    STGameModel *game = self.localGames[index];
    [self.storedGames removeObjectAtIndex:index];
    [self.storedGames insertObject:game atIndex:newIndex];
    [self sync];
}

@end
