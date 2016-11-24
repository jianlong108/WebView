//
//  TabbarController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "TabbarController.h"
#import "ViewController_two.h"
#import "ViewController_three.h"

@interface TabbarController ()

@end

@implementation TabbarController
//- (instancetype)init{
////    [super init];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ViewController_two *two = [[ViewController_two alloc]init];
    two.view.backgroundColor = [UIColor blueColor];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:two];
    [self addChildViewController:nav];
    
    ViewController_three *three = [[ViewController_three alloc]init];
    three.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:three];
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
