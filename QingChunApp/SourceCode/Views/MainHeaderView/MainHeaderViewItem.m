//
//  MainHeaderViewItem.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "MainHeaderViewItem.h"

@interface MainHeaderViewItem ()
{
    UIImage     *_normalImage;
    UIImage     *_selectedImage;
    NSString    *_title;
}
@end

@implementation MainHeaderViewItem
@synthesize normalImage = _normalImage;
@synthesize selectedImage = _selectedImage;
@synthesize title = _title;

- (instancetype)initWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    self  = [super init];
    if (self) {
        _normalImage = normalImage;
        _selectedImage = selectedImage;
        _title = title;
    }
    
    return self;
}

@end
