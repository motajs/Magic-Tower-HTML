//
//  UIColor+HexString.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (instancetype)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1];
}

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    
    NSAssert(hexString.length == 6, @"Color hex string should be of length 6");
    
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&result];
    
    return [UIColor colorWithRed:1.0f / 255.0f * ((result & 0xFF0000) >> 16) green:1.0f / 255.0f * ((result & 0x00FF00) >> 8) blue:1.0f / 255.0f * ((result & 0x0000FF) >> 0) alpha:alpha];
}

@end
