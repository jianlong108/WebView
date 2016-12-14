//
//  GameParseViewCell.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/11.
//  Copyright © 2016年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GameObject,GameParseViewCell;

@protocol GameParseViewCellDelegate <NSObject>

@optional
- (void)cell:(GameParseViewCell *)cell ClickBtn:(NSString *)str;

@end

@interface GameParseViewCell : UITableViewCell
/**object*/
@property (nonatomic, strong)GameObject *model;
/**<#说明#>*/
@property (nonatomic, weak)id<GameParseViewCellDelegate> delegate;
@end
