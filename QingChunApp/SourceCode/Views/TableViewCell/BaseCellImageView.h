//
//  BaseCellImageView.h
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseCellImageViewDelegate;

@interface BaseCellImageView : UIImageView

@property (strong, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) id<BaseCellImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl;
- (id)initWithFrame:(CGRect)frame delegate:(id<BaseCellImageViewDelegate>)delegate imageUrl:(NSString *)imageUrl;

@end

@protocol BaseCellImageViewDelegate <NSObject>

@optional

- (void)tapOnImageView:(BaseCellImageView *)baseCellImageView;

@end
