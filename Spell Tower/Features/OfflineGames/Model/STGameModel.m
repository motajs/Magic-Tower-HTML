//
//  STGameModel.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STGameModel.h"
#import "NSArray+Map.h"
#import "ICMacros.h"

@implementation STGameModel

+ (instancetype)modelFromJSON:(NSDictionary *)json
{
    STGameModel *model = [[STGameModel alloc] init];
    model.gameID = json[@"id"];
    model.titleName = [[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>" options:0 error:nil] stringByReplacingMatchesInString:json[@"title"] options:0 range:NSMakeRange(0, [json[@"title"] length]) withTemplate:@""];
    model.identifierName = json[@"name"];
    model.version = json[@"version"];
    model.originAuthor = json[@"author"];
    model.copiedAuthor = json[@"author2"];
    model.webURLString = json[@"link"];
    model.imageURL = [NSURL URLWithString:json[@"image"]];
    model.descriptionString = json[@"description"];
    model.extraInfo = json[@"content"];
    model.score = [json[@"score"] floatValue];
    model.playerCount = [json[@"people"] integerValue];
    model.winnerCount = [json[@"win"] integerValue];
    model.lastWinnerDate = [NSDate dateWithTimeIntervalSince1970:[json[@"lasttime"] integerValue]];
    model.createDate = [NSDate dateWithTimeIntervalSince1970:[json[@"createtime"] integerValue]];
    model.updateDate = [NSDate dateWithTimeIntervalSince1970:[json[@"updatetime"] integerValue]];
    model.tags = [json[@"tag"] componentsSeparatedByString:@"|"];
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    ICEncode(aCoder, gameID);
    ICEncode(aCoder, titleName);
    ICEncode(aCoder, identifierName);
    ICEncode(aCoder, version);
    ICEncode(aCoder, originAuthor);
    ICEncode(aCoder, copiedAuthor);
    ICEncode(aCoder, webURLString);
    ICEncode(aCoder, imageURL);
    ICEncode(aCoder, descriptionString);
    ICEncode(aCoder, extraInfo);
    ICEncodeFloat(aCoder, score);
    ICEncodeInteger(aCoder, playerCount);
    ICEncodeInteger(aCoder, winnerCount);
    ICEncode(aCoder, lastWinnerDate);
    ICEncode(aCoder, createDate);
    ICEncode(aCoder, updateDate);
    ICEncode(aCoder, tags);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        ICDecode(aCoder, gameID);
        ICDecode(aCoder, titleName);
        ICDecode(aCoder, identifierName);
        ICDecode(aCoder, version);
        ICDecode(aCoder, originAuthor);
        ICDecode(aCoder, copiedAuthor);
        ICDecode(aCoder, webURLString);
        ICDecode(aCoder, imageURL);
        ICDecode(aCoder, descriptionString);
        ICDecode(aCoder, extraInfo);
        ICDecodeFloat(aCoder, score);
        ICDecodeInteger(aCoder, playerCount);
        ICDecodeInteger(aCoder, winnerCount);
        ICDecode(aCoder, lastWinnerDate);
        ICDecode(aCoder, createDate);
        ICDecode(aCoder, updateDate);
        ICDecode(aCoder, tags);
    }
    return self;
}

+ (NSArray<STGameModel *> *)modelsFromJSONArray:(NSArray *)jsonArray
{
    return [jsonArray mapWithBlock:^id(id item, NSInteger index) {
        return [self modelFromJSON:item];
    }];
}

- (NSURL *)localRootURL
{
    NSString *rootPath = [[STGameModel allGamesRootPath] stringByAppendingPathComponent:self.gameID];
    return [NSURL fileURLWithPath:rootPath];
}

- (NSURL *)thumbURL
{
    NSString *imageURLString = self.imageURL.absoluteString;
    return [NSURL URLWithString:[[[imageURLString stringByDeletingPathExtension] stringByAppendingString:@".min"] stringByAppendingPathExtension:[imageURLString pathExtension]]];
}

- (NSURL *)downloadURL
{
    return [NSURL URLWithString:[self.webURLString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.identifierName]]];
}

+ (NSString *)allGamesRootPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = paths.firstObject;
    return libraryPath;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    STGameModel *model = object;
    return [self.gameID isEqualToString:model.gameID];
}

@end
