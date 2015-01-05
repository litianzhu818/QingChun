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

#define NAME_WIDTH (SELF_WIDTH - 4 * MARGIN_WIDTH - 2 * PHOTO_BUTTON_WIDTH)
#define NAME_HEIGHT 22.0f
#define TIME_WIDTH NAME_WIDTH
#define TIME_HEIGHT 18.0f

#define NAME_MORE_MARGIN MARGIN_WIDTH

#define TEXT_WIDTH (SELF_WIDTH - 2 * MARGIN_WIDTH)

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
    _photoButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_photoButton addTarget:self action:@selector(photoButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [_photoButton setTag:1];
    [self addSubview:_photoButton];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_photoButton) + MARGIN_WIDTH, MARGIN_WIDTH, NAME_WIDTH, NAME_HEIGHT)];
    [_nameLabel setFont:NAME_FONT];
    _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_nameLabel setTag:2];
    [self addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_photoButton) + MARGIN_WIDTH, VIEW_BY(_nameLabel), TIME_WIDTH, TIME_HEIGHT)];
    [_timeLabel setFont:TIME_FONT];
    [_timeLabel setTextColor:TIME_COLOR];
    [_timeLabel setTag:3];
    _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_timeLabel];
    
    _moreInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_BX(_nameLabel) + MARGIN_WIDTH, MARGIN_WIDTH, PHOTO_BUTTON_WIDTH, PHOTO_BUTTON_WIDTH)];
    _moreInfoButton.autoresizingMask = UIViewAutoresizingNone;
    [_moreInfoButton addTarget:self action:@selector(photoButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [_moreInfoButton setTag:4];
    [self addSubview:_moreInfoButton];
    
    //TODO:将文字信息，图片信息，视频信息分开
    //???:如果是文字加图片
    NSString *str = @"123";
    CGSize textSize = [self sizeWithString:str font:TEXT_FONT lineBreakMode:NSLineBreakByWordWrapping];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(_photoButton) + MARGIN_WIDTH,TEXT_WIDTH, textSize.height)];
    [_textLabel setNumberOfLines:0];
    [_textLabel setFont:TEXT_FONT];
    [_textLabel setTag:5];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:_textLabel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(_textLabel), TEXT_WIDTH, TEXT_WIDTH * 0.5)];
    [self addSubview:_imageView];
    
    horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0,VIEW_BY(_imageView) + MARGIN_WIDTH, SELF_WIDTH, LINE_WIDTH)];
    [horizontalLine setBackgroundColor:LINE_COLOR];
    horizontalLine.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:horizontalLine];
    
    _praiseButton = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(horizontalLine) + MARGIN_WIDTH, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [_praiseButton.titleLabel setFont:BUTTON_FONT];
    [_praiseButton.titleLabel setTextColor:LINE_COLOR];
    [_praiseButton setImage:PNG_NAME(@"zhan_normal.png") forState:UIControlStateNormal];
    [self addSubview:_praiseButton];
    
    verticalLine1 = [[UIView alloc] initWithFrame:CGRectMake(VIEW_BX(_praiseButton)+BUTTON_LINE_MARGIN_WIDTH, VIEW_BY(horizontalLine) + MARGIN_WIDTH, LINE_WIDTH, LINE_HEIGHT)];
    [verticalLine1 setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:verticalLine1];
    
    _shitButton = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN_WIDTH, VIEW_BY(horizontalLine) + MARGIN_WIDTH, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [_shitButton.titleLabel setFont:BUTTON_FONT];
    [_shitButton.titleLabel setTextColor:LINE_COLOR];
    [_shitButton setImage:PNG_NAME(@"zhan_normal.png") forState:UIControlStateNormal];
    [self addSubview:_shitButton];
    
    
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    //  //该方法已经弃用
    //    CGSize size = [sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return  [string boundingRectWithSize:CGSizeMake(TEXT_WIDTH, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
}

- (IBAction)photoButtonCliked:(id)sender
{
    
}


@end
