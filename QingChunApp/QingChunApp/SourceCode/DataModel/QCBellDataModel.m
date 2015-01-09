//
//  QCBellDataModel.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "QCBellDataModel.h"
#import "NSObject+AutoProperties.h"

@interface QCBellDataModel ()
{
    UIImage     *_image;
    NSString    *_title;
    NSUInteger  _number;
    NSUInteger  _tag;
}

@end

@implementation QCBellDataModel
@synthesize image = _image;
@synthesize title = _title;
@synthesize number = _number;
@synthesize tag = _tag;

#pragma mark - public class methods
+ (id)qcbellDataModel
{
   return [QCBellDataModel qcbellDataModelWithImage:nil title:nil];
}

+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title
{
    return [QCBellDataModel qcbellDataModelWithImage:image title:title number:0];
}

+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number
{
    return [QCBellDataModel qcbellDataModelWithImage:image title:title number:number tag:0];
}

+ (id)qcbellDataModelWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag
{
    return [[self alloc] initWithImage:image title:title number:number tag:tag];
}

#pragma mark - public object init methods

- (instancetype)init
{
    return [self initWithImage:nil title:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    return [self initWithImage:image title:title number:0];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number
{
    return [self initWithImage:image title:title number:number tag:0];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag
{
    self = [super init];
    if (self) {
        _image = image;
        _title = title;
        _number = number;
        _tag = tag;
    }
    return self;
}

#pragma mark - public action methods

- (void)updateNumber:(NSUInteger)number
{
    [self updateImage:nil title:nil number:number];
}
- (void)updateImage:(UIImage *)image title:(NSString *)title
{
    [self updateImage:image title:title number:0];
}
- (void)updateImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number
{
    [self updateImage:image title:title number:number tag:0];
}
- (void)updateImage:(UIImage *)image title:(NSString *)title number:(NSUInteger)number tag:(NSUInteger)tag
{
    if (image) _image = image;
    if (title) _title = title;
    if (number > 0) _number = number;
    if (tag > 0) _tag = tag;
}


@end
