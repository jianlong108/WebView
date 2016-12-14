//
//  GameObject.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/11.
//  Copyright © 2016年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Betcompany : NSObject
/**name*/
@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *oriTop;
@property (nonatomic, copy)NSString *oriHandi;
@property (nonatomic, copy)NSString *oridown;
@property (nonatomic, copy)NSString *nowTop;
@property (nonatomic, copy)NSString *nowHandi;
@property (nonatomic, copy)NSString *nowdown;

@end

@interface GameSubObject : NSObject
/**title*/
@property (nonatomic, copy)NSString *title;

/**href*/
@property (nonatomic, copy)NSString *href;

@end

@interface GameObject : NSObject

/**比赛名称*/
@property (nonatomic, strong)GameSubObject *gameName;

/**主队*/
@property (nonatomic, strong)GameSubObject *hometeam;
/**客队*/
@property (nonatomic, strong)GameSubObject *visitingteam;

/**亚盘*/
@property (nonatomic, strong)GameSubObject *plate;

/**欧赔*/
@property (nonatomic, strong)GameSubObject *oddset;

/**分析*/
@property (nonatomic, strong)GameSubObject *analysis;

/**情报*/
@property (nonatomic, strong)GameSubObject *intelligence;

/**betcompany*/
@property (nonatomic, strong)NSMutableArray *betCompanies;

/**可以*/
@property (nonatomic, assign)BOOL canBet;

@end
