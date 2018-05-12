//
//  STLocalGameManager.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STLocalGameManager.h"
#import "LWStorageManager.h"
#import <SSZipArchive.h>
#import "ICMessageCenter.h"
#import "STGameMessage.h"
#import "Utils.h"
#import "ICUIUtils.h"

static NSString * const ICProjectConfigsStorageKey = @"ICProjectConfigsStorageKey";

@interface STLocalGameManager()

@property (nonatomic, strong) NSMutableArray<STGameModel *> *storedGames;
@property (nonatomic, copy) void (^progressUpdateBlock)(float progress);

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
    [LWStorageManager storageSet:self.storedGames forKey:ICProjectConfigsStorageKey];
}

- (void)moveGameAtIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    STGameModel *game = self.localGames[index];
    [self.storedGames removeObjectAtIndex:index];
    [self.storedGames insertObject:game atIndex:newIndex];
    [self sync];
}

- (void)downloadGame:(STGameModel *)game progress:(void (^)(float))progressUpdateBlock withCompletionBlock:(void (^)(void))completionBlock
{
    self.progressUpdateBlock = progressUpdateBlock;
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:game.downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self installZipGameAtPath:location.path basedOnGame:game withCompletionBlock:completionBlock];
    }];
    [task.progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [task resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        if (self.progressUpdateBlock) {
            self.progressUpdateBlock(((NSProgress *)object).fractionCompleted);
        }
    }
}

- (void)installZipGameAtPath:(NSString *)path basedOnGame:(STGameModel *)basedGame withCompletionBlock:(void (^)(void))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STGameModel *game = basedGame;
        BOOL shouldExtractInfoFromZip = NO;
        if (!game) {
            game = [[STGameModel alloc] init];
            game.gameID = [Utils createRandom:6];
            shouldExtractInfoFromZip = YES;
        }
        NSError *error;
        [SSZipArchive unzipFileAtPath:path toDestination:game.localRootURL.path overwrite:YES password:nil error:&error];
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:game.localRootURL.path error:nil];
        if (contents.count == 1) {
            NSURL *tempURL = [[game.localRootURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"temp"];
            [[NSFileManager defaultManager] moveItemAtURL:[game.localRootURL URLByAppendingPathComponent:contents.firstObject] toURL:tempURL error:nil];
            [[NSFileManager defaultManager] removeItemAtURL:game.localRootURL error:nil];
            [[NSFileManager defaultManager] moveItemAtURL:tempURL toURL:game.localRootURL error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (shouldExtractInfoFromZip) {
                NSString *data = [NSString stringWithContentsOfURL:[game.localRootURL URLByAppendingPathComponent:@"project/data.js"] encoding:NSUTF8StringEncoding error:nil];
                UIWebView *webview = [[UIWebView alloc] init];
                [webview stringByEvaluatingJavaScriptFromString:data];
                NSString *varName = [data substringToIndex:[data rangeOfString:@"="].location];
                NSString *jsonText = [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"JSON.stringify(%@)", varName]];
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:[jsonText dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                game.titleName = info[@"firstData"][@"title"];
                game.identifierName = info[@"firstData"][@"name"];
            }
            [self.storedGames addObject:game];
            [self sync];
            self.progressUpdateBlock = nil;
            IC_SEND_MESSAGE(STGameMessage, gameListDidChange, gameListDidChange);
            if (completionBlock) {
                completionBlock();
            }
        });
    });
}

- (void)installOfflinePackagesIfNeeded
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths.firstObject;
    NSArray *documentContents = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [@"zip" isEqualToString:[evaluatedObject pathExtension].lowercaseString];
    }]];
    if (documentContents.count > 0) {
        [ICUIUtils loadingWithStatus:@"安装离线游戏"];
        dispatch_group_t group = dispatch_group_create();
        [documentContents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_group_enter(group);
            [self installZipGameAtPath:[documentPath stringByAppendingPathComponent:obj] basedOnGame:nil withCompletionBlock:^{
                [[NSFileManager defaultManager] removeItemAtPath:[documentPath stringByAppendingPathComponent:obj] error:nil];
                dispatch_group_leave(group);
            }];
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [ICUIUtils endLoading];
        });
    }
}

@end
