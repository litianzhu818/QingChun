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
#import "CellButtonView.h"

#define DEFAULT_EDGE_INSERT 8.0f
#define DAFAULT_MARGIN_WIDTH 10.0f

@interface MessageDisplayCell ()
{
    BaseCellHeaderView      *_cellHeaderView;
    CellButtonView          *_cellButtonView;
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
    //头部视图
    _cellHeaderView = [[BaseCellHeaderView alloc] initWithNormalTypeFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80) cellDisplayModel:self.cellDisPlayModel];
    [self.contentView addSubview:_cellHeaderView];
    
    //按钮视图
    _cellButtonView = [[CellButtonView alloc] initWithFrame:CGRectMake(DAFAULT_MARGIN_WIDTH, VIEW_BY(_cellHeaderView)+10, self.contentView.frame.size.width - 2*DAFAULT_MARGIN_WIDTH, 30) cellButtonViewModel:self.cellDisPlayModel.cellButtonViewModel];
    [self.contentView addSubview:_cellButtonView];
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
    _cellButtonView.cellButtonViewModel = _cellDisPlayModel.cellButtonViewModel;
    [_cellButtonView sizeToFit];
    
    _cellButtonView.frame = CGRectMake(DAFAULT_MARGIN_WIDTH, VIEW_BY(_cellHeaderView)+10, self.contentView.frame.size.width - 2*DAFAULT_MARGIN_WIDTH, 30);
    [_cellButtonView sizeToFit];
    
    NSLog(@"%@##%@",NSStringFromCGRect(_cellHeaderView.frame),NSStringFromCGRect(_cellButtonView.frame));
    
}

#pragma mark - class public methods
+ (NSString *)cellIdentifier
{
    return [NSString stringWithFormat:@"%@",@"MessageDisplayCellIdentifier"];
}
+ (CGFloat)cellFrameHeightWithWidth:(CGFloat)width cellDisplayModel:(CellDisplayModel *)cellDisplayModel
{
    CGFloat height = 0.0f;
    //加上顶部信息视图的高度
    height += [BaseCellHeaderView normalHeaderViewHeightWithWidth:width content:cellDisplayModel.cellContentModel.text];
    //加上底部按钮视图的高度
    height += 50.0;
    return height;
}

@end
