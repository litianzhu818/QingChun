//
//  BasePictureView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellImageView.h"
#import "BaseCellImageView.h"
#import "CellDisplayImageModel.h"

#import "MJPhoto.h"

#define MULTIPLE_IMAGE_INTERVAL 5.0f
#define MULTIPLE_IMAGE_WIDTH ((bound.size.width - 2*MULTIPLE_IMAGE_INTERVAL - 20)/3)
#define SINGLE_IMAGE_WIDTH 200.0f

@interface CellImageView ()<BaseCellImageViewDelegate>
{
    NSArray             *_cellDisplayImageModels;
    NSMutableArray      *_images;
}
@end

@implementation CellImageView
@synthesize cellDisplayImageModels = _cellDisplayImageModels;

#pragma mark - public init method
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame cellDisplayImageModels:nil];
}

- (instancetype)initWithFrame:(CGRect)frame cellDisplayImageModel:(CellDisplayImageModel *)cellDisplayImageModel
{
    return [self initWithFrame:frame cellDisplayImageModels:[NSArray arrayWithObjects:cellDisplayImageModel,nil]];
}

- (instancetype)initWithFrame:(CGRect)frame cellDisplayImageModels:(NSArray *)cellDisplayImageModels
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initParameters];
        [self setCellDisplayImageModels:[self cellDisplayImageModelsFrom:cellDisplayImageModels]];
    }
    return self;
}

#pragma mark - private init method

- (void)initParameters
{
    self.backgroundColor = [UIColor clearColor];
    _images = [ NSMutableArray array];
}

- (void)initUI
{
    if ([_cellDisplayImageModels count] == 1) {
        [self setupSinglePictureView];
    }else{
        [self setupMultiplePictureView];
    }
}

- (void)setupSinglePictureView
{
    CGFloat imageWith = 0.0f;
    CGFloat imageHeight = 0.0f;
    
    CellDisplayImageModel *cellDisplayImageModel = [_cellDisplayImageModels firstObject];
    
    CGFloat _aspectRatio = cellDisplayImageModel.width/cellDisplayImageModel.height;
    
    if (_aspectRatio > 1.0) {
        imageWith = SINGLE_IMAGE_WIDTH;
        imageHeight = imageWith/_aspectRatio;
    }else{
        imageHeight = SINGLE_IMAGE_WIDTH;
        imageWith = imageHeight*_aspectRatio;
    }
    
    BaseCellImageView *singleImageView = [[BaseCellImageView alloc] initWithFrame:CGRectMake(0, 0, imageWith, imageHeight) delegate:self imageUrl:[cellDisplayImageModel urlStr]];
    singleImageView.contentMode = UIViewContentModeScaleToFill;
    singleImageView.userInteractionEnabled = YES;
    singleImageView.delegate = self;
    singleImageView.tag = 0;
    
    [self addSubview:singleImageView];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    
    // 来源于哪个UIImageView
    photo.srcImageView = singleImageView;
    
    NSString *url = [[cellDisplayImageModel urlStr] stringByReplacingOccurrencesOfString:MESSAGE_IMAGE_QUALIRT_LOW withString:MESSAGE_IMAGE_QUALIRT_DEFAULT];
    // 图片路径
    photo.url = [NSURL URLWithString:url];
    [_images addObject:photo];
}

