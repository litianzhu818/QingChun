//
//  BaseCellHeaderView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellHeaderView.h"
#import "UIButton+WebCache.h"

#define DEFAULT_MARGIN_WIDTH    10.0f
#define USER_IMAGE_WIDTH        34                                              // 用户头像尺寸
#define MORE_BUTTON_WIDTH       20
#define MORE_BUTTON_HEIGHT      10
#define MORE_BUTTON_MARGIN      15
#define NAME_LABEL_HEIGHT       20
#define TIME_LABEL_HEIGHT       10
#define TIME_COLOR              [UIColor darkGrayColor]
#define USER_NAME_FONT          [UIFont systemFontOfSize:15]                    // 用户昵称字号
//#define kMBIconWH             12                                              // 会员图标尺寸
#define TIME_FONT               [UIFont systemFontOfSize:10]                    // 发表时间字号
#define TEXT_FONT               [UIFont systemFontOfSize:15]                    // 微博正文字号


@interface BaseCellHeaderView ()
{
    UIButton            *_photoButton;
    UIButton            *_moreBUtton;
    UILabel             *_nameLabel;
    UILabel             *_timeLabel;
    UILabel             *_textLabel;
    
    CGSize              _headerSize;
    CGFloat             _textWidth;
    CGFloat             _textHeight;
    
    BOOL                _hasMoreButton;
    CellHeaderType      _headerType;
    CellHeaderPhotoType _photoType;
    
    CellHeaderViewModel *_headerViewModel;
    
}

@end

@implementation BaseCellHeaderView
@synthesize headerViewModel = _headerViewModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel
{
    return [self initWithFrame:frame
           cellHeaderViewModel:headerViewModel
                CellHeaderType:CellHeaderTypeSimple
           cellHeaderPhotoType:CellHeaderPhotoTypeSquare
                    hasMoreBtn:NO];
}

- (id)initWithMultipleTypeFrame:(CGRect)frame  cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel cellHeaderPhotoType:(CellHeaderPhotoType)photoType
{
    return [self initWithFrame:frame cellHeaderViewModel:headerViewModel CellHeaderType:CellHeaderTypeMultiple cellHeaderPhotoType:photoType hasMoreBtn:YES];
}

- (id)initWithSimpleTypeFrame:(CGRect)frame  cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel cellHeaderPhotoType:(CellHeaderPhotoType)photoType
{
    return [self initWithFrame:frame cellHeaderViewModel:headerViewModel CellHeaderType:CellHeaderTypeSimple cellHeaderPhotoType:photoType hasMoreBtn:NO];
}

- (id)initWithFrame:(CGRect)frame
cellHeaderViewModel:(CellHeaderViewModel *)headerViewModel
     CellHeaderType:(CellHeaderType)headerType
cellHeaderPhotoType:(CellHeaderPhotoType)photoType
         hasMoreBtn:(BOOL)hasMoreBtn
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _headerViewModel = headerViewModel;
        _headerType = headerType;
        _photoType = photoType;
        [self setupUIWithCellHeaderType:_headerType cellHeaderPhotoType:_photoType];
    }
    return self;
}

- (void)setupUIWithCellHeaderType:(CellHeaderType)headerType cellHeaderPhotoType:(CellHeaderPhotoType)photoType
{
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, USER_IMAGE_WIDTH, USER_IMAGE_WIDTH)];
    if (photoType == CellHeaderPhotoTypeCircle) {
        _photoButton.layer.masksToBounds = YES;
        _photoButton.layer.cornerRadius = USER_IMAGE_WIDTH/2;
        /*
        _photoButton.layer.borderWidth = 2;
        _photoButton.layer.borderColor = [[UIColor blackColor] CGColor];
         */
    }
    
    [_photoButton addTarget:self action:@selector(ClikedOnPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, self.frame.size.width - 4*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH - MORE_BUTTON_WIDTH, NAME_LABEL_HEIGHT)];
    _timeLabel = [[UILabel alloc] init];
    _textLabel = [[UILabel alloc] init];
    
    [_nameLabel setFont:USER_NAME_FONT];
    
    [_timeLabel setFont:TIME_FONT];
    [_timeLabel setTextColor:TIME_COLOR];
    
    [_textLabel setFont:TEXT_FONT];
    _textLabel.numberOfLines = 0;
    
    if (headerType == CellHeaderTypeMultiple) {
        _moreBUtton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - MORE_BUTTON_WIDTH - DEFAULT_MARGIN_WIDTH, MORE_BUTTON_MARGIN, MORE_BUTTON_WIDTH, MORE_BUTTON_HEIGHT)];
        [_moreBUtton setImage:[UIImage imageNamed:@"more_btn_nor"] forState:UIControlStateNormal];
        [_moreBUtton setImage:[UIImage imageNamed:@"more_btn_sel"] forState:UIControlStateSelected];
        [_moreBUtton addTarget:self action:@selector(ClikedOnMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBUtton];
        
        _timeLabel.frame = CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, NAME_LABEL_HEIGHT+DEFAULT_MARGIN_WIDTH, self.frame.size.width - 4*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH - MORE_BUTTON_WIDTH, TIME_LABEL_HEIGHT);
        
        _textWidth = self.frame.size.width - 2*2*DEFAULT_MARGIN_WIDTH;
        _textHeight = [self sizeWithString:_headerViewModel.text font:TEXT_FONT lineBreakMode:NSLineBreakByWordWrapping].height;
        
        _textLabel.frame = CGRectMake(DEFAULT_MARGIN_WIDTH, USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, _textWidth, _textHeight);
    }else{
        _timeLabel.frame = CGRectMake(self.frame.size.width - MORE_BUTTON_WIDTH - DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_WIDTH, MORE_BUTTON_WIDTH, TIME_LABEL_HEIGHT);
        
        _textWidth = self.frame.size.width - 3*DEFAULT_MARGIN_WIDTH - USER_IMAGE_WIDTH;
        _textHeight = [self sizeWithString:_headerViewModel.text font:TEXT_FONT lineBreakMode:NSLineBreakByWordWrapping].height;
        
        _textLabel.frame = CGRectMake(USER_IMAGE_WIDTH + 2*DEFAULT_MARGIN_WIDTH, NAME_LABEL_HEIGHT + 2*DEFAULT_MARGIN_WIDTH, _textWidth, _textHeight);
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.headerSize.width, self.headerSize.height);
    
    [self addSubview:_photoButton];
    [self addSubview:_nameLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_textLabel];
    
    [_nameLabel setText:_headerViewModel.name];
    [_timeLabel setText:_headerViewModel.time];
    [_textLabel setText:_headerViewModel.text];
    [_photoButton sd_setImageWithURL:[NSURL URLWithString:_headerViewModel.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"headerImage"]];
}

- (CGSize)headerSize
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

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    //  //该方法已经弃用
    //    CGSize size = [sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return  [string boundingRectWithSize:CGSizeMake(_textWidth, CGFLOAT_MAX)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:attributes
                                 context:nil].size;
}

@end
