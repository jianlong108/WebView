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
/*
 
 
 #import <WebKit/WebKit.h>
 #import "TFHpple.h"
 #import "JSOCHandler.h"
 
@property (nonatomic, strong)WKWebView *webView;

@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UITableView *addView;

@property (nonatomic, strong) UIProgressView *progressView;


@property (nonatomic, strong)WKNavigation *mainWKNav;


@property (nonatomic, strong)JSOCHandler *handler;
 
 static CGFloat addViewHeight = 500;   // 添加自定义 View 的高度
 static BOOL showAddView = YES;        // 是否添加自定义 View
 static BOOL useEdgeInset = NO;        // 用那种方法添加自定义View， NO 使用
 - (JSOCHandler *)handler{
 if (_handler == nil) {
 _handler = [[JSOCHandler alloc] initWithDelegate:(id)self ViewController:self];
 }
 return _handler;
 }
 - (void)dealloc {
 [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
 [self.webView removeObserver:self forKeyPath:@"title"];
 [self.webView removeObserver:self forKeyPath:@"contentSize"];
 }
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
 
 configuration.userContentController = [[WKUserContentController alloc] init];
 // 交互对象设置
 [configuration.userContentController addScriptMessageHandler:(id)self.handler name:@"timefor"];
 // 支持内嵌视频播放，不然网页中的视频无法播放
 configuration.allowsInlineMediaPlayback = YES;
 
 
 _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 45 - 64) configuration:configuration];
 _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
 
 _webView.navigationDelegate = self;
 _webView.UIDelegate = self;
 
 //设置是否支持滑动返回
 _webView.allowsBackForwardNavigationGestures = YES;
 
 NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
 // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
 //WKWebView @/link is key-value observing (KVO) 头文件中,搜索关键字,即可得到可以kvo的属性
 [_webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
 [_webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
 
 // 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
 [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];
 
 [self.view addSubview:_webView];
 
 _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 2)];
 [self.view addSubview:_progressView];
 _progressView.progressTintColor = [UIColor greenColor];
 _progressView.trackTintColor = [UIColor clearColor];
 
 //estimatedProgress 网页加载的当前进度
 //    self.webView.estimatedProgress;
 }
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didFinishDownloadingToURL:(NSURL *)location{
 
 }
 - (void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
 NSURL *url = [NSURL URLWithString:@"http://www.310win.com/buy/jingcai.aspx?typeID=105&oddstype=2"];
 //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Study" withExtension:@"html"];
 NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 NSURLSessionDataTask* downloadtask =[session dataTaskWithRequest:request
 completionHandler:^(NSData * _Nullable data,
 NSURLResponse * _Nullable response,
 NSError * _Nullable error) {
 //                   NSLog(@"%@",response);
 //                   NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
 
 //                   TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
 //                   NSArray * elements  = [doc searchWithXPathQuery:@"//tr[@class='ni']"];
 //
 //                   TFHppleElement * element = [elements objectAtIndex:0];
 //                   [element text];                       // The text inside the HTML element (the content of the first text node)
 //                   [element tagName];                    // "a"
 //                   [element attributes];                 // NSDictionary of href, class, id, etc.
 //                   [element objectForKey:@"href"];       // Easy access to single attribute
 //                   [element firstChildWithTagName:@"b"]; // The first "b" child node
 
 }];
 [downloadtask resume];
 
 
 [_webView loadRequest:request];
 
 
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
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
 if ([keyPath isEqualToString:@"estimatedProgress"]) {
 [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
 if (self.webView.estimatedProgress < 1.0) {
 self.delayTime = 1 - self.webView.estimatedProgress;
 return;
 }
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 self.progressView.progress = 0;
 });
 } else if ([keyPath isEqualToString:@"title"]) {
 self.title = self.webView.title;
 } else if ([keyPath isEqualToString:@"contentSize"]) {
 if (self.contentHeight != self.webView.scrollView.contentSize.height) {
 self.contentHeight = self.webView.scrollView.contentSize.height;
 self.addView.frame = CGRectMake(0, self.contentHeight - addViewHeight, self.view.bounds.size.width, addViewHeight);
 NSLog(@"----------%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
 }
 }
 }
 #pragma mark - WKNavigationDelegate
 
 // 开始加载时调用
 - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
 if ([webView.URL.absoluteString isEqualToString:@"http://www.mm131.com/qingchun/2723.html"]) {
 _mainWKNav = navigation;
 }
 NSLog(@"didStartProvisionalNavigation   ====    %@", navigation);
 }
 
 // 页面加载完调用
 - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
 NSLog(@"didFinishNavigation   ====    %@", navigation);
 
 if (!showAddView) return;
 if (_mainWKNav == navigation) {
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
 self.addView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.webView.scrollView.contentSize.height, self.view.bounds.size.width, addViewHeight)style:UITableViewStylePlain];
 self.addView.delegate = self;
 self.addView.dataSource = self;
 
 [self.webView.scrollView addSubview:self.addView];
 
 if (useEdgeInset) {
 // url 使用 test.html 对比更明显
 self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, addViewHeight, 0);
 } else {
 NSString *js = [NSString stringWithFormat:@"\
 var appendDiv = document.getElementById(\"AppAppendDIV\");\
 if (appendDiv) {\
 appendDiv.style.height = %@+\"px\";\
 } else {\
 var appendDiv = document.createElement(\"div\");\
 appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
 appendDiv.style.width=%@+\"px\";\
 appendDiv.style.height=%@+\"px\";\
 document.body.appendChild(appendDiv);\
 }\
 ", @(addViewHeight), @(self.webView.scrollView.contentSize.width), @(addViewHeight)];
 [self.webView evaluateJavaScript:js completionHandler:nil];
 }
 });
 }
 
 }
 
 // 页面加载失败时调用
 - (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
 NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
 }
 
 // 内容开始返回时调用
 - (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
 NSLog(@"didCommitNavigation   ====    %@", navigation);
 }
 
 // 在发送请求之前，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
 NSLog(@"decidePolicyForNavigationAction   ====    %@", navigationAction);
 decisionHandler(WKNavigationActionPolicyAllow);
 }
 
 // 在收到响应后，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
 NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
 decisionHandler(WKNavigationResponsePolicyAllow);
 }
 
 // 加载HTTPS的链接，需要权限认证时调用
 - (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
 if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
 if ([challenge previousFailureCount] == 0) {
 NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
 completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
 } else {
 completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
 }
 } else {
 completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
 }
 }
 
 #pragma mark - WKUIDelegate
 
 // 提示框
 - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
 completionHandler();
 }]];
 [self presentViewController:alert animated:YES completion:NULL];
 }
 
 // 确认框
 - (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 completionHandler(YES);
 }]];
 [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 completionHandler(NO);
 }]];
 [self presentViewController:alert animated:YES completion:NULL];
 }
 
 // 输入框
 - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
 
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
 [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
 textField.textColor = [UIColor blackColor];
 textField.placeholder = defaultText;
 }];
 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 completionHandler([[alert.textFields lastObject] text]);
 }]];
 [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 completionHandler(nil);
 }]];
 [self presentViewController:alert animated:YES completion:NULL];
 }
 #pragma mark tableView
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 return 2;
 }
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return 5;
 }
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
 if (cell == nil) {
 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
 }
 cell.textLabel.text = @"这个做的不错";
 return cell;
 }

 */

@end
