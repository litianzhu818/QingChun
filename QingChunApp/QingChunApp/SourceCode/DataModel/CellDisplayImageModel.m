//
//  DisplayImage.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayImageModel.h"
#import "NSObject+AutoProperties.h"

@interface CellDisplayImageModel ()
{
    NSString *_urlStr;
}
@end

@implementation CellDisplayImageModel
@synthesize urlStr = _urlStr;

+ (instancetype)cellDisplayImageModelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithUrlStrSuffix:(NSString *)urlStrSuffix width:(CGFloat)width height:(CGFloat)height
{
    self = [super init];
    if (self) {
        //这里需要防止服务器返回图片宽高都为0的数据
        if (width == 0) {
            width = 200.0f;
        }
        if (height == 0) {
            height = 200.0f;
        }
        self.urlStrSuffix = urlStrSuffix;
        self.width = width;
        self.height = height;
        _urlStr = [NSString stringWithFormat:@"%@%@%@", [[UserConfig sharedInstance] GetImageURLPrefix], MESSAGE_IMAGE_QUALIRT_DEFAULT, self.urlStrSuffix];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithUrlStrSuffix:[dictionary objectForKey:@"dir"]
                                width:[[dictionary objectForKey:@"width"] floatValue]
                               height:[[dictionary objectForKey:@"height"] floatValue]];
}

@end
