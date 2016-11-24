//
//  ViewController_two.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "ViewController_two.h"

#import "ViewController_one.h"

@interface ViewController_two ()

@end

@implementation ViewController_two

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 300, 100)];
    [btn setTitle:@"进入webview" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(entryWebview) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}
- (void)entryWebview
{
    ViewController_one *one = [[ViewController_one alloc]init];
//    [self.navigationController pushViewController:one animated:YES];
    [self presentViewController:one animated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
