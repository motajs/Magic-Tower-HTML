//
//  STGameItemCollectionViewCell.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STGameModel.h"

@interface STGameItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^longPressBlock)(void);

- (void)setupWithModel:(STGameModel *)model;

@end
