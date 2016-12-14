//
//  WebViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/11.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>

/**wkWebView*/
@property (nonatomic, strong)WKWebView *webView;

@property (nonatomic, assign) CGFloat delayTime;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    configuration.userContentController = [[WKUserContentController alloc] init];
    // 交互对象设置
    //    [configuration.userContentController addScriptMessageHandler:(id)self.handler name:@"timefor"];
    // 支持内嵌视频播放，不然网页中的视频无法播放
    configuration.allowsInlineMediaPlayback = YES;
    
    
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    //设置是否支持滑动返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
//    NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
    //WKWebView @/link is key-value observing (KVO) 头文件中,搜索关键字,即可得到可以kvo的属性
//    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
//    [_webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
    
    // 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
//    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];
    
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 2)];
    [self.view addSubview:_progressView];
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.trackTintColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
//        if (self.webView.estimatedProgress < 1.0) {
//            self.delayTime = 1 - self.webView.estimatedProgress;
//            return;
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.progressView.progress = 0;
//        });
//    } else if ([keyPath isEqualToString:@"title"]) {
//        self.title = @"选择合适的比赛,理性分析";
//    } else if ([keyPath isEqualToString:@"contentSize"]) {
//        
//        
//    }
//}

@end
