//
//  ViewController.m
//  ZHECharts
//
//  Created by 曾浩 on 2017/7/31.
//  Copyright © 2017年 曾浩. All rights reserved.
//

#import "ViewController.h"
@import WebKit;

@interface ViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    [self.view addSubview:self.webView];
}

#pragma mark -- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        
    }
    
    // 调用JavaScript方法
    if (!self.webView.loading) {
        
        [self loadHtmlTestOne];
    }
}

- (void)loadHtmlTestOne
{
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"createChart2();"] completionHandler:^(id _Nullabled, NSError * _Nullable error) {
        NSLog(@"------ error: %@", error);
    }];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark -- 懒加载

- (WKWebView *)webView
{
    if (!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
        
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"echart/test" withExtension:@"html"];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:path]];
        
        
        // 导航代理
        _webView.navigationDelegate = self;
        // 与webview UI交互代理
        _webView.UIDelegate = self;
        
        // 添加KVO监听
        [_webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        [_webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        [_webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
