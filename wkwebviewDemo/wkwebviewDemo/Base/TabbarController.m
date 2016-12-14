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
    
    GameParseViewController *two = [[GameParseViewController alloc]init];
    two.view.backgroundColor = [UIColor blueColor];
    wkNavigationController *nav = [[wkNavigationController alloc]initWithRootViewController:two];
    [self addChildViewController:nav];
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.view.backgroundColor = [UIColor blueColor];
    wkNavigationController *homeNav = [[wkNavigationController alloc]initWithRootViewController:home];
    [self addChildViewController:homeNav];
    
    ViewController_three *three = [[ViewController_three alloc]init];
    wkNavigationController *nav1 = [[wkNavigationController alloc]initWithRootViewController:three];
    [self addChildViewController:nav1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
