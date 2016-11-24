//
//  ViewController_one.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "ViewController_one.h"
#import <WebKit/WebKit.h>

@interface ViewController_one ()
/**wkWebView*/
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation ViewController_one

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45) configuration:configuration];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //设置是否支持滑动返回
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [_webView loadRequest:quest];
    
   
    // 设置agent
    
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        
        // 给User-Agent添加额外的信息
        
        NSString *newUagent = [NSString stringWithFormat:@"%@ iphoneVerion/%@ nettype/%@", oldAgent, @"530", @"wifi"];
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUagent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
    }];
    if ([[UIDevice currentDevice].systemVersion doubleValue]>9.0f) {
        self.webView.customUserAgent = [NSString stringWithFormat:@"%@ iphoneVerion/%@ nettype/%@", @"第三方士大夫", @"630", @"4g"];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
