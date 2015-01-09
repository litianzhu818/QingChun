//
//  QCBellTableViewCell.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "QCBellTableViewCell.h"

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)initSuperUI
{
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
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
