//
//  InfoTableViewCell.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "InfoTableViewCell.h"

#define NAME_FONT [UIFont systemFontOfSize:14.0]
#define TIME_FONT [UIFont systemFontOfSize:11.0]
#define TEXT_FONT [UIFont systemFontOfSize:17.0]
#define BUTTON_FONT [UIFont systemFontOfSize:10.0]

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

#define TEXT_WIDTH (SELF_WIDTH - 4 * MARGIN_WIDTH)

#define LINE_WIDTH 1.0f
#define LINE_HEIGHT 36.0f

#define BUTTON_LINE_MARGIN_WIDTH 1.0f
#define BUTTON_HEIGHT 22.0f
#define BUTTON_WIDTH (SELF_WIDTH - 6 * BUTTON_LINE_MARGIN_WIDTH - 3 * LINE_WIDTH - 2 * MARGIN_WIDTH)/4


@implementation InfoTableViewCell

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"InfoTableViewCell" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib {
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    NSString *str = @"123";
//    CGSize textSize = [self sizeWithString:str font:TEXT_FONT lineBreakMode:NSLineBreakByWordWrapping];
//    _textlabel.frame = CGRectMake(2*MARGIN_WIDTH, _textlabel.frame.origin.y, TEXT_WIDTH, textSize.height);
    
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

- (void)loadView
{
    
}


@end
