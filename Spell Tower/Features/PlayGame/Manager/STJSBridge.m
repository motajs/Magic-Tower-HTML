//
//  STJSBridge.m
//  Spell Tower
//
//  Created by 熊典 on 2018/5/12.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STJSBridge.h"
#import "ICNetworkManager.h"
#import "IDResponder.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString * const kSTJSBridgeMethodKey = @"method";
NSString * const kSTJSBridgeParametersKey = @"parameters";

@interface STJSBridge()<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) NSMutableDictionary *methods;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) UIDocumentPickerViewController *documentPicker;
@property (nonatomic, copy) void (^completionHandler)(NSDictionary *parameters);

@end

@implementation STJSBridge

- (instancetype)initWithWebView:(UIWebView *)webView
{
    self = [super init];
    if (self) {
        self.webView = webView;
        self.methods = [NSMutableDictionary dictionary];
        [self registerMethods];
    }
    return self;
}

- (void)registerMethods
{
    [self registerMethod:@"httpRequest" forAction:^(NSDictionary *parameters, void (^callback)(NSDictionary *parameters)) {
        NSString *path = parameters[@"path"];
        NSString *method = parameters[@"method"];
        NSDictionary *data = parameters[@"data"];
        
        [ICNetworkManager requestApiPath:[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"https://h5mota.com"]].absoluteString method:method params:data requestType:ICNetworkRequestTypeFormData withCompletionBlock:^(BOOL success, NSDictionary *data, NSError *error) {
            if (success && !error) {
                callback(@{@"success": @(YES),
                           @"data": [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data options:0 error:nil] encoding:NSUTF8StringEncoding],
                           });
            } else {
                callback(@{@"success": @(NO),
                           @"error": error.localizedDescription,
                           });
            }
        }];
    }];
    
    [self registerMethod:@"download" forAction:^(NSDictionary *parameters, void (^callback)(NSDictionary *parameters)) {
        NSString *filename = parameters[@"filename"];
        NSString *content = parameters[@"content"];
        
        NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        [content writeToFile:tempFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tempFile]];
        UIViewController *topViewController = [IDResponder topViewController];
        [self.documentInteractionController presentOptionsMenuFromRect:topViewController.view.bounds inView:topViewController.view animated:YES];
    }];
    
    [self registerMethod:@"upload" forAction:^(NSDictionary *parameters, void (^callback)(NSDictionary *parameters)) {
        self.documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.xiongdianpku.Spell-Tower.gamesave", @"com.xiongdianpku.Spell-Tower.gamerecord"] inMode:UIDocumentPickerModeImport];
        self.documentPicker.delegate = self;
        [[IDResponder topViewController] presentViewController:self.documentPicker animated:YES completion:nil];
        self.completionHandler = callback;
    }];
}

- (void)registerMethod:(NSString *)method forAction:(void (^)(NSDictionary *parameters, void (^callback)(NSDictionary *parameters)))action
{
    self.methods[method] = action;
}

- (BOOL)handleOpenURL:(NSURLRequest *)urlRequest
{
    NSURLComponents *comps = [NSURLComponents componentsWithURL:urlRequest.URL resolvingAgainstBaseURL:NO];
    if (![comps.scheme isEqualToString:@"bridge"]) {
        return NO;
    }
    
    NSDictionary *body = [NSJSONSerialization JSONObjectWithData:[[comps.path substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSString *method = body[kSTJSBridgeMethodKey];
    
    if (!self.methods[method]) {
        return NO;
    }
    
    void (^block)(NSDictionary *parameters, void (^callback)(NSDictionary *parameters)) = self.methods[method];
    block(body[kSTJSBridgeParametersKey], ^(NSDictionary *parameters) {
        NSString *parameter = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil] encoding:NSUTF8StringEncoding];
        parameter = [parameter stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        parameter = [parameter stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.callback(\"%@\")", parameter]];
        });
    });
    
    return YES;
}

#pragma mark -UIDocumentPickerDelegate
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self cleanDocumentPicker];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    NSString *content = [NSString stringWithContentsOfURL:urls.firstObject encoding:NSUTF8StringEncoding error:nil];
    self.completionHandler(@{@"success": @(YES),
                             @"content": content});
    [self cleanDocumentPicker];
}

- (void)cleanDocumentPicker
{
    self.documentPicker = nil;
    self.completionHandler = nil;
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller
{
    self.documentInteractionController = nil;
}

@end
