//
//  BaseCellButtonView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellButtonView.h"

@implementation BaseCellButtonView

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
