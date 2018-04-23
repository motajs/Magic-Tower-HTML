//
//  STStoreTableViewCell.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STGameModel.h"

@interface STStoreTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^downloadButtonTapBlock)(void);

- (void)configWithGame:(STGameModel *)game;

@end
