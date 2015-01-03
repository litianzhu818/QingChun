//
//  BasePictureView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

@import UIKit;

@class CellDisplayImageModel;
@protocol CellImageViewDelegate;

@interface CellImageView : UIView

@property (assign, nonatomic) id<CellImageViewDelegate> delegate;

@property (strong, nonatomic) NSArray *cellDisplayImageModels;

- (instancetype)initWithFrame:(CGRect)frame cellDisplayImageModels:(NSArray *)cellDisplayImageModels;
- (instancetype)initWithFrame:(CGRect)frame cellDisplayImageModel:(CellDisplayImageModel *)cellDisplayImageModel;

- (NSString *)urlAtIndex:(NSUInteger)pictureIndex;
- (UIImage *)imageAtIndex:(NSUInteger)pictureIndex;

+ (CGFloat)heightWithCellDisplayImageModels:(NSArray *)cellDisplayImageModels;

@end


@protocol CellImageViewDelegate <NSObject>

@optional

- (void)cellImageView:(CellImageView *)cellImageView didTapedOnImageViewWith:(NSArray *)imageInfos onIndex:(NSUInteger)index;

@end
