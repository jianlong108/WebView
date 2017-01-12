//
//  JLBothSidesView.h
//  wkwebviewDemo
//
//  Created by Wangjianlong on 2017/1/12.
//  Copyright © 2017年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBothSidesView : UIView

/**正面button*/
@property (nonatomic, strong,readonly)UIButton *positiveBtn;

/**反面button*/
@property (nonatomic, strong,readonly)UIButton *oppositeBtn;

/**动画时间*/
@property (nonatomic, assign)NSTimeInterval animationDuration;

/**动画类型*/
@property (nonatomic, assign)UIViewAnimationOptions animationOptions;

- (void)transitionView;

@end
