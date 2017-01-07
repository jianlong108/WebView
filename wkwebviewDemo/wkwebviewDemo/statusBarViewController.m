//
//  statusBarViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "statusBarViewController.h"

@interface statusBarViewController ()

@end

@implementation statusBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"%@",NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
