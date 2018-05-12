//
//  STGameMessage.h
//  Spell Tower
//
//  Created by 熊典 on 2018/4/23.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICMessageCenter.h"

@protocol STGameMessage <NSObject>

- (void)gameListDidChange;

@end
