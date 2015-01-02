//
//  BaseCellHeaderView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellHeaderView.h"
#import "UIButton+WebCache.h"
#import "NSString+SA.h"
#import "CellDisplayModel.h"

#define DEFAULT_MARGIN_WIDTH    10.0f
#define USER_IMAGE_WIDTH        34                                              // 用户头像尺寸
#define MORE_BUTTON_WIDTH       20
#define MORE_BUTTON_HEIGHT      10
#define MORE_BUTTON_MARGIN      15
#define NAME_LABEL_HEIGHT       20
#define TIME_LABEL_HEIGHT       10
#define TIME_COLOR              [UIColor lightGrayColor]
#define USER_NAME_FONT          [UIFont systemFontOfSize:15]                    // 用户昵称字号
//#define kMBIconWH             12                                              // 会员图标尺寸
#define TIME_FONT               [UIFont systemFontOfSize:10]                    // 发表时间字号

#define TEXT_FONT               [UIFont systemFontOfSize:15]                    // 微博正文字号
#define TEXT_COLOR              [UIColor darkGrayColor]


@interface BaseCellHeaderView ()
{
    UIButton            *_photoButton;
    UIButton            *_moreBUtton;
    UILabel             *_nameLabel;
    UILabel             *_timeLabel;
    UILabel             *_textLabel;
    
    CGFloat             _textWidth;
    CGFloat             _textHeight;
    CellHeaderViewType  _cellHeaderViewType;
}

@end

@implementation BaseCellHeaderView
@synthesize cellDisplayModel = _cellDisplayModel;
@synthesize cellHeaderViewType = _cellHeaderViewType;

#pragma mark - class public methods
+ (CGFloat)normalHeaderViewHeightWithWidth:(CGFloat)width content:(NSString *)content
{
    return [BaseCellHeaderView headerViewHeightWithWidth:width
                                      cellHeaderViewType:CellHeaderViewTypeNormal
                                                 content:content];
}
+ (CGFloat)indentHeaderViewHeightWithWidth:(CGFloat)width content:(NSString *)content
{
    return [BaseCellHeaderView headerViewHeightWithWidth:width
                                      cellHeaderViewType:CellHeaderViewTypeIndent
                                                 content:content];
}
+ (CGFloat)headerViewHeightWithWidth:(CGFloat)width
                  cellHeaderViewType:(CellHeaderViewType)cellHeaderViewType
                             content:(NSString *)content
{
    CGFloat height = 0.0f;
    
    if (cellHeaderViewType == CellHeaderViewTypeNormal) {
        height = 3*DEFAULT_MARGIN_WIDTH + USER_IMAGE_WIDTH;
        height += [content sizeWithWidth:width
                                    font:TEXT_FONT
                           lineBreakMode:NSLineBreakByWordWrapping].height;
    }else if (cellHeaderViewType == CellHeaderViewTypeIndent){
        height = 3*DEFAULT_MARGIN_WIDTH + NAME_LABEL_HEIGHT;
        height += [content sizeWithWidth:(width - DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH)
                                    font:TEXT_FONT
                           lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    
    return height;
}

#pragma mark - object init methods

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellDisplayModel:nil];
}

- (id)initWithFrame:(CGRect)frame cellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    return [self initWithNormalTypeFrame:frame cellDisplayModel:cellDisplayModel];
}

- (id)initWithIndentTypeFrame:(CGRect)frame
             cellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    return [self initWithFrame:frame
            cellHeaderViewType:CellHeaderViewTypeIndent
              cellDisplayModel:cellDisplayModel];
}

- (id)initWithNormalTypeFrame:(CGRect)frame
             cellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    return [self initWithFrame:frame
            cellHeaderViewType:CellHeaderViewTypeNormal
              cellDisplayModel:cellDisplayModel];
}

- (id)initWithFrame:(CGRect)frame
 cellHeaderViewType:(CellHeaderViewType)cellHeaderViewType
   cellDisplayModel:(CellDisplayModel *)headerViewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cellDisplayModel = headerViewModel;
        _cellHeaderViewType = cellHeaderViewType;
        
        [self setupUIWithCellHeaderViewType:_cellHeaderViewType];
    }
    return self;
}

- (void)setCellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    _cellDisplayModel = cellDisplayModel;
    [self setNeedsLayout];
}

#pragma mark - object private methods

