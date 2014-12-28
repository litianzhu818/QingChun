//
//  CellDisplayUserModel.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellDisplayUserModel : NSObject

@property (strong,      nonatomic) NSString *ID;
@property (strong,      nonatomic) NSString *name;
@property (readonly,    nonatomic) NSString *imgUrlStr;
@property (strong,      nonatomic) NSString *imgUrlStrSufix;

- (id)initWithID:(NSString *)ID name:(NSString *)name imgUrlStrSufix:(NSString *)imgUrlStrSufix;

+ (id)cellDisplayUserModelWithID:(NSString *)ID name:(NSString *)name imgUrlStrSufix:(NSString *)imgUrlStrSufix;

@end
