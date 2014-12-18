//
//  BaseNavigationBar.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/23.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseNavigationBar.h"
#import "NavigationBarItem.h"

@interface BaseNavigationBar ()

@end

@implementation BaseNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initUI
{
    UITabBar *bar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, VIEW_W(self), VIEW_H(self))];
    UITabBarItem *baItem1 = [[UITabBarItem alloc] initWithTitle:@"李天柱" image:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    UITabBarItem *baItem2 = [[UITabBarItem alloc] initWithTitle:@"Peter Lee" image:PNG_NAME(@"qingchunba_selected.png") selectedImage:PNG_NAME(@"qingchunqiang_selected.png")];
    
    [bar setItems:[NSArray arrayWithObjects:baItem1,baItem2, nil]];
    [self addSubview:bar];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}



@end
