//
//  NSString+RelativePath.h
//  Iodine Code
//
//  Created by 熊典 on 2018/2/19.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RelativePath)

- (NSString*)stringWithPathRelativeTo:(NSString*)anchorPath;

@end
