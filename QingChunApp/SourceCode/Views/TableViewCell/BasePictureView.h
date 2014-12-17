//
//  BasePictureView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, PictueViewType) {
    PictueViewTypeSingle = 0,
    PictueViewTypeMultiple
};

@protocol BasePictureViewDelegate;

@interface BasePictureView : UIView

@property (assign, nonatomic) id<BasePictureViewDelegate> delegate;

@property (strong, nonatomic, readonly) NSArray *urls;
@property (assign, nonatomic, readonly) CGSize pictureSize;

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urls;
- (instancetype)initWithFrame:(CGRect)frame singleUrls:(NSString *)url;

- (NSString *)urlAtIndex:(NSUInteger)pictureIndex;
- (UIImage *)imageAtIndex:(NSUInteger)pictureIndex;

@end


@protocol BasePictureViewDelegate <NSObject>

@optional

- (void)didTapedOnImageView:(UIImageView *)imageView onIndex:(NSUInteger)index;

@end
