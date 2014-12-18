//
//  BasePictureView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BasePictureView.h"
#import "BaseCellImageView.h"

#define MULTIPLE_IMAGE_INTERVAL 5.0f
#define MULTIPLE_IMAGE_WIDTH 80.0f
#define SINGLE_IMAGE_WIDTH 200.0f

@interface BasePictureView ()<BaseCellImageViewDelegate>
{
    NSArray *_urls;
    NSMutableArray *_images;
    CGFloat _aspectRatio;
    CGSize _pictureSize;
}
@end

@implementation BasePictureView
@synthesize urls = _urls;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame urls:nil];
}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urls
{
    return [self initWithFrame:frame multipleUrls:urls aspectRatio:0.0];
}

- (instancetype)initWithFrame:(CGRect)frame singleUrls:(NSString *)url
{
    return [self initWithFrame:frame multipleUrls:[NSArray arrayWithObjects:url,nil] aspectRatio:1.0f];
}

- (instancetype)initWithFrame:(CGRect)frame singleUrls:(NSString *)url aspectRatio:(CGFloat)aspectRatio
{
    return [self initWithFrame:frame multipleUrls:[NSArray arrayWithObjects:url,nil] aspectRatio:aspectRatio];
}

- (instancetype)initWithFrame:(CGRect)frame multipleUrls:(NSArray *)urls aspectRatio:(CGFloat)aspectRatio
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initParameters];
        _urls = urls;
        [self initUI];
    }
    return self;
}


- (void)initParameters
{
    self.backgroundColor = [UIColor clearColor];
    _images = [ NSMutableArray array];
}

- (void)initUI
{
    if ([_urls count] == 1) {
        [self setupSinglePictureView];
    }else{
        [self setupMultiplePictureView];
    }
}

- (void)setupSinglePictureView
{
    CGFloat imageWith = 0.0f;
    CGFloat imageHeight = 0.0f;
    
    if (_aspectRatio > 1.0) {
        imageWith = SINGLE_IMAGE_WIDTH;
        imageHeight = imageWith/_aspectRatio;
    }else{
        imageHeight = SINGLE_IMAGE_WIDTH;
        imageWith = imageHeight*_aspectRatio;
    }
    _pictureSize = CGSizeMake(imageWith, imageHeight);
    self.frame =CGRectMake(self.frame.origin.x, self.frame.origin.y, imageWith, imageHeight);
    
    BaseCellImageView *singleImageView = [[BaseCellImageView alloc] initWithFrame:CGRectMake(0, 0, imageWith, imageHeight) delegate:self imageUrl:[_urls firstObject]];
     singleImageView.contentMode = UIViewContentModeScaleAspectFit;
    singleImageView.tag = 0;
    
    [self addSubview:singleImageView];
    [_images addObject:singleImageView];
}

- (void)setupMultiplePictureView
{
    CGFloat imageWith = 0.0f;
    CGFloat imageHeight = 0.0f;
    
    NSUInteger column       =   0;//列数
    NSUInteger row          =   0;//行数
    NSUInteger numOfImages  =   [_urls count];
    
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
    
    _pictureSize = CGSizeMake(imageWith, imageHeight);
    self.frame =CGRectMake(self.frame.origin.x, self.frame.origin.y, imageWith, imageHeight);
    
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    for (NSUInteger index = 1; index <= row; ++index) {
        
        originX = 0.0f;
        originY += (index - 1) * (MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL);
        
        for (NSInteger item = 1; item <= column; ++item) {
            
            NSUInteger sumOfViews = (index - 1) * 3 + item;
            
            if (sumOfViews > numOfImages) break;
            
            originX += (item - 1) * (MULTIPLE_IMAGE_WIDTH + MULTIPLE_IMAGE_INTERVAL);
            
            BaseCellImageView *singleImageView = [[BaseCellImageView alloc] initWithFrame:CGRectMake(originX, originY, MULTIPLE_IMAGE_WIDTH, MULTIPLE_IMAGE_WIDTH) delegate:self imageUrl:[_urls objectAtIndex:sumOfViews - 1]];
            singleImageView.contentMode = UIViewContentModeScaleAspectFill;
            singleImageView.tag = sumOfViews - 1;
            
            [self addSubview:singleImageView];
            [_images addObject:singleImageView];
        }
    }
    
}


- (NSString *)urlAtIndex:(NSUInteger)pictureIndex
{
    return [self.urls objectAtIndex:pictureIndex];
}
- (UIImage *)imageAtIndex:(NSUInteger)pictureIndex
{
    return [_images objectAtIndex:pictureIndex];
}

#pragma mark - BaseCellImageViewDelegate method
- (void)tapOnImageView:(BaseCellImageView *)baseCellImageView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedOnImageView:onIndex:)]) {
        [self.delegate didTapedOnImageView:baseCellImageView onIndex:baseCellImageView.tag];
    }
}
@end
