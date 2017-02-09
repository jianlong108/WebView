//
//  DBManager.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Betcompany;

@interface DBManager : NSObject
/**
 *  创建对象(单例)
 *
 *  @return 实例
 */
+ (instancetype)defaultObject;

/**
 *  释放对象,同时会删除本地的数据库文件.谨慎使用
 */
+ (void)removeObjectFromCacheAndDisk;

- (void)requeryALLDatasBlcok:(void(^)(NSArray<Betcompany *> *array))block;

- (void)requeryDatasBlcok:(void(^)(NSArray<Betcompany *> *array))block WithOriPlate:(NSString *)oriPlate NowPlate:(NSString *)nowPlate;
@end
