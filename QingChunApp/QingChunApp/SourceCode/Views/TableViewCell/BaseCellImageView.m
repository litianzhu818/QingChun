//
//  BaseCellImageView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/17.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseCellImageView.h"
#import "UIImageView+WebCache.h"

@interface BaseCellImageView ()
{
    UIImageView                 *_gifView;
    UITapGestureRecognizer      *_tapGestureRecognizer;
}

@end

@implementation BaseCellImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<BaseCellImageViewDelegate>)delegate imageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImageUrl:imageUrl];
        [self addGestures];
    }
    return self;
}

- (void)addGestures
{
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clikedOnImageView:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (void)removeGestures
{
    [self removeGestureRecognizer:_tapGestureRecognizer];
}

- (void)setupUIWithFrame:(CGRect)frame imageUrl:(NSString *)url
{
    // 添加Gif图标
    _gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
    _gifView.hidden = YES;
    [self addSubview:_gifView];
    
    [self setFrame:frame];
    
    [self setImageUrl:url];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"] options:SDWebImageRetryFailed | SDWebImageLowPriority ];
    
    if ([self isGifImageWithUrl:self.imageUrl]) {
        _gifView.hidden = ![self isGifImageWithUrl:self.imageUrl];
    }
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // 设置图片Frame的时候将Gif图标的Frame设置好
    CGSize gifViewSize = _gifView.frame.size;
    _gifView.frame = CGRectMake(frame.size.width - gifViewSize.width, frame.size.height - gifViewSize.height, gifViewSize.width, gifViewSize.height);
}


- (BOOL)isGifImageWithUrl:(NSString *)url
{
    return [self.imageUrl.lowercaseString hasSuffix:@".gif"];
}

- (void)clikedOnImageView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapOnImageView:)]) {
        [self.delegate tapOnImageView:self];
    }
}

- (void)dealloc
{
    [self setDelegate:nil];
    [self removeGestures];
}

@end
