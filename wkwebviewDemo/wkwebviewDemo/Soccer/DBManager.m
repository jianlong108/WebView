//
//  DBManager.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "GameObject.h"

@interface DBManager ()
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

@end

@implementation DBManager

static DBManager *obj;
+ (instancetype)defaultObject{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[DBManager alloc]init];
    });
    return obj;
}
+ (void)removeObjectFromCacheAndDisk{
    
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[obj dbPath] error:nil];
    if (success) {
        //        NSLog(@"删除本地数据库文件成功");
        obj = nil;
    }
    
}
- (instancetype)init{
    if (obj != nil) {
        return obj;
    }
    
    if (self = [super init]) {
        obj = self;
        [self initialize];
        
    }
    return self;
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
- (NSOperationQueue *)queue{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.name = @"推荐队列";
    }
    return _queue;
}
- (BOOL)deleteDataWithDataId:(NSInteger)soccer_ID{
    BOOL success = [self.db executeUpdate:@"delete FROM Soccer where soccer_ID = ?",[NSNumber numberWithInteger:soccer_ID]];
    if (success) {
//        [self getMaxIDOfDatas];
//        [self getMinIDOfDatas];
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
- (void)requeryDatasBlcok:(void(^)(NSArray<Betcompany *> *array))block WithOriPlate:(NSString *)oriPlate NowPlate:(NSString *)nowPlate{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            FMResultSet *s = [db executeQuery:@"select * from Soccer where (orignalpan == ? and nowpan == ?)",oriPlate,nowPlate];
            NSMutableArray *arr = [NSMutableArray array];
            while ([s next]) {
                Betcompany *company = [[Betcompany alloc]init];
                NSString *league = [s stringForColumn:@"league"];
                NSString *gameurl = [s stringForColumn:@"gameurl"];
                NSString *soccer = [s stringForColumn:@"soccer"];
                NSString *soccer_ID = [s stringForColumn:@"soccer_ID"];
                NSString *otodds = [s stringForColumn:@"otodds"];
                NSString *orignalpan = [s stringForColumn:@"orignalpan"];
                NSString *ododds = [s stringForColumn:@"ododds"];
                NSString *ntodds = [s stringForColumn:@"ntodds"];
                NSString *nowpan = [s stringForColumn:@"nowpan"];
                NSString *ndodds = [s stringForColumn:@"ndodds"];
                if (soccer_ID!=nil && ![soccer_ID isEqual:[NSNull null]] && league!=nil && ![league isEqual:[NSNull null]]) {
                    company.league = league;
                    company.soccer = soccer;
                    company.gameurl = gameurl;
                    company.oriTop = otodds;
                    company.oriHandi = orignalpan;
                    company.oridown = ododds;
                    company.nowTop = ntodds;
                    company.nowHandi = nowpan;
                    company.nowdown = ndodds;
                    [arr addObject:company];
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
- (void)requeryALLDatasBlcok:(void(^)(NSArray<Betcompany *> *array))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            FMResultSet *s = [db executeQuery:@"select * from Soccer"];
            NSMutableArray *arr = [NSMutableArray array];
            while ([s next]) {
                Betcompany *company = [[Betcompany alloc]init];
                NSString *league = [s stringForColumn:@"league"];
                NSString *gameurl = [s stringForColumn:@"gameurl"];
                NSString *soccer = [s stringForColumn:@"soccer"];
                NSString *soccer_ID = [s stringForColumn:@"soccer_ID"];
                NSString *otodds = [s stringForColumn:@"otodds"];
                NSString *orignalpan = [s stringForColumn:@"orignalpan"];
                NSString *ododds = [s stringForColumn:@"ododds"];
                NSString *ntodds = [s stringForColumn:@"ntodds"];
                NSString *nowpan = [s stringForColumn:@"nowpan"];
                NSString *ndodds = [s stringForColumn:@"ndodds"];
                if (soccer_ID!=nil && ![soccer_ID isEqual:[NSNull null]] && league!=nil && ![league isEqual:[NSNull null]]) {
                    company.league = league;
                    company.soccer = soccer;
                    company.gameurl = gameurl;
                    company.oriTop = otodds;
                    company.oriHandi = orignalpan;
                    company.oridown = ododds;
                    company.nowTop = ntodds;
                    company.nowHandi = nowpan;
                    company.nowdown = ndodds;
                    [arr addObject:company];
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
@end
