//
//  JSOCHandler.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/24.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "JSOCHandler.h"

@interface JSOCHandler ()

@property (nonatomic, weak) UIViewController *ViewController;
@end

@implementation JSOCHandler
- (instancetype)initWithDelegate:(id<JSOCHandlerDelegate>)delegate ViewController:(UIViewController *)vc{
    if (self = [super init]) {
        self.delegate = delegate;
        self.ViewController = vc;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:message.body];
    NSLog(@"JS交互参数：%@", dic);
    
    if ([message.name isEqualToString:@"timefor"] && [dic isKindOfClass:[NSDictionary class]]) {
        
        NSLog(@"currentThread  ------   %@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"0001"]) {
                NSString *js = [NSString stringWithFormat:@"globalCallback(\'%@\')", @"该设备的deviceId: *****"];
                [self.webView evaluateJavaScript:js completionHandler:nil];
            } else {
                return;
            }
        });
    } else {
        return;
    }
}
@end
