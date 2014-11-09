//
//  UserHeaderView.m
//  QingChunApp
//
//  Created by  李天柱 on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UserHeaderView.h"

@implementation UserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil];
        [self addSubview:[views objectAtIndex:0]];
        
        // customize the view a bit
        [self initUI];
    }
    return self;
}

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil]firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (void)initUI
{
    [self loadViews];
}

- (void)loadViews
{
    [_accessoryButton setBackgroundImage:[UIImage imageNamed:@"header_ac_nor"] forState:UIControlStateNormal];
    [_accessoryButton setBackgroundImage:[UIImage imageNamed:@"header_ac_se"] forState:UIControlStateSelected];
}

-(IBAction)clikedOnHeaderView:(id)sender
{
    LOG(NSStringFromClass([_delegate class]));
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender];
    }
}
- (void)cliked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender];
    }
}

-(IBAction)clikedOnAccessroyView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeaderView:didClikedOnButton:)]) {
        [self.delegate userHeaderView:self didClikedOnButton:sender];
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    self.alpha = 0.6;
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
    self.alpha = 1.0;
    [super touchesEnded:touches withEvent:event];
}*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
