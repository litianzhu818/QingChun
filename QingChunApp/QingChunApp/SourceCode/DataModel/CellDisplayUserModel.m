//
//  CellDisplayUserModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayUserModel.h"
#import "NSObject+AutoProperties.h"

@interface CellDisplayUserModel ()
{
    NSString *_imgUrlStr;
}
@end

@implementation CellDisplayUserModel
@synthesize imgUrlStr = _imgUrlStr;

- (id)initWithID:(NSString *)ID name:(NSString *)name imgUrlStrSufix:(NSString *)imgUrlStrSufix
{
    self = [super init];
    if (self) {
        self.ID = ID;
        self.name = name;
        self.imgUrlStrSufix = imgUrlStrSufix;
        _imgUrlStr = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_image_url_string"],self.imgUrlStrSufix];
    }
    
    return self;
}

+ (id)cellDisplayUserModelWithID:(NSString *)ID name:(NSString *)name imgUrlStrSufix:(NSString *)imgUrlStrSufix
{
    return [[self alloc] initWithID:ID name:name imgUrlStrSufix:imgUrlStrSufix];
}

@end
