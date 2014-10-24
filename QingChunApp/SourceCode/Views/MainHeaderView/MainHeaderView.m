//
//  MainHeaderView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainHeaderView.h"
#import "MainHeaderViewCell.h"
#import "MainHeaderViewItem.h"

#define MARGIN_TOP_WIDTH 20.0f
#define MAIN_CELL_HEIGHT 44.0f

@interface MainHeaderView ()
{
    NSMutableArray *viewArray;
    id<MainHeaderViewDelegate> _delegate;
    NSArray *_items;
}
@end

@implementation MainHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items frame:(CGRect)frame delegate:(id)delegate
{
    if (FRAME_H(frame) < 64.0) frame = CGRectMake(FRAME_TX(frame), FRAME_TY(frame), FRAME_W(frame), 64.0);
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        _items = items;
        [self initData];
        [self initUI];
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

- (void)initData
{
    viewArray = [NSMutableArray array];
}

- (void)initUI
{
    if ([_items count] <= 0) {
        return;
    }
    
    NSMutableArray *Constraints = [NSMutableArray array];
    NSMutableDictionary *viewDic = [NSMutableDictionary dictionary];
    NSMutableString *constrainString = [NSMutableString stringWithFormat:@"%@",@"H:|"];
    
    
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MainHeaderViewItem *item = obj;
        MainHeaderViewCell *cell = [[MainHeaderViewCell alloc] initWithCell:item frame:CGRectMake(0, MARGIN_TOP_WIDTH, MAIN_CELL_HEIGHT, MAIN_CELL_HEIGHT)];
        [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell setSelectedTextColor:[UIColor whiteColor]];
        [cell setNormalTextColor:[UIColor lightGrayColor]];
        [cell setUserInteractionEnabled:YES];
        [self addSubview:cell];
        [viewArray addObject:cell];
        [viewDic setObject:cell forKey:[NSString stringWithFormat:@"%@%d",@"cell",idx]];
        
        [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-MARGIN1-[cell]-MARGIN2-|"
                                                                                 options:0
                                                                                 metrics:@{
                                                                                           @"MARGIN1":[NSNumber numberWithFloat:MARGIN_TOP_WIDTH],@"MARGIN2":@0.0
                                                                                           }
                                                                                   views:NSDictionaryOfVariableBindings(cell)]];
        [constrainString appendFormat:@"-MARGIN1-[cell%d(==MARGIN2)]",idx];
        
    }];
    [constrainString appendString:@"-MARGIN1-|"];
    [Constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                             options:0
                                                                             metrics:@{
                                                                                       @"MARGIN1":@0.0,
                                                                                       @"MARGIN2":[NSNumber numberWithFloat:VIEW_W(self)/[_items count]]
                                                                                       }
                                                                               views:viewDic]];

    
    [self addConstraints:Constraints];
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