- (void)setupMultiplePictureView
{
    
    CGFloat imageWith = 0.0f;
    CGFloat imageHeight = 0.0f;
     
    
    NSUInteger column       =   0;//列数
    NSUInteger row          =   0;//行数
    NSUInteger numOfImages  =   [_cellDisplayImageModels count];
    
    
    if (numOfImages <= 3) {//一行，三列
        row = 1;
        column = numOfImages;
        imageWith = numOfImages * MULTIPLE_IMAGE_WIDTH + (numOfImages - 1) * MULTIPLE_IMAGE_INTERVAL;
        imageHeight = MULTIPLE_IMAGE_WIDTH;
    }else if (numOfImages == 4){//两行，两列
        row = 2;
        column = 2;
        imageWith = 2 * MULTIPLE_IMAGE_WIDTH +  MULTIPLE_IMAGE_INTERVAL;
        imageHeight = 2 * MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL;
    }else if (4 < numOfImages && numOfImages <= 6){//两行，三列
        row = 2;
        column = 3;
        imageWith = 3 * MULTIPLE_IMAGE_WIDTH + 2 * MULTIPLE_IMAGE_INTERVAL;
        imageHeight = 2 * MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL;
    }else if (6 < numOfImages && numOfImages <= 9){//三行，三列
        row = 3;
        column = 3;
        imageWith = 3 * MULTIPLE_IMAGE_WIDTH + 2 * MULTIPLE_IMAGE_INTERVAL;
        imageHeight = 3 * MULTIPLE_IMAGE_WIDTH + 2 * MULTIPLE_IMAGE_INTERVAL;
    }
    
    //这里的布局是：|-0-image-margin-image-margin-image-0|
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    for (NSUInteger index = 1; index <= row; ++index) {
        
        originX = 0.0f;
        originY += (index - 1) * (MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL);
        
        for (NSInteger item = 1; item <= column; ++item) {
            //到目前的视图，总共的视图数量
            NSUInteger sumOfViews = (index - 1) * 3 + item;
            //如果目前视图数量大于总数了，那么需要停止布局
            if (sumOfViews > numOfImages) break;
            
            originX += (item - 1) * (MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL);
            
            CellDisplayImageModel *tempCellDisplayImageModel = [_cellDisplayImageModels objectAtIndex:sumOfViews - 1];
            
            BaseCellImageView *singleImageView = [[BaseCellImageView alloc] initWithFrame:CGRectMake(originX, originY, MULTIPLE_IMAGE_WIDTH, MULTIPLE_IMAGE_WIDTH) delegate:self imageUrl:tempCellDisplayImageModel.urlStr];
            singleImageView.contentMode = UIViewContentModeScaleAspectFill;
            singleImageView.userInteractionEnabled = YES;
            singleImageView.delegate = self;
            singleImageView.tag = sumOfViews - 1;
            
            [self addSubview:singleImageView];
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            // 来源于哪个UIImageView
            photo.srcImageView = singleImageView;
            NSString *url = [[tempCellDisplayImageModel urlStr] stringByReplacingOccurrencesOfString:MESSAGE_IMAGE_QUALIRT_LOW withString:MESSAGE_IMAGE_QUALIRT_DEFAULT];
            // 图片路径
            photo.url = [NSURL URLWithString:url];
            [_images addObject:photo];
        }
    }
    
}

- (NSString *)urlAtIndex:(NSUInteger)pictureIndex
{
    return [(CellDisplayImageModel *)[self.cellDisplayImageModels objectAtIndex:pictureIndex] urlStr];
}

- (UIImage *)imageAtIndex:(NSUInteger)pictureIndex
{
    return [_images objectAtIndex:pictureIndex];
}

- (void)setCellDisplayImageModels:(NSArray *)cellDisplayImageModels
{
    if (!cellDisplayImageModels) {
        return;
    }
    _cellDisplayImageModels = cellDisplayImageModels;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_images removeAllObjects];
    
    [self initUI];
}

+ (CGFloat)heightWithCellDisplayImageModels:(NSArray *)cellDisplayImageModels
{
    CGFloat height = 0.0f;
    
    if ([cellDisplayImageModels count] == 1) {
        
        CellDisplayImageModel *cellDisplayImageModel = [cellDisplayImageModels firstObject];
        
        CGFloat _aspectRatio = cellDisplayImageModel.width/cellDisplayImageModel.height;
        
        if (_aspectRatio > 1.0) {
            height = SINGLE_IMAGE_WIDTH/_aspectRatio;
        }else{
            height = SINGLE_IMAGE_WIDTH;
        }

    }else{
        NSUInteger column       =   0;//列数
        NSUInteger row          =   0;//行数
        NSUInteger numOfImages  =   [cellDisplayImageModels count];
        
        if (numOfImages <= 3) {//一行，三列
            row = 1;
            column = numOfImages;
            
            height = MULTIPLE_IMAGE_WIDTH;
        }else if (numOfImages == 4){//两行，两列
            row = 2;
            column = 2;

            height = 2 * MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL;
        }else if (4 < numOfImages && numOfImages <= 6){//两行，三列
            row = 2;
            column = 3;
            
            height = 2 * MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL;
        }else if (6 < numOfImages && numOfImages <= 9){//三行，三列
            row = 3;
            column = 3;
            
            height = 3 * MULTIPLE_IMAGE_WIDTH + 2 * MULTIPLE_IMAGE_INTERVAL;
        }
    }
    
    return height;
}

#pragma mark - BaseCellImageViewDelegate method
- (void)tapOnImageView:(BaseCellImageView *)baseCellImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellImageView:didTapedOnImageViewWith:onIndex:)]) {
        [self.delegate cellImageView:self didTapedOnImageViewWith:_images onIndex:baseCellImageView.tag];
    }
}

#pragma mark - tools method
- (NSArray *)cellDisplayImageModelsFrom:(NSArray *)arrays
{
    if ([arrays count] < 1) return nil;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [arrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        CellDisplayImageModel *tempModel = [self cellDisplayImageModelFromDictionary:dic];
        [tempArray addObject:tempModel];
    }];
    
    return tempArray;
}

- (CellDisplayImageModel *)cellDisplayImageModelFromDictionary:(NSDictionary *)dictionary
{
    return [CellDisplayImageModel cellDisplayImageModelWithDictionary:dictionary];
}
@end
