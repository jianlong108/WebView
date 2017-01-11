//
//  GameParseViewCell.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2016/12/11.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "GameParseViewCell.h"
#import "GameObject.h"

@interface GameParseViewCell()
@property (weak, nonatomic) IBOutlet UIButton *gameNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *visitBtn;
@property (weak, nonatomic) IBOutlet UIButton *analysisBtn;
@property (weak, nonatomic) IBOutlet UILabel *orignalLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;

@end

@implementation GameParseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    // Initialization code
    [self.analysisBtn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.historyBtn addTarget:self action:@selector(historybtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.homeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.visitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.homeBtn.titleLabel.numberOfLines = 0;
    self.visitBtn.titleLabel.numberOfLines = 0;
}
- (void)clickbtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cell:ClickBtn:)]) {
        [self.delegate cell:self ClickBtn:_model.plate.href];
    }
}
- (void)historybtn:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(cell:ClickHistoryOrignal:NowHadi:)]) {
        [self.delegate cell:self ClickHistoryOrignal:_model.ori_Plate NowHadi:_model.now_Plate];
    }
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.backgroundColor = [UIColor whiteColor];
    _model = nil;
    
    [self.gameNameBtn setTitle:_model.gameName.title forState:UIControlStateNormal];
    [self.homeBtn setTitle:_model.hometeam.title forState:UIControlStateNormal];
    [self.visitBtn setTitle:_model.visitingteam.title forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GameObject *)model{
    _model = model;
    [self.gameNameBtn setTitle:_model.gameName.title forState:UIControlStateNormal];
    [self.homeBtn setTitle:_model.hometeam.title forState:UIControlStateNormal];
    [self.visitBtn setTitle:_model.visitingteam.title forState:UIControlStateNormal];
    
    self.orignalLabel.text = [NSString stringWithFormat:@"初\n %@ %@ %@",_model.ori_Top,_model.ori_Plate,_model.ori_Bottom];
    self.nowLabel.text = [NSString stringWithFormat:@"即\n %@ %@ %@",_model.now_Top,_model.now_Plate,_model.now_Bottom];
    
    self.backgroundColor = _model.canBet ? [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.5]:[UIColor whiteColor];
}
@end
