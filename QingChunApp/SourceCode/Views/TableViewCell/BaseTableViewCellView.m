//
//  BaseTableViewCellView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseTableViewCellView.h"
//两种模式：一、平铺，四个按钮都显示  二、缩进，显示两个，隐藏两个，用popupview

@interface  BaseTableViewCellView ()
{
    UIButton *photoButton;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *textLabel;
    
    UIImageView *backgroundView;
    
    //四个评论按钮
    
    CGSize  _viewSize;
    
    BOOL _animationBtn;
    
}

@end

@implementation BaseTableViewCellView
@synthesize viewSize = _viewSize;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    
    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        //TODO:这里可以将触摸范围扩大，便于操作，例如：
         CGRect validTouchArea = CGRectMake((self.frame.origin.x - 10),
         (self.frame.origin.y - 10),
         (self.frame.size.width + 10),
         (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            //your code here
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
