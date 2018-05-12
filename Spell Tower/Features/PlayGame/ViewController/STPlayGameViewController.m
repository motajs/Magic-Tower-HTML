//
//  STPlayGameViewController.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/24.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STPlayGameViewController.h"
#import "IDRouter.h"
#import "STGameModel.h"
#import <Masonry.h>
#import "ICUIUtils.h"
#import "STJSBridge.h"

@interface STPlayGameViewController()<IDRouterTransferrable, UIWebViewDelegate>

@property (nonatomic, strong) STGameModel *gameModel;
@property (nonatomic, strong) STJSBridge *jsBridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation STPlayGameViewController

+ (void)load
{
    [IDRouter registerViewControllerClass:self forURLPattern:@"tower://game"];
}

- (instancetype)initWithRouterParams:(NSDictionary<NSString *,id> *)params
{
    self = [super init];
    if (self) {
        self.gameModel = params[@"model"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.gameModel.titleName;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.gameModel.localRootURL URLByAppendingPathComponent:@"index.html"]]];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor blackColor];
        _webView.scrollView.scrollEnabled = NO;
        [_webView setMediaPlaybackRequiresUserAction:NO]; 
        _webView.delegate = self;
    }
    return _webView;
}

- (STJSBridge *)jsBridge
{
    if (!_jsBridge) {
        _jsBridge = [[STJSBridge alloc] initWithWebView:self.webView];
    }
    return _jsBridge;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *injectionJSPath = [[NSBundle mainBundle] pathForResource:@"injection" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:injectionJSPath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:jsContent];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ICUIUtils toast:@"打开游戏时发生错误"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.jsBridge handleOpenURL:request]) {
        return NO;
    }
    return YES;
}

@end
