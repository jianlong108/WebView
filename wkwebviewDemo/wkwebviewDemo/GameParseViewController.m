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
    
   
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(beginAnalysis) forControlEvents:UIControlEventTouchUpInside];
    btn.frame =CGRectMake(0, 0, 88, 44);
    btn.hidden = YES;
    [btn setTitle:@"开始分析" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"观看" style:UIBarButtonItemStylePlain target:self action:@selector(lookWeb)];
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
         NSArray * elements_ni  = [doc searchWithXPathQuery:@"//tr[@class]"];
         for (TFHppleElement *element in elements_ni) {
             NSLog(@"%@ %ld",[element objectForKey:@"class"],element.children.count);
             if ([[element objectForKey:@"class"]isEqualToString:@"ni"]||[[element objectForKey:@"class"]isEqualToString:@"ni2"]) {
                 if (element.children.count >20) {
                     [self.allGames addObject:element];
                 }
                 
             }
             
         }
         
         
         
         [self beginParse];
         
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self.MVP_GameView reloadData];
             self.navigationItem.leftBarButtonItem.customView.hidden = NO;
         });
         
         
     }];
    [downloadtask resume];
    
}
- (void)lookWeb{
    WebViewController *web = [[WebViewController alloc]init];
    web.url = [NSURL URLWithString:@"http://www.310win.com/buy/jingcai.aspx?typeID=105&oddstype=2"];
    
    [self.navigationController pushViewController:web animated:YES];
}
- (void)beginParse{
    for (TFHppleElement *element in self.allGames)
        {
            GameObject *game = [[GameObject alloc]init];
            
            int i = 0;
            NSArray *array = [element childrenWithTagName:@"td"];
            for (TFHppleElement *subEle in array)
            {
                NSArray *array = [subEle children];
                TFHppleElement *lastEle = subEle.children.lastObject;
                if (subEle.children.count == 5 && [subEle.firstChild.tagName isEqualToString:@"a"] && [lastEle.tagName isEqualToString:@"a"])
                {//亚欧析情
                    
                    for (TFHppleElement *subsubEle in array)
                    {
                        if (subsubEle.text != nil)
                        {
                            GameSubObject *object = [[GameSubObject alloc]init];
                            object.title = subsubEle.text;
                            object.href = [NSString stringWithFormat:@"%@%@",@"http://www.310win.com",[subsubEle objectForKey:@"href"]];
                            NSLog(@"111%@",object.title);
                            switch (i) {
                                case 3:
                                    game.plate = object;
                                    break;
                                case 4:
                                    game.oddset = object;
                                    break;
                                case 5:
                                    game.analysis = object;
                                    break;
                                case 6:
                                    game.intelligence = object;
                                    break;
                                default:
                                    break;
                            }
                            i++;
                        }
                    }
                    
                }
                else
                {
                    for (TFHppleElement *subsubEle in array)
                    {
                        if ([subsubEle.tagName isEqualToString:@"a"])
                        {
                            if (subsubEle.text != nil)
                            {
                                GameSubObject *object = [[GameSubObject alloc]init];
                                object.title = subsubEle.text;
                                if ([[subsubEle objectForKey:@"href"] containsString:@"http"]) {
                                    object.href = [subsubEle objectForKey:@"href"];
                                }else{
                                    object.href = [NSString stringWithFormat:@"%@%@",@"http://www.310win.com",[subsubEle objectForKey:@"href"]];
                                }
//                                NSLog(@"222%@",object.title);
                                switch (i) {
                                    case 0:
                                        game.gameName = object;
                                        break;
                                    case 1:
                                        game.hometeam = object;
                                        break;
                                    case 2:
                                        game.visitingteam = object;
                                        break;
                                    default:
                                        break;
                                }
                                i++;
                            }
                        }
                    }
                }
                
            }
            [self.gameModeles addObject:game];
            
        }
    
    
    
    
}
- (void)beginAnalysis{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        for (GameObject *object in self.gameModeles) {
            NSString *urlStr = object.plate.href;
//            NSLog(@"%@",urlStr);
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSessionDataTask* downloadtask =
            [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,NSURLResponse * _Nullable response,NSError * _Nullable error)
             {
                 
                 TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
                 
                 NSArray *array = [doc searchWithXPathQuery:@"//span[@id='odds']"];
                 TFHppleElement *span = array.firstObject;
                 TFHppleElement *table = span.firstChild;
                 NSArray * elements_ni  = [table searchWithXPathQuery:@"//tr[@class='ni']"];
                 for (TFHppleElement *ele in elements_ni) {
                     Betcompany *company = [[Betcompany alloc]init];
                     int i = 0;
                     for (TFHppleElement *subele in ele.children) {
                         if (subele.text.length > 1) {
                             NSMutableString *tempStr = [NSMutableString stringWithString:subele.text];
                             [tempStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tempStr.length)];

                             switch (i) {
                                 case 0:
                                     company.name = tempStr;
                                     break;
                                 case 1:
                                     company.oriTop = tempStr;
                                     break;
                                 case 2:
                                     company.oriHandi = tempStr;
                                     break;
                                 case 3:
                                     company.oridown = tempStr;
                                     break;
                                 case 4:
                                     company.nowTop = tempStr;
                                     break;
                                 case 5:
                                     company.nowHandi = tempStr;
                                     break;
                                 case 6:
                                     company.nowdown = tempStr;
                                     break;
                                 default:
                                     break;
                             }
                             i++;
                             
                         }
                         
                     }
                     [object.betCompanies addObject:company];
                 }
                 
                 NSArray * elements_ni2  = [table searchWithXPathQuery:@"//tr[@class='ni2']"];
                 for (TFHppleElement *ele in elements_ni2) {
                     Betcompany *company = [[Betcompany alloc]init];
                     int i = 0;
                     for (TFHppleElement *subele in ele.children) {
                         
                         if (subele.text.length > 1) {
                             NSMutableString *tempStr = [NSMutableString stringWithString:subele.text];
                             [tempStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tempStr.length)];
                             
                             switch (i) {
                                 case 0:
                                     company.name = tempStr;
                                     break;
                                 case 1:
                                     company.oriTop = tempStr;
                                     break;
                                 case 2:
                                     company.oriHandi = tempStr;
                                     break;
                                 case 3:
                                     company.oridown = tempStr;
                                     break;
                                 case 4:
                                     company.nowTop = tempStr;
                                     break;
                                 case 5:
                                     company.nowHandi = tempStr;
                                     break;
                                 case 6:
                                     company.nowdown = tempStr;
                                     break;
                                 default:
                                     break;
                             }
                             i++;
                             
                         }

                     }
                     [object.betCompanies addObject:company];
                 }
                 
                 for (Betcompany *company in object.betCompanies) {
//                     NSLog(@"%@ %@",company.nowHandi,company.oriHandi);
                     if ([company.name isEqualToString:@"澳彩"]) {
                         
                         if(![company.nowHandi isEqualToString:company.oriHandi])
                             object.canBet = YES;
                         else if(company.nowTop.floatValue > 1.0 || company.nowdown.floatValue > 1.0){
                             object.canBet = YES;
                         }
                     }
                 }
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
