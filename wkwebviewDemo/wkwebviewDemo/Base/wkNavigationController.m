//
//  wkNavigationController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/7.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "wkNavigationController.h"

@interface wkNavigationController ()
@end

@implementation wkNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%@",viewController);
    [super pushViewController:viewController animated:animated];
}
- (void)setNeedsStatusBarAppearanceUpdate{
    [super setNeedsStatusBarAppearanceUpdate];
}
@end
