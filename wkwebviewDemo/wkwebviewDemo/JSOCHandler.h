//
//  JSOCHandler.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/24.
//  Copyright © 2016年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol JSOCHandlerDelegate <NSObject>

@end

@interface JSOCHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<JSOCHandlerDelegate> delegate;
@property (nonatomic, weak) WKWebView *webView;

/**
 指定初始化方法
 
 @param delegate 代理
 @param vc 实现WebView的VC
 @return 返回自身实例
 */
- (instancetype)initWithDelegate:(id<JSOCHandlerDelegate>)delegate ViewController:(UIViewController *)vc;

@end
