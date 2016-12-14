//
//  ViewController_two.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/11/23.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "GameParseViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "HomeViewController.h"
#import "GameParseViewCell.h"
#import "WebViewController.h"
#import "GameObject.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface GameParseViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,GameParseViewCellDelegate>


@property (nonatomic, strong) UITableView *MVP_GameView;

/**所有比赛*/
@property (nonatomic, strong)NSMutableArray<TFHppleElement *> *allGames;
/**业务数组*/
@property (nonatomic, strong)NSMutableArray *gameModeles;

/**session*/
@property (nonatomic, strong)NSURLSession *session;

@end

@implementation GameParseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"观看" style:UIBarButtonItemStylePlain target:self action:@selector(beginParse)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.MVP_GameView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.MVP_GameView.delegate = self;
    self.MVP_GameView.dataSource = self;
    [self.MVP_GameView registerNib:[UINib nibWithNibName:@"GameParseViewCell" bundle:nil] forCellReuseIdentifier:@"mvp"];
    
    [self.view addSubview:self.MVP_GameView];

    
    NSURL *url = [NSURL URLWithString:@"http://www.310win.com/buy/jingcai.aspx?typeID=105&oddstype=2"];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Study" withExtension:@"html"];
    _session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask* downloadtask =
    [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response,NSError * _Nullable error)
     {
         
         TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
         NSArray * elements_ni  = [doc searchWithXPathQuery:@"//tr[@class='ni']"];
         [self.allGames addObjectsFromArray:elements_ni];
         
         NSArray * elements_ni2  = [doc searchWithXPathQuery:@"//tr[@class='ni2']"];
         [self.allGames addObjectsFromArray:elements_ni2];
         
         [self beginParse];
         
         
     }];
    [downloadtask resume];
    
}
- (void)beginParse{
    for (TFHppleElement *element in self.allGames)
        {
            GameObject *game = [[GameObject alloc]init];
            
            int i = 0;
            NSArray *array = [element childrenWithTagName:@"td"];
            for (TFHppleElement *subEle in array)
            {
                if ([subEle hasChildren])
                {
                    
                    NSArray *array = [subEle children];
                    if (array.count == 5)
                    {
                        
                        for (TFHppleElement *subsubEle in array)
                        {
                            if (![subsubEle.text isEqualToString:@""] && subsubEle.text != nil && [subsubEle objectForKey:@"href"])
                            {
                                GameSubObject *object = [[GameSubObject alloc]init];
                                object.title = subsubEle.text;
                                object.href = [[[subEle childrenWithTagName:@"a"] firstObject] objectForKey:@"href"];
                                switch (i) {
                                    case 0:
                                        game.hometeam = object;
                                        break;
                                    case 1:
                                        game.visitingteam = object;
                                        break;
                                    case 2:
                                        game.plate = object;
                                        break;
                                    case 3:
                                        game.oddset = object;
                                        break;
                                    case 4:
                                        game.analysis = object;
                                        break;
                                    case 5:
                                        game.intelligence = object;
                                        break;
                                    default:
                                        break;
                                }
                                i++;
                            }
                        }
                        
                    }else{
                        for (TFHppleElement *subsubEle in array) {
                            if (![subsubEle.text isEqualToString:@""] && subsubEle.text != nil) {
                                if ([[[subEle childrenWithTagName:@"a"] firstObject] objectForKey:@"href"]) {
                                    GameSubObject *object = [[GameSubObject alloc]init];
                                    object.title = subsubEle.text;
                                    object.href = [[[subEle childrenWithTagName:@"a"] firstObject] objectForKey:@"href"];
                                    game.gameName = object;
//                                    NSLog(@"+++%@ %@",subsubEle.text,[[[subEle childrenWithTagName:@"a"] firstObject] objectForKey:@"href"]);
                                }
                            }
                        }
                    }
                }
            }
            [self.gameModeles addObject:game];
            
        }
    
    [self.MVP_GameView reloadData];
    
    [self beginAnalysis];
}
- (void)beginAnalysis{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (GameObject *object in self.gameModeles) {
            NSString *urlStr = [NSMutableString stringWithFormat:@"http://www.310win.com%@",object.plate.href];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSessionDataTask* downloadtask =
            [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response,NSError * _Nullable error)
             {
                 
                 TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
                 NSArray * elements_ni  = [doc searchWithXPathQuery:@"//tr[@class='ni']"];
                 for (TFHppleElement *ele in elements_ni) {
                     Betcompany *company = [[Betcompany alloc]init];
                     int i = 0;
                     for (TFHppleElement *subele in ele.children) {
                         if (subele.text.length > 1) {
//                             NSLog(@"+++%@",subele.text);
                             switch (i) {
                                 case 0:
                                     company.name = subele.text;
                                     break;
                                 case 1:
                                     company.oriTop = subele.text;
                                     break;
                                 case 2:
                                     company.oriHandi = subele.text;
                                     break;
                                 case 3:
                                     company.oridown = subele.text;
                                     break;
                                 case 4:
                                     company.nowTop = subele.text;
                                     break;
                                 case 5:
                                     company.nowHandi = subele.text;
                                     break;
                                 case 6:
                                     company.nowdown = subele.text;
                                     break;
                                 default:
                                     break;
                             }
                             i++;
                             
                         }
                         
                     }
                     [object.betCompanies addObject:company];
                 }
                 
                 NSArray * elements_ni2  = [doc searchWithXPathQuery:@"//tr[@class='ni2']"];
                 for (TFHppleElement *ele in elements_ni2) {
                     Betcompany *company = [[Betcompany alloc]init];
                     int i = 0;
                     for (TFHppleElement *subele in ele.children) {
                         
                         if (subele.text.length > 1) {
//                             NSLog(@"---%@",subele.text);
                             switch (i) {
                                 case 0:
                                     company.name = subele.text;
                                     break;
                                 case 1:
                                     company.oriTop = subele.text;
                                     break;
                                 case 2:
                                     company.oriHandi = subele.text;
                                     break;
                                 case 3:
                                     company.oridown = subele.text;
                                     break;
                                 case 4:
                                     company.nowTop = subele.text;
                                     break;
                                 case 5:
                                     company.nowHandi = subele.text;
                                     break;
                                 case 6:
                                     company.nowdown = subele.text;
                                     break;
                                 default:
                                     break;
                             }
                             i++;
                         }
                     }
                     [object.betCompanies addObject:company];
                 }
//                 int i = 0;
                 for (Betcompany *company in object.betCompanies) {
//                     if (company.nowTop.floatValue > 1.0 || company.nowdown.floatValue > 1.0) {
//                         object.canBet = YES;
//                     }
                     if ([company.name isEqualToString:@"澳彩"]) {
                         if(![company.nowHandi isEqualToString:company.oriHandi])
                             object.canBet = YES;
                     }
                 }
//                 if (i>4) {
//                     object.canBet = YES;
//                 }else if (){
//                     
//                 }
                 if ([object isEqual:[self.gameModeles lastObject]]) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.MVP_GameView reloadData];
                     });
                 }
             }];
            [downloadtask resume];
        }
    });
}

- (NSMutableArray *)allGames{
    if (_allGames == nil) {
        _allGames = [NSMutableArray array];
    }
    return _allGames;
}
- (NSMutableArray *)gameModeles{
    if (_gameModeles == nil) {
        _gameModeles = [NSMutableArray array];
    }
    return _gameModeles;
}




#pragma mark - tableview -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameModeles.count;
}
- (GameParseViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GameParseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mvp"];
    cell.delegate = self;
    GameObject *game = self.gameModeles[indexPath.row];
    
    cell.model = game;
    return cell;
}
- (void)cell:(GameParseViewCell *)cell ClickBtn:(NSString *)str{
    WebViewController *web = [[WebViewController alloc]init];
    web.url = [NSURL URLWithString:str];
    
    [self.navigationController pushViewController:web animated:YES];
}

@end
