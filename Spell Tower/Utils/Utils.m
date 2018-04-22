//
//  Utils.m
//  Living Word
//
//  Created by 熊典 on 16/8/17.
//  Copyright © 2016年 熊典. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonCrypto.h> // MD5
#import <sys/sysctl.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#endif

@implementation Utils

+ (NSString *)md5:(NSString *)str { // 字符串MD5值算法
    const char* cStr=[str UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; // CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(cStr, (unsigned int)strlen(cStr), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    }
    return outPutStr;
}

+ (NSString *)md5Data:(NSData *)data { // MD5值算法
    const char* cStr=data.bytes;
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; // CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(cStr, (unsigned int)strlen(cStr), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++) {
        [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    }
    return outPutStr;
}

+ (NSInteger)currentTime{
    return (NSInteger)[[NSDate date] timeIntervalSince1970];
}

+ (NSString *)heal:(NSString *)str to:(NSInteger)n{
    NSMutableString *res=[str mutableCopy];
    while (res.length<n) {
        [res insertString:@"0" atIndex:0];
    }
    return [NSString stringWithString:res];
}

+ (NSArray *)keyValueArrayFromDictionary:(NSDictionary *)dic usingFormat:(NSArray *)lines{
    NSMutableArray *res=[NSMutableArray array];
    for (NSString *one in lines) {
        NSArray *items=[one componentsSeparatedByString:@"->"];
        if(dic[items[0]]!=nil) [res addObject:@{@"key":items[1], @"value":dic[items[0]]}];
    }
    return [NSArray arrayWithArray:res];
}

+ (NSString *)formatTime:(NSInteger)timestamp{
    NSInteger now=[[NSDate date] timeIntervalSince1970];
    NSInteger interval=now-timestamp;
    if (interval<-60) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateStyle=NSDateFormatterShortStyle;
        formatter.timeStyle=NSDateFormatterNoStyle;
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    }else if (interval<60) {
        return NSLocalizedString(@"Utils_Now", @"now");
    }else if (interval<3600){
        return [NSString stringWithFormat:NSLocalizedString(@"Utils_Min_Ago", @"%ld min ago"),(long)(interval/60)];
    }else if (interval<3600*24){
        return [NSString stringWithFormat:NSLocalizedString(@"Utils_Hours_Ago", @"%ld hours ago"),(long)(interval/3600)];
    }else if (interval<3600*24*5){
        return [NSString stringWithFormat:NSLocalizedString(@"Utils_Days_Ago", @"%ld days ago"),(long)(interval/3600/24)];
    }else{
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        formatter.dateStyle=NSDateFormatterShortStyle;
        formatter.timeStyle=NSDateFormatterNoStyle;
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
    }
}

+ (NSString *)appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)deviceInfo{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)osVersion{
#if TARGET_OS_IPHONE
    return [UIDevice currentDevice].systemVersion;
#else
    NSString *versionString = [[NSProcessInfo processInfo] operatingSystemVersionString];
    return versionString;
#endif
}

+ (NSString *)createRandom:(NSInteger)length{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand((unsigned int)time(NULL));
    });
    NSString *chars=@"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
    NSMutableString *str=[NSMutableString string];
    for (NSInteger i=0; i<length; i++) {
        [str appendString:[chars substringWithRange:NSMakeRange(rand()%chars.length, 1)]];
    }
    return str;
}

+ (NSString *)formatedSize:(size_t)size
{
    if (size < (1 << 10)) {
        return [NSString stringWithFormat:@"%ld B", size];
    } else if (size < (1 << 20)) {
        return [NSString stringWithFormat:@"%.1f KB", 1.0 * size / (1 << 10)];
    } else if (size < (1 << 30)) {
        return [NSString stringWithFormat:@"%.2f MB", 1.0 * size / (1 << 20)];
    } else {
        return [NSString stringWithFormat:@"%.2f GB", 1.0 * size / (1 << 30)];
    }
}
@end
