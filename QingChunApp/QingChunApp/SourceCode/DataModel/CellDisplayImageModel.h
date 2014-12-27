//
//  DisplayImage.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDisplayImageModel : NSObject 

@property (readonly, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *urlStrSuffix;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

- (instancetype)initWithUrlStrSuffix:(NSString *)urlStrSuffix width:(CGFloat)width height:(CGFloat)height;

@end
