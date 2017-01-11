//
//  GameObject.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/11.
//  Copyright © 2016年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Betcompany : NSObject

/**联赛*/
@property (nonatomic, copy)NSString *league;

/**比分*/
@property (nonatomic, copy)NSString *soccer;

/**比分*/
@property (nonatomic, copy)NSString *gameurl;

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

/**澳彩 初上*/
@property (nonatomic, copy)NSString *ori_Top;

/**澳彩 初盘*/
@property (nonatomic, copy)NSString *ori_Plate;

/**澳彩 初下*/
@property (nonatomic, copy)NSString *ori_Bottom;

/**澳彩 now上*/
@property (nonatomic, copy)NSString *now_Top;

/**澳彩 now盘*/
@property (nonatomic, copy)NSString *now_Plate;

/**澳彩 now下*/
@property (nonatomic, copy)NSString *now_Bottom;

/**可以*/
@property (nonatomic, assign)BOOL canBet;

@end
