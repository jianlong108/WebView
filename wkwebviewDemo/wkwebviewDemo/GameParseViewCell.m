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
@property (weak, nonatomic) IBOutlet UISwitch *canBet;

@end

@implementation GameParseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.analysisBtn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickbtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cell:ClickBtn:)]) {
        [self.delegate cell:self ClickBtn:_model.plate.href];
    }
}
- (void)prepareForReuse{
    [super prepareForReuse];
    _model = nil;
    
    [self.gameNameBtn setTitle:_model.gameName.title forState:UIControlStateNormal];
    [self.homeBtn setTitle:_model.hometeam.title forState:UIControlStateNormal];
    [self.visitBtn setTitle:_model.visitingteam.title forState:UIControlStateNormal];
    [self.canBet setOn:NO animated:NO];
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
    [self.canBet setOn:_model.canBet animated:YES];;
}
@end
