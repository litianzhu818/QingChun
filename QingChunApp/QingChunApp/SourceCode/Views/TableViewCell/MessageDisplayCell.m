//
//  MessageDisplayCell.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/1.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "MessageDisplayCell.h"
#import "CellDisplayModel.h"
#import "BaseCellHeaderView.h"

#define DEFAULT_EDGE_INSERT 8.0f

@interface MessageDisplayCell ()
{
    BaseCellHeaderView *_cellHeaderView;
}
@end

@implementation MessageDisplayCell
@synthesize messageDisplayCellType = _messageDisplayCellType;

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commentInit];
        [self setupUINormal];
    }
    return self;
}

- (void)commentInit
{
    UIImage *backgroundImage = [UIImage imageNamed:@"cell_bg"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(DEFAULT_EDGE_INSERT, DEFAULT_EDGE_INSERT, DEFAULT_EDGE_INSERT, DEFAULT_EDGE_INSERT)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self setBackgroundView:imageView];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setupUINormal
{
    _cellHeaderView = [[BaseCellHeaderView alloc] initWithNormalTypeFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80) cellDisplayModel:self.cellDisPlayModel];
//    _cellHeaderView = [[BaseCellHeaderView alloc] initWithIndentTypeFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80) cellDisplayModel:self.cellDisPlayModel];
    [self.contentView addSubview:_cellHeaderView];
}

- (void)setCellDisPlayModel:(CellDisplayModel *)cellDisPlayModel
{
    _cellDisPlayModel = cellDisPlayModel;
    
    [self setNeedsLayout];
}

- (void)setMessageDisplayCellType:(MessageDisplayCellType)messageDisplayCellType
{
    _messageDisplayCellType = messageDisplayCellType;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //add your code ...
    
    if (!_cellDisPlayModel) {
        return;
    }
    
    _cellHeaderView.cellDisplayModel = _cellDisPlayModel;
    
}

#pragma mark - class public methods
+ (NSString *)cellIdentifier
{
    return [NSString stringWithFormat:@"%@",@"MessageDisplayCellIdentifier"];
}
+ (CGFloat)cellFrameHeightWithWidth:(CGFloat)width cellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    CGFloat height = 0.0f;
    //因为字体的label距左右各为10.0f,所以穿进来的宽度要减去20
    height += [BaseCellHeaderView normalHeaderViewHeightWithWidth:width content:cellDisplayModel.cellContentModel.text];
    
    return height;
}

@end
