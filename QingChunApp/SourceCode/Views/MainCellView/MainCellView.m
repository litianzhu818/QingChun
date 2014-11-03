//
//  MainCellView.m
//  QingChunApp
//
//  Created by  李天柱 on 14-11-3.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainCellView.h"

#define NAME_FONT [UIFont systemFontOfSize:14.0]
#define TIME_FONT [UIFont systemFontOfSize:11.0]
#define TEXT_FONT [UIFont systemFontOfSize:17.0]
#define BUTTON_FONT [UIFont systemFontOfSize:12.0]

#define TIME_COLOR [UIColor darkGrayColor]
#define LINE_COLOR [UIColor lightGrayColor]

#define SELF_WIDTH 320.0f

#define MARGIN_WIDTH 8.0f
#define PHOTO_BUTTON_WIDTH 40.0f

#define NAME_WIDTH 200.0f
#define NAME_HEIGHT 22.0f
#define TIME_WIDTH 200.0f
#define TIME_HEIGHT 18.0f

#define LINE_WIDTH 1.0f
#define LINE_HEIGHT 36.0f

#define BUTTON_LINE_MARGIN_WIDTH 1.0f
#define BUTTON_HEIGHT 22.0f
#define BUTTON_WIDTH (SELF_WIDTH - 6 * BUTTON_LINE_MARGIN_WIDTH - 3 * LINE_WIDTH - 2 * MARGIN_WIDTH)/4




@interface MainCellView ()
{
    UIView *backgroundView;
    UIView *horizontalLine;
    UIView *verticalLine1;
    UIView *verticalLine2;
    UIView *verticalLine3;
}
@end

@implementation MainCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadViews
{
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, MARGIN_WIDTH, PHOTO_BUTTON_WIDTH, PHOTO_BUTTON_WIDTH)];
    _photoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [_photoButton addTarget:self action:@selector(photoButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [_photoButton setTag:1];
    [self addSubview:_photoButton];
    
    
}

- (IBAction)photoButtonCliked:(id)sender
{
    
}


@end
