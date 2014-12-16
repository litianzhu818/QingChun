//
//  BasePictureView.m
//  QingChunApp
//
//  Created by Peter Lee on 14/12/16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BasePictureView.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"

#define MULTIPLE_IMAGE_INTERVAL 5.0f
#define MULTIPLE_IMAGE_WIDTH 80.0f
#define SINGLE_IMAGE_WIDTH 200.0f

@interface BasePictureView ()
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

- (instancetype)initWithFrame:(CGRect)frame singleUrls:(NSString *)url aspectRatio:(CGFloat)aspectRatio
{
    return [self initWithFrame:frame urls:[NSArray arrayWithObjects:url,nil] aspectRatio:aspectRatio];
}
- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urls
{
    return [self initWithFrame:frame urls:urls aspectRatio:0.0];
}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urls aspectRatio:(CGFloat)aspectRatio
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initParameters];
        _urls = urls;
        [self setupViews];
        
    }
    return self;
}


- (void)initParameters
{
    self.backgroundColor = [UIColor clearColor];
    _images = [ NSMutableArray array];
}

- (void)setupViews
{
    switch ([_urls count]) {
        case 1:
//            <#statements#>
            break;
            
        default:
            break;
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
    
    UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWith, imageHeight)];
    
    [_images addObject:singleImageView];
}

- (NSString *)urlAtIndex:(NSUInteger)pictureIndex
{
    return [self.urls objectAtIndex:pictureIndex];
}
- (UIImage *)imageAtIndex:(NSUInteger)pictureIndex
{
    return [_images objectAtIndex:pictureIndex];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //your code here
    
    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        //TODO:这里可以将触摸范围扩大，便于操作，例如：
         CGRect validTouchArea = CGRectMake((self.frame.origin.x - 10),
         (self.frame.origin.y - 10),
         (self.frame.size.width + 10),
         (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            //your code here
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
