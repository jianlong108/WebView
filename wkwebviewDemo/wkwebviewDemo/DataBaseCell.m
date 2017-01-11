//
//  DataBaseCell.m
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/11.
//  Copyright © 2017年 JL. All rights reserved.
//

#import "DataBaseCell.h"
#import "GameObject.h"

@interface DataBaseCell()
@property (weak, nonatomic) IBOutlet UILabel *league;
@property (weak, nonatomic) IBOutlet UILabel *soccer;
@property (weak, nonatomic) IBOutlet UILabel *originalTop;
@property (weak, nonatomic) IBOutlet UILabel *originalPan;
@property (weak, nonatomic) IBOutlet UILabel *originalBottom;
@property (weak, nonatomic) IBOutlet UILabel *nowTop;
@property (weak, nonatomic) IBOutlet UILabel *nowPan;
@property (weak, nonatomic) IBOutlet UILabel *nowBottom;
@property (weak, nonatomic) IBOutlet UIButton *more;


@end

@implementation DataBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.more addTarget:self action:@selector(entryWebView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)prepareForReuse{
    [super prepareForReuse];
    _model = nil;
    self.league.text = _model.league;
    self.soccer.text = _model.soccer;
    self.originalTop.text = _model.oriTop;
    self.originalPan.text = _model.oriHandi;
    self.originalBottom.text = _model.oridown;
    self.nowTop.text = _model.nowTop;
    self.nowPan.text = _model.nowHandi;
    self.nowBottom.text = _model.nowdown;
}
- (void)setModel:(Betcompany *)model{
    _model = model;
    self.league.text = _model.league;
    self.soccer.text = _model.soccer;
    self.originalTop.text = _model.oriTop;
    self.originalPan.text = _model.oriHandi;
    self.originalBottom.text = _model.oridown;
    self.nowTop.text = _model.nowTop;
    self.nowPan.text = _model.nowHandi;
    self.nowBottom.text = _model.nowdown;
}
- (void)entryWebView{
    if ([_delegate respondsToSelector:@selector(cell:ClickDetailBtn:)]) {
        [_delegate cell:self ClickDetailBtn:self.model.gameurl];
    }
}
@end
