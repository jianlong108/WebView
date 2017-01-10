//
//  TabbarController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "TabbarController.h"
#import "GameParseViewController.h"
#import "ViewController_three.h"

#import "wkNavigationController.h"
#import "HomeViewController.h"
@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    GameParseViewController *two = [[GameParseViewController alloc]init];
    two.view.backgroundColor = [UIColor blueColor];
    wkNavigationController *nav = [[wkNavigationController alloc]initWithRootViewController:two];
    
    two.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"最新" image:[[UIImage imageNamed:@"shuju"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    [self addChildViewController:nav];
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.view.backgroundColor = [UIColor blueColor];
    wkNavigationController *homeNav = [[wkNavigationController alloc]initWithRootViewController:home];
    home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"数据" image:[[UIImage imageNamed:@"nav_cz"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    [self addChildViewController:homeNav];
    
    
    ViewController_three *user = [[ViewController_three alloc]init];
    wkNavigationController *nav1 = [[wkNavigationController alloc]initWithRootViewController:user];
    user.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人" image:[[UIImage imageNamed:@"nav_my"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    [self addChildViewController:nav1];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNeedsStatusBarAppearanceUpdate{
    [super setNeedsStatusBarAppearanceUpdate];
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
