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
#import "NSString+SA.h"
#import "UIButton+WebCache.h"

static const CGFloat marginWidth = 8.0f;
static const CGFloat marginHeight = 8.0f;
static const CGFloat headImageWidth = 28.0f;
static const CGFloat nameLabelWidth = 15.0f;
static const CGFloat floorLabelWidth = 60.0f;

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    
    return self;
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
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImageUrl]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"default"]];
    
    self.nameLabel.text = self.commentModel.userName;
    self.floorNumberLabel.text = [self floorStringWithText:self.commentModel.floors];
    self.commentContentLabel.text = self.commentModel.message;
    
    CGFloat currentHeight = [CommentTableViewCell cellHeightWithModel:self.commentModel] - 3*marginHeight - nameLabelWidth;
    CGRect currentFrame = self.commentContentLabel.frame;
    currentFrame.size.height = currentHeight;
    
    self.commentContentLabel.frame = currentFrame;
    
}

- (void)initSubViews
{
    if (!self.headImageView) {
        self.headImageView = ({
            UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(marginWidth, marginHeight, headImageWidth, headImageWidth)];
            //设置圆角图片
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = headImageWidth / 2;
            [imageView addTarget:self action:@selector(ClikedOnPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:imageView];
            
            imageView;
        });
    }
    
    if (!self.nameLabel) {
        self.nameLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(2*marginWidth + self.headImageView.frame.size.width, marginHeight, bound.size.width - 4*marginWidth - floorLabelWidth - headImageWidth, nameLabelWidth)];
            
            [label setFont:[UIFont systemFontOfSize:15]];
            [label setTextColor:UIColorFromRGB(0x61a653)];
            
            [self.contentView addSubview:label];
            
            label;
        });
    }
    
    if (!self.floorNumberLabel) {
        self.floorNumberLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(2*marginWidth + self.headImageView.frame.size.width, marginHeight, bound.size.width - 4*marginWidth - floorLabelWidth - headImageWidth, nameLabelWidth)];
            
            [label setFont:[UIFont systemFontOfSize:12]];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            
            [self.contentView addSubview:label];
            
            label;
        });
    }
    
    if (!self.commentContentLabel) {
        self.commentContentLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(2*marginWidth + self.headImageView.frame.size.width, 2*marginHeight + nameLabelWidth, self.nameLabel.frame.size.width + self.floorNumberLabel.frame.size.width + marginWidth, nameLabelWidth)];
            label.numberOfLines = 0;
            label.lineSpacing = 2.0f;
            [label setFont:[UIFont systemFontOfSize:15]];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:label];
            
            label;
        });
    }
}

- (void)ClikedOnPhotoButton:(id)sender
{

}

- (NSString *)floorStringWithText:(NSString *)text
{
    return [NSString stringWithFormat:@"%@%@",text,@"楼"];
}

+ (NSString *)cellIdentifier
{
    return @"CommentCellIdentifier";
}

+ (CGFloat)cellHeightWithModel:(CellCommentModel *)model
{
    CGFloat cellHeight = 0.0f;
    cellHeight += (2*marginHeight+nameLabelWidth);
    cellHeight += [model.message sizeWithWidth:(bound.size.width - 3*marginWidth -floorLabelWidth) font:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByWordWrapping].height;
    cellHeight += marginHeight;
    return cellHeight;
}

@end
