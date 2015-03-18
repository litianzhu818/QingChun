//
//  CommentTableViewCell.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/18.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "CommentTableViewCell.h"

#import "TTTAttributedLabel.h"
#import "CellCommentModel.h"

static const CGFloat marginWidth = 8.0f;
static const CGFloat marginHeight = 8.0f;
static const CGFloat headImageWidth = 28.0f;
static const CGFloat nameLabelWidth = 10.0f;
static const CGFloat floorLabelWidth = 60.0f;

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(CellCommentModel *)commentModel
{
    if (_commentModel == commentModel)  return;
    
    _commentModel = commentModel;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.commentModel) return;
    
    
}

- (void)initSubViews
{
    if (!self.headImageView) {
        self.headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth, marginHeight, headImageWidth, headImageWidth)];
            //设置圆角图片
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = headImageWidth / 2;
            
            [self.contentView addSubview:imageView];
            
            imageView;
        });
    }
    
    if (!self.nameLabel) {
        self.nameLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(2*marginWidth + self.headImageView.frame.size.width, marginHeight, self.contentView.frame.size.width - 4*marginWidth - floorLabelWidth - headImageWidth, nameLabelWidth)];
            
            [label setFont:[UIFont systemFontOfSize:15]];
            [label setTextColor:UIColorFromRGB(0x61a653)];
            
            [self.contentView addSubview:label];
            
            label;
        });
    }
    
    if (!self.floorNumberLabel) {
        self.floorNumberLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(2*marginWidth + self.headImageView.frame.size.width, marginHeight, self.contentView.frame.size.width - 4*marginWidth - floorLabelWidth - headImageWidth, nameLabelWidth)];
            
            [label setFont:[UIFont systemFontOfSize:12]];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            
            [self.contentView addSubview:label];
            
            label;
        });
    }
}

@end
