//
//  ViewController_one.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "HomeViewController.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "JLTableView.h"
#import "GameObject.h"
#import "DataBaseCell.h"
#import "WebViewController.h"
#import "DBManager.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,JLTableViewDelegate,DataBaseCellDelegate>

/**数据库操作队列*/
@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

/**自顶向下插入的数据个数*/
@property (nonatomic, assign)NSInteger maxID;

/**自下向上插入的数据个数*/
@property (nonatomic, assign)NSInteger minID;

/**db*/
@property (nonatomic, weak)FMDatabase *db;

/**QUEUE*/
@property (nonatomic, strong)NSOperationQueue *queue;

/**数据库路径*/
@property (nonatomic, copy) NSString *dbPath;

/**<#说明#>*/
@property (nonatomic, strong) UITableView *MVP_GameView;


@end



@implementation HomeViewController


- (void)getAllData{
    __weak typeof(self) weakSelf = self;
    [[DBManager defaultObject] requeryALLDatasBlcok:^(NSArray<NSDictionary *> *array) {
        weakSelf.dataArray = array;
        weakSelf.MVP_GameView.hidden = NO;
        [weakSelf.MVP_GameView reloadData];
    }];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImg.image = [UIImage imageNamed:@"analysis_bg2"];
    [self.view addSubview:bgImg];
    
    UIButton *getDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getDataBtn setBackgroundImage:[UIImage imageNamed:@"Field"] forState:UIControlStateNormal];
    getDataBtn.frame = CGRectMake(0, 0, 300, 100);
    getDataBtn.center = self.view.center;
    [getDataBtn addTarget:self action:@selector(getAllData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getDataBtn];
    
    
    
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.MVP_GameView.hidden = NO;
}
- (UITableView *)MVP_GameView{
    if (_MVP_GameView == nil) {
        _MVP_GameView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-45) style:UITableViewStylePlain];
        _MVP_GameView.delegate = self;
        _MVP_GameView.dataSource = self;
        [_MVP_GameView registerNib:[UINib nibWithNibName:@"DataBaseCell" bundle:nil] forCellReuseIdentifier:@"database"];
        _MVP_GameView.rowHeight = 88;
        [self.view addSubview:_MVP_GameView];
    }
    return _MVP_GameView;
}
#pragma mark - tableview -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (DataBaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"database"];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (void)cell:(DataBaseCell *)cell ClickDetailBtn:(NSString *)str{
    WebViewController *web = [[WebViewController alloc]init];
    web.url = [NSURL URLWithString:str];
    [self.navigationController pushViewController:web animated:YES];
}
- (void)JLTableView:(JLTableView *)tableView SwitchFromIndex:(NSUInteger)fromeIndex ToIndex:(NSUInteger)toIndex{
    NSLog(@"FROM -- INDEX %ld  TO  INDEX  %ld",fromeIndex,toIndex);
}
@end
