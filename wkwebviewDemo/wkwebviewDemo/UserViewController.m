//
//  UserViewController.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "UserViewController.h"
#import "JLBothSidesBtn.h"

@interface UserViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**双面button*/
@property (nonatomic, strong)JLBothSidesBtn *bothSidesView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bothSidesView  =[[JLBothSidesBtn alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_bothSidesView];
    _bothSidesView.autoTransition = NO;
    
    UITextField *filed = [[UITextField alloc]initWithFrame:CGRectMake(100, 220, 100, 100)];
    filed.backgroundColor = [UIColor lightGrayColor];
    filed.placeholder = @"请输入...";
    [self.view addSubview:filed];
    
    // Do any additional setup after loading the view.
    
    [_bothSidesView.positiveBtn addTarget:self action:@selector(dbtn1) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_bothSidesView.oppositeBtn addTarget:self action:@selector(dbtn2) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)dbtn1{
    NSLog(@"positiveBtn");
    UIImagePickerController *piceker = [[UIImagePickerController alloc]init];
    piceker.sourceType = UIImagePickerControllerSourceTypeCamera;
    piceker.allowsEditing = YES;
    piceker.navigationBarHidden = NO;
    piceker.toolbarHidden = YES;
//    piceker.view.window.windowLevel = UIWindowLevelStatusBar +1;
    piceker.delegate = self;
//    piceker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    piceker.modalPresentationStyle= UIModalPresentationFullScreen;
        piceker.modalPresentationCapturesStatusBarAppearance = YES;
//    piceker.extendedLayoutIncludesOpaqueBars = YES;
    piceker.automaticallyAdjustsScrollViewInsets= NO;
        piceker.edgesForExtendedLayout = UIRectEdgeNone;
//    piceker.definesPresentationContext = YES;
    //    piceker.extendedLayoutIncludesOpaqueBars = NO;
    //    piceker.modalPresentationCapturesStatusBarAppearance = NO;
    [self presentViewController:piceker animated:YES completion:^{}];
    
}
-(void)dbtn2{
    NSLog(@"oppositeBtn");
    UIViewController *vc =[[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)dbtn3{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_bothSidesView transitionView];
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
