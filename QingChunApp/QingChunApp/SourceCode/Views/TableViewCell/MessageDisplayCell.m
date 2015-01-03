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
#import "CellImageView.h"

#import "MJPhotoBrowser.h"

#define DEFAULT_EDGE_INSERT 8.0f
#define DAFAULT_MARGIN_WIDTH 10.0f

@interface MessageDisplayCell ()<CellImageViewDelegate,CellButtonViewDelegate,BaseCellHeaderViewDelegate>
{
    //顶部视图，显示用户信息和文本内容
    BaseCellHeaderView      *_cellHeaderView;
    //图片视图，用于显示图片
    CellImageView           *_cellImageView;
    //按钮视图
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
    _cellHeaderView = ({
        BaseCellHeaderView *cellHeaderView = [[BaseCellHeaderView alloc] initWithNormalTypeFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 80) cellDisplayModel:self.cellDisPlayModel];
        cellHeaderView.delegate = self;
        [self.contentView addSubview:cellHeaderView];
        cellHeaderView;
    });
    
    
    //图片视图
    _cellImageView = ({
        CellImageView *cellImageView = [[CellImageView alloc] initWithFrame:CGRectMake(DAFAULT_MARGIN_WIDTH, VIEW_BY(_cellHeaderView), VIEW_W(self.contentView)-2*DAFAULT_MARGIN_WIDTH, 10)];
        cellImageView.delegate = self;
        cellImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:cellImageView];
        cellImageView;
    });
    
    
    
    //按钮视图
    _cellButtonView = ({
        CellButtonView *cellButtonView = [[CellButtonView alloc] initWithFrame:CGRectMake(DAFAULT_MARGIN_WIDTH, VIEW_BY(_cellImageView)+10, self.contentView.frame.size.width - 2*DAFAULT_MARGIN_WIDTH, 30) cellButtonViewModel:self.cellDisPlayModel.cellButtonViewModel];
        cellButtonView.delegate = self;
        [self.contentView addSubview:cellButtonView];
        cellButtonView;
    });
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
    
    //为各个子控件添加相应的数据源
    _cellHeaderView.cellDisplayModel = _cellDisPlayModel;
    _cellImageView.cellDisplayImageModels = _cellDisPlayModel.cellDisplayImageModels;
    _cellButtonView.cellButtonViewModel = _cellDisPlayModel.cellButtonViewModel;
    
    //顶部视图的高度,此时的宽度是屏宽-20（左右边距各10）
    CGFloat tempHeight = [BaseCellHeaderView normalHeaderViewHeightWithWidth:(bound.size.width-20) content:_cellDisPlayModel.cellContentModel.text];
    
    //如果有图片
    if ([self.cellDisPlayModel.cellDisplayImageModels count] > 0) {
        //显示图片视图控件
        [_cellImageView setHidden:NO];
        
        //计算图片视图的高度
        CGFloat _cellImageViewHeight = [CellImageView heightWithCellDisplayImageModels:_cellDisPlayModel.cellDisplayImageModels];
        
        //调整图片视图新的位置frame
        _cellImageView.frame = CGRectMake(DAFAULT_MARGIN_WIDTH, tempHeight, VIEW_W(self.contentView)-2*DAFAULT_MARGIN_WIDTH, _cellImageViewHeight);
        
        //调整完图片视图的高度之后，需要把起点高度加上，以便后面的视图好调整位置
        tempHeight += _cellImageViewHeight;
        //加上按钮和图片之间的距离10
        tempHeight += 10;
    }else{
        //没有图片时，影藏图片视图控件
        //这时千万不能romevFromSuperview或者设置nil，因为其他数据需要重用该控件
        [_cellImageView setHidden:YES];
    }
    
    //调整按钮视图的位置frame
    _cellButtonView.frame = CGRectMake(DAFAULT_MARGIN_WIDTH, tempHeight, self.contentView.frame.size.width - 2*DAFAULT_MARGIN_WIDTH, 30);
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
    
    if ([cellDisplayModel.cellDisplayImageModels count] > 0){
        //加上图片高度
        height += [CellImageView heightWithCellDisplayImageModels:cellDisplayModel.cellDisplayImageModels];
        
        //按钮视图距离上面视图边距10.0f
        height += 10.0f;
    }
    
    //按钮视图距离下边距10.0f
    height += 10.0f;
    
    //加上底部按钮视图的高度
    height += 30.0f;
    
    return height;
}

#pragma mark - CellImageViewDelegate methods
- (void)cellImageView:(CellImageView *)cellImageView didTapedOnImageViewWith:(NSArray *)imageInfos onIndex:(NSUInteger)index
{
    //显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = imageInfos; // 设置所有的图片
    [browser show];
}

@end
