//
//  CellDisplayModel.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellDisplayUserModel;
@class CellDisplayImageModel;
@class CellButtonViewModel;
@class CellContentModel;

@interface CellDisplayModel : NSObject

@property (strong, nonatomic) CellContentModel *cellContentModel;
@property (strong, nonatomic) CellButtonViewModel *cellButtonViewModel;
@property (strong, nonatomic) CellDisplayUserModel *cellDisplayUserModel;

@property (strong, nonatomic) NSArray *cellDisplayImageModels;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)cellDisplayModelWithDictionary:(NSDictionary *)dictionary;

@end
