//
//  ViewController_three.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "ViewController_three.h"
#import "statusBarViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController_three ()<UIScrollViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate>
/**location*/
@property (nonatomic, strong)CLLocationManager *locationManager;
/***/
@property (nonatomic, weak)UIScrollView *scrollview;
@end

@implementation ViewController_three

- (void)loadView{
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    scrollview.delegate = self;
    
    _scrollview =scrollview;
    self.view = scrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollview.contentSize = CGSizeMake(320, 20000);
    self.view.backgroundColor = [UIColor orangeColor];
    
//    _locationManager = [[CLLocationManager alloc]init];
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    //    if ([[AppContext systemVersion] floatValue] >= 8) {
//    [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
//    //    }
//    [_locationManager startUpdatingLocation];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)next{
    statusBarViewController *ipc = [[statusBarViewController alloc]init];
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.view.frame = [UIScreen mainScreen].bounds;
//    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
//    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    NSLog(@"%@",NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
}
/**
 设置当前界面显示电池条的样式.

 @return 电池条样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (_scrollview.contentOffset.y < 100 && _scrollview.contentOffset.y > 50) {
        return UIStatusBarStyleDefault;
    }else {
        return UIStatusBarStyleLightContent;
    }
    
}
/**
 如果当前界面不显示电池条,重写此方法.并返回YES.否则忽视此方法

 @return 是否显示电池条,默认显示.
 */
- (BOOL)prefersStatusBarHidden{
    return YES;
}

/**
 如果在某个条件满足时,需要变换当前电池条的样式,调用[self setNeedsStatusBarAppearanceUpdate];
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 100 && scrollView.contentOffset.y > 50) {
        //满足条件时,需要调用此方法,主动刷新电池条样式.此时application会再次调用- (UIStatusBarStyle)preferredStatusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"%@",[NSThread currentThread]);
}
@end
