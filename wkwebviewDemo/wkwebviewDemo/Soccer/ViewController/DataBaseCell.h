//
//  DataBaseCell.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Betcompany,DataBaseCell;

@protocol DataBaseCellDelegate <NSObject>

@optional
- (void)cell:(DataBaseCell *)cell ClickDetailBtn:(NSString *)str;

@end

@interface DataBaseCell : UITableViewCell
/**数据*/
@property (nonatomic, strong)Betcompany *model;
/**<#说明#>*/
@property (nonatomic, weak)id<DataBaseCellDelegate> delegate;
@end
