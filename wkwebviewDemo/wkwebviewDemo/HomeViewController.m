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

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,JLTableViewDelegate>

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

/**所有的护具*/
@property (nonatomic, strong) NSArray*dataArray;

@end



@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initialize];
    
    [self getAllData];
    
    self.MVP_GameView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.MVP_GameView.delegate = self;
    self.MVP_GameView.dataSource = self;
    
    self.MVP_GameView.rowHeight = 88;
    self.MVP_GameView.hidden = YES;
    [self.view addSubview:self.MVP_GameView];
}
- (void)getAllData{
    __weak typeof(self) weakSelf = self;
    [self requeryALLDatasBlcok:^(NSArray<NSDictionary *> *array) {
        weakSelf.dataArray = array;
        weakSelf.MVP_GameView.hidden = NO;
        [weakSelf.MVP_GameView reloadData];
    }];
}
- (void)initialize{
    if (_dbQueue == nil) {
//        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"Soccer.db"];
        NSString *dbFilePath = [[NSBundle mainBundle] pathForResource:@"Soccer" ofType:@"db"];
        self.dbPath = dbFilePath;
        //        NSLog(@"数据库路径--%@",dbPath);
        _dbQueue = [[FMDatabaseQueue alloc]initWithPath:dbFilePath];
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS \"Soccer\" (\"soccer_ID\" integer NOT NULL,\"league\" text NOT NULL,\"soccer\" text NOT NULL,\"gameurl\" text NOT NULL,\"otodds\" text NOT NULL,\"orignalpan\" text NOT NULL,\"ododds\" text NOT NULL,\"ntodds\" text NOT NULL,\"nowpan\" text NOT NULL,\"ndodds\" text NOT NULL)"];
        if (success) {
                        NSLog(@"创建数据库成功");
            self.db = db;
            //            [self getMinIDOfDatas];
            //            [self getMaxIDOfDatas];
        }else {
                        NSLog(@"创建数据库失败");
        }
    }];
}
- (NSUInteger)getCountOfDatas{
    NSUInteger count = 0;
    
    FMResultSet *s = [self.db executeQuery:@"SELECT count(*) FROM Soccer"];
    
    while ([s next]) {
        NSDictionary *a = [s resultDict];
        count = [a[@"count(*)"] integerValue];
        //        NSLog(@"当前表中的总数为%tu",count);
    }
    return count;
    
}
- (void)requeryDataWithRange:(NSRange)range DatasBlcok:(void(^)(NSArray<NSDictionary *> *array))block{
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if ((NSInteger)location<0 || (NSInteger)length <0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            FMResultSet *s = [db executeQuery:@"select * from Soccer  order by ah_index  limit ?,?",[NSNumber numberWithUnsignedInteger:range.location],[NSNumber numberWithUnsignedInteger:range.length]];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:length];
            while ([s next]) {
                NSMutableDictionary *dic_m = [NSMutableDictionary dictionaryWithCapacity:2];
                NSString *aid = [s stringForColumn:@"data_id"];
                NSString *ajson = [s stringForColumn:@"data_text"];
                if (aid!=nil && ![aid isEqual:[NSNull null]] && ajson!=nil && ![ajson isEqual:[NSNull null]]) {
                    [dic_m setValue:ajson forKey:aid];
                    [arr addObject:dic_m];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(arr);
                }
            });
            
        }];
    });
}
- (BOOL)deleteDataWithDataId:(NSInteger)soccer_ID{
    BOOL success = [self.db executeUpdate:@"delete FROM Soccer where soccer_ID = ?",[NSNumber numberWithInteger:soccer_ID]];
    if (success) {
        [self getMaxIDOfDatas];
        [self getMinIDOfDatas];
    }
    //    NSLog(@"删除data_id%tu数据%d",dataID,success);
    
    return success;
}
- (BOOL)deleteAllDatas{
    BOOL success = [self.db executeUpdate:@"delete FROM Soccer"];
    if (success) {
        self.maxID = 0;
        self.minID = 0;
    }
    //    NSLog(@"删除所有数据-%d",success);
    
    return success;
}
- (NSUInteger)getCountOfDataID:(NSInteger)soccer_ID{
    
    NSUInteger count = 0;
    FMResultSet *s = [self.db executeQuery:@"SELECT count(*) FROM Soccer where soccer_ID = ?",[NSNumber numberWithInteger:soccer_ID]];
    
    while ([s next]) {
        NSDictionary *a = [s resultDict];
        count = [a[@"count(*)"] integerValue];
        //        NSLog(@"当前表中data_id %ld 的总数为%tu",(long)data_id,count);
    }
    return count;
    
}
#pragma mark - private -
//SELECT article_id FROM ArticleRecommendTable where rownum = 0 order by article_id desc
- (void)getMaxIDOfDatas{
    
    FMResultSet *s = [self.db executeQuery:@"SELECT max(soccer_ID) FROM Soccer"];
    
    while ([s next]) {
        
        NSDictionary *a = [s resultDict];
        if (![a[@"max(ah_index)"] isEqual:[NSNull null]]) {
            NSInteger tempminCount = [a[@"max(ah_index)"] integerValue];
            //            NSLog(@"当前最大的index%ld",(long)tempminCount);
            self.maxID = tempminCount;
        }
        
    }
}

- (void)getMinIDOfDatas{
    
    FMResultSet *s = [self.db executeQuery:@"SELECT min(soccer_ID) FROM Soccer"];
    
    while ([s next]) {
        //        NSLog(@"%@",[NSThread currentThread]);
        NSDictionary *a = [s resultDict];
        if (![a[@"min(ah_index)"] isEqual:[NSNull null]]) {
            NSInteger tempminCount = [a[@"min(ah_index)"] integerValue];
            //            NSLog(@"当前最小的index%ld",(long)tempminCount);
            self.minID = tempminCount;
        }
        
    }
}
- (NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.name = @"推荐队列";
    }
    return _queue;
}


- (void)requeryALLDatasBlcok:(void(^)(NSArray<NSDictionary *> *array))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            
            FMResultSet *s = [db executeQuery:@"select * from Soccer"];
            NSMutableArray *arr = [NSMutableArray array];
            while ([s next]) {
                NSMutableDictionary *dic_m = [NSMutableDictionary dictionaryWithCapacity:2];
                NSString *soccer_ID = [s stringForColumn:@"soccer_ID"];
                NSString *league = [s stringForColumn:@"league"];
                NSString *gameurl = [s stringForColumn:@"gameurl"];
                NSString *soccer = [s stringForColumn:@"soccer"];
                if (soccer_ID!=nil && ![soccer_ID isEqual:[NSNull null]] && league!=nil && ![league isEqual:[NSNull null]]) {
                    [dic_m setObject:league forKey:@"league"];
                    [dic_m setObject:soccer_ID forKey:@"soccer_ID"];
                    [dic_m setObject:gameurl forKey:@"gameurl"];
                    [dic_m setObject:soccer forKey:@"soccer"];
                    [arr addObject:dic_m];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(arr);
                }
            });
            
        }];
    });
}

#pragma mark - tableview -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataBase"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dataBase"];
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = dic[@"league"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
@end
