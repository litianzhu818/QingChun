//
//  QCBellTableViewCell.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "QCBellTableViewCell.h"
#import "QCBellDataModel.h"

#define F0 [UIFont systemFontOfSize:10]
#define F1 [UIFont boldSystemFontOfSize:17]

#define DEFAULT_MARGIN_HEIGHT 5.0
#define DEFAULT_MARGIN_WIDTH 2*DEFAULT_MARGIN_HEIGHT

#define DEFAULT_IMAGE_VIEW_HEIGHT 40.0

@interface QCBellTableViewCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIButton *_badgeButton;
}
@end

@implementation QCBellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSuperUI];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
}

-(void)initSuperUI
{
    self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    _imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN_WIDTH, DEFAULT_MARGIN_HEIGHT, DEFAULT_IMAGE_VIEW_HEIGHT, DEFAULT_IMAGE_VIEW_HEIGHT)];
        
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    _badgeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(bound.size.width-6*DEFAULT_MARGIN_WIDTH, (bound.size.height-2*DEFAULT_MARGIN_WIDTH)/2, 2*DEFAULT_MARGIN_WIDTH, 2*DEFAULT_MARGIN_WIDTH)];
        
        //竖直居中显示
        CGPoint buttonCenterPoint = button.center;
        buttonCenterPoint.y = _imageView.center.y;
        button.center = buttonCenterPoint;
        
        UIImage *image = [UIImage imageNamed:@"new"];
        
        [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:floorf(image.size.width*0.5) topCapHeight:floorf(image.size.height*0.5)] forState:UIControlStateNormal];
        [button.titleLabel setFont:F0];
        [button setTintColor:[UIColor whiteColor]];
        [button setHidden:YES];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = DEFAULT_MARGIN_WIDTH;
        
        [self.contentView addSubview:button];
        
        button;
    });
    
    _titleLabel = ({
    
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*DEFAULT_MARGIN_WIDTH+_imageView.frame.size.width, DEFAULT_MARGIN_HEIGHT, (bound.size.width-4*DEFAULT_MARGIN_WIDTH)-3*DEFAULT_MARGIN_WIDTH-DEFAULT_IMAGE_VIEW_HEIGHT, DEFAULT_IMAGE_VIEW_HEIGHT)];
        [titleLabel setFont:F1];
        [self.contentView addSubview:titleLabel];
        titleLabel;
    });
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.qcbellDataModel) return;
    
    _imageView.image = self.qcbellDataModel.image;
    _titleLabel.text = self.qcbellDataModel.title;
    [self updateBadgeWithNumber:self.qcbellDataModel.number];
}

-(NSString *)getStringFrom:(NSUInteger)bageNumber
{
    NSString *bageNumberString = nil;
    if (bageNumber <= 99) {
        bageNumberString = [NSString stringWithFormat:@"%ld",(unsigned long)bageNumber];
    }else{
        bageNumberString = [NSString stringWithFormat:@"%@",@"..."];
    }
    return bageNumberString;
}


- (void)updateBadgeWithNumber:(NSUInteger)number
{
    [_badgeButton setTitle:[self getStringFrom:number] forState:UIControlStateNormal];
    [_badgeButton setHidden:((number < 1) ? YES:NO)];
}

+ (CGFloat)CellHeight
{
    return 2*DEFAULT_MARGIN_HEIGHT + DEFAULT_IMAGE_VIEW_HEIGHT;
}

+ (NSString *)CellIdentifier
{
    return [NSString stringWithFormat:@"%@",@"QCBellTableViewCellIdentifier"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