- (void)setupUIWithCellHeaderViewType:(CellHeaderViewType)headerViewType
{
    //头像
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, USER_IMAGE_WIDTH, USER_IMAGE_WIDTH)];
    [_photoButton addTarget:self action:@selector(ClikedOnPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //名称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, self.frame.size.width - 4*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH - 4*MORE_BUTTON_WIDTH, NAME_LABEL_HEIGHT)];
    [_nameLabel setTextColor:UIColorFromRGB(0x61a653)];
    
    //时间和内容
    _timeLabel = [[UILabel alloc] init];
    _textLabel = [[UILabel alloc] init];
    
    [_nameLabel setFont:USER_NAME_FONT];
    
    [_timeLabel setFont:TIME_FONT];
    [_timeLabel setTextColor:TIME_COLOR];
    
    [_textLabel setFont:TEXT_FONT];
    _textLabel.numberOfLines = 0;
    
    //添加这些控件
    [self addSubview:_photoButton];
    [self addSubview:_nameLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_textLabel];
    
    if (headerViewType == CellHeaderViewTypeIndent) {//如果是缩进类型的
        //设置头像为圆形
        _photoButton.layer.masksToBounds = YES;
        _photoButton.layer.cornerRadius = USER_IMAGE_WIDTH/2;
        
        //时间label的frame
        _timeLabel.frame = CGRectMake(self.frame.size.width - 4*MORE_BUTTON_WIDTH - DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, 4*MORE_BUTTON_WIDTH, TIME_LABEL_HEIGHT);
        //这时的时间要往右对齐
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        
        //文本的宽高和frame
        _textWidth = self.frame.size.width - 3*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH;
        _textHeight = 2* DEFAULT_MARGIN_WIDTH;
        
        _textLabel.frame = CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, NAME_LABEL_HEIGHT + 2*DEFAULT_MARGIN_WIDTH, _textWidth, _textHeight);
        
        //初始化结束
        return;
    }
    /*******************如果是正常布局（带有more按钮的）***************************/
    //添加more按钮
    _moreBUtton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - MORE_BUTTON_WIDTH - DEFAULT_MARGIN_WIDTH, MORE_BUTTON_MARGIN, MORE_BUTTON_WIDTH, MORE_BUTTON_HEIGHT)];
    [_moreBUtton setImage:[UIImage imageNamed:@"more_btn_nor"] forState:UIControlStateNormal];
    [_moreBUtton setImage:[UIImage imageNamed:@"more_btn_sel"] forState:UIControlStateSelected];
    [_moreBUtton addTarget:self action:@selector(ClikedOnMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBUtton];
    
    //设置时间的label的位置
    _timeLabel.frame = CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, NAME_LABEL_HEIGHT+DEFAULT_MARGIN_WIDTH, self.frame.size.width - 4*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH - MORE_BUTTON_WIDTH, TIME_LABEL_HEIGHT);
    //这时的时间应以左对齐
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    
    //设置文本的长宽和frame
    _textWidth = self.frame.size.width - 2*DEFAULT_MARGIN_WIDTH;
    _textHeight = 2* DEFAULT_MARGIN_WIDTH;
    
    _textLabel.frame = CGRectMake(DEFAULT_MARGIN_WIDTH, USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, _textWidth, _textHeight);
    [_textLabel setTextColor:TEXT_COLOR];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_cellDisplayModel) {
        return;
    }
    [_photoButton sd_setImageWithURL:[NSURL URLWithString:_cellDisplayModel.cellDisplayUserModel.imgUrlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default"]];
    [_nameLabel setText:_cellDisplayModel.cellDisplayUserModel.name];
    [_timeLabel setText:_cellDisplayModel.cellContentModel.time];
    [_textLabel setText:_cellDisplayModel.cellContentModel.text];
    
    CGRect textLabelFrame = _textLabel.frame;
    
     _textHeight = [_cellDisplayModel.cellContentModel.text sizeWithWidth:_textWidth
                                                                     font:TEXT_FONT
                                                            lineBreakMode:NSLineBreakByWordWrapping].height;
    
    textLabelFrame.size.height = _textHeight;
    
    _textLabel.frame = textLabelFrame;
    [_textLabel sizeToFit];
    
    CGFloat height = 0.0f;
    
    if (_cellHeaderViewType == CellHeaderViewTypeNormal) {
        height = 3*DEFAULT_MARGIN_WIDTH + USER_IMAGE_WIDTH + _textHeight;
    }else if (_cellHeaderViewType == CellHeaderViewTypeIndent){
        height = 3*DEFAULT_MARGIN_WIDTH + NAME_LABEL_HEIGHT + _textHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
}
/*
- (CGSize)headerViewSize
{
    CGFloat height = 0.0f;
    switch (_headerType) {
        case CellHeaderTypeSimple:
            height = 3*DEFAULT_MARGIN_WIDTH + NAME_LABEL_HEIGHT + _textHeight;
            break;
        case CellHeaderTypeMultiple:
            height = 3*DEFAULT_MARGIN_WIDTH + USER_IMAGE_WIDTH + _textHeight;
            break;
        default:
            break;
    }
    
    return CGSizeMake(self.frame.size.width, height);
}
 */

- (IBAction)ClikedOnPhotoButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCellHeaderView:clikedOnPhotoButton:)]) {
        [self.delegate baseCellHeaderView:self clikedOnPhotoButton:sender];
    }
}

- (IBAction)ClikedOnMoreButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseCellHeaderView:clikedOnMoreButton:)]) {
        [self.delegate baseCellHeaderView:self clikedOnMoreButton:sender];
    }
}
/*
- (CGSize)sizeWithString:(NSString *)string
                   width:(CGFloat)width
                    font:(UIFont *)font
           lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    //  //该方法已经弃用
    //    CGSize size = [sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy
                                 };
    
    return  [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:attributes
                                 context:nil].size;
}
 */

@end
