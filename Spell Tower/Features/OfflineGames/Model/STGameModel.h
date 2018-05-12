//
//  STGameModel.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STGameModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *gameID;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *identifierName;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *originAuthor;
@property (nonatomic, strong) NSString *copiedAuthor;
@property (nonatomic, strong) NSString *webURLString;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSString *extraInfo;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) NSInteger playerCount;
@property (nonatomic, assign) NSInteger winnerCount;

@property (nonatomic, assign) NSDate *updateDate;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *lastWinnerDate;
@property (nonatomic, strong) NSArray<NSString *> *tags;

@property (nonatomic, readonly) NSURL *localRootURL;
@property (nonatomic, readonly) NSURL *thumbURL;
@property (nonatomic, readonly) NSURL *downloadURL;

+ (instancetype)modelFromJSON:(NSDictionary *)json;
+ (NSArray<STGameModel *> *)modelsFromJSONArray:(NSArray *)jsonArray;

@end
