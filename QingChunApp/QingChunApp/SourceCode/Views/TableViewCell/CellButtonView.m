//
//  CellButtonView.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/20.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellButtonView.h"
#import "UIImage+SA.h"
#import "NSString+SA.h"

@implementation CellButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加3个按钮
        _likeButton = [self addButtonWithImage:@"timeline_icon_comment.png"
                            backgroundImage:@"timeline_card_leftbottom.png" buttonIndex:0];
        
        _unlikeButton = [self addButtonWithImage:@"timeline_icon_retweet.png"
                             backgroundImage:@"timeline_card_middlebottom.png" buttonIndex:1];
        
        _shareButton = [self addButtonWithImage:@"timeline_icon_unlike.png"
                              backgroundImage:@"timeline_card_rightbottom.png" buttonIndex:2];
        _commentButton = [self addButtonWithImage:@"timeline_icon_unlike.png"
    backgroundImage:@"timeline_card_rightbottom.png" buttonIndex:3];
        
    }     return self;
}

- (id)initWithFrame:(CGRect)frame  cellButtonViewModel:(CellButtonViewModel *)cellButtonViewModel
{
    self = [super initWithFrame:frame cellButtonViewModel:cellButtonViewModel];
    if (self) {
        // 添加4个按钮
        _likeButton = [self addButtonWithImage:@"like.png"
                               backgroundImage:nil
                                   buttonIndex:0];
        
        _unlikeButton = [self addButtonWithImage:@"unlike.png"
                                 backgroundImage:nil
                                     buttonIndex:1];
        
        _shareButton = [self addButtonWithImage:@"share.png"
                                backgroundImage:nil
                                    buttonIndex:2];
        _commentButton = [self addButtonWithImage:@"comment.png"
    backgroundImage:nil buttonIndex:3];
    }
    
    return self;
}

#pragma mark - 1.1、添加按钮方法
- (UIButton *)addButtonWithImage:(NSString *)imageName backgroundImage:(NSString *)backgroundImageName buttonIndex:(NSInteger)index
{
    UIButton *button = [super addButtonWithImage:imageName backgroundImage:backgroundImageName buttonIndex:index];
    [button setBackgroundImage:[UIImage resizeImage:backgroundImageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizeImage:[backgroundImageName fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(clikedOnButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮间间隔图片
    if (index) {
        UIImageView *cardButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"botton_center_line"]];
        [self addSubview:cardButton];
        cardButton.center = CGPointMake(button.frame.origin.x, self.frame.size.height * 0.5);
    }
    
    return button;
}

- (void)clikedOnButton:(UIButton *)button
{
    if (button.tag <= 1) {
        [button.imageView.layer addAnimation:_keyframeAnimation forKey:@"SHOW"];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellButtonView:didTouchUpInsideOnButtonIndex:)]) {
        [self.delegate cellButtonView:self didTouchUpInsideOnButtonIndex:button.tag];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
